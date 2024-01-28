\echo "fw_transaction_static.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_transaction_static.sql') into v_log_id;
        commit;

        -- Please note that the earliest transaction_static is from December 2012. I have checked, that after joining, it is all correct.
        with trans_id_code as (
            select id, code from transactions where transaction_date > '2012-11-01'
        )

        insert into transaction_statics (
            transaction_id,
            code,
            worker_code,
            worker_name,
            passport_number,
            country_id,
            emp_code,
            emp_name,
            emp_address1,
            emp_address2,
            emp_address3,
            emp_address4,
            emp_postcode,
            emp_town_id,
            emp_state_id,
            doc_code,
            doc_name,
            clinic_name,
            doc_phone,
            doc_address1,
            doc_address2,
            doc_address3,
            doc_address4,
            doc_postcode,
            doc_town_id,
            doc_state_id,
            xray_code,
            xray_name,
            lab_code,
            lab_name,
            job_type,
            gender,
            dob,
            final_result,
            tcupi_ind,
            hiv, tuberculosis, malaria, leprosy, std, hepatitis, cancer, epilepsy, psychiatric_disorder, other, hypertension, heart_diseases, bronchial_asthma, diabetes_mellitus, peptic_ulcer, kidney_diseases, pregnant, opiates, cannabis,
            created_at,
            updated_at,
            arrival_date,
            transaction_date,
            examination_date,
            certify_date
        )
        select
            trans_id_code.id,
            fts.trans_id,
            fts.worker_code,
            fts.worker_name,
            fts.passport_no,
            countries.id,
            fts.emp_code,
            fts.emp_name,
            fts.emp_address1,
            fts.emp_address2,
            fts.emp_address3,
            fts.emp_address4,
            fts.emp_postcode,
            emp_towns.id,
            emp_states.id,
            fts.doc_code,
            fts.doc_name,
            fts.clinic_name,
            fts.doc_phone,
            fts.doc_address1,
            fts.doc_address2,
            fts.doc_address3,
            fts.doc_address4,
            fts.doc_postcode,
            doc_towns.id,
            doc_states.id,
            fts.xray_code,
            fts.xray_name,
            fts.lab_code,
            fts.lab_name,
            fts.job_type,
            fts.sex,
            TO_CHAR(fts.dob, 'YYYY-MM-DD'),
            case
                when fts.fit_ind = 'N' then 'SUITABLE'
                when fts.fit_ind = 'Y' then 'UNSUITABLE'
                else null end,
            fts.tcupi_ind,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            coalesce(fts.creation_date, clock_timestamp()),
            coalesce(fts.creation_date, clock_timestamp()),
            fts.arrival_date,
            fts.transdate,
            fts.exam_date,
            fts.certify_date
        from
            fomema_backup_moh.fw_transaction_static fts
            join trans_id_code on trans_id_code.code = fts.trans_id
            left join countries on countries.old_code = fts.country_code
            left join states emp_states on emp_states.code = fts.emp_state_code
            left join states doc_states on doc_states.code = fts.doc_state_code
            left join towns emp_towns on emp_towns.code = fts.emp_district_code
            left join towns doc_towns on doc_towns.code = fts.doc_district_code;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_transaction_static.sql ended"