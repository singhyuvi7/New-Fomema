\echo "quarantine_fw_doc_de_history_and_follow_up.sql loaded"

\echo "history_hiv - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_hiv') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3101' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_hiv_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_hiv = 'Y' or d1_hiv_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_hiv - End"

\echo "history_tuberculosis - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_tuberculosis') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3102' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_tb_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_tb = 'Y' or d1_tb_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_tuberculosis - End"

\echo "history_leprosy - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_leprosy') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3103' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_leprosy_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_leprosy = 'Y' or d1_leprosy_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_leprosy - End"

\echo "history_viral_hepatitis - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_viral_hepatitis') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3104' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_hepatitis_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_hepatitis = 'Y' or d1_hepatitis_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_viral_hepatitis - End"

\echo "history_psychiatric_illness - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_psychiatric_illness') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3105' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_psych_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_psych = 'Y' or d1_psych_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_psychiatric_illness - End"

\echo "history_epilepsy - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_epilepsy') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3106' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_epilepsy_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_epilepsy = 'Y' or d1_epilepsy_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_epilepsy - End"

\echo "history_cancer - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_cancer') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3107' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_cancer_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_cancer = 'Y' or d1_cancer_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_cancer - End"

\echo "history_std - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_std') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3108' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_std_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_std = 'Y' or d1_std_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_std - End"

\echo "history_malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_malaria') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3201' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d1_malaria_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d1_malaria = 'Y' or d1_malaria_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_malaria - End"

\echo "history_hypertension - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_hypertension') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3202' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_hypertension_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_hypertension = 'Y' or d2_hypertension_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_hypertension - End"

\echo "history_heart_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_heart_diseases') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3203' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_heartdisease_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_heartdisease = 'Y' or d2_heartdisease_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_heart_diseases - End"

\echo "history_bronchial_asthma - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_bronchial_asthma') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3204' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_asthma_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_asthma = 'Y' or d2_asthma_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_bronchial_asthma - End"

\echo "history_diabetes_mellitus - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_diabetes_mellitus') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3205' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_diabetes_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_diabetes = 'Y' or d2_diabetes_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_diabetes_mellitus - End"

\echo "history_peptic_ulcer - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_peptic_ulcer') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3206' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_ulcer_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_ulcer = 'Y' or d2_ulcer_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_peptic_ulcer - End"

\echo "history_kidney_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_kidney_diseases') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3207' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_kidney_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_kidney = 'Y' or d2_kidney_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_kidney_diseases - End"

\echo "history_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3209' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d2_others_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d2_others = 'Y' or d2_others_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_other - End"

\echo "notified_health_office - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - notified_health_office') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5001' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d8_notifymoh_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d8_notifymoh = 'Y' or d8_notifymoh_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "notified_health_office - End"

\echo "referred_to_government_hospital - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - referred_to_government_hospital') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5002' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d8_refergh_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d8_refergh = 'Y' or d8_refergh_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "referred_to_government_hospital - End"

\echo "referred_to_private_hospital - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - referred_to_private_hospital') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5003' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d8_referph_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d8_referph = 'Y' or d8_referph_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "referred_to_private_hospital - End"

\echo "treating_patient - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - treating_patient') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5004' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d8_treatpatient_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d8_treatpatient = 'Y' or d8_treatpatient_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "treating_patient - End"

\echo "undergoing_treatment - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - undergoing_treatment') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '5005' limit 1;
        raise notice 'Condition ID -> %', condition_id;

        insert into doctor_examination_details (
            transaction_id, condition_id, doctor_examination_id, created_at, updated_at, date_value
        )
        select
            local_trans.id, condition_id, de.id, coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            qfwd.d8_ongoingtreatment_date
        from
            fomema_backup_nios.quarantine_fw_doc qfwd join transactions local_trans on local_trans.code = qfwd.trans_id
            join doctor_examinations de on de.transaction_id = local_trans.id
        where
            d8_ongoingtreatment = 'Y' or d8_ongoingtreatment_date is not null;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "undergoing_treatment - End"

\echo "history_taken_drug_recently - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_history_and_follow_up.sql - history_taken_drug_recently') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3210' limit 1;
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
            d2_taken_drugs = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "history_taken_drug_recently - End"

\echo "quarantine_fw_doc_de_history_and_follow_up.sql ended"