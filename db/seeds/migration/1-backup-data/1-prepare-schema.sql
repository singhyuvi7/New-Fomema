do $$
declare
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    raise notice 'now: %', clock_timestamp();

    CREATE TABLE if not exists public.copy_logs
    (
        id bigserial,
        created_at timestamp(0) without time zone default current_timestamp,
        updated_at timestamp(0) without time zone default current_timestamp,
        description character varying(255),
        oracle_table_id bigint,
        start_at timestamp(0) without time zone,
        end_at timestamp(0) without time zone,
        remark text
    );

    insert into public.copy_logs (description, start_at) values ('start prepare schema for backup process', clock_timestamp()) returning id into v_copy_log_id_table;

    create extension if not exists oracle_fdw;

    -- NIOS DB
    drop server if exists nios_server cascade;
    create server if not exists nios_server foreign data wrapper oracle_fdw options (dbserver '//111.67.34.134:1521/niosdb');
    grant usage on foreign server nios_server to deployer;
    DROP USER MAPPING IF EXISTS FOR deployer SERVER nios_server;
    create user mapping if not exists for deployer server nios_server options (user 'fong', password 'fong1234');
    -- reference schema
    drop schema if exists nios_foreign cascade;
    create schema if not exists nios_foreign;
    -- data schema
    drop schema if exists nios cascade;
    create schema if not exists nios; 
    -- /NIOS DB

    -- MOH DB
    drop server if exists moh_server cascade;
    create server if not exists moh_server foreign data wrapper oracle_fdw options (dbserver '//111.67.34.134:1521/niosdb');
    grant usage on foreign server moh_server to deployer;
    DROP USER MAPPING IF EXISTS FOR deployer SERVER moh_server;
    create user mapping if not exists for deployer server moh_server options (user 'fong', password 'fong1234');
    -- reference schema
    drop schema if exists moh_foreign cascade;
    create schema if not exists moh_foreign;
    -- data schema
    drop schema if exists moh cascade;
    create schema if not exists moh; 
    -- /MOH DB

    -- PORTAL DB
    drop server if exists portal_server cascade;
    create server if not exists portal_server foreign data wrapper oracle_fdw options (dbserver '//202.9.102.7:1521/nwp');
    grant usage on foreign server portal_server to deployer;
    DROP USER MAPPING IF EXISTS FOR deployer SERVER portal_server;
    create user mapping if not exists for deployer server portal_server options (user 'fong', password 'fong1234');
    -- reference schema
    drop schema if exists portal_foreign cascade;
    create schema if not exists portal_foreign;
    -- data schema
    drop schema if exists portal cascade;
    create schema if not exists portal; 
    -- /PORTAL DB

    update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

    raise notice 'now: %', clock_timestamp();
end;
$$;
