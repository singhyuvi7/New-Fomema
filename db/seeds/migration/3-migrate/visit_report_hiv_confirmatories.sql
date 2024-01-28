\echo "visit_report_hiv_confirmatories.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_hiv_confirmatories ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_hiv_confirmatories (
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

\echo "visit_report_hiv_confirmatories.sql - main data done"

UPDATE visit_report_hiv_confirmatories rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_06';

\echo "visit_report_hiv_confirmatories.sql - iqa done"

UPDATE visit_report_hiv_confirmatories rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_06_A';

\echo "visit_report_hiv_confirmatories.sql - iqa_detail_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_061';

\echo "visit_report_hiv_confirmatories.sql - iqa_record done"

UPDATE visit_report_hiv_confirmatories rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_062';

\echo "visit_report_hiv_confirmatories.sql - iqa_perform_acknowledge done"

UPDATE visit_report_hiv_confirmatories rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_063';

\echo "visit_report_hiv_confirmatories.sql - iqa_validate_acknowledge done"

UPDATE visit_report_hiv_confirmatories rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_07';

\echo "visit_report_hiv_confirmatories.sql - eqa done"

UPDATE visit_report_hiv_confirmatories rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_07_A';

\echo "visit_report_hiv_confirmatories.sql - eqa_detail_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_08';

\echo "visit_report_hiv_confirmatories.sql - test_worksheet done"

UPDATE visit_report_hiv_confirmatories rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_08_A';

\echo "visit_report_hiv_confirmatories.sql - test_worksheet_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_08_D';

\echo "visit_report_hiv_confirmatories.sql - worksheet_document done"

UPDATE visit_report_hiv_confirmatories rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_08_B';

\echo "visit_report_hiv_confirmatories.sql - worksheet_acknowledge done"

UPDATE visit_report_hiv_confirmatories rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_08_C';

\echo "visit_report_hiv_confirmatories.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_hiv_confirmatories rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_09';

\echo "visit_report_hiv_confirmatories.sql - sop done"

UPDATE visit_report_hiv_confirmatories rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_09_A';

\echo "visit_report_hiv_confirmatories.sql - sop_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_10';

\echo "visit_report_hiv_confirmatories.sql - iso done"

UPDATE visit_report_hiv_confirmatories rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_10_A';

\echo "visit_report_hiv_confirmatories.sql - iso_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_11';

\echo "visit_report_hiv_confirmatories.sql - instrument_maintenance_record done"

UPDATE visit_report_hiv_confirmatories rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_11_A';

\echo "visit_report_hiv_confirmatories.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_12';

\echo "visit_report_hiv_confirmatories.sql - duration_per_cycle done"

UPDATE visit_report_hiv_confirmatories rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_13';

\echo "visit_report_hiv_confirmatories.sql - sample_per_cycle done"

UPDATE visit_report_hiv_confirmatories rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_14';

\echo "visit_report_hiv_confirmatories.sql - troubleshoot done"

UPDATE visit_report_hiv_confirmatories rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_14_A';

\echo "visit_report_hiv_confirmatories.sql - troubleshoot_comment done"

UPDATE visit_report_hiv_confirmatories rpt
SET remarks = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '18_15';

\echo "visit_report_hiv_confirmatories.sql - remarks done"

\echo "visit_report_hiv_confirmatories.sql ended"