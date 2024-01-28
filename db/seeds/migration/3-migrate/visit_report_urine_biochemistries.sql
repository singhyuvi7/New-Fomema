\echo "visit_report_urine_biochemistries.sql loaded"

-- need id to map with visit_reports
ALTER TABLE visit_report_urine_biochemistries ADD COLUMN IF NOT EXISTS report_id bigint;

insert into visit_report_urine_biochemistries (
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

\echo "visit_report_urine_biochemistries.sql - main data done"

UPDATE visit_report_urine_biochemistries rpt
SET iqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_07';

\echo "visit_report_urine_biochemistries.sql - iqa done"

UPDATE visit_report_urine_biochemistries rpt
SET iqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_07_A';

\echo "visit_report_urine_biochemistries.sql - iqa_detail_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET iqa_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_071';

\echo "visit_report_urine_biochemistries.sql - iqa_record done"

UPDATE visit_report_urine_biochemistries rpt
SET iqa_perform_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_072';

\echo "visit_report_urine_biochemistries.sql - iqa_perform_acknowledge done"

UPDATE visit_report_urine_biochemistries rpt
SET iqa_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_073';

\echo "visit_report_urine_biochemistries.sql - iqa_validate_acknowledge done"

UPDATE visit_report_urine_biochemistries rpt
SET eqa = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_08';

\echo "visit_report_urine_biochemistries.sql - eqa done"

UPDATE visit_report_urine_biochemistries rpt
SET eqa_detail_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_08_A';

\echo "visit_report_urine_biochemistries.sql - eqa_detail_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET test_worksheet = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_09';

\echo "visit_report_urine_biochemistries.sql - test_worksheet done"

UPDATE visit_report_urine_biochemistries rpt
SET test_worksheet_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_09_A';

\echo "visit_report_urine_biochemistries.sql - test_worksheet_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET worksheet_document = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_09_D';

\echo "visit_report_urine_biochemistries.sql - worksheet_document done"

UPDATE visit_report_urine_biochemistries rpt
SET worksheet_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_09_B';

\echo "visit_report_urine_biochemistries.sql - worksheet_acknowledge done"

UPDATE visit_report_urine_biochemistries rpt
SET worksheet_validate_acknowledge = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_09_C';

\echo "visit_report_urine_biochemistries.sql - worksheet_validate_acknowledge done"

UPDATE visit_report_urine_biochemistries rpt
SET sop = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_10';

\echo "visit_report_urine_biochemistries.sql - sop done"

UPDATE visit_report_urine_biochemistries rpt
SET sop_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_10_A';

\echo "visit_report_urine_biochemistries.sql - sop_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET iso = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_11';

\echo "visit_report_urine_biochemistries.sql - iso done"

UPDATE visit_report_urine_biochemistries rpt
SET iso_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_11_A';

\echo "visit_report_urine_biochemistries.sql - iso_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET instrument_maintenance_record = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_12';

\echo "visit_report_urine_biochemistries.sql - instrument_maintenance_record done"

UPDATE visit_report_urine_biochemistries rpt
SET instrument_maintenance_record_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_12_A';

\echo "visit_report_urine_biochemistries.sql - instrument_maintenance_record_comment done"

UPDATE visit_report_urine_biochemistries rpt
SET duration_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_13';

\echo "visit_report_urine_biochemistries.sql - duration_per_cycle done"

UPDATE visit_report_urine_biochemistries rpt
SET sample_per_cycle = cast(det.datavalue as int)
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_14';

\echo "visit_report_urine_biochemistries.sql - sample_per_cycle done"

UPDATE visit_report_urine_biochemistries rpt
SET troubleshoot = CASE WHEN det.datavalue = 'N/A' THEN 'NA' ELSE det.datavalue END
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_15';

\echo "visit_report_urine_biochemistries.sql - troubleshoot done"

UPDATE visit_report_urine_biochemistries rpt
SET troubleshoot_comment = det.datavalue
FROM
	fomema_backup_nios.visit_rpt_labdetail det
WHERE rpt.report_id = det.report_id and rpt_seq = '28_15_A';

\echo "visit_report_urine_biochemistries.sql - troubleshoot_comment done"

\echo "visit_report_urine_biochemistries.sql ended"