\echo "fw_details_update_doctor_examinations_follow_up.sql loaded"

\echo "Update doctor_examinations.notified_health_office - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.notified_health_office') into v_log_id;
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
            fwd.parameter_code = '5001';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.notified_health_office - End"

\echo "Update doctor_examinations.referred_to_government_hospital - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.referred_to_government_hospital') into v_log_id;
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
            fwd.parameter_code = '5002';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.referred_to_government_hospital - End"

\echo "Update doctor_examinations.referred_to_private_hospital - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.referred_to_private_hospital') into v_log_id;
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
            fwd.parameter_code = '5003';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.referred_to_private_hospital - End"

\echo "Update doctor_examinations.treating_patient - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.treating_patient') into v_log_id;
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
            fwd.parameter_code = '5004';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.treating_patient - End"

\echo "Update doctor_examinations.undergoing_treatment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.undergoing_treatment') into v_log_id;
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
            fwd.parameter_code = '5005';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.undergoing_treatment - End"

\echo "fw_details_update_doctor_examinations_follow_up.sql ended"