\echo "visit_report_hbsag_screenings.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_hbsag_screenings ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_hbsag_screenings (
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

\echo "visit_report_hbsag_screenings.sql - main data done"

UPDATE visit_report_hbsag_screenings rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_06';

\echo "visit_report_hbsag_screenings.sql - iqa done"

UPDATE visit_report_hbsag_screenings rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_06_A';

\echo "visit_report_hbsag_screenings.sql - iqa_detail_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_061';

\echo "visit_report_hbsag_screenings.sql - iqa_record done"

UPDATE visit_report_hbsag_screenings rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_062';

\echo "visit_report_hbsag_screenings.sql - iqa_perform_acknowledge done"

UPDATE visit_report_hbsag_screenings rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_063';

\echo "visit_report_hbsag_screenings.sql - iqa_validate_acknowledge done"

UPDATE visit_report_hbsag_screenings rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_07';

\echo "visit_report_hbsag_screenings.sql - eqa done"

UPDATE visit_report_hbsag_screenings rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_07_A';

\echo "visit_report_hbsag_screenings.sql - eqa_detail_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_08';

\echo "visit_report_hbsag_screenings.sql - test_worksheet done"

UPDATE visit_report_hbsag_screenings rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_08_A';

\echo "visit_report_hbsag_screenings.sql - test_worksheet_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_08_D';

\echo "visit_report_hbsag_screenings.sql - worksheet_document done"

UPDATE visit_report_hbsag_screenings rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_08_B';

\echo "visit_report_hbsag_screenings.sql - worksheet_acknowledge done"

UPDATE visit_report_hbsag_screenings rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_08_C';

\echo "visit_report_hbsag_screenings.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_hbsag_screenings rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_09';

\echo "visit_report_hbsag_screenings.sql - sop done"

UPDATE visit_report_hbsag_screenings rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_09_A';

\echo "visit_report_hbsag_screenings.sql - sop_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_10';

\echo "visit_report_hbsag_screenings.sql - iso done"

UPDATE visit_report_hbsag_screenings rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_10_A';

\echo "visit_report_hbsag_screenings.sql - iso_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_11';

\echo "visit_report_hbsag_screenings.sql - instrument_maintenance_record done"

UPDATE visit_report_hbsag_screenings rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_11_A';

\echo "visit_report_hbsag_screenings.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_hbsag_screenings rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_12';

\echo "visit_report_hbsag_screenings.sql - duration_per_cycle done"

UPDATE visit_report_hbsag_screenings rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_13';

\echo "visit_report_hbsag_screenings.sql - sample_per_cycle done"

UPDATE visit_report_hbsag_screenings rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_14';

\echo "visit_report_hbsag_screenings.sql - troubleshoot done"

UPDATE visit_report_hbsag_screenings rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '19_14_A';

\echo "visit_report_hbsag_screenings.sql - troubleshoot_comment done"

\echo "visit_report_hbsag_screenings.sql ended"