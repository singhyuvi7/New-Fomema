/*
    DoctorExamination
    Only in Doctor Examination
        doctor_id

    transaction_id
    physical_height
    physical_weight
    physical_pulse
    physical_blood_pressure_systolic
    physical_blood_pressure_diastolic
    physical_last_menstrual_period_date
    result
    suitability
    transmitted_at
    created_at
    updated_at
    created_by
    updated_by
*/

\echo "quarantine_fw_doc_medical_examinations.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
        loop_counter integer := 0;
        offset_amount integer := 0;
    BEGIN
        select start_migration_log('quarantine_fw_doc_medical_examinations - Creating MedicalExaminations.sql') into v_log_id;
        commit;

        loop
            exit when loop_counter = 11;
            raise notice 'Loop counter -> %', loop_counter;
            offset_amount := 70000 * loop_counter;
            raise notice 'Offset amount -> %', offset_amount;

            insert into medical_examinations (
                transaction_id, physical_height, physical_weight, physical_pulse,
                physical_blood_pressure_systolic, physical_blood_pressure_diastolic, physical_last_menstrual_period_date,
                result,
                suitability, transmitted_at,
                created_at,
                updated_at,
                created_by, updated_by
            )
            select
                de.transaction_id, de.physical_height, de.physical_weight, de.physical_pulse,
                de.physical_blood_pressure_systolic, de.physical_blood_pressure_diastolic, de.physical_last_menstrual_period_date,
                case
                    when de.result = 'ABNORMAL' or de.suitability = 'UNSUITABLE' then 'ABNORMAL'
                    else 'NORMAL' end,
                de.suitability, de.transmitted_at,
                coalesce(qfwd.time_inserted, clock_timestamp()),
                coalesce(qfwd.modification_date, clock_timestamp()),
                updator_users.id, updator_users.id
            from
                doctor_examinations de
                join transactions local_trans on de.transaction_id = local_trans.id
                join fomema_backup_nios.quarantine_fw_doc qfwd on local_trans.code = qfwd.trans_id
                left join fomema_backup_nios.v_user_master mod_user on qfwd.modification_id = mod_user.uuid
                left join users updator_users on mod_user.userid = updator_users.code
            order by
                qfwd.trans_id
            limit 70000 offset offset_amount;

            loop_counter := loop_counter + 1;
        end loop;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "quarantine_fw_doc_medical_examinations.sql ended"