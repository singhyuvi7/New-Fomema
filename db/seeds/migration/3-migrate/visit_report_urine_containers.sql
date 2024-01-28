\echo "visit_report_urine_containers.sql loaded"

insert into visit_report_urine_containers (
    visit_report_id, category,
    created_at,updated_at,
    created_by,updated_by
) 
select vr.id, rpt.datavalue,
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by
from fomema_backup_nios.visit_rpt_labdetail rpt 
join visit_reports vr on rpt.report_id = vr.report_id
where rpt.rpt_seq = '01_04' and rpt.datavalue is not null;

\echo "visit_report_urine_containers.sql ended"
