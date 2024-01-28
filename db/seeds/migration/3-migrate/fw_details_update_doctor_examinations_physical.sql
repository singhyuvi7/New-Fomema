\echo "fw_details_update_doctor_examinations_physical.sql loaded"

\echo "Update doctor_examinations.physical_chronic_skin_rash - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_chronic_skin_rash') into v_log_id;
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
            fwd.parameter_code = '3401';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_chronic_skin_rash - End"

\echo "Update doctor_examinations.physical_anaesthetic_skin_patch - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_anaesthetic_skin_patch') into v_log_id;
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
            fwd.parameter_code = '3402';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_anaesthetic_skin_patch - End"

\echo "Update doctor_examinations.physical_deformities_of_limbs - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_deformities_of_limbs') into v_log_id;
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
            fwd.parameter_code = '3403';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_deformities_of_limbs - End"

\echo "Update doctor_examinations.physical_pallor - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_pallor') into v_log_id;
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
            fwd.parameter_code = '3404';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_pallor - End"

\echo "Update doctor_examinations.physical_jaundice - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_jaundice') into v_log_id;
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
            fwd.parameter_code = '3405';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_jaundice - End"

\echo "Update doctor_examinations.physical_lymph_node_enlargement - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_lymph_node_enlargement') into v_log_id;
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
            fwd.parameter_code = '3406';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_lymph_node_enlargement - End"

\echo "Update doctor_examinations.physical_vision_test_aided_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_vision_test_aided_left') into v_log_id;
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
            fwd.parameter_code = '3407';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_vision_test_aided_left - End"

\echo "Update doctor_examinations.physical_vision_test_aided_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_vision_test_aided_right') into v_log_id;
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
            fwd.parameter_code = '3408';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_vision_test_aided_right - End"

\echo "Update doctor_examinations.physical_vision_test_unaided_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_vision_test_unaided_left') into v_log_id;
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
            fwd.parameter_code = '3409';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_vision_test_unaided_left - End"

\echo "Update doctor_examinations.physical_vision_test_unaided_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_vision_test_unaided_right') into v_log_id;
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
            fwd.parameter_code = '3410';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_vision_test_unaided_right - End"

\echo "Update doctor_examinations.physical_hearing_ability_left - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_hearing_ability_left') into v_log_id;
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
            fwd.parameter_code = '3411';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_hearing_ability_left - End"

\echo "Update doctor_examinations.physical_hearing_ability_right - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_hearing_ability_right') into v_log_id;
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
            fwd.parameter_code = '3412';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_hearing_ability_right - End"

\echo "Update doctor_examinations.physical_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_other') into v_log_id;
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
            fwd.parameter_code = '3413';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_other - End"

\echo "Update doctor_examinations.physical_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.physical_comment') into v_log_id;
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
            fwc.parameter_code = '5103';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.physical_comment - End"

\echo "fw_details_update_doctor_examinations_physical.sql ended"