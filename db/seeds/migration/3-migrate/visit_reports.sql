\echo "visit_reports.sql loaded"

-- need id to map with visit_report_doctors and visit_report_xray_facilities (column remove at visit_report_xray_facilities)
ALTER TABLE visit_reports ADD COLUMN IF NOT EXISTS report_id bigint;

-- visit_report - doctor
insert into visit_reports (
    code,visit_plan_id,visit_plan_item_id,
    visitable_type,visitable_id,visit_date,
    visit_time_from,visit_time_to,visit_category,comment,
    follow_up,prepare_by,prepare_at,status,
    level_1_approval_decision,level_1_approval_comment, level_1_approval_by,level_1_approval_at,
    level_2_approval_decision, level_2_approval_comment,level_2_approval_by, level_2_approval_at,
    created_at,updated_at,
    created_by,updated_by,
    report_id
) 
select concat('D',trim(to_char(rpt.report_id, '00000'))), null, null,
    'Doctor', doc.id, rpt.visit_date, 
    rpt.start_time, rpt.end_time,null, rpt.remarks, 
    rpt.doctor_comment, prepare.id, rpt.prepared_date,'LEVEL_2_APPROVED',
    'APPROVE',null, null, null,
    'APPROVE',null, null, null,
    rpt.creation_date, rpt.modify_date,
    creation.id, modify_user.id,
    rpt.report_id
from fomema_backup_nios.visit_rpt_docxray rpt 
left join doctors doc on rpt.provider_code = doc.code
left join users prepare on rpt.prepared_by = prepare.code
left join users creation on rpt.creator_id = creation.code
left join users modify_user on rpt.modify_id = modify_user.code
where rpt.provider_code LIKE 'D%'
limit 2;

\echo "visit_report.sql - doctor done"

-- visit_report - xray
insert into visit_reports (
    code,visit_plan_id,visit_plan_item_id,
    visitable_type,visitable_id,visit_date,
    visit_time_from,visit_time_to,visit_category,comment,
    follow_up,prepare_by,prepare_at,status,
    level_1_approval_decision,level_1_approval_comment, level_1_approval_by,level_1_approval_at,
    level_2_approval_decision, level_2_approval_comment,level_2_approval_by, level_2_approval_at,
    created_at,updated_at,
    created_by,updated_by,
    report_id
) 
select concat('X',trim(to_char(rpt.report_id, '00000'))), null, null,
    'XrayFacility', xray.id, rpt.visit_date, 
    rpt.start_time, rpt.end_time,null, rpt.remarks, 
    rpt.doctor_comment, prepare.id, rpt.prepared_date,'LEVEL_2_APPROVED',
    'APPROVE',null, null, null,
    'APPROVE',null, null, null,
    rpt.creation_date, rpt.modify_date,
    creation.id, modify_user.id,
    rpt.report_id
from fomema_backup_nios.visit_rpt_docxray rpt 
left join xray_facilities xray on rpt.provider_code = xray.code
left join users prepare on rpt.prepared_by = prepare.code
left join users creation on rpt.creator_id = creation.code
left join users modify_user on rpt.modify_id = modify_user.code
where rpt.provider_code LIKE 'X%'
limit 2;

\echo "visit_report.sql - xray done"

-- visit_report - lab
insert into visit_reports (
    code,visit_plan_id,visit_plan_item_id,
    visitable_type,visitable_id,visit_date,
    visit_time_from,visit_time_to,visit_category,comment,
    follow_up,prepare_by,prepare_at,status,
    level_1_approval_decision,level_1_approval_comment, level_1_approval_by,level_1_approval_at,
    level_2_approval_decision, level_2_approval_comment,level_2_approval_by, level_2_approval_at,
    created_at,updated_at,
    created_by,updated_by,
    report_id
) 
select concat('L',trim(to_char(rpt.report_id, '00000'))), null, null,
    'Laboratory', lab.id, rpt.visit_date, 
    rpt.start_time, rpt.end_time,case when rpt.lab_category = 'COLLECTIONCENTRE' then 'COLLECTION_CENTRE' when rpt.lab_category = 'PARTIAL' then 'PARTIAL' when rpt.lab_category = 'FULL' then 'FULL' else null end visit_category, null, 
    null, creation.id, rpt.creation_date,'LEVEL_2_APPROVED',
    'APPROVE',null, null, null,
    'APPROVE',null, null, null,
    rpt.creation_date, rpt.modify_date,
    creation.id, modify_user.id,
    rpt.report_id
from fomema_backup_nios.visit_rpt_labmaster rpt 
left join laboratories lab on rpt.laboratory_code = lab.code
left join users creation on rpt.creator_id = creation.code
left join users modify_user on rpt.modify_id = modify_user.code
limit 2;

\echo "visit_report.sql - lab done"

\echo "visit_reports.sql ended"