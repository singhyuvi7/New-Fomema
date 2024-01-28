\echo "medical_appeal_approvals_for_cancelled.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('medical_appeal_approvals_for_cancelled.sql') into v_log_id;
        commit;

        with appeal_close_comments_list  as (
            select appealid, appeal_close_comments from fomema_backup_nios.fw_appeal where appealid in (
                select id from medical_appeals where result = 'CANCEL/CLOSE'
                and id not in (select medical_appeal_id from medical_appeal_approvals)
            )
        )

        insert into medical_appeal_approvals (
            medical_appeal_id,
            medical_mle1_decision,
            medical_mle1_id,
            medical_mle1_decision_at,
            medical_mle1_comment,
            created_at,
            updated_at
        )
        select
            ma.id,
            'CANCEL/CLOSE',
            ma.officer_in_charge_id,
            ma.completed_at,
            accl.appeal_close_comments,
            ma.completed_at,
            ma.completed_at
        from
            medical_appeals ma join appeal_close_comments_list accl on ma.id = accl.appealid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_appeal_approvals_for_cancelled.sql ended"