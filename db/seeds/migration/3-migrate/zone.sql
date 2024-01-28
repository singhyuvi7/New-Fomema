\echo "zone.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('zone.sql') into v_log_id;
    commit;

    insert into zones (code, name, created_at, updated_at) 
    select zone_code, zone_name, clock_timestamp(), clock_timestamp() from fomema_backup_nios.zone_master;

    perform end_migration_log(v_log_id);
end
$$;

\echo "zone.sql ended"
