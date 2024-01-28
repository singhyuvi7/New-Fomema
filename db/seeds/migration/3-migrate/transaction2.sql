\echo 'transaction.sql loaded'

do $$
declare
    v_log_id bigint;
    v_count bigint;
begin
    select start_migration_log('transaction2.sql - main') into v_log_id;
    commit;

/* bypass fingerprint mapping */
drop table if exists z_bypass_fingerprint_reason_mappings;

create table if not exists z_bypass_fingerprint_reason_mappings (
    oldcode numeric(1),
    newcode character varying
);

create index if not exists idx_z_bypass_fingerprint_reason_mappings_on_oldcode on z_bypass_fingerprint_reason_mappings(oldcode);
create index if not exists idx_z_bypass_fingerprint_reason_mappings_on_newcode on z_bypass_fingerprint_reason_mappings(newcode);

insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (1, 'BT'); -- BELOW THRESHOLD
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (2, 'MNF'); -- MATCHING NOT FOUND
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (3, 'OTHER'); -- OTHERS
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (4, 'OTHER'); -- OTHERS
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (5, 'CC'); -- CHANGE COUPLING
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (6, 'EC'); -- EXPIRED CASE
insert into z_bypass_fingerprint_reason_mappings (oldcode, newcode) values (7, 'PHTPA'); -- PENDING HTP ACTION

-- insert into bypass_fingerprint_reasons (code, description, created_at, updated_at)
-- select error_ind, error_desc, clock_timestamp(), clock_timestamp() from fomema_backup_nios.bypass_error;
/* /bypass fingerprint mapping */
commit;

insert into transactions (
    code, doctor_id, employer_id,
    laboratory_id, radiologist_id,
    xray_facility_id, fw_code, foreign_worker_id,
    transaction_date, certification_date, doctor_transmit_date, medical_examination_date,
    laboratory_transmit_date, xray_transmit_date,
    medical_tcupi, worker_consented,
    updated_by, updated_at,
    created_by, created_at,
    ignore_expiry, ignore_merts_expiry_at,
    xray_film_type, fw_gender,
    fw_plks_number, fw_maid_online,
    fw_name, fw_date_of_birth, fw_passport_number, fw_country_id, fw_job_type_id,
    organization_id, expired_at,
    doctor_fp_result, xray_fp_result,
    doctor_fp_result_date, xray_fp_result_date,
    status,
    final_result,
    final_result_date,
    med_ind_count, reg_ind,
    medical_result,
    xray_result,
    medical_quarantine_release_date,
    xray_quarantine_release_date,
    digital_xray_provider_id,
    worker_matched,
    worker_identity_confirmed,
    xray_worker_identity_confirmed,
    ignore_reprint_rule,
    registration_type,
    unsuitable_slip_downloaded,
    xray_reporter_type,
    doctor_fp, xray_fp
)
select
    fwt.trans_id code, /* fwt.doctor_code */ doctors.id doctor_id, /* fwt.employer_code */ employers.id employer_id,
    /* fwt.laboratory_code */ laboratories.id laboratory_id, /* fwt.radiologist_code */ radiologists.id radiologist_id,
    /* fwt.xray_code */ xray_facilities.id xray_facility_id, fwt.worker_code, foreign_workers.id foreign_worker_id,
    fwt.transdate transaction_date, fwt.certify_date certification_date, fwt.certify_date doctor_transmit_date, fwt.exam_date medical_examination_date,
    fwt.lab_submit_date laboratory_transmit_date, fwt.xray_submit_date xray_transmit_date,
    /* fwt.tcupi_ind */ /* case when fwt.tcupi_ind in ('Y', 'X') then true else false end */ false medical_tcupi,
    /* fwt.worker_consent */ /* case when fwt.worker_consent = 'Y' then true else false end */ false worker_consented,
    /* fwt.modify_id */ updator_users.id updated_by, /* fwt.modification_date */ coalesce(fwt.modification_date, clock_timestamp()) updated_at,
    /* fwt.created_by */ creator_users.id created_by, fwt.transdate created_at,
    /* fwt.imr_ind */ /* case when fwt.imr_ind = 'Y' then true else false end */ false ignore_expiry, coalesce(fwt.modification_date, clock_timestamp()) ignore_merts_expiry_at,
    /* fwt.xray_film_type */ /* case when fwt.xray_film_type = 'D' then 'DIGITAL' when fwt.xray_film_type = 'P' then 'ANALOG' else null end */ null xray_film_type, fwt.sex fw_gender,
    /* fwt.plks_no */ fwt.plks_no::text fw_plks_number, /* fwt.ispra */ /* case when fwt.ispra = 1 then 'PRAON' else 'FOMEMA' end */ 'FOMEMA' fw_maid_online,
    foreign_workers.name fw_name, foreign_workers.date_of_birth fw_date_of_birth, foreign_workers.passport_number fw_passport_number, foreign_workers.country_id fw_country_id, foreign_workers.job_type_id fw_job_type_id,
    organizations.id organization_id, fwt.transdate + interval '30' day expired_at,
    /* case when fwt.docfp = 1 then 1 else 2 end */ 2 doctor_fp_result,
    /* case when fwt.xrayfp = 1 then 1 else 2 end */ 2 xray_fp_result,
    fwt.docfp_date doctor_fp_result_date, fwt.xrayfp_date xray_fp_result_date,
    /* case when fwt.fit_ind is not null then 'CERTIFIED' when fwt.certify_date is not null then 'REVIEW' when fwt.lab_submit_date is not null and fwt.xray_submit_date is not null then 'CERTIFICATION' when fwt.exam_date is not null then 'EXAMINATION' else 'NEW' end */ 'NEW' status,
    /* case when fwt.fit_ind = 'N' then 'SUITABLE' when fwt.fit_ind = 'Y' then 'UNSUITABLE' else null end */ null final_result,
    /* case when fwt.fit_ind is not null then fwt.modification_date else null end */ null final_result_date,
    fwt.med_ind med_ind_count, fwt.reg_ind reg_ind,
    /* case when fwt.mfit_ind = 0 then 'SUITABLE' when fwt.mfit_ind = 1 then 'UNSUITABLE' else null end */ null medical_result,
    /* case when fwt.xfit_ind = 0 then 'SUITABLE' when fwt.xfit_ind = 1 then 'UNSUITABLE' else null end */ null xray_result,
    fwt.release_date medical_quarantine_release_date,
    fwt.xrelease_date xray_quarantine_release_date,
    /* case when fwt.provider_id = 'SHC' then 1 else null end */ null digital_xray_provider_id,
    /* case when fwt.exam_date is not null then true else false end */ false worker_matched,
    /* case when fwt.exam_date is not null then true else false end */ false worker_identity_confirmed,
    /* case when fwt.xray_submit_date is not null then true else false end */ false xray_worker_identity_confirmed,
    /* case when fwt.irr_ind = 'Y' then true else false end */ false ignore_reprint_rule,
    /* case when fwt.renew_ind = 'Y' then 1 else 0 end */ 0 registration_type,
    /* case when fwt.unfit_printed = 'Y' then true else false end */ false unsuitable_slip_downloaded,
    /* case when fwt.xray_submit_date is not null then 'SELF' else null end */ null xray_reporter_type,
    false doctor_fp, false xray_fp
