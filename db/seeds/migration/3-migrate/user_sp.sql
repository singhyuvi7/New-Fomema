\echo "user_sp.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('user_sp.sql') into v_log_id;
    commit;

-- doctors
insert into users (
    code, username, name, 
    status, email, 
	role_id, created_at, updated_at, last_sign_in_at, 
	userable_type, userable_id, 
    confirmed_at, password_changed_at
) 
select usercode code, usercode username, username as name, 
/* status */ case when u.status = 'ACTIVE' then 'ACTIVE' else 'INACTIVE' end status, doctors.email, 
roles.id role_id, doctors.created_at as created_at, doctors.updated_at as updated_at, lastlogindate last_sign_in_at, 
'Doctor' userable_type, doctors.id userable_id, 
clock_timestamp() confirmed_at, clock_timestamp() - interval '1 year' password_changed_at
from fomema_backup_nios.users u 
join doctors on u.usercode = doctors.code 
left join roles on roles.code = 'DOCTOR'
order by doctors.created_at;

-- \echo "user_sp.sql doctor users done"

-- laboratories
insert into users (
    code, username, name, 
    status, email, 
	role_id, created_at, updated_at, last_sign_in_at, 
	userable_type, userable_id, 
    confirmed_at, password_changed_at
) 
select usercode, usercode, username, 
/* status */ case when u.status = 'ACTIVE' then 'ACTIVE' else 'INACTIVE' end status, laboratories.email, 
roles.id role_id, laboratories.created_at as created_at, laboratories.updated_at as updated_at, lastlogindate, 
'Laboratory' userable_type, laboratories.id userable_id, 
clock_timestamp() confirmed_at, clock_timestamp() - interval '1 year' password_changed_at
from fomema_backup_nios.users u 
join laboratories on u.usercode = laboratories.code 
left join roles on roles.code = 'LABORATORY'
order by laboratories.created_at;

-- \echo "user_sp.sql laboratory users done"

-- xray_facilities
insert into users (
    code, username, name, 
    status, email, 
	role_id, created_at, updated_at, last_sign_in_at, 
	userable_type, userable_id, 
    confirmed_at, password_changed_at
) 
select usercode, usercode, username, 
/* status */ case when u.status = 'ACTIVE' then 'ACTIVE' else 'INACTIVE' end status, xray_facilities.email, 
roles.id role_id, xray_facilities.created_at as created_at, xray_facilities.updated_at as updated_at, lastlogindate, 
'XrayFacility' userable_type, xray_facilities.id userable_id, 
clock_timestamp() confirmed_at, clock_timestamp() - interval '1 year' password_changed_at
from fomema_backup_nios.users u 
join xray_facilities on u.usercode = xray_facilities.code 
left join roles on roles.code = 'XRAY_FACILITY'
order by xray_facilities.created_at;

-- \echo "user_sp.sql xray facility users done"

-- radiologists
insert into users (
    code, username, name, 
    status, email, 
	role_id, created_at, updated_at, last_sign_in_at, 
	userable_type, userable_id, 
    confirmed_at, password_changed_at
) 
select usercode, usercode, username, 
/* status */ case when u.status = 'ACTIVE' then 'ACTIVE' else 'INACTIVE' end status, radiologists.email, 
roles.id role_id, radiologists.created_at as created_at, radiologists.updated_at as updated_at, lastlogindate, 
'Radiologist' userable_type, radiologists.id userable_id, 
clock_timestamp() confirmed_at, clock_timestamp() - interval '1 year' password_changed_at
from fomema_backup_nios.users u 
join radiologists on u.usercode = radiologists.code 
left join roles on roles.code = 'RADIOLOGIST'
order by radiologists.created_at;

-- \echo "user_sp.sql radiologist users done"

    perform end_migration_log(v_log_id);
end
$$;

\echo "user_sp.sql ended"
