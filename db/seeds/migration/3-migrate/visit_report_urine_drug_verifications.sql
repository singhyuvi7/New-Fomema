\echo "visit_report_urine_drug_verifications.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_urine_drug_verifications ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_urine_drug_verifications (
    visit_report_id,
    created_at,updated_at,
    created_by,updated_by,
    report_id
) 
select vr.id,
    vr.created_at, vr.updated_at,
    vr.created_by,vr.updated_by,
    rpt.report_id
from fomema_backup_nios.visit_rpt_labmaster rpt 
join visit_reports vr on rpt.report_id = vr.report_id;

\echo "visit_report_urine_drug_verifications.sql - main data done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_07_B1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_07_B2';

\echo "visit_report_urine_drug_verifications.sql - iqa done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_07_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_07_A2';

\echo "visit_report_urine_drug_verifications.sql - iqa_detail_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_071_1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_071_2';

\echo "visit_report_urine_drug_verifications.sql - iqa_record done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_072_1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_072_2';

\echo "visit_report_urine_drug_verifications.sql - iqa_perform_acknowledge done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_073_1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_073_2';

\echo "visit_report_urine_drug_verifications.sql - iqa_validate_acknowledge done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_08_B1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_08_B2';

\echo "visit_report_urine_drug_verifications.sql - eqa done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_08_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_08_A2';

\echo "visit_report_urine_drug_verifications.sql - eqa_detail_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_W1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_W2';

\echo "visit_report_urine_drug_verifications.sql - test_worksheet done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_A2';

\echo "visit_report_urine_drug_verifications.sql - test_worksheet_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_D1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_D2';

\echo "visit_report_urine_drug_verifications.sql - worksheet_document done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_B1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_B2';

\echo "visit_report_urine_drug_verifications.sql - worksheet_acknowledge done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_C1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_09_C2';

\echo "visit_report_urine_drug_verifications.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_10_B1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_10_B2';

\echo "visit_report_urine_drug_verifications.sql - sop done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_10_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_10_A2';

\echo "visit_report_urine_drug_verifications.sql - sop_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_11_B1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_11_B2';

\echo "visit_report_urine_drug_verifications.sql - iso done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_11_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_11_A2';

\echo "visit_report_urine_drug_verifications.sql - iso_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_12_1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_12_2';

\echo "visit_report_urine_drug_verifications.sql - instrument_maintenance_record done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_12_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_12_A2';

\echo "visit_report_urine_drug_verifications.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_13_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_13_A2';

\echo "visit_report_urine_drug_verifications.sql - duration_per_cycle done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_14_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_14_A2';

\echo "visit_report_urine_drug_verifications.sql - sample_per_cycle done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END,
cannabinoids_troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_15';

\echo "visit_report_urine_drug_verifications.sql - troubleshoot done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_troubleshoot_comment = det.datavalue,
cannabinoids_troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_15_A';

\echo "visit_report_urine_drug_verifications.sql - troubleshoot comment done"

UPDATE visit_report_urine_drug_verifications rpt
SET opiates_drug_detection_level = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_03_A1';

UPDATE visit_report_urine_drug_verifications rpt
SET cannabinoids_drug_detection_level = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '25_03_B1';

\echo "visit_report_urine_drug_verifications.sql - drug_detection_level done"

\echo "visit_report_urine_drug_verifications.sql ended"