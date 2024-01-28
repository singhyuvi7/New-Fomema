\echo "fw_details_update_doctor_examinations_history.sql loaded"

/*
Medical History -> All these are medical history (31xx & 32xx)
    3101    HIV/AIDS
        => doctor_examinations.history_hiv "YES|NO" & doctor_examinations.history_hiv_date

    3102    Tuberculosis
        => doctor_examinations.history_tuberculosis "YES|NO" & doctor_examinations.history_tuberculosis_date

    3103    Leprosy
        => doctor_examinations.history_leprosy "YES|NO" & doctor_examinations.history_leprosy_date

    3104    Viral Hepatitis
        => doctor_examinations.history_viral_hepatitis "YES|NO" & doctor_examinations.history_viral_hepatitis_date

    3105    Psychiatric Illness
        => doctor_examinations.history_psychiatric_illness "YES|NO" & doctor_examinations.history_psychiatric_illness_date

    3106    Epilepsy
        => doctor_examinations.history_epilepsy "YES|NO" & doctor_examinations.history_epilepsy_date

    3107    Cancer
        => doctor_examinations.history_cancer "YES|NO" & doctor_examinations.history_cancer_date

    3108    Sexually Transmitted Disease
        => doctor_examinations.history_std "YES|NO" & doctor_examinations.history_std_date

    3109    Malaria
        => doctor_examinations.history_malaria "YES|NO" & doctor_examinations.history_malaria_date

    3201    Malaria
        => doctor_examinations.history_malaria "YES|NO" & doctor_examinations.history_malaria_date (Yes there are 2. This is the older 1)

    3202    Hypertension
        => doctor_examinations.history_hypertension "YES|NO" & doctor_examinations.history_hypertension_date

    3203    Heart Diseases
        => doctor_examinations.history_heart_diseases "YES|NO" & doctor_examinations.history_heart_diseases_date

    3204    Bronchial Asthma
        => doctor_examinations.history_bronchial_asthma "YES|NO" & doctor_examinations.history_bronchial_asthma_date

    3205    Diabetes Mellitus
        => doctor_examinations.history_diabetes_mellitus "YES|NO" & doctor_examinations.history_diabetes_mellitus_date

    3206    Peptic Ulcer
        => doctor_examinations.history_peptic_ulcer "YES|NO" & doctor_examinations.history_peptic_ulcer_date

    3207    Kidney Diseases
        => doctor_examinations.history_kidney_diseases "YES|NO" & doctor_examinations.history_kidney_diseases_date

    3209    Others
        => doctor_examinations.history_other "YES|NO" & doctor_examinations.history_other_date

    5101    Medical History Comments
        => doctor_examinations.history_comment
*/

\echo "Update doctor_examinations.history_hiv - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_hiv') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3101';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_hiv - End"

\echo "Update doctor_examinations.history_tuberculosis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_tuberculosis') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3102';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_tuberculosis - End"

\echo "Update doctor_examinations.history_leprosy - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_leprosy') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3103';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_leprosy - End"

\echo "Update doctor_examinations.history_viral_hepatitis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_viral_hepatitis') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3104';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_viral_hepatitis - End"

\echo "Update doctor_examinations.history_psychiatric_illness - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_psychiatric_illness') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3105';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_psychiatric_illness - End"

\echo "Update doctor_examinations.history_epilepsy - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_epilepsy') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3106';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_epilepsy - End"

\echo "Update doctor_examinations.history_cancer - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_cancer') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3107';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_cancer - End"

\echo "Update doctor_examinations.history_std - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_std') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3108';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_std - End"

\echo "Update doctor_examinations.history_malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_malaria') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3109';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_malaria - End"

\echo "Update doctor_examinations.history_malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_malaria') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3201';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_malaria - End"

\echo "Update doctor_examinations.history_hypertension - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_hypertension') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3202';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_hypertension - End"

\echo "Update doctor_examinations.history_heart_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_heart_diseases') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3203';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_heart_diseases - End"

\echo "Update doctor_examinations.history_bronchial_asthma - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_bronchial_asthma') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3204';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_bronchial_asthma - End"

\echo "Update doctor_examinations.history_diabetes_mellitus - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_diabetes_mellitus') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3205';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_diabetes_mellitus - End"

\echo "Update doctor_examinations.history_peptic_ulcer - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_peptic_ulcer') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3206';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_peptic_ulcer - End"

\echo "Update doctor_examinations.history_kidney_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_kidney_diseases') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3207';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_kidney_diseases - End"

\echo "Update doctor_examinations.history_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_other') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, date_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.effected_date
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3209';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_other - End"

\echo "Update doctor_examinations.history_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_comment') into v_log_id;
        commit;

        insert into doctor_examination_comments (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, comment
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwc.comments
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '5101';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.history_comment - End"

\echo "Update doctor_examinations.taken_drugs - Start"
DO $$
    DECLARE
        v_log_id bigint;
        taken_drugs_condition_id int;
    BEGIN
        select start_migration_log('Update doctor_examinations.history_other') into v_log_id;
        commit;

        select id into taken_drugs_condition_id from conditions where code = '3210' limit 1;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            lt.id, de.id, taken_drugs_condition_id
        from
            transactions lt
            join doctor_examinations de on de.transaction_id = lt.id
            join fomema_backup_nios.fw_transaction fwt on fwt.trans_id = lt.code
        where
            fwt.taken_drugs = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.taken_drugs - End"


\echo "fw_details_update_doctor_examinations_history.sql ended"