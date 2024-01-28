\echo "visit_plan_states.sql loaded"

-- doctor
insert into visit_plan_states (
	visit_plan_id, state_id, 
    created_at, updated_at
    -- created_by, updated_by
) 
select distinct visit_plan_id, state_id, NOW(), NOW()
from visit_plan_items item;


\echo "visit_plan_states.sql ended"
