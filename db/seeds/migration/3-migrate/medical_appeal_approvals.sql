/*
    Appeal Approval
        appealappid
        appealid

        status
            A   150304 - Accepted
            C   2896 - Cancel Request (To cancel approval request)
            N   416 - Pending
            R   652 - Rejected
        appeal_result
            S - Suitable
            U - Unsuitable

        MLE1 Stuff
            req_userid
            req_date
            req_comments

        MLE2 Stuff
            approval_userid
            approval_date
            approval_comments

*/

\echo "medical_appeal_approvals.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        noreply_user_id int;
    BEGIN
        select start_migration_log('medical_appeal_approvals.sql') into v_log_id;
        commit;

        select id into noreply_user_id from users where code = 'NOREPLY' limit 1;

        insert into medical_appeal_approvals (
            medical_appeal_id,
            medical_mle1_decision,
            medical_mle2_decision,
            medical_mle1_id,
            medical_mle2_id,
            medical_mle1_decision_at,
            medical_mle2_decision_at,
            medical_mle1_comment,
            medical_mle2_comment,
            created_at,
            updated_at
        )
        select
            ma.id,
            case
                when faa.status = 'C' then 'CANCEL/CLOSE'
                when faa.appeal_result = 'U' then 'UNSUCCESSFUL'
                when faa.appeal_result = 'S' then 'SUCCESSFUL'
                else null end,
            case
                when faa.status = 'A' then 'APPROVED'
                when faa.status = 'R' then 'REJECTED'
                else null end,
            case
                when mle1.id is null then noreply_user_id
                else mle1.id end,
            case
                when mle2.id is null then noreply_user_id
                else mle2.id end,
            faa.req_date,
            faa.approval_date,
            faa.req_comments,
            faa.approval_comments,
            coalesce(faa.req_date, clock_timestamp()),
            coalesce(faa.approval_date, faa.req_date, clock_timestamp())
        from
            fomema_backup_nios.fw_appeal_approval faa join medical_appeals ma on ma.id = faa.appealid
            left join fomema_backup_nios.v_user_master req_user on faa.req_userid = req_user.uuid
            left join users mle1 on req_user.userid = mle1.code
            left join fomema_backup_nios.v_user_master appr_user on faa.approval_userid = appr_user.uuid
            left join users mle2 on appr_user.userid = mle2.code
        order by
            faa.appealappid;

        -- with faa as (
        --     select max(appealappid) over (partition by id) max_appealappid, *
        --     from fomema_backup_nios.fw_appeal_approval
        --     order by id, appealappid
        -- )

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_appeal_approvals.sql ended"