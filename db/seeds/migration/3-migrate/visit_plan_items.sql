\echo "visit_plan_items.sql loaded"

-- doctor
insert into visit_plan_items (
	visit_plan_id, visitable_id, visitable_type, 
    state_id, town_id,
    created_at, updated_at
    -- created_by, updated_by
) 
select vp.id, sp.id, 'Doctor',
    st.id, tw.id,
    creation_date, modify_date
from fomema_backup_nios.visit_plan_detail det 
left join visit_plans vp on det.plan_id = vp.plan_id
left join doctors sp on det.provider_id = sp.code
left join states st on det.state_code = st.code
left join towns tw on det.district_code = tw.code
where vp.visitable_type = 'Doctor'
limit 2;

-- xray
insert into visit_plan_items (
	visit_plan_id, visitable_id, visitable_type, 
    state_id, town_id,
    created_at, updated_at
    -- created_by, updated_by
) 
select vp.id, sp.id, 'XrayFacility',
    st.id, tw.id,
    creation_date, modify_date
from fomema_backup_nios.visit_plan_detail det 
left join visit_plans vp on det.plan_id = vp.plan_id
left join xray_facilities sp on det.provider_id = sp.code
left join states st on det.state_code = st.code
left join towns tw on det.district_code = tw.code
where vp.visitable_type = 'XrayFacility'
limit 2;

-- lab
insert into visit_plan_items (
	visit_plan_id, visitable_id, visitable_type, 
    state_id, town_id,
    created_at, updated_at
    -- created_by, updated_by
) 
select vp.id, sp.id, 'Laboratory',
    st.id, tw.id,
    creation_date, modify_date
from fomema_backup_nios.visit_plan_detail det 
left join visit_plans vp on det.plan_id = vp.plan_id
left join laboratories sp on det.provider_id = sp.code
left join states st on det.state_code = st.code
left join towns tw on det.district_code = tw.code
where vp.visitable_type = 'Laboratory'
limit 2;

-- need id to map with visit_plan_items (column added at visit_plan_items)
ALTER TABLE visit_plans DROP COLUMN IF EXISTS plan_id;

\echo "visit_plan_items.sql ended"

