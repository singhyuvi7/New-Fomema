\echo "xray_dispatch_list.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_dispatch_list.sql') into v_log_id; commit;

    insert into xray_dispatches (
        code,
        xray_facility_id,
        film_count,
        sent_date,
        received_date,
        created_by,
        created_at,
        updated_by,
        updated_at,
        received_count
    ) 
    select  
        xdl.dispatch_listid as code,
        xf.id as xray_facility_id,
        xdl.films_count as film_count,
        xdl.date_sent as sent_date,
        xdl.date_received as received_date,
        coalesce(creator_users.id, xray_creator_users.id) as created_by,
        coalesce(xdl.create_date, clock_timestamp()) as created_at,
        coalesce(updator_users.id, xray_updator_users.id) as updated_by,
        coalesce(xdl.modify_date, clock_timestamp()) as updated_at,
        xdl.received_count as received_count
    from fomema_backup_nios.xray_dispatch_list xdl left join xray_facilities xf on xdl.bc_xray_code = xf.code
    left join users creator_users on xdl.creator_id = creator_users.id::varchar
    left join users xray_creator_users on xdl.creator_id = xray_creator_users.username and xray_creator_users.userable_type = 'XrayFacility'
    left join users updator_users on xdl.modifier_id = updator_users.id::varchar
    left join users xray_updator_users on xdl.modifier_id = xray_updator_users.username and xray_updator_users.userable_type = 'XrayFacility'
    order by xdl.create_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo "xray_dispatch_list.sql ended"
