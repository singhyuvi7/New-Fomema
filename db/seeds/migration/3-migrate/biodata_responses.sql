\echo "biodata_responses.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('biodata_responses.sql') into v_log_id;
    commit;

	insert into biodata_responses (
        biodata_request_id, 
        foreign_worker_id, 
        status_code,
        status_message,
        description,
        row_count,
        passport_number, 
        nationality, 
        date_of_birth, 
        gender, 
        worker_name, 
        document_expiry_date, 
        document_issue_authority, 
        application_number, 
        afis_id,
        ners_reason_code, 
        date_of_arrival,
        employer_name, 
        employer_id, 
        employer_type, 
        employer_address_1,
        employer_address_2,
        employer_address_3, 
        employer_address_4, 
        employer_postcode, 
        employer_city,
        employer_state, 
        employer_email, 
        employer_phone_number, 
        ners_status, 
        ners_message, 
        fp_availability_status, 
        fp_bio_sl, 
        fp_avail, 
        transaction_id,
        renewal_count_years, 
        pra_create_id, 
        created_at, 
        updated_at
    ) 
    select br.id, 
        br.foreign_worker_id, 
        um.error_ind,
        case when error_ind = 'GWY0000' then 'SUCCESS' else 'ERROR' end,
        um.error_desc,
        case when error_ind = 'GWY0000' then 1 else 0 end,
        um.passport_no, 
        um.nationality, 
        um.date_of_birth, 
        um.gender, 
        um.worker_name, 
        um.doc_expiry_date, 
        um.doc_issue_authority,
        um.application_number, 
        um.afis_id,
        um.ners_reason_code, 
        um.date_of_arrival,
        um.employer_name, 
        um.employer_id, 
        um.employer_type, 
        um.employer_address1, 
        um.employer_address2, 
        um.employer_address3, 
        um.employer_address4, 
        um.employer_postcode, 
        um.employer_city,
        um.employer_state, 
        um.employer_email, 
        um.employer_phone_no, 
        um.ners_status, 
        um.ners_message, 
        um.fp_availability_status, 
        um.fp_biosl, 
        um.fp_avail, 
        um.transaction_id,
        cast(um.renew_count_year as int), 
        um.pra_create_id,
        um.creation_date, 
        um.creation_date
    from fomema_backup_nios.foreign_worker_biodata um
    join biodata_requests br on um.trans_id = br.app_transaction_id;

    perform end_migration_log(v_log_id);
end
$$;

\echo "biodata_responses.sql ended"