\echo "quarantine_fw_doc_de_physicals.sql loaded"

\echo "physical_chronic_skin_rash - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_chronic_skin_rash') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3401' limit 1;
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
            d5_skinrash = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_chronic_skin_rash - End"

\echo "physical_anaesthetic_skin_patch - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_anaesthetic_skin_patch') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3402' limit 1;
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
            d5_skinpatch = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_anaesthetic_skin_patch - End"

\echo "physical_deformities_of_limbs - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_deformities_of_limbs') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3403' limit 1;
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
            d5_deformities = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_deformities_of_limbs - End"

\echo "physical_pallor - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_pallor') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3404' limit 1;
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
            d5_anaemia = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_pallor - End"

\echo "physical_jaundice - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_jaundice') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3405' limit 1;
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
            d5_jaundice = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_jaundice - End"

\echo "physical_lymph_node_enlargement - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_lymph_node_enlargement') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3406' limit 1;
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
            d5_enlargement = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_lymph_node_enlargement - End"

\echo "physical_vision_test_aided_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_vision_test_aided_left') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3407' limit 1;
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
            d5_vision_aidedleft = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_vision_test_aided_left - End"

\echo "physical_vision_test_aided_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_vision_test_aided_right') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3408' limit 1;
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
            d5_vision_aidedright = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_vision_test_aided_right - End"

\echo "physical_vision_test_unaided_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_vision_test_unaided_left') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3409' limit 1;
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
            d5_vision_unaidedleft = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_vision_test_unaided_left - End"

\echo "physical_vision_test_unaided_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_vision_test_unaided_right') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3410' limit 1;
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
            d5_vision_unaidedright = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_vision_test_unaided_right - End"

\echo "physical_hearing_ability_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_hearing_ability_left') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3411' limit 1;
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
            d5_hearingleft = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_hearing_ability_left - End"

\echo "physical_hearing_ability_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_hearing_ability_right') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3412' limit 1;
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
            d5_hearingright = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_hearing_ability_right - End"

\echo "physical_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        condition_id integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_de_physicals.sql - physical_other') into v_log_id;
        commit;

        select id into condition_id from conditions where code = '3413' limit 1;
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
            d5_others = 'Y';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "physical_other - End"

\echo "quarantine_fw_doc_de_physicals.sql ended"