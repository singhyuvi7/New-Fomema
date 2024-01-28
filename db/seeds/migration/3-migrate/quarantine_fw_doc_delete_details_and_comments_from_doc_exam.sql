\echo "quarantine_fw_doc_delete_details_and_comments_from_doc_exam.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_delete_details_and_comments_from_doc_exam.sql - deleting details') into v_log_id;
        commit;

        delete from
            doctor_examination_details ded
        where exists (
            select 1 from medical_examinations me where ded.transaction_id = me.transaction_id
        );

        perform end_migration_log(v_log_id);
    END
$$;

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_delete_details_and_comments_from_doc_exam.sql - deleting comments') into v_log_id;
        commit;

        delete from
            doctor_examination_comments dec
        where exists (
            select 1 from medical_examinations me where dec.transaction_id = me.transaction_id
        );

        perform end_migration_log(v_log_id);
    END
$$;

\echo "quarantine_fw_doc_delete_details_and_comments_from_doc_exam.sql loaded"
