
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    create or replace view v_migration_logs as 
    select *, coalesce(end_at, clock_timestamp()) - start_at duration from migration_logs;
    
    insert into public.migration_logs (description, start_at) values ('start prepare schema for copy process', clock_timestamp()) returning id into v_copy_log_id_process;

    create extension if not exists postgres_fdw;

    drop schema if exists nios;
    create schema if not exists nios;
    drop schema if exists fomema_backup_nios;
    create schema if not exists fomema_backup_nios;

    drop schema if exists moh;
    create schema if not exists moh;
    drop schema if exists fomema_backup_moh;
    create schema if not exists fomema_backup_moh;

    drop schema if exists portal;
    create schema if not exists portal;
    drop schema if exists fomema_backup_portal;
    create schema if not exists fomema_backup_portal;

    drop server if exists fomema_backup cascade;
    create server if not exists fomema_backup foreign data wrapper postgres_fdw options (host '172.24.184.162', port '5432', dbname 'fomema_backup');

    drop user mapping if exists for deployer server fomema_backup;
    create user mapping if not exists for deployer server fomema_backup options (user 'deployer', password 'bookdoc#123');

    grant usage on foreign server fomema_backup to deployer;

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
