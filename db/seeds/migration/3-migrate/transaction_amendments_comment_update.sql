\echo "transaction_amendments_comment_update.sql loaded"

\echo "transaction_amendments_comment_update.sql - Delete doctor_examination_comments - Start"
DO $$
    DECLARE
        v_log_id bigint;

    BEGIN
        select start_migration_log('transaction_amendments_comment_update.sql') into v_log_id;
        commit;

        delete from doctor_examination_comments where transaction_id in (
            select ta.transaction_id from transaction_amendments ta join medical_examinations me on ta.transaction_id = me.transaction_id
        ) and condition_id in (
            select id from conditions where code in ('5501', '5502')
        );

        perform end_migration_log(v_log_id);
    END
$$;
\echo "transaction_amendments_comment_update.sql - Delete doctor_examination_comments - End"

\echo "transaction_amendments_comment_update.sql - Transfer over comments - Start"
DO $$
    DECLARE
        v_log_id bigint;

    BEGIN
        select start_migration_log('transaction_amendments_comment_update.sql') into v_log_id;
        commit;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, comment, created_at, updated_at, created_by, updated_by
        )
        select
            mec.transaction_id, mec.condition_id, de.id, mec.comment, mec.created_at, mec.updated_at, mec.created_by, mec.updated_by
        from
            medical_examination_comments mec join doctor_examinations de on de.transaction_id = mec.transaction_id
        where mec.transaction_id in (
            select ta.transaction_id from transaction_amendments ta join medical_examinations me on ta.transaction_id = me.transaction_id
        ) and condition_id in (
            select id from conditions where code in ('5501', '5502')
        );

        perform end_migration_log(v_log_id);
    END
$$;
\echo "transaction_amendments_comment_update.sql - Transfer over comments - End"

\echo "transaction_amendments_comment_update.sql ended"