from
    fomema_backup_nios.fw_transaction fwt
    left join doctors on fwt.doctor_code = doctors.code
    left join employers on fwt.employer_code = employers.code
    left join laboratories on fwt.laboratory_code = laboratories.code
    left join radiologists on fwt.radiologist_code = radiologists.code
    left join xray_facilities on fwt.xray_code = xray_facilities.code
    left join foreign_workers on fwt.worker_code = foreign_workers.code
    left join fomema_backup_nios.v_user_master updators on fwt.modify_id = updators.uuid
    left join users updator_users on updators.userid = updator_users.code
    left join users creator_users on fwt.created_by is not null and substring(fwt.created_by, 3) = creator_users.code
    left join organizations on fwt.created_by is not null and substring(fwt.created_by, 1, 2) = organizations.code and organizations.org_type = 'BRANCH'
-- order by
--     fwt.transdate
;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - medical_tcupi') into v_log_id; commit;
    update transactions set medical_tcupi = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.tcupi_ind in ('Y', 'X');
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - worker_consented') into v_log_id; commit;
    update transactions set worker_consented = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.worker_consent = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - ignore_expiry') into v_log_id; commit;
    update transactions set ignore_expiry = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.imr_ind = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_film_type DIGITAL') into v_log_id; commit;
    update transactions set xray_film_type = 'DIGITAL' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xray_film_type = 'P';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_film_type ANALOG') into v_log_id; commit;
    update transactions set xray_film_type = 'ANALOG' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xray_film_type = 'D';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - fw_maid_online') into v_log_id; commit;
    update transactions set fw_maid_online = 'PRAON' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.ispra = 1;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - doctor_fp_result') into v_log_id; commit;
    update transactions set doctor_fp_result = 1 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.docfp = 1;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_fp_result') into v_log_id; commit;
    update transactions set xray_fp_result = 1 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xrayfp = 1;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - status EXAMINATION') into v_log_id; commit;
    update transactions set status = 'EXAMINATION' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.exam_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - status CERTIFICATION') into v_log_id; commit;
    update transactions set status = 'CERTIFICATION' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.lab_submit_date is not null and fwt.xray_submit_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - status REVIEW') into v_log_id; commit;
    update transactions set status = 'REVIEW' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.certify_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - status CERTIFIED') into v_log_id; commit;
    update transactions set status = 'CERTIFIED' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.fit_ind is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - final_result SUITABLE') into v_log_id; commit;
    update transactions set final_result = 'SUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.fit_ind = 'N';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - final_result UNSUITABLE') into v_log_id; commit;
    update transactions set final_result = 'UNSUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.fit_ind = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - final_result_date') into v_log_id; commit;
    update transactions set final_result_date = fwt.modification_date 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.fit_ind is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - medical_result SUITABLE') into v_log_id; commit;
    update transactions set medical_result = 'SUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.mfit_ind = 0;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - medical_result UNSUITABLE') into v_log_id; commit;
    update transactions set medical_result = 'UNSUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.mfit_ind = 1;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_result SUITABLE') into v_log_id; commit;
    update transactions set xray_result = 'SUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xfit_ind = 0;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_result UNSUITABLE') into v_log_id; commit;
    update transactions set xray_result = 'UNSUITABLE' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xfit_ind = 1;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - digital_xray_provider_id') into v_log_id; commit;
    update transactions set digital_xray_provider_id = 1 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.provider_id = 'SHC';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - worker_matched, worker_identity_confirmed') into v_log_id; commit;
    update transactions set worker_matched = true, worker_identity_confirmed = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.exam_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_worker_identity_confirmed') into v_log_id; commit;
    update transactions set xray_worker_identity_confirmed = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xray_submit_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - ignore_reprint_rule') into v_log_id; commit;
    update transactions set ignore_reprint_rule = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.irr_ind = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - registration_type') into v_log_id; commit;
    update transactions set registration_type = 1 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.renew_ind = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - unsuitable_slip_downloaded') into v_log_id; commit;
    update transactions set unsuitable_slip_downloaded = true 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.unfit_printed = 'Y';
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);

    select start_migration_log('transaction2.sql - xray_reporter_type') into v_log_id; commit;
    update transactions set xray_reporter_type = 'SELF' 
    from fomema_backup_nios.fw_transaction fwt 
    where fwt.trans_id = transactions.code and fwt.xray_submit_date is not null;
    GET DIAGNOSTICS v_count = ROW_COUNT;
    update migration_logs set comment = 'v_count: ' || v_count where id = v_log_id;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'transaction.sql end'


