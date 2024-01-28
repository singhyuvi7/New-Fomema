\echo "fw_details_update_doctor_examinations_condition.sql loaded"

\echo "Update doctor_examinations.condition_hiv - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_hiv') into v_log_id;
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
            fwd.parameter_code = '3501';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_hiv - End"

\echo "Update doctor_examinations.condition_tuberculosis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_tuberculosis') into v_log_id;
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
            fwd.parameter_code = '3502';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_tuberculosis - End"

\echo "Update doctor_examinations.condition_malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_malaria') into v_log_id;
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
            fwd.parameter_code = '3503';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_malaria - End"

\echo "Update doctor_examinations.condition_leprosy - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_leprosy') into v_log_id;
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
            fwd.parameter_code = '3504';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_leprosy - End"

\echo "Update doctor_examinations.condition_std - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_std') into v_log_id;
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
            fwd.parameter_code = '3505';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_std - End"

\echo "Update doctor_examinations.condition_hepatitis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_hepatitis') into v_log_id;
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
            fwd.parameter_code = '3506';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_hepatitis - End"

\echo "Update doctor_examinations.condition_cancer - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_cancer') into v_log_id;
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
            fwd.parameter_code = '3507';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_cancer - End"

\echo "Update doctor_examinations.condition_epilepsy - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_epilepsy') into v_log_id;
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
            fwd.parameter_code = '3508';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_epilepsy - End"

\echo "Update doctor_examinations.condition_psychiatric_disorder - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_psychiatric_disorder') into v_log_id;
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
            fwd.parameter_code = '3509';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_psychiatric_disorder - End"

\echo "Update doctor_examinations.condition_urine_for_pregnant - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_urine_for_pregnant') into v_log_id;
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
            fwd.parameter_code = '3510';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_urine_for_pregnant - End"

\echo "Update doctor_examinations.condition_urine_for_cannabis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_urine_for_cannabis') into v_log_id;
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
            fwd.parameter_code = '3511';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_urine_for_cannabis - End"

\echo "Update doctor_examinations.condition_urine_for_opiates - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_urine_for_opiates') into v_log_id;
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
            fwd.parameter_code = '3512';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_urine_for_opiates - End"

\echo "Update doctor_examinations.condition_hypertension - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_hypertension') into v_log_id;
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
            fwd.parameter_code = '3514';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_hypertension - End"

\echo "Update doctor_examinations.condition_heart_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_heart_diseases') into v_log_id;
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
            fwd.parameter_code = '3515';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_heart_diseases - End"

\echo "Update doctor_examinations.condition_bronchial_asthma - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_bronchial_asthma') into v_log_id;
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
            fwd.parameter_code = '3516';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_bronchial_asthma - End"

\echo "Update doctor_examinations.condition_diabetes_mellitus - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_diabetes_mellitus') into v_log_id;
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
            fwd.parameter_code = '3517';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_diabetes_mellitus - End"

\echo "Update doctor_examinations.condition_peptic_ulcer - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_peptic_ulcer') into v_log_id;
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
            fwd.parameter_code = '3518';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_peptic_ulcer - End"

\echo "Update doctor_examinations.condition_kidney_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_kidney_diseases') into v_log_id;
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
            fwd.parameter_code = '3519';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_kidney_diseases - End"

\echo "Update doctor_examinations.condition_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
        other_condition_id int;
    BEGIN
        select start_migration_log('Update doctor_examinations.condition_other') into v_log_id;
        commit;

        select id into other_condition_id from conditions where code = '3520' limit 1;

        with transaction_ids as (
            select distinct(trans_id) from fomema_backup_nios.fw_detail where parameter_code = '3513' and trans_id not in (
                select distinct(trans_id) from fomema_backup_nios.fw_detail where parameter_code in ('3514', '3515', '3516', '3517', '3518', '3519', '3520')
            )

            union
            select distinct(trans_id) from fomema_backup_nios.fw_detail where parameter_code = '3520'
        )

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, other_condition_id
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join transaction_ids ti on ti.trans_id = local_trans.code;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.condition_other - End"

\echo "fw_details_update_doctor_examinations_condition.sql ended"