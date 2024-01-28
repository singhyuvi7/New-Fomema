\echo "status_change_pending.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        noreply_user_id int;
    BEGIN
        select start_migration_log('status_change_pending.sql') into v_log_id;
        commit;

        select id into noreply_user_id from users where code = 'NOREPLY' limit 1;

        with count_singles as (
            select trans_id, count(*) from fomema_backup_nios.status_change_history group by trans_id
        ),

        pending_union_scp as (
            select scp.trans_id, scp.old_status, scp.new_status, scp.mod_date, scp.userid, scp.wrongtrans_ind
                from fomema_backup_nios.status_change_pending scp
            where (scp.trans_id, scp.mod_date) in
                (
                select trans_id, max(mod_date) as mod_date from fomema_backup_nios.status_change_pending group by trans_id
                )

            union all

            select sch.trans_id, sch.old_status, sch.new_status, sch.mod_date, sch.userid, sch.wrongtrans_ind
            from fomema_backup_nios.status_change_history sch
            where trans_id in (
                select trans_id from count_singles where count = 1
            )
        ),

        unique_scp_cases as (
            select trans_id, old_status, new_status, mod_date, userid, wrongtrans_ind
            from pending_union_scp
            where (trans_id, mod_date) in
            (
                select trans_id, max(mod_date) as mod_date from pending_union_scp group by trans_id
            ) group by trans_id, old_status, new_status, mod_date, userid, wrongtrans_ind
        )

        insert into transaction_amendments (
            transaction_id,
            created_by,
            original_status,
            new_status,
            amendment_reason,
            created_at,
            updated_at,
            wrong_transmission_doctor,
            wrong_transmission_lab,
            wrong_transmission_xray
        )
        select
            lt.id,
            case
                when users.id is not null then users.id
                else noreply_user_id end,
            case
                when usc.old_status = 'Y' then 'UNSUITABLE'
                else 'SUITABLE' end,
            case
                when usc.new_status = 'Y' then 'UNSUITABLE'
                else 'SUITABLE' end,
            'MIGRATION DATA',
            coalesce(usc.mod_date, clock_timestamp()),
            coalesce(usc.mod_date, clock_timestamp()),
            case
                when usc.wrongtrans_ind ~* 'D' then true
                else false end,
            case
                when usc.wrongtrans_ind ~* 'L' then true
                else false end,
            case
                when usc.wrongtrans_ind ~* 'X' then true
                else false end
        from
            unique_scp_cases usc
            join transactions lt on lt.code = usc.trans_id
            left join users on users.code = usc.userid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "status_change_pending.sql ended"