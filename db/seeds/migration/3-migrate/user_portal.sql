\echo "user_portal.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('user_portal.sql') into v_log_id; commit;
    insert into users (
        code, username, name, 
        status, email, 
        role_id, created_at, 
        updated_at, password_changed_at,
        userable_type, userable_id, 
        confirmed_at
    ) 
    select
        um.usercode as code,
        um.usercode as username,
        um.username as name,
        case
            when um.status = 1 then 'ACTIVE'
            else 'INACTIVE'
        end as status,
        um.email,
        roles.id as role_id,
        coalesce(um.creation_date, clock_timestamp()) as created_at,
        coalesce(um.modification_date, clock_timestamp()) as updated_at,
        clock_timestamp() - interval '1 year' as password_changed_at,
        'Employer' as userable_type,
        employers.id as userable_id,
        clock_timestamp() as confirmed_at
    from
        fomema_backup_portal.user_master um
        join employers on um.usercode = employers.code
        left join roles on roles.code = 'EMPLOYER'
        order by um.creation_date;

    insert into users (
        code, 
        username, 
        name, 
        status, 
        email, 
        role_id, 
        created_at, 
        updated_at, 
        password_changed_at,
        userable_type, 
        userable_id, 
        confirmed_at
    ) 
    select 
        e.code as code,
        e.code as username,
        e.name as name,
        e.status as status,
        e.email as email,
        roles.id as role_id,
        e.created_at as created_at,
        e.updated_at as updated_at,
        clock_timestamp() - interval '1 year' as password_changed_at,
        'Employer' as userable_type,
        e.id as userable_id,
        clock_timestamp() as confirmed_at
    from employers e left join users u on e.code = u.code and u.userable_type = 'Employer' 
    left join roles on roles.code = 'EMPLOYER'
    where u.id is null
    order by e.created_at;
    perform end_migration_log(v_log_id);
end
$$;

\echo "user_portal.sql ended"
