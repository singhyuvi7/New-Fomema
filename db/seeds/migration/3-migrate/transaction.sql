\echo 'transaction.sql loaded'

do $$
declare
    v_log_id bigint;
    rec record;
begin
    select start_migration_log('transaction.sql - preparation') into v_log_id; commit;

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
    perform rebuild_index_prepare('transactions');
    perform end_migration_log(v_log_id);
    select start_migration_log('transaction.sql - insert') into v_log_id; commit;

insert into transactions (
    code, doctor_id, employer_id,
    laboratory_id,
    xray_facility_id, fw_code, foreign_worker_id,
    transaction_date, certification_date, doctor_transmit_date, medical_examination_date,
    laboratory_transmit_date, xray_transmit_date,
    medical_tcupi, worker_consented,
    updated_by, updated_at,
    created_by, created_at,
    ignore_expiry,
    ignore_merts_expiry_at,
    xray_film_type, fw_gender,
    fw_plks_number, fw_maid_online,
    fw_name, fw_date_of_birth, fw_passport_number, fw_country_id, fw_job_type_id,
    organization_id, expired_at,
    doctor_fp_result, xray_fp_result,
    doctor_fp_result_date, xray_fp_result_date,
    status,
    final_result,
    final_result_date,
    medical_status,
    medical_result,
    xray_result,
    medical_quarantine_release_date,
    xray_quarantine_release_date,
    med_ind_count, reg_ind,
    digital_xray_provider_id,
    worker_matched,
    worker_identity_confirmed,
    xray_worker_identity_confirmed,
    ignore_reprint_rule,
    registration_type,
    unsuitable_slip_downloaded,
    xray_reporter_type,
    doctor_fp, xray_fp,
    medical_pr_source
)
select
    fwt.trans_id code, /* fwt.doctor_code */ doctors.id doctor_id, /* fwt.employer_code */ employers.id employer_id,
    /* fwt.laboratory_code */ laboratories.id laboratory_id,
    /* fwt.xray_code */ xray_facilities.id xray_facility_id, fwt.worker_code, foreign_workers.id foreign_worker_id,
    fwt.transdate transaction_date, coalesce(fwt.certify_date, qfwd.certification_date, xqfd.certification_date) certification_date, coalesce(fwt.certify_date, qfwd.certification_date, xqfd.certification_date) doctor_transmit_date, fwt.exam_date medical_examination_date,
    fwt.lab_submit_date laboratory_transmit_date, fwt.xray_submit_date xray_transmit_date,
    case
        when 
            fwt.tcupi_ind in ('Y', 'X') then true
            else false 
        end as medical_tcupi,
    /* fwt.worker_consent */ case when fwt.worker_consent = 'Y' then true else false end as worker_consented,
    /* fwt.modify_id */ updator_users.id updated_by, /* fwt.modification_date */ coalesce(fwt.modification_date, clock_timestamp()) updated_at,
    /* fwt.created_by */ creator_users.id created_by, fwt.transdate created_at,
    /* fwt.imr_ind */ case when fwt.imr_ind = 'Y' then true else false end as ignore_expiry,
    case when fwt.imr_ind = 'Y' then coalesce(fwt.modification_date, clock_timestamp()) else null end as ignore_merts_expiry_at,
    /* fwt.xray_film_type */ case when fwt.xray_film_type = 'D' then 'DIGITAL' when fwt.xray_film_type = 'P' then 'ANALOG' else null end as xray_film_type, fwt.sex fw_gender,
    /* fwt.plks_no */ fwt.plks_no::text fw_plks_number, /* fwt.ispra */ case when ispra = 1 then 'PRAON' else 'FOMEMA' end as fw_maid_online,
    foreign_workers.name fw_name, foreign_workers.date_of_birth fw_date_of_birth, foreign_workers.passport_number fw_passport_number, foreign_workers.country_id fw_country_id, foreign_workers.job_type_id fw_job_type_id,
    organizations.id organization_id, fwt.transdate + interval '30' day expired_at,
    case when fwt.docfp = 1 then 1 else 2 end as doctor_fp_result,
    case when fwt.xrayfp = 1 then 1 else 2 end as xray_fp_result,
    docfp_date doctor_fp_result_date, xrayfp_date xray_fp_result_date,
    case
        -- Note: For the transactions older than 2019, checking certify_date is enough. But for newer cases, must check mr & xr. fit_ind will always have result after certification.
        when (fwt.certify_date is not null and transdate < '2019-01-01') or (fwt.mr = 1 and fwt.xr = 1) then 'CERTIFIED'
        when fwt.dfit_ind is not null then 'REVIEW'
        when fwt.lab_submit_date is not null and fwt.xray_submit_date is not null and fwt.exam_date is not null then 'CERTIFICATION' -- Must make sure there is exam_date.
        when fwt.exam_date is not null then 'EXAMINATION'
        else 'NEW' end as status,
    case
        -- Note: Only show final_result if CERTIFIED. This time, must check for the date for mr & xr, otherwise might give a false null.
        when (fwt.certify_date is null and transdate < '2019-01-01') or (transdate >= '2019-01-01' and (fwt.mr != 1 or fwt.xr != 1)) then null
        when fwt.fit_ind = 'N' then 'SUITABLE'
        when fwt.fit_ind = 'Y' then 'UNSUITABLE'
        else null end as final_result,
    case
        when (fwt.certify_date is null and transdate < '2019-01-01') or (transdate >= '2019-01-01' and (fwt.mr != 1 or fwt.xr != 1)) then null
        when fwt.fit_ind is not null then fwt.modification_date
        else null end as final_result_date,
    case
        when (fwt.certify_date is not null and transdate < '2019-01-01') or fwt.mr = 1 then 'CERTIFIED'
        when qfwd.status = 'S' and qfwd.inspstatus = 'T' then 'TCUPI'
        when qfwd.status = 'S' then 'PENDING_APPROVAL'
        when qfwd.status = 'N' then 'NEW'
        else null end as medical_status,
    case
        when fwt.mfit_ind = 0 then 'SUITABLE'
        when fwt.mfit_ind = 1 then 'UNSUITABLE'
        when (fwt.mr = 1 or fwt.release_date is not null) and fwt.dfit_ind = 0 then 'SUITABLE' -- If mr = 1 and mfit is null, will take results from dfit_ind.
        when (fwt.mr = 1 or fwt.release_date is not null) and fwt.dfit_ind = 1 then 'UNSUITABLE'
        else null end as medical_result,
    case
        when fwt.xfit_ind = 0 then 'SUITABLE'
        when fwt.xfit_ind = 1 then 'UNSUITABLE'
        when (fwt.xr = 1 or fwt.xrelease_date is not null) and fwt.dfit_ind = 0 then 'SUITABLE' -- If xr = 1 and xfit is null, will take results from dfit_ind.
        when (fwt.xr = 1 or fwt.xrelease_date is not null) and fwt.dfit_ind = 1 then 'UNSUITABLE' -- If xr = 1 and xfit is null, will take results from dfit_ind.
        else null end as xray_result,
    fwt.release_date medical_quarantine_release_date,
    fwt.xrelease_date xray_quarantine_release_date,
    fwt.med_ind med_ind_count, fwt.reg_ind reg_ind,
    case when fwt.provider_id = 'SHC' then 1 else null end as digital_xray_provider_id,
    case when fwt.exam_date is not null then true else false end as worker_matched,
    case when fwt.exam_date is not null then true else false end as worker_identity_confirmed,
    case when fwt.xrayfp_date is not null then true else false end as xray_worker_identity_confirmed,
    case when fwt.irr_ind = 'Y' then true else false end as ignore_reprint_rule,
    case when fwt.renew_ind = 'Y' then 1 else 0 end as registration_type,
    case when fwt.unfit_printed = 'Y' then true else false end as unsuitable_slip_downloaded,
    case when fwt.xray_submit_date is not null then 'SELF' else null end as xray_reporter_type,
    false doctor_fp, false xray_fp,
    case
        when qfwd.qrtn_source = 1 then 'MERTS'
        when qfwd.qrtn_source = 4 then 'XQCC'
        end as medical_pr_source
