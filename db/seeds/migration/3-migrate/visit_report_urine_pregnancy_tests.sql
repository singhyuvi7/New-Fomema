\echo "visit_report_urine_pregnancy_tests.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_urine_pregnancy_tests ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_urine_pregnancy_tests (
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

\echo "visit_report_urine_pregnancy_tests.sql - main data done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_07';

\echo "visit_report_urine_pregnancy_tests.sql - iqa done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_07_A';

\echo "visit_report_urine_pregnancy_tests.sql - iqa_detail_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_071';

\echo "visit_report_urine_pregnancy_tests.sql - iqa_record done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_072';

\echo "visit_report_urine_pregnancy_tests.sql - iqa_perform_acknowledge done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_073';

\echo "visit_report_urine_pregnancy_tests.sql - iqa_validate_acknowledge done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_08';

\echo "visit_report_urine_pregnancy_tests.sql - eqa done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_08_A';

\echo "visit_report_urine_pregnancy_tests.sql - eqa_detail_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_09';

\echo "visit_report_urine_pregnancy_tests.sql - test_worksheet done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_09_A';

\echo "visit_report_urine_pregnancy_tests.sql - test_worksheet_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_09_D';

\echo "visit_report_urine_pregnancy_tests.sql - worksheet_document done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_09_B';

\echo "visit_report_urine_pregnancy_tests.sql - worksheet_acknowledge done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_09_C';

\echo "visit_report_urine_pregnancy_tests.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_10';

\echo "visit_report_urine_pregnancy_tests.sql - sop done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_10_A';

\echo "visit_report_urine_pregnancy_tests.sql - sop_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_11';

\echo "visit_report_urine_pregnancy_tests.sql - iso done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_11_A';

\echo "visit_report_urine_pregnancy_tests.sql - iso_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_12';

\echo "visit_report_urine_pregnancy_tests.sql - instrument_maintenance_record done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_12_A';

\echo "visit_report_urine_pregnancy_tests.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_13';

\echo "visit_report_urine_pregnancy_tests.sql - duration_per_cycle done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_14';

\echo "visit_report_urine_pregnancy_tests.sql - sample_per_cycle done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_15';

\echo "visit_report_urine_pregnancy_tests.sql - troubleshoot done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_15_A';

\echo "visit_report_urine_pregnancy_tests.sql - troubleshoot_comment done"

UPDATE visit_report_urine_pregnancy_tests rpt
SET hcg_detection_level = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '26_03';

\echo "visit_report_urine_pregnancy_tests.sql - hcg_detection_level done"

\echo "visit_report_urine_pregnancy_tests.sql ended"