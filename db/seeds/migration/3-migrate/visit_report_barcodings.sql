\echo "visit_report_barcodings.sql loaded"

insert into visit_report_barcodings (
    visit_report_id, mode,
    created_at,updated_at,
    created_by,updated_by
) 
select vr.id, case when rpt.datavalue = 'N/A' then 'NA' else rpt.datavalue end,
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by
from fomema_backup_nios.visit_rpt_labdetail rpt 
join visit_reports vr on rpt.report_id = vr.report_id
where rpt.rpt_seq = '01_08';

\echo "visit_report_barcodings.sql ended"