from
    fomema_backup_nios.fw_transaction fwt
    left join doctors on fwt.doctor_code = doctors.code
    left join employers on fwt.employer_code = employers.code
    left join laboratories on fwt.laboratory_code = laboratories.code
    left join xray_facilities on fwt.xray_code = xray_facilities.code
    left join foreign_workers on fwt.worker_code = foreign_workers.code
    left join fomema_backup_nios.v_user_master updators on fwt.modify_id = updators.uuid
    left join users updator_users on updators.userid = updator_users.code
    left join users creator_users on fwt.created_by is not null and substring(fwt.created_by, 3) = creator_users.code
    left join organizations on fwt.created_by is not null and substring(fwt.created_by, 1, 2) = organizations.code and organizations.org_type = 'BRANCH'
    left join fomema_backup_nios.xqcc_quarantine_fw_doc xqfd on fwt.trans_id = xqfd.trans_id
    left join fomema_backup_nios.quarantine_fw_doc qfwd on fwt.trans_id = qfwd.trans_id
order by
    fwt.transdate
;

    perform end_migration_log(v_log_id);

    -- rebuild index
    -- select start_migration_log('transaction.sql - rebuild index') into v_log_id; commit;
    -- perform rebuild_index('transactions');
    -- perform end_migration_log(v_log_id);
    for rec in (select * from tmp_indexes where schemaname = 'public' and tablename = 'transactions') loop
        select start_migration_log('transaction.sql - rebuild index ' || rec.indexname) into v_log_id; commit;
        execute replace(rec.indexdef, ' ON ONLY ', ' ON ');
        commit;
        delete from tmp_indexes where tablename = rec.tablename and indexname = rec.indexname;
        perform end_migration_log(v_log_id);
    end loop;

    select start_migration_log('transaction.sql - foreign_workers.latest_transaction_id') into v_log_id; commit;
    with tbl as (
        select foreign_worker_id, transaction_date, id, fw_plks_number, rank() over (partition by foreign_worker_id order by transaction_date desc) as rank from transactions
    )
    update foreign_workers set latest_transaction_id = tbl.id, plks_number = tbl.fw_plks_number
    from tbl
    where tbl.rank = 1 and tbl.foreign_worker_id = foreign_workers.id;
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

-- In, another sql file
    -- "CANCELLED" => "CANCELLED", --> If in fw_transaction_cancel. There wont be any exams if its in cancel, because you can only cancel before exams start. So in fw_details, doc/lab/xray, do not create these examinations. --> for Joey.

-- Not included yet
    -- "NEW_PENDING_APPROVAL" => "NEW PENDING APPROVAL",
    -- "CANCEL_PENDING_PAYMENT" => "CANCELATION (PENDING FOR PAYMENT)",
    -- "REJECTED" => "REJECTED", --> In old system, only approved transactions will be created. Ignore this status.

