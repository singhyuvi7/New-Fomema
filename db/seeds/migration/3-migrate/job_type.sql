\echo "job_type.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('job_type.sql') into v_log_id;
    commit;

    insert into job_types (name, created_at, updated_at) 
    select job_type, clock_timestamp(), clock_timestamp() from fomema_backup_nios.jobtype_master;

    perform end_migration_log(v_log_id);
end
$$;

\echo "job_type.sql ended"
