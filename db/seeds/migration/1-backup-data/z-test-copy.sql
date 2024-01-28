do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into copy_logs (description, begin_at) values ('start copy nios master process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table AGENT_MASTER', 10 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.AGENT_MASTER;

    create foreign table if not exists nios_foreign.AGENT_MASTER (
        "agent_code" varchar(10),
        "agent_name" varchar(50),
        "agency_licence_no" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "email_id" varchar(100),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "version_no" varchar(10),
        "creation_date" timestamp,
        "comments" varchar(4000),
        "bc_agent_code" varchar(13),
        "branch_code" varchar(2),
        "status_code" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'AGENT_MASTER');

    raise notice 'created foreign table for AGENT_MASTER';
    -- /foreign table

    -- copy table
    drop table if exists nios.AGENT_MASTER;

    create table if not exists nios.AGENT_MASTER as select * from nios_foreign.AGENT_MASTER;

    raise notice 'copied table nios.AGENT_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BANK_MASTER', 33 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BANK_MASTER;

    create foreign table if not exists nios_foreign.BANK_MASTER (
        "bank_code" varchar(8),
        "bank_name" varchar(100),
        "isactive" char(1),
        "swift_code" varchar(20),
        "local_bank" char(20),
        "routing" varchar(15),
        "routing2" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'BANK_MASTER');

    raise notice 'created foreign table for BANK_MASTER';
    -- /foreign table

    -- copy table
    drop table if exists nios.BANK_MASTER;

    create table if not exists nios.BANK_MASTER as select * from nios_foreign.BANK_MASTER;

    raise notice 'copied table nios.BANK_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;


update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
