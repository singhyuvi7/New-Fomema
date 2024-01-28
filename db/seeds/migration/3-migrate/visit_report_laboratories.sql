\echo "visit_report_laboratories.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_laboratories ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_laboratories (
    visit_report_id,laboratory_id,type_of_visit,
    moh_representative,
    qlf_nontech_degree_count,
    qlf_nontech_diploma_count,
    qlf_nontech_certificate_count,
    qlf_tech_degree_count,
    qlf_tech_diploma_count,
    qlf_tech_certificate_count,
    qlf_despatch_degree_count,
    qlf_despatch_diploma_count,
    qlf_despatch_certificate_count,
    qlf_other_degree_count,
    qlf_other_diploma_count,
    qlf_other_certificate_count,
    created_at,updated_at,created_by,updated_by,
    report_id
) 
select vr.id,lab.id, rpt.visit_type,
    rpt.moh_representative,
    case when rpt.nontechnical_degree_cnt is null then 0 else rpt.nontechnical_degree_cnt end,
    case when rpt.nontechnical_diploma_cnt is null then 0 else rpt.nontechnical_diploma_cnt end,
    case when rpt.nontechnical_cert_cnt is null then 0 else rpt.nontechnical_cert_cnt end,
    case when rpt.technical_degree_cnt is null then 0 else rpt.technical_degree_cnt end,
    case when rpt.technical_diploma_cnt is null then 0 else rpt.technical_diploma_cnt end,
    case when rpt.technical_cert_cnt is null then 0 else rpt.technical_cert_cnt end,
    case when rpt.despatch_degree_cnt is null then 0 else rpt.despatch_degree_cnt end,
    case when rpt.despatch_diploma_cnt is null then 0 else rpt.despatch_diploma_cnt end,
    case when rpt.despatch_cert_cnt is null then 0 else rpt.despatch_cert_cnt end,
    case when rpt.others_degree_cnt is null then 0 else rpt.others_degree_cnt end,
    case when rpt.others_diploma_cnt is null then 0 else rpt.others_diploma_cnt end,
    case when rpt.others_cert_cnt is null then 0 else rpt.others_cert_cnt end,
    rpt.creation_date, rpt.modify_date,
    creation.id, modify_user.id,
    rpt.report_id
from fomema_backup_nios.visit_rpt_labmaster rpt 
left join visit_reports vr on rpt.report_id = vr.report_id
left join laboratories lab on rpt.laboratory_code = lab.code
left join users creation on rpt.creator_id = creation.code
left join users modify_user on rpt.modify_id = modify_user.code;

\echo "visit_report_laboratories.sql - main data done"

UPDATE visit_report_laboratories rpt
SET organization_chart = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '31_01';

\echo "visit_report_laboratories.sql - organization_chart done"

UPDATE visit_report_laboratories rpt
SET organization_chart_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '31_01_A';

\echo "visit_report_laboratories.sql - organization_chart_comment done"

UPDATE visit_report_laboratories rpt
SET adequate_chart = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '32_01';

\echo "visit_report_laboratories.sql - adequate_chart done"

UPDATE visit_report_laboratories rpt
SET adequate_chart_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '32_01_A';

\echo "visit_report_laboratories.sql - adequate_chart_comment done"

UPDATE visit_report_laboratories rpt
SET specimen_collection_per_day = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_01';

\echo "visit_report_laboratories.sql - specimen_collection_per_day done"

UPDATE visit_report_laboratories rpt
SET packaging_despatch_specimen_bag = CASE WHEN det.datavalue = 'ACCEPTABLE' THEN 'ACCEPTABLE' WHEN det.datavalue = 'NOT_ACCEPTABLE' THEN 'UNACCEPTABLE' ELSE null END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_03';

\echo "visit_report_laboratories.sql - packaging_despatch_specimen_bag done"

UPDATE visit_report_laboratories rpt
SET packaging_to_laboraotry = CASE WHEN det.datavalue = 'ACCEPTABLE' THEN 'ACCEPTABLE' WHEN det.datavalue = 'NOT_ACCEPTABLE' THEN 'UNACCEPTABLE' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_03_2';

\echo "visit_report_laboratories.sql - packaging_to_laboraotry done"

UPDATE visit_report_laboratories rpt
SET traceability_from_clinic = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_05';

\echo "visit_report_laboratories.sql - traceability_from_clinic done"

UPDATE visit_report_laboratories rpt
SET traceability_from_clinic_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_05_A';

\echo "visit_report_laboratories.sql - traceability_from_clinic_comment done"

UPDATE visit_report_laboratories rpt
SET traceability_from_despatch = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_06';

\echo "visit_report_laboratories.sql - traceability_from_despatch done"

UPDATE visit_report_laboratories rpt
SET traceability_from_despatch_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_06_A';

\echo "visit_report_laboratories.sql - traceability_from_despatch_comment done"

UPDATE visit_report_laboratories rpt
SET traceability_from_laboratory = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_13';

\echo "visit_report_laboratories.sql - traceability_from_laboratory done"

UPDATE visit_report_laboratories rpt
SET traceability_from_laboratory_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_13_A';

\echo "visit_report_laboratories.sql - traceability_from_laboratory_comment done"

UPDATE visit_report_laboratories rpt
SET traceability_from_laboratory = CASE WHEN det.datavalue = 'N/A' THEN 'NA' WHEN det.datavalue = 'YES' THEN 'YES' WHEN det.datavalue = 'YES2' THEN 'YES_WITHOUT_SEPARATION' WHEN det.datavalue = 'NO' THEN 'NO' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq IN ('01_09','01_091','01_092');

\echo "visit_report_laboratories.sql - speciment_centrifucation done"