-- Statuses
    -- Included
    -- "NEW" => "NEW",
    -- "EXAMINATION" => "EXAMINATION",
    -- "CERTIFICATION" => "CERTIFICATION",
    -- "REVIEW" => "REVIEW",
    -- "CERTIFIED" => "CERTIFIED"

-- Not included yet
    -- "NEW_PENDING_APPROVAL" => "NEW PENDING APPROVAL",
    -- "CANCEL_PENDING_PAYMENT" => "CANCELATION (PENDING FOR PAYMENT)",
    -- "CANCELLED" => "CANCELLED", --> If in fw_transaction_cancel. There wont be any exams if its in cancel, because you can only cancel before exams start. So in fw_details, doc/lab/xray, do not create these examinations. --> for Joey.
    -- "REJECTED" => "REJECTED", --> In old system, only approved transactions will be created. Ignore this status.



-- medical_status, -> Still mapping
    -- case
    -- when fwt.mr = 1 then 'CERTIFIED'
    -- when nios_trans.qrtn_ind = 'Y' then 'REVIEW'
    -- when nios_trans.qrtn_ind = 'Y' then 'NEW',

    -- Medical Statuses
    -- "NEW" => "NEW", # new pending review case after doctor certified
    -- "REVIEW" => "REVIEW", # 1st MLE picked up the case

    -- "PENDING_APPROVAL" => "PENDING FOR APPROVAL", # 1st MLE made decision, pending 2nd MLE approval
    -- "TCUPI" => "TCUPI", # when 1st MLE decision is TCUPI and 2nd MLE approved
    -- "TCUPI_PENDING_APPROVAL" => "PENDING FOR 2ND MLE APPROVAL", # 1st MLE made decision, pending 2nd MLE approval

    -- "CERTIFIED" => "CERTIFIED"


    -- xr
