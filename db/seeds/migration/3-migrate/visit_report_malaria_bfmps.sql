\echo "visit_report_malaria_bfmps.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_malaria_bfmps ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_malaria_bfmps (
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

\echo "visit_report_malaria_bfmps.sql - main data done"

UPDATE visit_report_malaria_bfmps rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_04';

\echo "visit_report_malaria_bfmps.sql - iqa done"

UPDATE visit_report_malaria_bfmps rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_04_A';

\echo "visit_report_malaria_bfmps.sql - iqa_detail_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_041';

\echo "visit_report_malaria_bfmps.sql - iqa_record done"

UPDATE visit_report_malaria_bfmps rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_042';

\echo "visit_report_malaria_bfmps.sql - iqa_perform_acknowledge done"

UPDATE visit_report_malaria_bfmps rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_043';

\echo "visit_report_malaria_bfmps.sql - iqa_validate_acknowledge done"

UPDATE visit_report_malaria_bfmps rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_05';

\echo "visit_report_malaria_bfmps.sql - eqa done"

UPDATE visit_report_malaria_bfmps rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_05_A';

\echo "visit_report_malaria_bfmps.sql - eqa_detail_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_15';

\echo "visit_report_malaria_bfmps.sql - test_worksheet done"

UPDATE visit_report_malaria_bfmps rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_15_A';

\echo "visit_report_malaria_bfmps.sql - test_worksheet_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_15_D';

\echo "visit_report_malaria_bfmps.sql - worksheet_document done"

UPDATE visit_report_malaria_bfmps rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_15_B';

\echo "visit_report_malaria_bfmps.sql - worksheet_acknowledge done"

UPDATE visit_report_malaria_bfmps rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_15_C';

\echo "visit_report_malaria_bfmps.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_malaria_bfmps rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_06';

\echo "visit_report_malaria_bfmps.sql - sop done"

UPDATE visit_report_malaria_bfmps rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_06_A';

\echo "visit_report_malaria_bfmps.sql - sop_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_07';

\echo "visit_report_malaria_bfmps.sql - iso done"

UPDATE visit_report_malaria_bfmps rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_07_A';

\echo "visit_report_malaria_bfmps.sql - iso_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_09';

\echo "visit_report_malaria_bfmps.sql - instrument_maintenance_record done"

UPDATE visit_report_malaria_bfmps rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_09_A';

\echo "visit_report_malaria_bfmps.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_malaria_bfmps rpt
SET duration_per_slide = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '15_10';

\echo "visit_report_malaria_bfmps.sql - duration_per_slide done"

\echo "visit_report_malaria_bfmps.sql ended"