UPDATE visit_report_laboratories rpt
SET speciment_rejection = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq IN ('01_10','01_101','01_102');

\echo "visit_report_laboratories.sql - speciment_rejection done"

UPDATE visit_report_laboratories rpt
SET rejection_criteria = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq IN ('01_11','01_111');

\echo "visit_report_laboratories.sql - rejection_criteria done"

UPDATE visit_report_laboratories rpt
SET keep_negative_specimen = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_01';

\echo "visit_report_laboratories.sql - keep_negative_specimen done"

UPDATE visit_report_laboratories rpt
SET keep_negative_specimen_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_01_A';

\echo "visit_report_laboratories.sql - keep_negative_specimen_comment done"

UPDATE visit_report_laboratories rpt
SET keep_positive_specimen = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_02';

\echo "visit_report_laboratories.sql - keep_positive_specimen done"

UPDATE visit_report_laboratories rpt
SET keep_positive_specimen_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_02_A';

\echo "visit_report_laboratories.sql - keep_positive_specimen_comment done"

UPDATE visit_report_laboratories rpt
SET adequate_space = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_03';

\echo "visit_report_laboratories.sql - adequate_space done"

UPDATE visit_report_laboratories rpt
SET adequate_space_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_03_A';

\echo "visit_report_laboratories.sql - adequate_space_comment done"

UPDATE visit_report_laboratories rpt
SET appropriate_temperature = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_04';

\echo "visit_report_laboratories.sql - appropriate_temperature done"

UPDATE visit_report_laboratories rpt
SET appropriate_temperature_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_04_A';

\echo "visit_report_laboratories.sql - appropriate_temperature_comment done"

UPDATE visit_report_laboratories rpt
SET specimen_traceability = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_05';

\echo "visit_report_laboratories.sql - specimen_traceability done"

UPDATE visit_report_laboratories rpt
SET specimen_traceability_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_05_A';

\echo "visit_report_laboratories.sql - specimen_traceability_comment done"

UPDATE visit_report_laboratories rpt
SET specimen_tube_used_acceptable = CASE WHEN det.datavalue = 'NOTACCEPTABLE' THEN 'UNACCEPTABLE' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_12_I';

\echo "visit_report_laboratories.sql - specimen_tube_used_acceptable done"

UPDATE visit_report_laboratories rpt
SET urine_container_acceptable = CASE WHEN det.datavalue = 'NOTACCEPTABLE' THEN 'UNACCEPTABLE' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '01_04_I';

\echo "visit_report_laboratories.sql - urine_container_acceptable done"

UPDATE visit_report_laboratories rpt
SET keep_negative_malaria_slide = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_06';

\echo "visit_report_laboratories.sql - keep_negative_malaria_slide done"

UPDATE visit_report_laboratories rpt
SET keep_negative_malaria_slide_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_06_A';

\echo "visit_report_laboratories.sql - keep_negative_malaria_slide_comment done"

UPDATE visit_report_laboratories rpt
SET quality_check = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_07';

\echo "visit_report_laboratories.sql - quality_check done"

UPDATE visit_report_laboratories rpt
SET quality_check_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '10_07_A';

\echo "visit_report_laboratories.sql - quality_check_comment done"

UPDATE visit_report_laboratories rpt
SET laboratory_handbook = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_01';

\echo "visit_report_laboratories.sql - laboratory_handbook done"

UPDATE visit_report_laboratories rpt
SET laboratory_handbook_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_01_A';

\echo "visit_report_laboratories.sql - laboratory_handbook_comment done"

UPDATE visit_report_laboratories rpt
SET biologial_waste = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_02';

\echo "visit_report_laboratories.sql - biologial_waste done"

UPDATE visit_report_laboratories rpt
SET biologial_waste_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_02_A';

\echo "visit_report_laboratories.sql - biologial_waste_comment done"

UPDATE visit_report_laboratories rpt
SET emergency_eyewash = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_03';

\echo "visit_report_laboratories.sql - emergency_eyewash done"

UPDATE visit_report_laboratories rpt
SET emergency_eyewash_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '30_03_A';

\echo "visit_report_laboratories.sql - emergency_eyewash_comment done"

UPDATE visit_report_laboratories rpt
SET check_report_before_transmission = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '11_01';

\echo "visit_report_laboratories.sql - check_report_before_transmission done"

UPDATE visit_report_laboratories rpt
SET check_report_before_transmission_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '11_01_A';

\echo "visit_report_laboratories.sql - check_report_before_transmission_comment done"

UPDATE visit_report_laboratories rpt
SET avoid_result_manipulation_precaution = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '11_02';

\echo "visit_report_laboratories.sql - avoid_result_manipulation_precaution done"

UPDATE visit_report_laboratories rpt
SET avoid_result_manipulation_precaution_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '11_02_A';

\echo "visit_report_laboratories.sql - avoid_result_manipulation_precaution_comment done"

UPDATE visit_report_laboratories rpt
SET result_transmission = CASE WHEN det.datavalue = 'N/A' THEN 'NA' WHEN det.datavalue = 'MANUAL' THEN 'MANUAL' WHEN det.datavalue = 'WEB SERVICE' THEN 'WEB_SERVICE' WHEN det.datavalue = 'WEB%20SERVICE^-' THEN 'WEB_SERVICE' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '11_04';

\echo "visit_report_laboratories.sql - result_transmission done"

UPDATE visit_report_laboratories rpt
SET satisfactory = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '13_01';

\echo "visit_report_laboratories.sql - satisfactory done"

UPDATE visit_report_laboratories rpt
SET comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '13_02';

\echo "visit_report_laboratories.sql - comment done"

\echo "visit_report_laboratories.sql ended"