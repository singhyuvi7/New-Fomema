\echo "quarantine_fw_doc_migration_for_unreleased_cases.sql loaded"

\echo "Deleting medical_examination_details - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_migration_for_unreleased_cases.sql - deleting detail') into v_log_id;
        commit;

        with pending_review_transactions as (
            select trans_id from fomema_backup_nios.fw_transaction where trans_id in (
                select trans_id from fomema_backup_nios.quarantine_fw_doc
            ) and mr = 0
        ),

        transaction_ids as (
            select id from transactions where code in (select trans_id from pending_review_transactions)
        )

        delete from medical_examination_details where transaction_id in (select id from transaction_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Deleting medical_examination_details - End"

\echo "Deleting medical_examination_comments - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_migration_for_unreleased_cases.sql - deleting detail') into v_log_id;
        commit;

        with pending_review_transactions as (
            select trans_id from fomema_backup_nios.fw_transaction where trans_id in (
                select trans_id from fomema_backup_nios.quarantine_fw_doc
            ) and mr = 0
        ),

        transaction_ids as (
            select id from transactions where code in (select trans_id from pending_review_transactions)
        )

        delete from medical_examination_comments where transaction_id in (select id from transaction_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Deleting medical_examination_comments - End"

\echo "Reinserting into medical_examination_details - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_migration_for_unreleased_cases.sql - deleting detail') into v_log_id;
        commit;

        with pending_review_transactions as (
            select trans_id from fomema_backup_nios.fw_transaction where trans_id in (
                select trans_id from fomema_backup_nios.quarantine_fw_doc
            ) and mr = 0
        ),

        transaction_ids as (
            select id from transactions where code in (select trans_id from pending_review_transactions)
        )

        insert into medical_examination_details (
            transaction_id, condition_id, medical_examination_id, date_value, text_value, created_at, updated_at
        )
        select
            ded.transaction_id, ded.condition_id, me.id, ded.date_value, ded.text_value, ded.created_at, ded.updated_at
        from
            doctor_examination_details ded join medical_examinations me on ded.transaction_id = me.transaction_id
        where
            me.transaction_id in (select id from transaction_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Reinserting into medical_examination_details - End"

\echo "Reinserting into medical_examination_comments - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_migration_for_unreleased_cases.sql - deleting detail') into v_log_id;
        commit;

        with pending_review_transactions as (
            select trans_id from fomema_backup_nios.fw_transaction where trans_id in (
                select trans_id from fomema_backup_nios.quarantine_fw_doc
            ) and mr = 0
        ),

        transaction_ids as (
            select id from transactions where code in (select trans_id from pending_review_transactions)
        )

        insert into medical_examination_comments (
            transaction_id, condition_id, medical_examination_id, comment, created_at, updated_at
        )
        select
            dec.transaction_id, dec.condition_id, me.id, dec.comment, dec.created_at, dec.updated_at
        from
            doctor_examination_comments dec join medical_examinations me on dec.transaction_id = me.transaction_id
        where
            me.transaction_id in (select id from transaction_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Reinserting into medical_examination_comments - End"

\echo "quarantine_fw_doc_migration_for_unreleased_cases.sql ended"