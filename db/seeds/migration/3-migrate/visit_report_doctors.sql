\echo "visit_report_doctors.sql loaded"

-- need report_id to map with visit_rpt_sop_compliance (column remove at visit_report_doctors)
ALTER TABLE visit_report_doctors ADD COLUMN IF NOT EXISTS report_id bigint;

-- doctors
insert into visit_report_doctors (
    visit_report_id,doctor_id,doctor_name,
    type_of_visit,interacted_with,number_of_visit_checklist,
    foreign_worker_present,foreign_worker_present_acceptable,apc_number,
    apc_year,apc_acceptable,private_healthcare_registration_number,
    private_healthcare_registration_number_acceptable,
    written_consent_acceptable,medical_record_maintenance_acceptable,
    communicable_disease_acceptable,no_communicable_disease,
    vacutainer_expiry_date,vacutainer_acceptable,adequate_facility_acceptable,
    dispatch_record_acceptable,operating_hour_acceptable, 
    other_comment,recommendation,
    created_at,updated_at,
    created_by,updated_by,
    unacceptable_fields,
    notification_via_notification_form, notification_via_e_notifikasi,recommendation_date,
    report_id
) 
select vr.id, doc.id, rpt.doc_rad_name,
    rpt.type_visit, rpt.interactedwith, rpt.visit_checklist_num, 
    rpt.fw_present_count, rpt.fw_id_verification, rpt.apc_serial_no,
    cast(rpt.apc_year as int), rpt.cfm_apc_original, rpt.healthact_regno, 
    rpt.healthact_registered, 
    rpt.fw_written_consent, rpt.fw_medical_record, 
    rpt.disease_notification, case when rpt.no_disease_notify = 'Y' then true else false end,
    rpt.vacutainer_expirydate, rpt.vacutainer, rpt.clinic_facility_adequate,
    rpt.lab_coc_adequate, rpt.operation_hrs, 
    rpt.others_comment,
    CASE WHEN rpt.recommendation = 'SNCL' THEN 'NON_COMPLIANCE'
    WHEN rpt.recommendation = 'INSP_MSPD' THEN 'REFER_MSPC'
    WHEN rpt.recommendation = 'MSPC' THEN 'NON_COMPLIANCE_MSPC'
    WHEN rpt.recommendation = 'SAL' THEN 'REPRIMAND_LETTER'
    WHEN rpt.recommendation = 'SAT' THEN 'SATISFACTORY'
    WHEN rpt.recommendation = 'SNCL_INSP' THEN 'NON_COMPLIANCE_AND_REFER_MSPC'
    WHEN rpt.recommendation = 'SNCL_MSPC' THEN 'NON_COMPLIANCE_AND_REFER_MSPC'
    ELSE
        rpt.recommendation
    END, 
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by,
    concat('{', 
        case when rpt.verify_fw_comment is NULL then '"foreign_worker":{"others":false,"others_comment":""}' else concat('"foreign_worker":{"others":true,"others_comment":"',rpt.verify_fw_comment,'"}') end, ',',
        case when rpt.apc_comment is NULL then '"apc":{"others":false,"others_comment":""}' else concat('"apc":{"others":true,"others_comment":"',rpt.apc_comment,'"}') end, ',',
        case when rpt.healthact_comment is NULL then '"registration_number":{"others":false,"others_comment":""}' else concat('"registration_number":{"others":true,"others_comment":"',rpt.healthact_comment,'"}') end, ',',
        case when rpt.fw_written_comment is NULL then '"foreign_workers_consent":{"others":false,"others_comment":""}' else concat('"foreign_workers_consent":{"others":true,"others_comment":"',rpt.fw_written_comment,'"}') end, ',',
        case when rpt.fw_medical_comment is NULL then '"medical_records":{"others":false,"others_comment":""}' else concat('"medical_records":{"others":true,"others_comment":"',rpt.fw_medical_comment,'"}') end, ',',
        case when rpt.disease_notification_comment is NULL then '"notification":{"others":false,"others_comment":""}' else concat('"notification":{"others":true,"others_comment":"',rpt.disease_notification_comment,'"}') end, ',',
        case when rpt.vacutainer_comment is NULL then '"vacutainer":{"others":false,"others_comment":""}' else concat('"vacutainer":{"others":true,"others_comment":"',rpt.vacutainer_comment,'"}') end, ',',
        case when rpt.clinic_facility_comment is NULL then '"adequate_facilities":{"others":false,"others_comment":""}' else concat('"adequate_facilities":{"others":true,"others_comment":"',rpt.clinic_facility_comment,'"}') end, ',',
        case when rpt.lab_coc_comment is NULL then '"dispatch":{"others":false,"others_comment":""}' else concat('"dispatch":{"others":true,"others_comment":"',rpt.lab_coc_comment,'"}') end, ',',
        case when rpt.operation_hrs_comment is NULL then '"operation_hours":{"others":false,"others_comment":""}' else concat('"operation_hours":{"others":true,"others_comment":"',rpt.operation_hrs_comment,'"}') end, ',', 
        '"others":{"others":false,"others_comment":""}', '}'
        ),
    null,null,null,
    rpt.report_id
