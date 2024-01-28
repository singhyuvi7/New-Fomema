\echo "monitor_reason.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('monitor_reason.sql') into v_log_id;
    commit;

insert into monitor_reasons (code, description, short_description, created_at, updated_at) 
select reason_code, description, shortdesc, clock_timestamp(), clock_timestamp() from fomema_backup_nios.fw_monitor_reason;

    perform end_migration_log(v_log_id);
end
$$;

\echo "monitor_reason.sql ended"
