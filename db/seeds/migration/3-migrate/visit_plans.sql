\echo "visit_plans.sql loaded"

-- need id to map with visit_plan_items (column remove at visit_plan_items)
ALTER TABLE visit_plans ADD COLUMN IF NOT EXISTS plan_id bigint;

-- user_master
insert into visit_plans (
	code, status, visitable_type,
    -- created_by, updated_by,
    created_at, updated_at,
    plan_id
) 
select concat(mas.category,trim(to_char(mas.plan_id, '00000'))), case when mas.plan_status = 'O' then 'LEVEL_2_APPROVED' else 'SUSPENDED' end status, 
    case when mas.category = 'X' then 'XrayFacility' when mas.category = 'D' then 'Doctor' else 'Laboratory' end category,
    -- creator_id, modify_id
    creation_date, modify_date,
    mas.plan_id
from fomema_backup_nios.visit_plan_master mas limit 5;

-- users

\echo "visit_plans.sql ended"

