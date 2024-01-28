\echo "visit_report_blood_groupings.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_blood_groupings ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_blood_groupings (
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

\echo "visit_report_blood_groupings.sql - main data done"

UPDATE visit_report_blood_groupings rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_02';

\echo "visit_report_blood_groupings.sql - iqa done"

UPDATE visit_report_blood_groupings rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_02_A';

\echo "visit_report_blood_groupings.sql - iqa_detail_comment done"

UPDATE visit_report_blood_groupings rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_021';

\echo "visit_report_blood_groupings.sql - iqa_record done"

UPDATE visit_report_blood_groupings rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_022';

\echo "visit_report_blood_groupings.sql - iqa_perform_acknowledge done"

UPDATE visit_report_blood_groupings rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_023';

\echo "visit_report_blood_groupings.sql - iqa_validate_acknowledge done"

UPDATE visit_report_blood_groupings rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_03';

\echo "visit_report_blood_groupings.sql - eqa done"

UPDATE visit_report_blood_groupings rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_03_A';

\echo "visit_report_blood_groupings.sql - eqa_detail_comment done"

UPDATE visit_report_blood_groupings rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_11';

\echo "visit_report_blood_groupings.sql - test_worksheet done"

UPDATE visit_report_blood_groupings rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_113';

\echo "visit_report_blood_groupings.sql - test_worksheet_comment done"

UPDATE visit_report_blood_groupings rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_114';

\echo "visit_report_blood_groupings.sql - worksheet_document done"

UPDATE visit_report_blood_groupings rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_111';

\echo "visit_report_blood_groupings.sql - worksheet_acknowledge done"

UPDATE visit_report_blood_groupings rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_112';

\echo "visit_report_blood_groupings.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_blood_groupings rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_04';

\echo "visit_report_blood_groupings.sql - sop done"

UPDATE visit_report_blood_groupings rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_041';

\echo "visit_report_blood_groupings.sql - sop_comment done"

UPDATE visit_report_blood_groupings rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_05';

\echo "visit_report_blood_groupings.sql - iso done"

UPDATE visit_report_blood_groupings rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_051';

\echo "visit_report_blood_groupings.sql - iso_comment done"

UPDATE visit_report_blood_groupings rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_12';

\echo "visit_report_blood_groupings.sql - instrument_maintenance_record done"

UPDATE visit_report_blood_groupings rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_121';

\echo "visit_report_blood_groupings.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_blood_groupings rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_13';

\echo "visit_report_blood_groupings.sql - duration_per_cycle done"

UPDATE visit_report_blood_groupings rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_14';

\echo "visit_report_blood_groupings.sql - sample_per_cycle done"

UPDATE visit_report_blood_groupings rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_06';

\echo "visit_report_blood_groupings.sql - troubleshoot done"

UPDATE visit_report_blood_groupings rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '02_061';

\echo "visit_report_blood_groupings.sql - troubleshoot_comment done"

\echo "visit_report_blood_groupings.sql ended"