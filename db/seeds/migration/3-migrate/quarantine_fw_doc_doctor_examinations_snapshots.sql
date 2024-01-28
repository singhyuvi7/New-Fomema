\echo "quarantine_fw_doc_doctor_examinations_snapshots.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('quarantine_fw_doc_doctor_examinations_snapshots - Updating DoctorExaminations.sql') into v_log_id;
        commit;

        UPDATE
            doctor_examinations de
        SET
            physical_height = qfwd.d5_height,
            physical_weight = qfwd.d5_weight,
            physical_pulse = qfwd.d5_pulse,
            physical_blood_pressure_systolic = qfwd.d5_systolic,
            physical_blood_pressure_diastolic = qfwd.d5_diastolic,
            physical_last_menstrual_period_date = qfwd.last_pms_date,
            result = case when qfwd.d7_fw_medstatus = 'Y' then 'ABNORMAL' else 'NORMAL' end
        FROM
            transactions local_trans join fomema_backup_nios.quarantine_fw_doc qfwd on local_trans.code = qfwd.trans_id
        WHERE
            de.transaction_id = local_trans.id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "quarantine_fw_doc_doctor_examinations_snapshots.sql ended"