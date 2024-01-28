\echo "visit_plan_towns.sql loaded"

-- doctor
insert into visit_plan_towns (
	visit_plan_id,state_id, town_id, 
    created_at, updated_at
    -- created_by, updated_by
) 
select distinct visit_plan_id, state_id, town_id, NOW(), NOW()
from visit_plan_items item;


\echo "visit_plan_towns.sql ended"
