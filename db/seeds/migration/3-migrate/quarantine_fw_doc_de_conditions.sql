\echo "quarantine_fw_doc_de_conditions.sql loaded"

\echo "condition_hiv - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_hiv') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3501' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_hiv = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_hiv - End"

\echo "condition_tuberculosis - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_tuberculosis') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3502' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_tb = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_tuberculosis - End"

\echo "condition_malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_malaria') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3503' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_malaria = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_malaria - End"

\echo "condition_leprosy - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_leprosy') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3504' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_leprosy = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_leprosy - End"

\echo "condition_std - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_std') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3505' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_std = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_std - End"

\echo "condition_hepatitis - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_hepatitis') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3506' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_hepatitis = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_hepatitis - End"

\echo "condition_cancer - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_cancer') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3507' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_cancer = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_cancer - End"

\echo "condition_epilepsy - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_epilepsy') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3508' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_epilepsy = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_epilepsy - End"

\echo "condition_psychiatric_disorder - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_psychiatric_disorder') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3509' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_psych = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_psychiatric_disorder - End"

\echo "condition_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3520' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_others6 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_other - End"

\echo "condition_hypertension - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_hypertension') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3514' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_hypertension = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_hypertension - End"

\echo "condition_heart_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_heart_diseases') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3515' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_heart_diseases = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_heart_diseases - End"

\echo "condition_bronchial_asthma - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_bronchial_asthma') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3516' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_asthma = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_bronchial_asthma - End"

\echo "condition_diabetes_mellitus - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_diabetes_mellitus') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3517' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_diabetes = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_diabetes_mellitus - End"

\echo "condition_peptic_ulcer - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_peptic_ulcer') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3518' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_ulcer = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_peptic_ulcer - End"

\echo "condition_kidney_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_kidney_diseases') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3519' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_kidney = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_kidney_diseases - End"

\echo "condition_urine_for_pregnant - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_urine_for_pregnant') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3510' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_pregnant = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_urine_for_pregnant - End"

\echo "condition_urine_for_opiates - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_urine_for_opiates') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3512' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_opiates = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_urine_for_opiates - End"

\echo "condition_urine_for_cannabis - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_conditions.sql - condition_urine_for_cannabis') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3511' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp())
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d6_cannabis = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "condition_urine_for_cannabis - End"

\echo "quarantine_fw_doc_de_conditions.sql ended"