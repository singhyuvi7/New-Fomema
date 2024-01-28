\echo "fw_details_update_doctor_examinations_system.sql loaded"

\echo "Update doctor_examinations.system_cardiovascular_heart_size - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_cardiovascular_heart_size') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3011';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_cardiovascular_heart_size - End"

\echo "Update doctor_examinations.system_cardiovascular_heart_sounds - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_cardiovascular_heart_sounds') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3012';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_cardiovascular_heart_sounds - End"

\echo "Update doctor_examinations.system_cardiovascular_other_findings - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_cardiovascular_other_findings') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3013';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_cardiovascular_other_findings - End"

\echo "Update doctor_examinations.system_respiratory_breath_sounds - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_respiratory_breath_sounds') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3021';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_respiratory_breath_sounds - End"

\echo "Update doctor_examinations.system_respiratory_other_findings - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_respiratory_other_findings') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3022';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_respiratory_other_findings - End"

\echo "Update doctor_examinations.gastrointestinal_liver - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_liver') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3031';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_liver - End"

\echo "Update doctor_examinations.gastrointestinal_spleen - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_spleen') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3032';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_spleen - End"

\echo "Update doctor_examinations.system_genitourinary_kidney - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_genitourinary_kidney') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3033';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_genitourinary_kidney - End"

\echo "Update doctor_examinations.gastrointestinal_swelling - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_swelling') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3034';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_swelling - End"

\echo "Update doctor_examinations.gastrointestinal_lymph_nodes - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_lymph_nodes') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3035';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_lymph_nodes - End"

\echo "Update doctor_examinations.gastrointestinal_rectal_examination - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_rectal_examination') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3036';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_rectal_examination - End"

\echo "Update doctor_examinations.gastrointestinal_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.gastrointestinal_other') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3037';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.gastrointestinal_other - End"

\echo "Update doctor_examinations.system_nervous_general_mental_status - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_general_mental_status') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3041';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_general_mental_status - End"

\echo "Update doctor_examinations.system_nervous_speech - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_speech') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3042';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_speech - End"

\echo "Update doctor_examinations.system_nervous_cognitive_function - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_cognitive_function') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3043';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_cognitive_function - End"

\echo "Update doctor_examinations.system_nervous_size_of_peripheral_nerves - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_size_of_peripheral_nerves') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3044';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_size_of_peripheral_nerves - End"

\echo "Update doctor_examinations.system_nervous_motor_power - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_motor_power') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3045';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_motor_power - End"

\echo "Update doctor_examinations.system_nervous_sensory - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_sensory') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3046';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_sensory - End"

\echo "Update doctor_examinations.system_nervous_reflexes - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_reflexes') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3047';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_reflexes - End"

\echo "Update doctor_examinations.system_genitourinary_discharge - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_genitourinary_discharge') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3051';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_genitourinary_discharge - End"

\echo "Update doctor_examinations.system_genitourinary_sores_ulcers - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_genitourinary_sores_ulcers') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3052';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_genitourinary_sores_ulcers - End"

\echo "Update doctor_examinations.system_nervous_general_appearance - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_general_appearance') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3053';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_general_appearance - End"

\echo "Update doctor_examinations.system_nervous_speech_quality - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_speech_quality') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3054';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_speech_quality - End"

\echo "Update doctor_examinations.system_nervous_speech_coherent - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_speech_coherent') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3055';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_speech_coherent - End"

\echo "Update doctor_examinations.system_nervous_speech_relevant - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_speech_relevant') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3056';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_speech_relevant - End"

\echo "Update doctor_examinations.system_nervous_mood - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3057';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood - End"

\echo "Update doctor_examinations.system_nervous_mood_depressed - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood_depressed') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3077';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood_depressed - End"

\echo "Update doctor_examinations.system_nervous_mood_depressed_feeling_down - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood_depressed_feeling_down') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3058';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood_depressed_feeling_down - End"

\echo "Update doctor_examinations.system_nervous_mood_depressed_lost_interest - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood_depressed_lost_interest') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3059';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood_depressed_lost_interest - End"

\echo "Update doctor_examinations.system_nervous_mood_anxious - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood_anxious') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3060';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood_anxious - End"

\echo "Update doctor_examinations.system_nervous_mood_irritable - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_mood_irritable') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3061';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_mood_irritable - End"

\echo "Update doctor_examinations.system_nervous_affect - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_affect') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3062';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_affect - End"

\echo "Update doctor_examinations.system_nervous_thought - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_thought') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3063';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_thought - End"

\echo "Update doctor_examinations.system_nervous_thought_delusion - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_thought_delusion') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3064';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_thought_delusion - End"

\echo "Update doctor_examinations.system_nervous_thought_suicidality - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_thought_suicidality') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3078';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_thought_suicidality - End"

\echo "Update doctor_examinations.system_nervous_thought_suicidality_worth_living - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_thought_suicidality_worth_living') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3065';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_thought_suicidality_worth_living - End"

\echo "Update doctor_examinations.system_nervous_thought_suicidality_ending_life - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_thought_suicidality_ending_life') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3066';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_thought_suicidality_ending_life - End"

\echo "Update doctor_examinations.system_nervous_perception - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_perception') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3067';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_perception - End"

\echo "Update doctor_examinations.system_nervous_orientation - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_orientation') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3068';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_orientation - End"

\echo "Update doctor_examinations.system_nervous_time - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_time') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3069';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_time - End"

\echo "Update doctor_examinations.system_nervous_place - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_place') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3070';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_place - End"

\echo "Update doctor_examinations.system_nervous_person - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_person') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3071';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_person - End"

\echo "Update doctor_examinations.system_nervous_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_nervous_other') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3072';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_nervous_other - End"

\echo "Update doctor_examinations.system_breast_abnormal_discharge - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_breast_abnormal_discharge') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3073';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_breast_abnormal_discharge - End"

\echo "Update doctor_examinations.system_breast_lump - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_breast_lump') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3074';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_breast_lump - End"

\echo "Update doctor_examinations.system_breast_axillary_lympth_node - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_breast_axillary_lympth_node') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3075';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_breast_axillary_lympth_node - End"

\echo "Update doctor_examinations.system_breast_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_breast_other') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '3076';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_breast_other - End"

\echo "Update doctor_examinations.system_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.system_comment') into v_log_id;
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
            fwc.parameter_code = '5102';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.system_comment - End"

\echo "fw_details_update_doctor_examinations_system.sql ended"