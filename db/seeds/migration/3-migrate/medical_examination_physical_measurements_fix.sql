\echo "medical_examination_physical_measurements_fix.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('medical_examination_physical_measurements_fix.sql') into v_log_id;
        commit;

        -- After PR is released, the values will be updated. But because during migration, the PR are migrated over before they are done, and in the new system it doesn't update the same way, will need to migrate this way.
        with pending_review_transactions as (
            select trans_id from fomema_backup_nios.fw_transaction where trans_id in (
                select trans_id from fomema_backup_nios.quarantine_fw_doc
            ) and mr = 0
        ),

        transaction_ids as (
            select id from transactions where code in (select trans_id from pending_review_transactions)
        )

        UPDATE
            medical_examinations me
        SET
            physical_height = de.physical_height,
            physical_weight = de.physical_weight,
            physical_pulse = de.physical_pulse,
            physical_blood_pressure_systolic = de.physical_blood_pressure_systolic,
            physical_blood_pressure_diastolic = de.physical_blood_pressure_diastolic,
            physical_last_menstrual_period_date = de.physical_last_menstrual_period_date
        FROM
            doctor_examinations de
        WHERE
            (me.physical_height is null or me.transaction_id in (select id from transaction_ids))
            and me.transaction_id = de.transaction_id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "medical_examination_physical_measurements_fix.sql ended"