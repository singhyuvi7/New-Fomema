\echo "visit_report_hbsag_verifications.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_hbsag_verifications ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_hbsag_verifications (
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

\echo "visit_report_hbsag_verifications.sql - main data done"

UPDATE visit_report_hbsag_verifications rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_06';

\echo "visit_report_hbsag_verifications.sql - iqa done"

UPDATE visit_report_hbsag_verifications rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_06_A';

\echo "visit_report_hbsag_verifications.sql - iqa_detail_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_061';

\echo "visit_report_hbsag_verifications.sql - iqa_record done"

UPDATE visit_report_hbsag_verifications rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_062';

\echo "visit_report_hbsag_verifications.sql - iqa_perform_acknowledge done"

UPDATE visit_report_hbsag_verifications rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_063';

\echo "visit_report_hbsag_verifications.sql - iqa_validate_acknowledge done"

UPDATE visit_report_hbsag_verifications rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_07';

\echo "visit_report_hbsag_verifications.sql - eqa done"

UPDATE visit_report_hbsag_verifications rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_07_A';

\echo "visit_report_hbsag_verifications.sql - eqa_detail_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_08';

\echo "visit_report_hbsag_verifications.sql - test_worksheet done"

UPDATE visit_report_hbsag_verifications rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_08_A';

\echo "visit_report_hbsag_verifications.sql - test_worksheet_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_08_D';

\echo "visit_report_hbsag_verifications.sql - worksheet_document done"

UPDATE visit_report_hbsag_verifications rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_08_B';

\echo "visit_report_hbsag_verifications.sql - worksheet_acknowledge done"

UPDATE visit_report_hbsag_verifications rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_08_C';

\echo "visit_report_hbsag_verifications.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_hbsag_verifications rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_09';

\echo "visit_report_hbsag_verifications.sql - sop done"

UPDATE visit_report_hbsag_verifications rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_09_A';

\echo "visit_report_hbsag_verifications.sql - sop_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_10';

\echo "visit_report_hbsag_verifications.sql - iso done"

UPDATE visit_report_hbsag_verifications rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_10_A';

\echo "visit_report_hbsag_verifications.sql - iso_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_11';

\echo "visit_report_hbsag_verifications.sql - instrument_maintenance_record done"

UPDATE visit_report_hbsag_verifications rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_11_A';

\echo "visit_report_hbsag_verifications.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_hbsag_verifications rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_12';

\echo "visit_report_hbsag_verifications.sql - duration_per_cycle done"

UPDATE visit_report_hbsag_verifications rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_13';

\echo "visit_report_hbsag_verifications.sql - sample_per_cycle done"

UPDATE visit_report_hbsag_verifications rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_14';

\echo "visit_report_hbsag_verifications.sql - troubleshoot done"

UPDATE visit_report_hbsag_verifications rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '20_14_A';

\echo "visit_report_hbsag_verifications.sql - troubleshoot_comment done"

\echo "visit_report_hbsag_verifications.sql ended"