/*
    Check medical_reviews.sql for more info on the original tables.
*/

\echo "tcupi_reviews.sql loaded"

\echo "tcupi_reviews.sql - normal tcupi seeding"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('tcupi_reviews.sql - normal tcupi seeding') into v_log_id;
        commit;

        insert into tcupi_reviews (
            transaction_id,
            medical_mle1_id,
            medical_mle1_decision,
            medical_mle1_comment,
            medical_mle1_decision_at,
            medical_mle2_id,
            medical_mle2_decision,
            medical_mle2_comment,
            medical_mle2_decision_at,
            created_at,
            updated_at,
            qrrid
        )
        select
            local_trans.id,
            mle1.id,
            case when qr_request.medstatus = 'Y' then 'UNSUITABLE' when qr_request.medstatus = 'N' then 'SUITABLE' else null end,
            qr_request.comments,
            qr_request.creation_date,
            mle2.id,
            case when qr_approval.status = 'A' then 'APPROVE' when qr_approval.status = 'R' then 'REJECT' else null end,
            qr_approval.comments,
            qr_approval.approval_date,
            coalesce(qr_request.creation_date, clock_timestamp()),
            coalesce(qr_approval.approval_date, qr_request.modify_date, qr_request.creation_date, clock_timestamp()),
            qr_request.qrrid
        from
            fomema_backup_nios.quarantine_release_request qr_request
            join transactions local_trans on qr_request.trans_id = local_trans.code
            left join fomema_backup_nios.quarantine_release_approval qr_approval on qr_approval.qrrid = qr_request.qrrid
            left join fomema_backup_nios.v_user_master request_user on qr_request.request_by = request_user.uuid
            left join users mle1 on request_user.userid = mle1.code
            left join fomema_backup_nios.v_user_master approval_user on qr_approval.approval_id = approval_user.uuid
            left join users mle2 on approval_user.userid = mle2.code
        where
            qr_request.status in ('TP', 'TA', 'TR', 'TPS', 'TRP') -- Only TCUPI related.
        order by
            qr_request.qrrid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "tcupi_reviews.sql - normal tcupi seeding"

\echo "tcupi_reviews.sql - ATP tcupi seeding"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('tcupi_reviews.sql - ATP tcupi seeding') into v_log_id;
        commit;

        insert into tcupi_reviews (
            transaction_id,
            created_at,
            updated_at,
            qrrid
        )
        select
            local_trans.id,
            coalesce(qr_request.creation_date, clock_timestamp()),
            coalesce(qr_request.modify_date, qr_request.creation_date, clock_timestamp()),
            qr_request.qrrid
        from
            fomema_backup_nios.quarantine_release_request qr_request
            join transactions local_trans on qr_request.trans_id = local_trans.code
        where
            qr_request.status in ('ATP', 'TRP') -- Only ATP TCUPI & TRP TCUPI. Both these will need fresh TCUPI.
        order by
            qr_request.qrrid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "tcupi_reviews.sql - ATP tcupi seeding"

\echo "tcupi_reviews.sql ended"