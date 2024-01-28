\echo "quarantine_fw_doc_de_systems.sql loaded"

\echo "system_cardiovascular_heart_size - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_cardiovascular_heart_size') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3011' limit 1;
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
            d3_heartsize = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_cardiovascular_heart_size - End"

\echo "system_cardiovascular_heart_sounds - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_cardiovascular_heart_sounds') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3012' limit 1;
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
            d3_heartsound = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_cardiovascular_heart_sounds - End"

\echo "system_cardiovascular_other_findings - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_cardiovascular_other_findings') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3013' limit 1;
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
            d3_othercardio = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_cardiovascular_other_findings - End"

\echo "system_respiratory_breath_sounds - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_respiratory_breath_sounds') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3021' limit 1;
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
            d3_breathsound = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_respiratory_breath_sounds - End"

\echo "system_respiratory_other_findings - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_respiratory_other_findings') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3022' limit 1;
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
            d3_otherrespiratory = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_respiratory_other_findings - End"

\echo "gastrointestinal_liver - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_liver') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3031' limit 1;
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
            d3_liver = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_liver - End"

\echo "gastrointestinal_spleen - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_spleen') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3032' limit 1;
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
            d3_spleen = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_spleen - End"

\echo "gastrointestinal_swelling - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_swelling') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3034' limit 1;
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
            d3_swelling = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_swelling - End"

\echo "gastrointestinal_lymph_nodes - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_lymph_nodes') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3035' limit 1;
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
            d3_lymphnodes = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_lymph_nodes - End"

\echo "gastrointestinal_rectal_examination - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_rectal_examination') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3036' limit 1;
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
            d3_rectal = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_rectal_examination - End"

\echo "gastrointestinal_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - gastrointestinal_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3037' limit 1;
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
            d3_other = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "gastrointestinal_other - End"

\echo "system_nervous_general_mental_status - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_general_mental_status') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3041' limit 1;
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
            d4_mental = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_general_mental_status - End"

\echo "system_nervous_general_appearance - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_general_appearance') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3053' limit 1;
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
            d4_appearance = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_general_appearance - End"

\echo "system_nervous_speech_quality - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_speech_quality') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3054' limit 1;
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
            d4_speechquality = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_speech_quality - End"

\echo "system_nervous_speech_coherent - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_speech_coherent') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3055' limit 1;
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
            d4_coherent = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_speech_coherent - End"

\echo "system_nervous_speech_relevant - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_speech_relevant') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3056' limit 1;
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
            d4_relevant = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_speech_relevant - End"

\echo "system_nervous_mood - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3057' limit 1;
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
            d4_mood = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood - End"

\echo "system_nervous_mood_depressed - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood_depressed') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3077' limit 1;
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
            d4_depressed = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood_depressed - End"

\echo "system_nervous_mood_depressed_feeling_down - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood_depressed_feeling_down') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3058' limit 1;
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
            d4_depressed1 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood_depressed_feeling_down - End"

\echo "system_nervous_mood_depressed_lost_interest - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood_depressed_lost_interest') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3059' limit 1;
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
            d4_depressed2 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood_depressed_lost_interest - End"

\echo "system_nervous_mood_anxious - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood_anxious') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3060' limit 1;
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
            d4_anxious = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood_anxious - End"

\echo "system_nervous_mood_irritable - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_mood_irritable') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3061' limit 1;
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
            d4_irritable = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_mood_irritable - End"

\echo "system_nervous_affect - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_affect') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3062' limit 1;
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
            d4_affect = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_affect - End"

\echo "system_nervous_thought - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_thought') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3063' limit 1;
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
            d4_thought = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_thought - End"

\echo "system_nervous_thought_delusion - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_thought_delusion') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3064' limit 1;
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
            d4_delusion = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_thought_delusion - End"

\echo "system_nervous_thought_suicidality - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_thought_suicidality') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3078' limit 1;
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
            d4_suicidality = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_thought_suicidality - End"

\echo "system_nervous_thought_suicidality_worth_living - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_thought_suicidality_worth_living') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3065' limit 1;
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
            d4_suicidality1 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_thought_suicidality_worth_living - End"

\echo "system_nervous_thought_suicidality_ending_life - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_thought_suicidality_ending_life') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3066' limit 1;
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
            d4_suicidality2 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_thought_suicidality_ending_life - End"

\echo "system_nervous_perception - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_perception') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3067' limit 1;
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
            d4_perception = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_perception - End"

\echo "system_nervous_orientation - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_orientation') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3068' limit 1;
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
            d4_orientation = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_orientation - End"

\echo "system_nervous_time - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_time') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3069' limit 1;
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
            d4_time = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_time - End"

\echo "system_nervous_place - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_place') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3070' limit 1;
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
            d4_place = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_place - End"

\echo "system_nervous_person - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_person') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3071' limit 1;
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
            d4_person = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_person - End"

\echo "system_nervous_speech - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_speech') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3042' limit 1;
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
            d4_speech = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_speech - End"

\echo "system_nervous_cognitive_function - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_cognitive_function') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3043' limit 1;
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
            d4_cognitive = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_cognitive_function - End"

\echo "system_nervous_size_of_peripheral_nerves - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_size_of_peripheral_nerves') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3044' limit 1;
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
            d4_peripheralnerves = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_size_of_peripheral_nerves - End"

\echo "system_nervous_motor_power - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_motor_power') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3045' limit 1;
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
            d4_motorpower = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_motor_power - End"

\echo "system_nervous_sensory - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_sensory') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3046' limit 1;
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
            d4_sensory = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_sensory - End"

\echo "system_nervous_reflexes - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_reflexes') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3047' limit 1;
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
            d4_reflexes = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_reflexes - End"

\echo "system_nervous_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_nervous_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3072' limit 1;
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
            d4_other = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_nervous_other - End"

\echo "system_genitourinary_kidney - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_genitourinary_kidney') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3033' limit 1;
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
            d4_kidney = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_genitourinary_kidney - End"

\echo "system_genitourinary_discharge - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_genitourinary_discharge') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3051' limit 1;
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
            d4_gendischarge = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_genitourinary_discharge - End"

\echo "system_genitourinary_sores_ulcers - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_genitourinary_sores_ulcers') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3052' limit 1;
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
            d4_gensores = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_genitourinary_sores_ulcers - End"

\echo "system_breast_abnormal_discharge - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_breast_abnormal_discharge') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3073' limit 1;
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
            d4_discharge = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_breast_abnormal_discharge - End"

\echo "system_breast_lump - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_breast_lump') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3074' limit 1;
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
            d4_lump = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_breast_lump - End"

\echo "system_breast_axillary_lympth_node - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_breast_axillary_lympth_node') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3075' limit 1;
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
            d4_axillary = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_breast_axillary_lympth_node - End"

\echo "system_breast_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_systems.sql - system_breast_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3076' limit 1;
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
            d4_other6 = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "system_breast_other - End"

\echo "quarantine_fw_doc_de_systems.sql ended"