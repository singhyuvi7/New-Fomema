\echo "quarantine_fw_doc_de_comments.sql loaded"

\echo "history_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_comments.sql - history_comment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5101' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, comment
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_comments
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_comments is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_comment - End"

\echo "physical_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_comments.sql - physical_comment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5103' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, comment
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d5_comments
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d5_comments is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_comment - End"

\echo "system_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_comments.sql - system_comment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5102' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, comment
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d4_comments
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d4_comments is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_comment - End"

\echo "certification_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_comments.sql - certification_comment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5501' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, comment
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d7_comments
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d7_comments is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "certification_comment - End"

\echo "unsuitable_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_comments.sql - unsuitable_comment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5502' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_comments (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, comment
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d7_unfit_reason
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d7_unfit_reason is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "unsuitable_comment - End"

\echo "quarantine_fw_doc_de_comments.sql loaded"