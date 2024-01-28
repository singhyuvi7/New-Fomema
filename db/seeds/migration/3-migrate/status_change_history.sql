\echo "status_change_history.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        noreply_user_id int;
    BEGIN
        select start_migration_log('status_change_history.sql - Min Dates') into v_log_id;
        commit;

        select id into noreply_user_id from users where code = 'NOREPLY' limit 1;

        with count_singles as (
            select trans_id, count(*) from fomema_backup_nios.status_change_history group by trans_id
        ),

        requested_parameters as (
            select
                sch.trans_id,
                lt.id transaction_id,
                case
                    when users.id is not null then users.id
                    else noreply_user_id end created_by,
                'MIGRATION DATA' amendment_reason,
                coalesce(sch.mod_date, clock_timestamp()) created_at,
                case
                    when sch.wrongtrans_ind ~* 'D' then true
                    else false end wrong_transmission_doctor,
                case
                    when sch.wrongtrans_ind ~* 'L' then true
                    else false end wrong_transmission_lab,
                case
                    when sch.wrongtrans_ind ~* 'X' then true
                    else false end wrong_transmission_xray
            from
                fomema_backup_nios.status_change_history sch
                join transactions lt on lt.code = sch.trans_id
                left join users on users.code = sch.userid
            where
                sch.trans_id != '168130' and (sch.trans_id, sch.mod_date) in
                    (
                        select trans_id, min(mod_date) as mod_date from fomema_backup_nios.status_change_history where trans_id not in (
                            select trans_id from count_singles where count = 1
                        ) group by trans_id
                    )
        ),

        completed_parameters as (
            select
                rp.*,
                case
                    when users.id is not null then users.id
                    else noreply_user_id end approval_by,
                sch.mod_date approval_at,
                sch.mod_date updated_at,
                'CONCURRED' approval_status,
                'MIGRATION DATA' approval_comment,
                case
                    when sch.old_status = 'Y' then 'UNSUITABLE'
                    else 'SUITABLE' end original_status,
                case
                    when sch.new_status = 'Y' then 'UNSUITABLE'
                    else 'SUITABLE' end new_status
            from
                fomema_backup_nios.status_change_history sch
                        join requested_parameters rp on sch.trans_id = rp.trans_id
                left join users on users.code = sch.userid
            where
                (sch.trans_id, sch.mod_date) in
                    (
                        select trans_id, max(mod_date) as mod_date from fomema_backup_nios.status_change_history where trans_id not in (
                            select trans_id from count_singles where count = 1
                        ) group by trans_id
                    )
        )

        insert into transaction_amendments (
            transaction_id,
            created_by,
            original_status,
            new_status,
            amendment_reason,
            approval_by,
            approval_status,
            approval_at,
            created_at,
            updated_at,
            approval_comment,
            wrong_transmission_doctor,
            wrong_transmission_lab,
            wrong_transmission_xray
        )
        select
            transaction_id,
            created_by,
            original_status,
            new_status,
            amendment_reason,
            approval_by,
            approval_status,
            approval_at,
            created_at,
            updated_at,
            approval_comment,
            wrong_transmission_doctor,
            wrong_transmission_lab,
            wrong_transmission_xray
        from
            completed_parameters
        order by
            created_at;

        perform end_migration_log(v_log_id);
    END
$$;