\echo "user_nios.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('user_nios.sql') into v_log_id;
    commit;

-- user_master
insert into users (
    code, 
    username, 
    name, 
    status, 
    email, 
    role_id, 
    created_by, 
    created_at, 
    updated_by, 
    updated_at,
    userable_type, 
    userable_id, 
    confirmed_at, 
    password_changed_at,
    designation
) 
select 
    um.userid as code, 
    um.userid as username, 
    um.displayname as name, 
    case when um.status = 'Y' then 'ACTIVE' else 'INACTIVE' end as status, 
    um.email_id as email, 
    /* um.roleid */ roles.id as role_id, 
    /* um.creator_id */ null as created_by, 
    um.creation_date as created_at, 
    /* um.modify_id */ null as updated_by, 
    um.modification_date as updated_at, 
    'Organization' as userable_type, 
    /* um.branch_code */ organizations.id as userable_id, 
    clock_timestamp() as confirmed_at, 
    clock_timestamp() - interval '1 year' as password_changed_at, 
    um.designation as designation 
from fomema_backup_nios.v_user_master um
join organizations on um.branch_code = organizations.code 
left join fomema_backup_nios.role_master rm on um.roleid = rm.roleid 
left join z_role_mappings on rm.description = z_role_mappings.oldcode 
left join roles on z_role_mappings.newcode = roles.code;

-- system user
update users set status = 'INACTIVE', email = 'noreply@fomema.com.my', /*code = 'NOREPLY',*/ username = 'NOREPLY'
where code = 'ADMIN_RADIOLOGIST';

    perform end_migration_log(v_log_id);
end
$$;

\echo "user_nios.sql ended"