from fomema_backup_nios.visit_rpt_docxray rpt 
left join visit_reports vr on rpt.report_id = vr.report_id
left join doctors doc on rpt.provider_code = doc.code
where rpt.provider_code LIKE 'D%';

\echo "visit_report_doctors.sql done"

-- doctors : sop compliance : satisfactory (S)
UPDATE visit_report_doctors 
SET
    satisfactory = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'S';

\echo "visit_report_doctors.sql sop - satisfactory done"

-- doctors : sop compliance : non_verify_original_passport_fw_present (Y)
UPDATE visit_report_doctors 
SET
    non_verify_original_passport_fw_present = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'Y';

\echo "visit_report_doctors.sql sop - non_verify_original_passport_fw_present done"

-- doctors : sop compliance : non_verify_original_passport_fw_not_present (N)
UPDATE visit_report_doctors 
SET
    non_verify_original_passport_fw_not_present = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'N';

\echo "visit_report_doctors.sql sop - non_verify_original_passport_fw_not_present done"

-- doctors : sop compliance : unable_to_produce_apc (A)
UPDATE visit_report_doctors 
SET
    unable_to_produce_apc = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'A';

\echo "visit_report_doctors.sql sop - unable_to_produce_apc done"

-- doctors : sop compliance : non_notify_communicable_disease (G)
UPDATE visit_report_doctors 
SET
    non_notify_communicable_disease = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'G';

\echo "visit_report_doctors.sql sop - non_notify_communicable_disease done"

-- doctors : sop compliance : inadequate_equipment (I)
UPDATE visit_report_doctors 
SET
    inadequate_equipment = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'I';

\echo "visit_report_doctors.sql sop - inadequate_equipment done"

-- doctors : sop compliance : insufficient_operation_hour (H)
UPDATE visit_report_doctors 
SET
    insufficient_operation_hour = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'H';

\echo "visit_report_doctors.sql sop - insufficient_operation_hour done"


-- doctors : sop compliance : inappropriate_vacutainer (V)
UPDATE visit_report_doctors 
SET
    inappropriate_vacutainer = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'V';

\echo "visit_report_doctors.sql sop - inappropriate_vacutainer done"

-- doctors : sop compliance : no_produce_dispatch_record (L)
UPDATE visit_report_doctors 
SET
    no_produce_dispatch_record = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'L';

\echo "visit_report_doctors.sql sop - no_produce_dispatch_record done"

-- doctors : sop compliance : no_produce_written_consent (C)
UPDATE visit_report_doctors 
SET
    no_produce_written_consent = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'C';

\echo "visit_report_doctors.sql sop - no_produce_written_consent done"

-- doctors : sop compliance : no_produce_medical_record (R)
UPDATE visit_report_doctors 
SET
    no_produce_medical_record = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'R';

\echo "visit_report_doctors.sql sop - no_produce_medical_record done"

-- doctors : sop compliance : closed (P)
UPDATE visit_report_doctors 
SET
    closed = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'P';

\echo "visit_report_doctors.sql sop - closed done"

-- doctors : sop compliance : no_produce_borang_b (B)
UPDATE visit_report_doctors 
SET
    no_produce_borang_b = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'B';

\echo "visit_report_doctors.sql sop - no_produce_borang_b done"

-- doctors : sop compliance : other (K)
UPDATE visit_report_doctors 
SET
    other = true
FROM fomema_backup_nios.visit_rpt_sop_compliance sop 
WHERE visit_report_doctors.report_id = sop.report_id
AND sop.sopcomp_ind = 'K';

\echo "visit_report_doctors.sql sop - other done"

-- visit-rpt_followup
UPDATE visit_report_doctors 
SET
    recommendation = CASE WHEN fl.type = 'SNCL' THEN 'NON_COMPLIANCE'
    WHEN fl.type = 'INSP_MSPD' THEN 'REFER_MSPC'
    WHEN fl.type = 'MSPC' THEN 'NON_COMPLIANCE_MSPC'
    WHEN fl.type = 'SAL' THEN 'REPRIMAND_LETTER'
    WHEN fl.type = 'SAT' THEN 'SATISFACTORY'
    WHEN fl.type = 'SNCL_INSP' THEN 'NON_COMPLIANCE_AND_REFER_MSPC'
    WHEN fl.type = 'SNCL_MSPC' THEN 'NON_COMPLIANCE_AND_REFER_MSPC'
    ELSE
        fl.type
    END
FROM fomema_backup_nios.visit_rpt_followup fl 
WHERE visit_report_doctors.report_id = fl.visit_report_id
AND fl.service_provider_code LIKE 'D%';

\echo "visit_report_doctors.sql recommendation done"

-- drop report_id
ALTER TABLE visit_report_doctors DROP COLUMN IF EXISTS report_id;

\echo "visit_report_doctors.sql ended"
