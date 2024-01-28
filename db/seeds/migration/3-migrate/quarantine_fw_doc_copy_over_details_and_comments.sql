\echo "quarantine_fw_doc_copy_over_details_and_comments.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_copy_over_details_and_comments.sql - copying details') into v_log_id;
        commit;

        insert into medical_examination_details (
            transaction_id, condition_id, medical_examination_id, date_value, text_value, created_at, updated_at
        )
        select
            ded.transaction_id, ded.condition_id, me.id, ded.date_value, ded.text_value, ded.created_at, ded.updated_at
        from
            doctor_examination_details ded join medical_examinations me on ded.transaction_id = me.transaction_id;

        perform end_migration_log(v_log_id);
    END
$$;

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_copy_over_details_and_comments.sql - copying comments') into v_log_id;
        commit;

        insert into medical_examination_comments (
            transaction_id, condition_id, medical_examination_id, comment, created_at, updated_at
        )
        select
            dec.transaction_id, dec.condition_id, me.id, dec.comment, dec.created_at, dec.updated_at
        from
            doctor_examination_comments dec join medical_examinations me on dec.transaction_id = me.transaction_id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "quarantine_fw_doc_copy_over_details_and_comments.sql loaded"
