do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into copy_logs (description, begin_at) values ('start copy nios process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ACCOUNT_CONCILE', 1 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ACCOUNT_CONCILE;

    create foreign table if not exists nios_foreign.ACCOUNT_CONCILE (
        "id" numeric(19),
        "version" numeric(19),
        "amount_expect" numeric(14, 2),
        "amount_return" numeric(14, 2),
        "creation_date" timestamp,
        "description" varchar(4000),
        "description2" varchar(4000),
        "isread" numeric(10),
        "process_date" timestamp,
        "process_id" varchar(1020),
        "reference_id" numeric(10),
        "type" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'ACCOUNT_CONCILE');

    raise notice 'created foreign table for ACCOUNT_CONCILE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ACCOUNT_CONCILE;

    -- create table if not exists nios.ACCOUNT_CONCILE as select * from nios_foreign.ACCOUNT_CONCILE;

    raise notice 'copied table nios.ACCOUNT_CONCILE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ACCOUNT_REFERENCE', 2 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ACCOUNT_REFERENCE;

    create foreign table if not exists nios_foreign.ACCOUNT_REFERENCE (
        "id" numeric(19),
        "version" numeric(19),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_master_id" varchar(76),
        "payment_no" varchar(64),
        "payment_type" numeric(10),
        "reference_source" numeric(10),
        "tranno" varchar(40),
        "payment_refund_id" varchar(76)
    ) server nios_server options (schema 'NIOS1', table 'ACCOUNT_REFERENCE');

    raise notice 'created foreign table for ACCOUNT_REFERENCE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ACCOUNT_REFERENCE;

    -- create table if not exists nios.ACCOUNT_REFERENCE as select * from nios_foreign.ACCOUNT_REFERENCE;

    raise notice 'copied table nios.ACCOUNT_REFERENCE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ACCOUNT_SETTING', 3 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ACCOUNT_SETTING;

    create foreign table if not exists nios_foreign.ACCOUNT_SETTING (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "parameter" varchar(120),
        "value" varchar(50),
        "description" varchar(400)
    ) server nios_server options (schema 'NIOS1', table 'ACCOUNT_SETTING');

    raise notice 'created foreign table for ACCOUNT_SETTING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ACCOUNT_SETTING;

    -- create table if not exists nios.ACCOUNT_SETTING as select * from nios_foreign.ACCOUNT_SETTING;

    raise notice 'copied table nios.ACCOUNT_SETTING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ADMINUSERS', 4 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ADMINUSERS;

    create foreign table if not exists nios_foreign.ADMINUSERS (
        "usercode" varchar(13),
        "username" varchar(50),
        "userpass" varchar(100),
        "lastlogindate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ADMINUSERS');

    raise notice 'created foreign table for ADMINUSERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ADMINUSERS;

    -- create table if not exists nios.ADMINUSERS as select * from nios_foreign.ADMINUSERS;

    raise notice 'copied table nios.ADMINUSERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ADVANCE_PAYMENT', 5 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ADVANCE_PAYMENT;

    create foreign table if not exists nios_foreign.ADVANCE_PAYMENT (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "ap_group_id" numeric(19),
        "bank_area" varchar(1020),
        "bank_code" varchar(1020),
        "contact_address1" varchar(200),
        "contact_address2" varchar(200),
        "contact_address3" varchar(200),
        "contact_address4" varchar(200),
        "contact_district_code" varchar(28),
        "contact_fax" varchar(400),
        "contact_name" varchar(200),
        "contact_phone" varchar(400),
        "contact_post_code" varchar(40),
        "contact_state_code" varchar(28),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "date_issue" timestamp,
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "payment_no" varchar(1020),
        "payment_type" numeric(10),
        "status" varchar(4),
        "zone_code" varchar(1020),
        "branch_code" varchar(8),
        "voided_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ADVANCE_PAYMENT');

    raise notice 'created foreign table for ADVANCE_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ADVANCE_PAYMENT;

    -- create table if not exists nios.ADVANCE_PAYMENT as select * from nios_foreign.ADVANCE_PAYMENT;

    raise notice 'copied table nios.ADVANCE_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ADVANCE_PAYMENT_ACCOUNT', 6 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ADVANCE_PAYMENT_ACCOUNT;

    create foreign table if not exists nios_foreign.ADVANCE_PAYMENT_ACCOUNT (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "ap_id" numeric(19),
        "ap_group_id" numeric(19),
        "branch_code" varchar(8),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "description" varchar(4000),
        "draft_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(126),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "type" numeric(10),
        "refund_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'ADVANCE_PAYMENT_ACCOUNT');

    raise notice 'created foreign table for ADVANCE_PAYMENT_ACCOUNT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ADVANCE_PAYMENT_ACCOUNT;

    -- create table if not exists nios.ADVANCE_PAYMENT_ACCOUNT as select * from nios_foreign.ADVANCE_PAYMENT_ACCOUNT;

    raise notice 'copied table nios.ADVANCE_PAYMENT_ACCOUNT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ADVANCE_PAYMENT_APPROVAL', 7 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ADVANCE_PAYMENT_APPROVAL;

    create foreign table if not exists nios_foreign.ADVANCE_PAYMENT_APPROVAL (
        "id" numeric(19),
        "version" numeric(19),
        "approve_status" varchar(1020),
        "comments" varchar(1600),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "approval_id" numeric(10),
        "ap_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'ADVANCE_PAYMENT_APPROVAL');

    raise notice 'created foreign table for ADVANCE_PAYMENT_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ADVANCE_PAYMENT_APPROVAL;

    -- create table if not exists nios.ADVANCE_PAYMENT_APPROVAL as select * from nios_foreign.ADVANCE_PAYMENT_APPROVAL;

    raise notice 'copied table nios.ADVANCE_PAYMENT_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ADVANCE_PAYMENT_GROUP', 8 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ADVANCE_PAYMENT_GROUP;

    create foreign table if not exists nios_foreign.ADVANCE_PAYMENT_GROUP (
        "id" numeric(19),
        "version" numeric(19),
        "address1" varchar(1020),
        "address2" varchar(1020),
        "address3" varchar(1020),
        "address4" varchar(1020),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "district_code" varchar(28),
        "email_address" varchar(400),
        "fax" varchar(1020),
        "group_code" varchar(40),
        "group_name" varchar(200),
        "isactive" varchar(1020),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "phone" varchar(1020),
        "postcode" varchar(1020),
        "roc" varchar(80),
        "state_code" varchar(28)
    ) server nios_server options (schema 'NIOS1', table 'ADVANCE_PAYMENT_GROUP');

    raise notice 'created foreign table for ADVANCE_PAYMENT_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ADVANCE_PAYMENT_GROUP;

    -- create table if not exists nios.ADVANCE_PAYMENT_GROUP as select * from nios_foreign.ADVANCE_PAYMENT_GROUP;

    raise notice 'copied table nios.ADVANCE_PAYMENT_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table AGENT_HISTORY', 9 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.AGENT_HISTORY;

    create foreign table if not exists nios_foreign.AGENT_HISTORY (
        "agent_code" varchar(10),
        "bc_agent_code" varchar(13),
        "agent_name" varchar(50),
        "agency_licence_no" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "email_id" varchar(100),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "version_no" varchar(10),
        "comments" varchar(40),
        "district_name" varchar(40),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "status_code" varchar(5),
        "branch_code" varchar(2),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'AGENT_HISTORY');

    raise notice 'created foreign table for AGENT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.AGENT_HISTORY;

    -- create table if not exists nios.AGENT_HISTORY as select * from nios_foreign.AGENT_HISTORY;

    raise notice 'copied table nios.AGENT_HISTORY';
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
    -- drop table if exists nios.AGENT_MASTER;

    -- create table if not exists nios.AGENT_MASTER as select * from nios_foreign.AGENT_MASTER;

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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ANNOUNCEMENT', 11 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ANNOUNCEMENT;

    create foreign table if not exists nios_foreign.ANNOUNCEMENT (
        "id" numeric,
        "creation_date" timestamp,
        "subject" varchar(200),
        "start_date" timestamp,
        "end_date" timestamp,
        "content" text,
        "status" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'ANNOUNCEMENT');

    raise notice 'created foreign table for ANNOUNCEMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ANNOUNCEMENT;

    -- create table if not exists nios.ANNOUNCEMENT as select * from nios_foreign.ANNOUNCEMENT;

    raise notice 'copied table nios.ANNOUNCEMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_FW_APPEAL', 12 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_FW_APPEAL;

    create foreign table if not exists nios_foreign.APPEAL_FW_APPEAL (
        "appealid" numeric(10),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "appeal_doctor_code" varchar(13),
        "letter_apointment_date" timestamp,
        "result_date" timestamp,
        "idemnity_date" timestamp,
        "letter_notification" timestamp,
        "comments" varchar(4000),
        "follow_up" varchar(13),
        "status" varchar(5),
        "appeal_success" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "phase_status" varchar(2),
        "blood_group" varchar(3),
        "rh" varchar(1),
        "appeal_close_comments" varchar(4000),
        "officer_incharge" varchar(50),
        "iscancelled" varchar(1),
        "appeal_type" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_FW_APPEAL');

    raise notice 'created foreign table for APPEAL_FW_APPEAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_FW_APPEAL;

    -- create table if not exists nios.APPEAL_FW_APPEAL as select * from nios_foreign.APPEAL_FW_APPEAL;

    raise notice 'copied table nios.APPEAL_FW_APPEAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_FW_APPEAL_APPROVAL', 13 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_FW_APPEAL_APPROVAL;

    create foreign table if not exists nios_foreign.APPEAL_FW_APPEAL_APPROVAL (
        "appealappid" numeric(10),
        "appealid" numeric(10),
        "req_userid" numeric(10),
        "req_date" timestamp,
        "req_comments" varchar(4000),
        "approval_userid" numeric(10),
        "approval_date" timestamp,
        "approval_comments" varchar(4000),
        "status" varchar(1),
        "appeal_result" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_FW_APPEAL_APPROVAL');

    raise notice 'created foreign table for APPEAL_FW_APPEAL_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_FW_APPEAL_APPROVAL;

    -- create table if not exists nios.APPEAL_FW_APPEAL_APPROVAL as select * from nios_foreign.APPEAL_FW_APPEAL_APPROVAL;

    raise notice 'copied table nios.APPEAL_FW_APPEAL_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_FW_APPEAL_APPRO_HIS', 14 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_FW_APPEAL_APPRO_HIS;

    create foreign table if not exists nios_foreign.APPEAL_FW_APPEAL_APPRO_HIS (
        "appealappid" numeric(10),
        "appealid" numeric(10),
        "req_userid" numeric(10),
        "req_date" timestamp,
        "req_comments" varchar(4000),
        "approval_userid" numeric(10),
        "approval_date" timestamp,
        "approval_comments" varchar(4000),
        "status" varchar(1),
        "appeal_result" varchar(1),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_FW_APPEAL_APPRO_HIS');

    raise notice 'created foreign table for APPEAL_FW_APPEAL_APPRO_HIS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_FW_APPEAL_APPRO_HIS;

    -- create table if not exists nios.APPEAL_FW_APPEAL_APPRO_HIS as select * from nios_foreign.APPEAL_FW_APPEAL_APPRO_HIS;

    raise notice 'copied table nios.APPEAL_FW_APPEAL_APPRO_HIS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_PAYMENT', 16 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_PAYMENT;

    create foreign table if not exists nios_foreign.APPEAL_PAYMENT (
        "worker_code" varchar(10),
        "lab_code" varchar(10),
        "lab_amt" numeric(6, 2),
        "lab_inform" char(1),
        "lab_cond" varchar(10),
        "date_reg" timestamp,
        "reg_by" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_PAYMENT');

    raise notice 'created foreign table for APPEAL_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_PAYMENT;

    -- create table if not exists nios.APPEAL_PAYMENT as select * from nios_foreign.APPEAL_PAYMENT;

    raise notice 'copied table nios.APPEAL_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_TODOLIST', 18 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_TODOLIST;

    create foreign table if not exists nios_foreign.APPEAL_TODOLIST (
        "todoid" numeric(10),
        "remark" varchar(500),
        "url" varchar(500)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_TODOLIST');

    raise notice 'created foreign table for APPEAL_TODOLIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_TODOLIST;

    -- create table if not exists nios.APPEAL_TODOLIST as select * from nios_foreign.APPEAL_TODOLIST;

    raise notice 'copied table nios.APPEAL_TODOLIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APPEAL_TODOLIST_MAP', 19 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APPEAL_TODOLIST_MAP;

    create foreign table if not exists nios_foreign.APPEAL_TODOLIST_MAP (
        "parameter_code" varchar(10),
        "todoid" numeric(10),
        "can_appeal" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_TODOLIST_MAP');

    raise notice 'created foreign table for APPEAL_TODOLIST_MAP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APPEAL_TODOLIST_MAP;

    -- create table if not exists nios.APPEAL_TODOLIST_MAP as select * from nios_foreign.APPEAL_TODOLIST_MAP;

    raise notice 'copied table nios.APPEAL_TODOLIST_MAP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APP_AUDIT', 20 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APP_AUDIT;

    create foreign table if not exists nios_foreign.APP_AUDIT (
        "audit_date" timestamp,
        "userid" varchar(30),
        "module_id" varchar(30),
        "audit_details" varchar
    ) server nios_server options (schema 'NIOS1', table 'APP_AUDIT');

    raise notice 'created foreign table for APP_AUDIT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APP_AUDIT;

    -- create table if not exists nios.APP_AUDIT as select * from nios_foreign.APP_AUDIT;

    raise notice 'copied table nios.APP_AUDIT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APP_LOG', 21 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APP_LOG;

    create foreign table if not exists nios_foreign.APP_LOG (
        "log_id" numeric(10),
        "log_date" timestamp,
        "module" varchar(60),
        "action" varchar(300),
        "err#" numeric(6),
        "errm" varchar(250),
        "more1" varchar(1000),
        "more2" varchar(2000),
        "req_id" varchar(16)
    ) server nios_server options (schema 'NIOS1', table 'APP_LOG');

    raise notice 'created foreign table for APP_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APP_LOG;

    -- create table if not exists nios.APP_LOG as select * from nios_foreign.APP_LOG;

    raise notice 'copied table nios.APP_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table APP_MODULE', 22 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.APP_MODULE;

    create foreign table if not exists nios_foreign.APP_MODULE (
        "module_id" varchar(30),
        "description" varchar(80)
    ) server nios_server options (schema 'NIOS1', table 'APP_MODULE');

    raise notice 'created foreign table for APP_MODULE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.APP_MODULE;

    -- create table if not exists nios.APP_MODULE as select * from nios_foreign.APP_MODULE;

    raise notice 'copied table nios.APP_MODULE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table AP_INVOICE_GENERATED', 23 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.AP_INVOICE_GENERATED;

    create foreign table if not exists nios_foreign.AP_INVOICE_GENERATED (
        "creditor_code" varchar(10),
        "trans_id" varchar(14),
        "created_date" timestamp,
        "filename" varchar(100),
        "type" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'AP_INVOICE_GENERATED');

    raise notice 'created foreign table for AP_INVOICE_GENERATED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.AP_INVOICE_GENERATED;

    -- create table if not exists nios.AP_INVOICE_GENERATED as select * from nios_foreign.AP_INVOICE_GENERATED;

    raise notice 'copied table nios.AP_INVOICE_GENERATED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ARCH_FW_COMMENT', 24 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ARCH_FW_COMMENT;

    create foreign table if not exists nios_foreign.ARCH_FW_COMMENT (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_COMMENT');

    raise notice 'created foreign table for ARCH_FW_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ARCH_FW_COMMENT;

    -- create table if not exists nios.ARCH_FW_COMMENT as select * from nios_foreign.ARCH_FW_COMMENT;

    raise notice 'copied table nios.ARCH_FW_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ARCH_FW_DETAIL', 25 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ARCH_FW_DETAIL;

    create foreign table if not exists nios_foreign.ARCH_FW_DETAIL (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_DETAIL');

    raise notice 'created foreign table for ARCH_FW_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ARCH_FW_DETAIL;

    -- create table if not exists nios.ARCH_FW_DETAIL as select * from nios_foreign.ARCH_FW_DETAIL;

    raise notice 'copied table nios.ARCH_FW_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ARCH_FW_EXTRA_COMMENTS', 26 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ARCH_FW_EXTRA_COMMENTS;

    create foreign table if not exists nios_foreign.ARCH_FW_EXTRA_COMMENTS (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "comments" text
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_EXTRA_COMMENTS');

    raise notice 'created foreign table for ARCH_FW_EXTRA_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ARCH_FW_EXTRA_COMMENTS;

    -- create table if not exists nios.ARCH_FW_EXTRA_COMMENTS as select * from nios_foreign.ARCH_FW_EXTRA_COMMENTS;

    raise notice 'copied table nios.ARCH_FW_EXTRA_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ARCH_FW_QUARANTINE_REASON', 27 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ARCH_FW_QUARANTINE_REASON;

    create foreign table if not exists nios_foreign.ARCH_FW_QUARANTINE_REASON (
        "trans_id" varchar(14),
        "reason_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_QUARANTINE_REASON');

    raise notice 'created foreign table for ARCH_FW_QUARANTINE_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ARCH_FW_QUARANTINE_REASON;

    -- create table if not exists nios.ARCH_FW_QUARANTINE_REASON as select * from nios_foreign.ARCH_FW_QUARANTINE_REASON;

    raise notice 'copied table nios.ARCH_FW_QUARANTINE_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ARCH_FW_TRANSACTION', 28 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ARCH_FW_TRANSACTION;

    create foreign table if not exists nios_foreign.ARCH_FW_TRANSACTION (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "laboratory_code" varchar(10),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "org_bit" varchar(1),
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "systolic" varchar(6),
        "diastolic" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "imm_ind" varchar(1),
        "renew_ind" varchar(1),
        "qrtn_ind" varchar(1),
        "imm_send_ind" varchar(1),
        "lab_notdone_ind" varchar(1),
        "xray_notdone_ind" varchar(1),
        "release_date" timestamp,
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "imm_send_date" timestamp,
        "user_id" varchar(30),
        "bc_doctor_code" varchar(13),
        "bc_employer_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "version_no" varchar(10),
        "xray_testdone_date" timestamp,
        "taken_drugs" varchar(1),
        "tcupi_ind" varchar(1),
        "lab_specimen_date" timestamp,
        "last_pms_date" timestamp,
        "worker_consent" varchar(1),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "irr_ind" varchar(1),
        "imr_ind" varchar(1),
        "med_ind" numeric,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_TRANSACTION');

    raise notice 'created foreign table for ARCH_FW_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ARCH_FW_TRANSACTION;

    -- create table if not exists nios.ARCH_FW_TRANSACTION as select * from nios_foreign.ARCH_FW_TRANSACTION;

    raise notice 'copied table nios.ARCH_FW_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BAD_PAYMENT', 29 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BAD_PAYMENT;

    create foreign table if not exists nios_foreign.BAD_PAYMENT (
        "paymentid" numeric(10),
        "bank_code" varchar(8),
        "bank_branch" varchar(100),
        "document_no" varchar(50),
        "document_date" timestamp,
        "contact_name" varchar(50),
        "contact_phone" varchar(25),
        "contact_fax" varchar(25),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "contact_post_code" varchar(10),
        "contact_state_code" varchar(7),
        "contact_district_code" varchar(7),
        "amount" numeric(10, 2),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "version_no" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'BAD_PAYMENT');

    raise notice 'created foreign table for BAD_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BAD_PAYMENT;

    -- create table if not exists nios.BAD_PAYMENT as select * from nios_foreign.BAD_PAYMENT;

    raise notice 'copied table nios.BAD_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BAD_PAYMENT_HISTORY', 30 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BAD_PAYMENT_HISTORY;

    create foreign table if not exists nios_foreign.BAD_PAYMENT_HISTORY (
        "paymentid" numeric(10),
        "bank_code" varchar(8),
        "bank_branch" varchar(100),
        "document_no" varchar(50),
        "document_date" timestamp,
        "contact_name" varchar(50),
        "contact_phone" varchar(25),
        "contact_fax" varchar(25),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "contact_post_code" varchar(10),
        "contact_state_code" varchar(7),
        "contact_district_code" varchar(7),
        "amount" numeric(10, 2),
        "status" varchar(5),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "version_no" varchar(10),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BAD_PAYMENT_HISTORY');

    raise notice 'created foreign table for BAD_PAYMENT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BAD_PAYMENT_HISTORY;

    -- create table if not exists nios.BAD_PAYMENT_HISTORY as select * from nios_foreign.BAD_PAYMENT_HISTORY;

    raise notice 'copied table nios.BAD_PAYMENT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BAD_PAYMENT_REMOVAL_COMMENTS', 31 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BAD_PAYMENT_REMOVAL_COMMENTS;

    create foreign table if not exists nios_foreign.BAD_PAYMENT_REMOVAL_COMMENTS (
        "paymentid" numeric(10),
        "removal_comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BAD_PAYMENT_REMOVAL_COMMENTS');

    raise notice 'created foreign table for BAD_PAYMENT_REMOVAL_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BAD_PAYMENT_REMOVAL_COMMENTS;

    -- create table if not exists nios.BAD_PAYMENT_REMOVAL_COMMENTS as select * from nios_foreign.BAD_PAYMENT_REMOVAL_COMMENTS;

    raise notice 'copied table nios.BAD_PAYMENT_REMOVAL_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BANK_DRAFT_EXPIRY', 32 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BANK_DRAFT_EXPIRY;

    create foreign table if not exists nios_foreign.BANK_DRAFT_EXPIRY (
        "bank_code" varchar(8),
        "valid_days" numeric(20)
    ) server nios_server options (schema 'NIOS1', table 'BANK_DRAFT_EXPIRY');

    raise notice 'created foreign table for BANK_DRAFT_EXPIRY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BANK_DRAFT_EXPIRY;

    -- create table if not exists nios.BANK_DRAFT_EXPIRY as select * from nios_foreign.BANK_DRAFT_EXPIRY;

    raise notice 'copied table nios.BANK_DRAFT_EXPIRY';
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
    -- drop table if exists nios.BANK_MASTER;

    -- create table if not exists nios.BANK_MASTER as select * from nios_foreign.BANK_MASTER;

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

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BARCODE_TRANSACTION', 34 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BARCODE_TRANSACTION;

    create foreign table if not exists nios_foreign.BARCODE_TRANSACTION (
        "barcodetransid" numeric,
        "tranno" varchar(10),
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "status" varchar(5),
        "creator_id" varchar(50),
        "creation_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'BARCODE_TRANSACTION');

    raise notice 'created foreign table for BARCODE_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BARCODE_TRANSACTION;

    -- create table if not exists nios.BARCODE_TRANSACTION as select * from nios_foreign.BARCODE_TRANSACTION;

    raise notice 'copied table nios.BARCODE_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BATCHLAB_GROUP', 35 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BATCHLAB_GROUP;

    create foreign table if not exists nios_foreign.BATCHLAB_GROUP (
        "lab_group" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BATCHLAB_GROUP');

    raise notice 'created foreign table for BATCHLAB_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BATCHLAB_GROUP;

    -- create table if not exists nios.BATCHLAB_GROUP as select * from nios_foreign.BATCHLAB_GROUP;

    raise notice 'copied table nios.BATCHLAB_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BATCHLOG', 36 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BATCHLOG;

    create foreign table if not exists nios_foreign.BATCHLOG (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(100),
        "reason" varchar(4000),
        "module" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'BATCHLOG');

    raise notice 'created foreign table for BATCHLOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BATCHLOG;

    -- create table if not exists nios.BATCHLOG as select * from nios_foreign.BATCHLOG;

    raise notice 'copied table nios.BATCHLOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BATCHUSERS', 37 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BATCHUSERS;

    create foreign table if not exists nios_foreign.BATCHUSERS (
        "usercode" varchar(13),
        "username" varchar(50),
        "userpass" varchar(100),
        "useremail" varchar(50),
        "lastlogindate" timestamp,
        "logoutdate" timestamp,
        "status" varchar(10),
        "ismerts" numeric,
        "usergroup" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'BATCHUSERS');

    raise notice 'created foreign table for BATCHUSERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BATCHUSERS;

    -- create table if not exists nios.BATCHUSERS as select * from nios_foreign.BATCHUSERS;

    raise notice 'copied table nios.BATCHUSERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BATCH_COUPLING_CHANGE', 38 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BATCH_COUPLING_CHANGE;

    create foreign table if not exists nios_foreign.BATCH_COUPLING_CHANGE (
        "batch_transid" varchar(14),
        "bc_doctor_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_xray_code" varchar(13),
        "status" varchar(2),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BATCH_COUPLING_CHANGE');

    raise notice 'created foreign table for BATCH_COUPLING_CHANGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BATCH_COUPLING_CHANGE;

    -- create table if not exists nios.BATCH_COUPLING_CHANGE as select * from nios_foreign.BATCH_COUPLING_CHANGE;

    raise notice 'copied table nios.BATCH_COUPLING_CHANGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BATCH_COUPLING_CHANGE_HISTORY', 39 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BATCH_COUPLING_CHANGE_HISTORY;

    create foreign table if not exists nios_foreign.BATCH_COUPLING_CHANGE_HISTORY (
        "batch_transid" varchar(14),
        "bc_doctor_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_xray_code" varchar(13),
        "status" varchar(2),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BATCH_COUPLING_CHANGE_HISTORY');

    raise notice 'created foreign table for BATCH_COUPLING_CHANGE_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BATCH_COUPLING_CHANGE_HISTORY;

    -- create table if not exists nios.BATCH_COUPLING_CHANGE_HISTORY as select * from nios_foreign.BATCH_COUPLING_CHANGE_HISTORY;

    raise notice 'copied table nios.BATCH_COUPLING_CHANGE_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BRANCHES', 40 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BRANCHES;

    create foreign table if not exists nios_foreign.BRANCHES (
        "branch_code" varchar(2),
        "name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(5),
        "district" varchar(15),
        "state" varchar(15),
        "phone" varchar(100),
        "fax" varchar(100),
        "email" varchar(100),
        "created_by" varchar(10),
        "branch_type" varchar(2),
        "bank_code" varchar(8),
        "bank_co" varchar(50),
        "bank_acctno" varchar(50),
        "bank_zone" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'BRANCHES');

    raise notice 'created foreign table for BRANCHES';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BRANCHES;

    -- create table if not exists nios.BRANCHES as select * from nios_foreign.BRANCHES;

    raise notice 'copied table nios.BRANCHES';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BRANCH_PRINTERS', 41 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BRANCH_PRINTERS;

    create foreign table if not exists nios_foreign.BRANCH_PRINTERS (
        "branch_printerid" numeric(10),
        "branch_code" varchar(2),
        "printer_name" varchar(100),
        "active" char(1)
    ) server nios_server options (schema 'NIOS1', table 'BRANCH_PRINTERS');

    raise notice 'created foreign table for BRANCH_PRINTERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BRANCH_PRINTERS;

    -- create table if not exists nios.BRANCH_PRINTERS as select * from nios_foreign.BRANCH_PRINTERS;

    raise notice 'copied table nios.BRANCH_PRINTERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BULLETIN_ACKNOWLEDGE', 42 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BULLETIN_ACKNOWLEDGE;

    create foreign table if not exists nios_foreign.BULLETIN_ACKNOWLEDGE (
        "bulletinid" numeric(10),
        "usercode" varchar(10),
        "ackdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BULLETIN_ACKNOWLEDGE');

    raise notice 'created foreign table for BULLETIN_ACKNOWLEDGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BULLETIN_ACKNOWLEDGE;

    -- create table if not exists nios.BULLETIN_ACKNOWLEDGE as select * from nios_foreign.BULLETIN_ACKNOWLEDGE;

    raise notice 'copied table nios.BULLETIN_ACKNOWLEDGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BULLETIN_MASTER', 43 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BULLETIN_MASTER;

    create foreign table if not exists nios_foreign.BULLETIN_MASTER (
        "bulletinid" numeric(10),
        "type" char(1),
        "target" char(1),
        "notice_date" timestamp,
        "subject" varchar(250),
        "notice" text,
        "start_date" timestamp,
        "expiry_date" timestamp,
        "acknowledge" char(1),
        "filename" varchar(50),
        "filepath" varchar(250),
        "createby" varchar(13),
        "createdate" timestamp,
        "modifyby" varchar(13),
        "modifydate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BULLETIN_MASTER');

    raise notice 'created foreign table for BULLETIN_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BULLETIN_MASTER;

    -- create table if not exists nios.BULLETIN_MASTER as select * from nios_foreign.BULLETIN_MASTER;

    raise notice 'copied table nios.BULLETIN_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BULLETIN_TARGET', 44 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BULLETIN_TARGET;

    create foreign table if not exists nios_foreign.BULLETIN_TARGET (
        "bulletinid" numeric(10),
        "usercode" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'BULLETIN_TARGET');

    raise notice 'created foreign table for BULLETIN_TARGET';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BULLETIN_TARGET;

    -- create table if not exists nios.BULLETIN_TARGET as select * from nios_foreign.BULLETIN_TARGET;

    raise notice 'copied table nios.BULLETIN_TARGET';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table BYPASS_ERROR', 45 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.BYPASS_ERROR;

    create foreign table if not exists nios_foreign.BYPASS_ERROR (
        "error_desc" varchar(30),
        "error_ind" numeric(2)
    ) server nios_server options (schema 'NIOS1', table 'BYPASS_ERROR');

    raise notice 'created foreign table for BYPASS_ERROR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.BYPASS_ERROR;

    -- create table if not exists nios.BYPASS_ERROR as select * from nios_foreign.BYPASS_ERROR;

    raise notice 'copied table nios.BYPASS_ERROR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CAPABILITY_MASTER', 46 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CAPABILITY_MASTER;

    create foreign table if not exists nios_foreign.CAPABILITY_MASTER (
        "capid" numeric(10),
        "description" varchar(100),
        "category" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "longdesc" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'CAPABILITY_MASTER');

    raise notice 'created foreign table for CAPABILITY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CAPABILITY_MASTER;

    -- create table if not exists nios.CAPABILITY_MASTER as select * from nios_foreign.CAPABILITY_MASTER;

    raise notice 'copied table nios.CAPABILITY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CNG_WORKER_CLINIC', 47 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CNG_WORKER_CLINIC;

    create foreign table if not exists nios_foreign.CNG_WORKER_CLINIC (
        "worker_code" varchar(10),
        "country_code" varchar(3),
        "clinic_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'CNG_WORKER_CLINIC');

    raise notice 'created foreign table for CNG_WORKER_CLINIC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CNG_WORKER_CLINIC;

    -- create table if not exists nios.CNG_WORKER_CLINIC as select * from nios_foreign.CNG_WORKER_CLINIC;

    raise notice 'copied table nios.CNG_WORKER_CLINIC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CODE_M', 48 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CODE_M;

    create foreign table if not exists nios_foreign.CODE_M (
        "req_type" varchar(2),
        "type_ind" varchar(1),
        "state_code" varchar(1),
        "name_first" varchar(1),
        "last_issue_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'CODE_M');

    raise notice 'created foreign table for CODE_M';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CODE_M;

    -- create table if not exists nios.CODE_M as select * from nios_foreign.CODE_M;

    raise notice 'copied table nios.CODE_M';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CODE_MASTER', 49 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CODE_MASTER;

    create foreign table if not exists nios_foreign.CODE_MASTER (
        "req_type" varchar(2),
        "type_ind" varchar(1),
        "state_code" varchar(1),
        "name_first" varchar(1),
        "last_issue_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'CODE_MASTER');

    raise notice 'created foreign table for CODE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CODE_MASTER;

    -- create table if not exists nios.CODE_MASTER as select * from nios_foreign.CODE_MASTER;

    raise notice 'copied table nios.CODE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CODE_STATE_MASTER', 50 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CODE_STATE_MASTER;

    create foreign table if not exists nios_foreign.CODE_STATE_MASTER (
        "state_code" varchar(7),
        "map_code" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'CODE_STATE_MASTER');

    raise notice 'created foreign table for CODE_STATE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CODE_STATE_MASTER;

    -- create table if not exists nios.CODE_STATE_MASTER as select * from nios_foreign.CODE_STATE_MASTER;

    raise notice 'copied table nios.CODE_STATE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CONDITION_MAP', 51 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CONDITION_MAP;

    create foreign table if not exists nios_foreign.CONDITION_MAP (
        "parameter_code" varchar(10),
        "old_parameter_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'CONDITION_MAP');

    raise notice 'created foreign table for CONDITION_MAP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CONDITION_MAP;

    -- create table if not exists nios.CONDITION_MAP as select * from nios_foreign.CONDITION_MAP;

    raise notice 'copied table nios.CONDITION_MAP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CONDITION_MASTER', 52 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CONDITION_MASTER;

    create foreign table if not exists nios_foreign.CONDITION_MASTER (
        "parameter_code" varchar(10),
        "description" varchar(240)
    ) server nios_server options (schema 'NIOS1', table 'CONDITION_MASTER');

    raise notice 'created foreign table for CONDITION_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CONDITION_MASTER;

    -- create table if not exists nios.CONDITION_MASTER as select * from nios_foreign.CONDITION_MASTER;

    raise notice 'copied table nios.CONDITION_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table COUNTRY_MASTER', 53 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.COUNTRY_MASTER;

    create foreign table if not exists nios_foreign.COUNTRY_MASTER (
        "country_code" varchar(3),
        "country_name" varchar(50),
        "sequence" numeric(5)
    ) server nios_server options (schema 'NIOS1', table 'COUNTRY_MASTER');

    raise notice 'created foreign table for COUNTRY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.COUNTRY_MASTER;

    -- create table if not exists nios.COUNTRY_MASTER as select * from nios_foreign.COUNTRY_MASTER;

    raise notice 'copied table nios.COUNTRY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table COUPLING_TRANS', 54 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.COUPLING_TRANS;

    create foreign table if not exists nios_foreign.COUPLING_TRANS (
        "bc_doctor_code" varchar(13),
        "bc_old_laboratory_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_old_xray_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_old_radiologist_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "transdate" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'COUPLING_TRANS');

    raise notice 'created foreign table for COUPLING_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.COUPLING_TRANS;

    -- create table if not exists nios.COUPLING_TRANS as select * from nios_foreign.COUPLING_TRANS;

    raise notice 'copied table nios.COUPLING_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table CUSTOMER_COMPLAINT', 55 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.CUSTOMER_COMPLAINT;

    create foreign table if not exists nios_foreign.CUSTOMER_COMPLAINT (
        "complaint_id" numeric(10),
        "complaint_by" varchar(100),
        "complaint_code" varchar(13),
        "complaint_type" varchar(1),
        "complaint_against" varchar(100),
        "complaint_against_code" varchar(13),
        "complaint_against_type" varchar(1),
        "complaint_date" timestamp,
        "complaint_content" varchar(2000),
        "assigned_to" varchar(100),
        "resolution_remarks" varchar(2000),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'CUSTOMER_COMPLAINT');

    raise notice 'created foreign table for CUSTOMER_COMPLAINT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.CUSTOMER_COMPLAINT;

    -- create table if not exists nios.CUSTOMER_COMPLAINT as select * from nios_foreign.CUSTOMER_COMPLAINT;

    raise notice 'copied table nios.CUSTOMER_COMPLAINT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DELAY_TRANS', 56 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DELAY_TRANS;

    create foreign table if not exists nios_foreign.DELAY_TRANS (
        "doctor_code" varchar(10),
        "worker_code" varchar(10),
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DELAY_TRANS');

    raise notice 'created foreign table for DELAY_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DELAY_TRANS;

    -- create table if not exists nios.DELAY_TRANS as select * from nios_foreign.DELAY_TRANS;

    raise notice 'copied table nios.DELAY_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DIFF_RH', 57 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DIFF_RH;

    create foreign table if not exists nios_foreign.DIFF_RH (
        "tranno" varchar(10),
        "oldtranno" varchar(10),
        "branch_code" varchar(2),
        "service_type" varchar(2),
        "trandate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DIFF_RH');

    raise notice 'created foreign table for DIFF_RH';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DIFF_RH;

    -- create table if not exists nios.DIFF_RH as select * from nios_foreign.DIFF_RH;

    raise notice 'copied table nios.DIFF_RH';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DISCRP_TAB', 58 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DISCRP_TAB;

    create foreign table if not exists nios_foreign.DISCRP_TAB (
        "ftype" varchar(1),
        "scandir" varchar(2),
        "fcode" varchar(10),
        "ecode" varchar(2),
        "a_loc" varchar(1),
        "a_fcode" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'DISCRP_TAB');

    raise notice 'created foreign table for DISCRP_TAB';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DISCRP_TAB;

    -- create table if not exists nios.DISCRP_TAB as select * from nios_foreign.DISCRP_TAB;

    raise notice 'copied table nios.DISCRP_TAB';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DISTRICT_MAP', 59 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DISTRICT_MAP;

    create foreign table if not exists nios_foreign.DISTRICT_MAP (
        "district_map_code" varchar(7),
        "district_map_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'DISTRICT_MAP');

    raise notice 'created foreign table for DISTRICT_MAP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DISTRICT_MAP;

    -- create table if not exists nios.DISTRICT_MAP as select * from nios_foreign.DISTRICT_MAP;

    raise notice 'copied table nios.DISTRICT_MAP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DISTRICT_MASTER', 60 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DISTRICT_MASTER;

    create foreign table if not exists nios_foreign.DISTRICT_MASTER (
        "district_code" varchar(7),
        "district_name" varchar(40),
        "country_code" varchar(3),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'DISTRICT_MASTER');

    raise notice 'created foreign table for DISTRICT_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DISTRICT_MASTER;

    -- create table if not exists nios.DISTRICT_MASTER as select * from nios_foreign.DISTRICT_MASTER;

    raise notice 'copied table nios.DISTRICT_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DISTRICT_OFFICE', 61 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DISTRICT_OFFICE;

    create foreign table if not exists nios_foreign.DISTRICT_OFFICE (
        "office_code" varchar(7),
        "office_name" varchar(255),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "status_code" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DISTRICT_OFFICE');

    raise notice 'created foreign table for DISTRICT_OFFICE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DISTRICT_OFFICE;

    -- create table if not exists nios.DISTRICT_OFFICE as select * from nios_foreign.DISTRICT_OFFICE;

    raise notice 'copied table nios.DISTRICT_OFFICE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DISTRICT_OFFICE_HISTORY', 62 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DISTRICT_OFFICE_HISTORY;

    create foreign table if not exists nios_foreign.DISTRICT_OFFICE_HISTORY (
        "office_code" varchar(7),
        "office_name" varchar(255),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "status_code" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "log_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DISTRICT_OFFICE_HISTORY');

    raise notice 'created foreign table for DISTRICT_OFFICE_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DISTRICT_OFFICE_HISTORY;

    -- create table if not exists nios.DISTRICT_OFFICE_HISTORY as select * from nios_foreign.DISTRICT_OFFICE_HISTORY;

    raise notice 'copied table nios.DISTRICT_OFFICE_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_CHANGE_REQUEST', 63 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_CHANGE_REQUEST;

    create foreign table if not exists nios_foreign.DOCTOR_CHANGE_REQUEST (
        "dm_cr_id" numeric(10),
        "doctor_code" varchar(10),
        "request_date" timestamp,
        "status" varchar(20),
        "mclx_date" timestamp,
        "mclx_appxray" varchar(10),
        "approvedby" numeric(10),
        "approved_date" timestamp,
        "approved_comment" varchar(1000),
        "createby" numeric(10),
        "createdate" timestamp,
        "modifyby" numeric(10),
        "modifydate" timestamp,
        "require_mclx" varchar(1),
        "report_printed" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_CHANGE_REQUEST');

    raise notice 'created foreign table for DOCTOR_CHANGE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_CHANGE_REQUEST;

    -- create table if not exists nios.DOCTOR_CHANGE_REQUEST as select * from nios_foreign.DOCTOR_CHANGE_REQUEST;

    raise notice 'copied table nios.DOCTOR_CHANGE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_CHANGE_REQUEST_DETAIL', 64 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_CHANGE_REQUEST_DETAIL;

    create foreign table if not exists nios_foreign.DOCTOR_CHANGE_REQUEST_DETAIL (
        "dm_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_CHANGE_REQUEST_DETAIL');

    raise notice 'created foreign table for DOCTOR_CHANGE_REQUEST_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_CHANGE_REQUEST_DETAIL;

    -- create table if not exists nios.DOCTOR_CHANGE_REQUEST_DETAIL as select * from nios_foreign.DOCTOR_CHANGE_REQUEST_DETAIL;

    raise notice 'copied table nios.DOCTOR_CHANGE_REQUEST_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_HISTORY', 65 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_HISTORY;

    create foreign table if not exists nios_foreign.DOCTOR_HISTORY (
        "doctor_code" varchar(10),
        "version_no" varchar(10),
        "creation_date" timestamp,
        "doctor_name" varchar(50),
        "clinic_name" varchar(100),
        "doctor_ic_new" varchar(20),
        "doctor_ic_old" varchar(20),
        "annual_practice_certificate" varchar(20),
        "application_number" varchar(7),
        "application_year" varchar(4),
        "kdm_member" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "phone" varchar(100),
        "fax" varchar(100),
        "xray_code" varchar(10),
        "radiologist_code" varchar(10),
        "laboratory_code" varchar(10),
        "email_id" varchar(100),
        "xray_regn_no" varchar(20),
        "own_xray_clinic" varchar(1),
        "qualification" varchar(50),
        "no_of_solo_clinics" varchar(2),
        "no_of_group_clinics" varchar(2),
        "comments" varchar(4000),
        "numquarantine" numeric(4),
        "district_name" varchar(40),
        "modification_date" timestamp,
        "bc_doctor_code" varchar(13),
        "status_code" varchar(5),
        "quota" numeric(5),
        "quota_use" numeric(5),
        "nearest_district_office" varchar(7),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "isproblematic" varchar(2),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "prefer_xray_code" varchar(13),
        "prefer_xray_distance" varchar(10),
        "dregid" numeric(10),
        "action" varchar(10),
        "action_date" timestamp,
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "bank_code" varchar(8),
        "gst_type" numeric(1),
        "mystics_ic" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_HISTORY');

    raise notice 'created foreign table for DOCTOR_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_HISTORY;

    -- create table if not exists nios.DOCTOR_HISTORY as select * from nios_foreign.DOCTOR_HISTORY;

    raise notice 'copied table nios.DOCTOR_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_LOAD_6P', 66 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_LOAD_6P;

    create foreign table if not exists nios_foreign.DOCTOR_LOAD_6P (
        "doctor_code" varchar(10),
        "quota" numeric(10),
        "quota_use" numeric(5),
        "allocation" numeric(10),
        "allocation_use" numeric(10),
        "no_exam" numeric(10),
        "load" numeric(10),
        "action_date" timestamp,
        "dist_code" varchar(5),
        "state_code" varchar(5),
        "bal_quota" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_LOAD_6P');

    raise notice 'created foreign table for DOCTOR_LOAD_6P';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_LOAD_6P;

    -- create table if not exists nios.DOCTOR_LOAD_6P as select * from nios_foreign.DOCTOR_LOAD_6P;

    raise notice 'copied table nios.DOCTOR_LOAD_6P';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_MASTER', 67 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_MASTER;

    create foreign table if not exists nios_foreign.DOCTOR_MASTER (
        "doctor_code" varchar(10),
        "doctor_name" varchar(50),
        "clinic_name" varchar(100),
        "creation_date" timestamp,
        "doctor_ic_new" varchar(20),
        "doctor_ic_old" varchar(20),
        "annual_practice_certificate" varchar(20),
        "application_number" varchar(7),
        "application_year" varchar(4),
        "kdm_member" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "laboratory_code" varchar(10),
        "email_id" varchar(100),
        "xray_regn_no" varchar(20),
        "version_no" varchar(10),
        "own_xray_clinic" varchar(1),
        "qualification" varchar(50),
        "no_of_solo_clinics" varchar(2),
        "no_of_group_clinics" varchar(2),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "numquarantine" numeric(4),
        "bc_doctor_code" varchar(13),
        "quota" numeric(10),
        "quota_use" numeric(5),
        "nearest_district_office" varchar(7),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "isproblematic" varchar(2),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "prefer_xray_code" varchar(13),
        "prefer_xray_distance" varchar(10),
        "dregid" numeric(10),
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "mystics_ic" numeric,
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "fp_device" numeric(1),
        "device_install" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_MASTER');

    raise notice 'created foreign table for DOCTOR_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_MASTER;

    -- create table if not exists nios.DOCTOR_MASTER as select * from nios_foreign.DOCTOR_MASTER;

    raise notice 'copied table nios.DOCTOR_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_OPTHOUR', 68 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_OPTHOUR;

    create foreign table if not exists nios_foreign.DOCTOR_OPTHOUR (
        "usercode" varchar(13),
        "monday_start" timestamp,
        "monday_end" timestamp,
        "monday_isclose" char(1),
        "monday_is24" char(1),
        "monday_break" varchar(255),
        "tuesday_start" timestamp,
        "tuesday_end" timestamp,
        "tuesday_isclose" char(1),
        "tuesday_is24" char(1),
        "tuesday_break" varchar(255),
        "wednesday_start" timestamp,
        "wednesday_end" timestamp,
        "wednesday_isclose" char(1),
        "wednesday_is24" char(1),
        "wednesday_break" varchar(255),
        "thursday_start" timestamp,
        "thursday_end" timestamp,
        "thursday_isclose" char(1),
        "thursday_is24" char(1),
        "thursday_break" varchar(255),
        "friday_start" timestamp,
        "friday_end" timestamp,
        "friday_isclose" char(1),
        "friday_is24" char(1),
        "friday_break" varchar(255),
        "saturday_start" timestamp,
        "saturday_end" timestamp,
        "saturday_isclose" char(1),
        "saturday_is24" char(1),
        "saturday_break" varchar(255),
        "sunday_start" timestamp,
        "sunday_end" timestamp,
        "sunday_isclose" char(1),
        "sunday_is24" char(1),
        "sunday_break" varchar(255),
        "pubhol_start" timestamp,
        "pubhol_end" timestamp,
        "pubhol_isclose" char(1),
        "pubhol_is24" char(1),
        "pubhol_break" varchar(255),
        "close_remark" varchar(255),
        "modified" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_OPTHOUR');

    raise notice 'created foreign table for DOCTOR_OPTHOUR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_OPTHOUR;

    -- create table if not exists nios.DOCTOR_OPTHOUR as select * from nios_foreign.DOCTOR_OPTHOUR;

    raise notice 'copied table nios.DOCTOR_OPTHOUR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_OPTHOUR_CHANGELOG', 69 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_OPTHOUR_CHANGELOG;

    create foreign table if not exists nios_foreign.DOCTOR_OPTHOUR_CHANGELOG (
        "opt_changelog_cr_id" numeric(10),
        "usercode" varchar(20),
        "modifiedby" varchar(20),
        "modify_date" timestamp,
        "type" varchar(1),
        "bulletinid" numeric,
        "dismiss" varchar(1),
        "dismiss_by" numeric,
        "dismiss_date" timestamp,
        "remark" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_OPTHOUR_CHANGELOG');

    raise notice 'created foreign table for DOCTOR_OPTHOUR_CHANGELOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_OPTHOUR_CHANGELOG;

    -- create table if not exists nios.DOCTOR_OPTHOUR_CHANGELOG as select * from nios_foreign.DOCTOR_OPTHOUR_CHANGELOG;

    raise notice 'copied table nios.DOCTOR_OPTHOUR_CHANGELOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_PARAMETER_MASTER', 70 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_PARAMETER_MASTER;

    create foreign table if not exists nios_foreign.DOCTOR_PARAMETER_MASTER (
        "parameter_code" varchar(10),
        "description" varchar(50),
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_PARAMETER_MASTER');

    raise notice 'created foreign table for DOCTOR_PARAMETER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_PARAMETER_MASTER;

    -- create table if not exists nios.DOCTOR_PARAMETER_MASTER as select * from nios_foreign.DOCTOR_PARAMETER_MASTER;

    raise notice 'copied table nios.DOCTOR_PARAMETER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_QUOTA_TRANS', 71 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_QUOTA_TRANS;

    create foreign table if not exists nios_foreign.DOCTOR_QUOTA_TRANS (
        "trans_date" timestamp,
        "doctor_code" varchar(10),
        "old_quota" numeric,
        "new_quota" numeric,
        "decision_date" timestamp,
        "userid" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_QUOTA_TRANS');

    raise notice 'created foreign table for DOCTOR_QUOTA_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_QUOTA_TRANS;

    -- create table if not exists nios.DOCTOR_QUOTA_TRANS as select * from nios_foreign.DOCTOR_QUOTA_TRANS;

    raise notice 'copied table nios.DOCTOR_QUOTA_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_REGISTRATION', 72 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_REGISTRATION;

    create foreign table if not exists nios_foreign.DOCTOR_REGISTRATION (
        "dregid" numeric(10),
        "doctor_name" varchar(50),
        "clinic_name" varchar(50),
        "doctor_ic_new" varchar(20),
        "doctor_ic_old" varchar(20),
        "application_number" varchar(20),
        "application_year" varchar(4),
        "kdm_member" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "xray_regn_no" varchar(20),
        "own_xray_clinic" varchar(1),
        "qualification" varchar(50),
        "no_of_solo_clinics" varchar(2),
        "no_of_group_clinics" varchar(2),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "prefer_xray_code" varchar(13),
        "prefer_xray_distance" varchar(10),
        "quota" numeric(5),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "nearest_district_office" varchar(7),
        "rcm_xray_code1" varchar(13),
        "rcm_xray_code2" varchar(13),
        "rcm_xray_code3" varchar(13),
        "tranno" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_REGISTRATION');

    raise notice 'created foreign table for DOCTOR_REGISTRATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_REGISTRATION;

    -- create table if not exists nios.DOCTOR_REGISTRATION as select * from nios_foreign.DOCTOR_REGISTRATION;

    raise notice 'copied table nios.DOCTOR_REGISTRATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_REQUEST', 73 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_REQUEST;

    create foreign table if not exists nios_foreign.DOCTOR_REQUEST (
        "dregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_REQUEST');

    raise notice 'created foreign table for DOCTOR_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_REQUEST;

    -- create table if not exists nios.DOCTOR_REQUEST as select * from nios_foreign.DOCTOR_REQUEST;

    raise notice 'copied table nios.DOCTOR_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOCTOR_STATUS_ENQUIRY', 74 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOCTOR_STATUS_ENQUIRY;

    create foreign table if not exists nios_foreign.DOCTOR_STATUS_ENQUIRY (
        "bc_doctor_code" varchar(10),
        "reserved_quota" numeric(10),
        "pend_exam_less_5" numeric(10),
        "pend_exam_greater_5" numeric(10),
        "pend_cert_less_4" numeric(10),
        "pend_cert_greater_4" numeric(10),
        "pend_xray_less_5" numeric(10),
        "pend_xray_greater_5" numeric(10),
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_STATUS_ENQUIRY');

    raise notice 'created foreign table for DOCTOR_STATUS_ENQUIRY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOCTOR_STATUS_ENQUIRY;

    -- create table if not exists nios.DOCTOR_STATUS_ENQUIRY as select * from nios_foreign.DOCTOR_STATUS_ENQUIRY;

    raise notice 'copied table nios.DOCTOR_STATUS_ENQUIRY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOC_COMPARE', 75 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOC_COMPARE;

    create foreign table if not exists nios_foreign.DOC_COMPARE (
        "doctor_code" varchar(10),
        "old_doctor_name" varchar(50),
        "old_doctor_regn_no" varchar(20),
        "old_radiologist_code" varchar(10),
        "old_xray_code" varchar(10),
        "old_laboratory_code" varchar(10),
        "new_doctor_name" varchar(50),
        "new_doctor_regn_no" varchar(20),
        "new_radiologist_code" varchar(10),
        "new_xray_code" varchar(10),
        "new_laboratory_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_COMPARE');

    raise notice 'created foreign table for DOC_COMPARE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOC_COMPARE;

    -- create table if not exists nios.DOC_COMPARE as select * from nios_foreign.DOC_COMPARE;

    raise notice 'copied table nios.DOC_COMPARE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOC_LAB_ALLOCATION', 76 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOC_LAB_ALLOCATION;

    create foreign table if not exists nios_foreign.DOC_LAB_ALLOCATION (
        "doctor_code" varchar(10),
        "old_lab" varchar(10),
        "new_lab" varchar(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_LAB_ALLOCATION');

    raise notice 'created foreign table for DOC_LAB_ALLOCATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOC_LAB_ALLOCATION;

    -- create table if not exists nios.DOC_LAB_ALLOCATION as select * from nios_foreign.DOC_LAB_ALLOCATION;

    raise notice 'copied table nios.DOC_LAB_ALLOCATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOC_QUOTA_ALLOCATION', 77 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOC_QUOTA_ALLOCATION;

    create foreign table if not exists nios_foreign.DOC_QUOTA_ALLOCATION (
        "doctor_code" varchar(10),
        "old_quota" numeric(10),
        "new_quota" numeric(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_QUOTA_ALLOCATION');

    raise notice 'created foreign table for DOC_QUOTA_ALLOCATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOC_QUOTA_ALLOCATION;

    -- create table if not exists nios.DOC_QUOTA_ALLOCATION as select * from nios_foreign.DOC_QUOTA_ALLOCATION;

    raise notice 'copied table nios.DOC_QUOTA_ALLOCATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOC_STATUS', 78 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOC_STATUS;

    create foreign table if not exists nios_foreign.DOC_STATUS (
        "action_date" timestamp,
        "doctor_code" varchar(10),
        "status" varchar(3),
        "reason" varchar(200),
        "date_susp" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOC_STATUS');

    raise notice 'created foreign table for DOC_STATUS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOC_STATUS;

    -- create table if not exists nios.DOC_STATUS as select * from nios_foreign.DOC_STATUS;

    raise notice 'copied table nios.DOC_STATUS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DOC_XRAY_ALLOCATION', 79 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DOC_XRAY_ALLOCATION;

    create foreign table if not exists nios_foreign.DOC_XRAY_ALLOCATION (
        "doctor_code" varchar(10),
        "old_xray" varchar(10),
        "new_xray" varchar(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_XRAY_ALLOCATION');

    raise notice 'created foreign table for DOC_XRAY_ALLOCATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DOC_XRAY_ALLOCATION;

    -- create table if not exists nios.DOC_XRAY_ALLOCATION as select * from nios_foreign.DOC_XRAY_ALLOCATION;

    raise notice 'copied table nios.DOC_XRAY_ALLOCATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DRAFT_ALLOCATION', 80 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DRAFT_ALLOCATION;

    create foreign table if not exists nios_foreign.DRAFT_ALLOCATION (
        "id" numeric(19),
        "version" numeric(19),
        "allocation_amount" numeric(126),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_master_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(126),
        "invoice_no" varchar(40),
        "process_fee" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'DRAFT_ALLOCATION');

    raise notice 'created foreign table for DRAFT_ALLOCATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DRAFT_ALLOCATION;

    -- create table if not exists nios.DRAFT_ALLOCATION as select * from nios_foreign.DRAFT_ALLOCATION;

    raise notice 'copied table nios.DRAFT_ALLOCATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DRAFT_MASTER', 81 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DRAFT_MASTER;

    create foreign table if not exists nios_foreign.DRAFT_MASTER (
        "id" numeric(19),
        "version" numeric(19),
        "approval_code" varchar(80),
        "bank_area" varchar(400),
        "bank_code" varchar(32),
        "branch_code" varchar(8),
        "card_type" varchar(80),
        "collection_status" varchar(1020),
        "collection_uuid" varchar(1020),
        "comments" varchar(2000),
        "contact_address1" varchar(200),
        "contact_address2" varchar(200),
        "contact_address3" varchar(200),
        "contact_address4" varchar(200),
        "contact_district_code" varchar(28),
        "contact_fax" varchar(400),
        "contact_name" varchar(200),
        "contact_phone" varchar(400),
        "contact_post_code" varchar(28),
        "contact_state_code" varchar(28),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "date_issue" timestamp,
        "draft_type" numeric(10),
        "expiry_date" timestamp,
        "invoice_batch" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "name_on_card" varchar(400),
        "payment_amount" numeric(126),
        "payment_no" varchar(64),
        "payment_surcharge" numeric(126),
        "payment_type" numeric(10),
        "receipt_payment_no" varchar(64),
        "receipt_payment_type" numeric(10),
        "receipt_tranno" varchar(40),
        "ref_no" varchar(200),
        "replacement_draft_id" numeric(19),
        "status" numeric(10),
        "tranno" varchar(40),
        "transdate" timestamp,
        "voided_reason" varchar(1020),
        "zone_code" varchar(8),
        "source" numeric(10),
        "collection_cn_status" numeric,
        "collection_date" timestamp,
        "voided_date" timestamp,
        "gst_amount" numeric(126),
        "gst_percentage" numeric(126),
        "employer_alloc_master_id" numeric(19),
        "ap_invoice_no" varchar(255),
        "ap_group_id" numeric(19),
        "other_amount" numeric(126),
        "other_amount_gst" numeric(126),
        "process_fee" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'DRAFT_MASTER');

    raise notice 'created foreign table for DRAFT_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DRAFT_MASTER;

    -- create table if not exists nios.DRAFT_MASTER as select * from nios_foreign.DRAFT_MASTER;

    raise notice 'copied table nios.DRAFT_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DRAFT_USAGE', 82 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DRAFT_USAGE;

    create foreign table if not exists nios_foreign.DRAFT_USAGE (
        "id" numeric(19),
        "version" numeric(19),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_master_id" numeric(19),
        "employer_code" varchar(40),
        "status" numeric(10),
        "trans_id" varchar(56),
        "utilise_amount" numeric(126),
        "worker_code" varchar(40),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'DRAFT_USAGE');

    raise notice 'created foreign table for DRAFT_USAGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DRAFT_USAGE;

    -- create table if not exists nios.DRAFT_USAGE as select * from nios_foreign.DRAFT_USAGE;

    raise notice 'copied table nios.DRAFT_USAGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DUP_REC', 83 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DUP_REC;

    create foreign table if not exists nios_foreign.DUP_REC (
        "payment_no" varchar(10),
        "count" numeric
    ) server nios_server options (schema 'NIOS1', table 'DUP_REC');

    raise notice 'created foreign table for DUP_REC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DUP_REC;

    -- create table if not exists nios.DUP_REC as select * from nios_foreign.DUP_REC;

    raise notice 'copied table nios.DUP_REC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXBASKET', 84 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXBASKET;

    create foreign table if not exists nios_foreign.DXBASKET (
        "id" numeric(19),
        "version" numeric(19),
        "status" varchar(40),
        "submit_date" timestamp,
        "trans_id" varchar(56),
        "xray_code" varchar(40),
        "pickup_date" timestamp,
        "batch_id" numeric(10),
        "source_ref" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DXBASKET');

    raise notice 'created foreign table for DXBASKET';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXBASKET;

    -- create table if not exists nios.DXBASKET as select * from nios_foreign.DXBASKET;

    raise notice 'copied table nios.DXBASKET';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXFILM_AUDIT', 85 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXFILM_AUDIT;

    create foreign table if not exists nios_foreign.DXFILM_AUDIT (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(4000),
        "create_date" timestamp,
        "creator_id" varchar(200),
        "film_auditid" numeric(10),
        "modifier_id" varchar(200),
        "modify_date" timestamp,
        "ref_transid" varchar(56),
        "trans_id" varchar(56),
        "worker_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'DXFILM_AUDIT');

    raise notice 'created foreign table for DXFILM_AUDIT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXFILM_AUDIT;

    -- create table if not exists nios.DXFILM_AUDIT as select * from nios_foreign.DXFILM_AUDIT;

    raise notice 'copied table nios.DXFILM_AUDIT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXFILM_MOVEMENT', 86 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXFILM_MOVEMENT;

    create foreign table if not exists nios_foreign.DXFILM_MOVEMENT (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(500),
        "status" varchar(20),
        "status_date" timestamp,
        "trans_id" varchar(14),
        "uuid" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'DXFILM_MOVEMENT');

    raise notice 'created foreign table for DXFILM_MOVEMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXFILM_MOVEMENT;

    -- create table if not exists nios.DXFILM_MOVEMENT as select * from nios_foreign.DXFILM_MOVEMENT;

    raise notice 'copied table nios.DXFILM_MOVEMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPCR_AUDIT_COMMENT', 87 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPCR_AUDIT_COMMENT;

    create foreign table if not exists nios_foreign.DXPCR_AUDIT_COMMENT (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(2000),
        "parameter_code" varchar(20),
        "pcr_audit_film_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_AUDIT_COMMENT');

    raise notice 'created foreign table for DXPCR_AUDIT_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPCR_AUDIT_COMMENT;

    -- create table if not exists nios.DXPCR_AUDIT_COMMENT as select * from nios_foreign.DXPCR_AUDIT_COMMENT;

    raise notice 'copied table nios.DXPCR_AUDIT_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPCR_AUDIT_DETAIL', 88 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPCR_AUDIT_DETAIL;

    create foreign table if not exists nios_foreign.DXPCR_AUDIT_DETAIL (
        "id" numeric(19),
        "version" numeric(19),
        "parameter_code" varchar(20),
        "parameter_value" varchar(8),
        "pcr_audit_film_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_AUDIT_DETAIL');

    raise notice 'created foreign table for DXPCR_AUDIT_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPCR_AUDIT_DETAIL;

    -- create table if not exists nios.DXPCR_AUDIT_DETAIL as select * from nios_foreign.DXPCR_AUDIT_DETAIL;

    raise notice 'copied table nios.DXPCR_AUDIT_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPCR_AUDIT_FILM', 89 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPCR_AUDIT_FILM;

    create foreign table if not exists nios_foreign.DXPCR_AUDIT_FILM (
        "id" numeric(19),
        "version" numeric(19),
        "audit_date" timestamp,
        "create_date" timestamp,
        "creator_id" numeric(10),
        "modify_date" timestamp,
        "modify_id" numeric(10),
        "pcr_code" varchar(40),
        "review_film_id" numeric(19),
        "trans_id" varchar(56),
        "worker_code" varchar(40),
        "xray_code" varchar(40),
        "retake_source" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_AUDIT_FILM');

    raise notice 'created foreign table for DXPCR_AUDIT_FILM';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPCR_AUDIT_FILM;

    -- create table if not exists nios.DXPCR_AUDIT_FILM as select * from nios_foreign.DXPCR_AUDIT_FILM;

    raise notice 'copied table nios.DXPCR_AUDIT_FILM';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPCR_POOL', 90 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPCR_POOL;

    create foreign table if not exists nios_foreign.DXPCR_POOL (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" varchar(40),
        "modify_date" timestamp,
        "modify_id" varchar(40),
        "pcr_code" varchar(40),
        "process_status" varchar(4),
        "review_film_id" numeric(19),
        "status" varchar(1020),
        "trans_id" varchar(56),
        "radiologist_code" varchar(40),
        "source_ref" numeric(1),
        "audit_film_id" numeric(19),
        "retake_source" numeric(1),
        "retake_request" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_POOL');

    raise notice 'created foreign table for DXPCR_POOL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPCR_POOL;

    -- create table if not exists nios.DXPCR_POOL as select * from nios_foreign.DXPCR_POOL;

    raise notice 'copied table nios.DXPCR_POOL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPCR_RETAKE_REASONS', 91 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPCR_RETAKE_REASONS;

    create foreign table if not exists nios_foreign.DXPCR_RETAKE_REASONS (
        "id" varchar(20),
        "description" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_RETAKE_REASONS');

    raise notice 'created foreign table for DXPCR_RETAKE_REASONS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPCR_RETAKE_REASONS;

    -- create table if not exists nios.DXPCR_RETAKE_REASONS as select * from nios_foreign.DXPCR_RETAKE_REASONS;

    raise notice 'copied table nios.DXPCR_RETAKE_REASONS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXPROVIDER_MASTER', 92 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXPROVIDER_MASTER;

    create foreign table if not exists nios_foreign.DXPROVIDER_MASTER (
        "provider_id" varchar(3),
        "provider_name" varchar(20),
        "passphrase" varchar(20),
        "provider_url" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'DXPROVIDER_MASTER');

    raise notice 'created foreign table for DXPROVIDER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXPROVIDER_MASTER;

    -- create table if not exists nios.DXPROVIDER_MASTER as select * from nios_foreign.DXPROVIDER_MASTER;

    raise notice 'copied table nios.DXPROVIDER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXREVIEW_FILM', 93 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXREVIEW_FILM;

    create foreign table if not exists nios_foreign.DXREVIEW_FILM (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "modify_date" timestamp,
        "modify_id" numeric(10),
        "status" varchar(40),
        "trans_id" varchar(56),
        "worker_code" varchar(1020),
        "xray_code" varchar(40),
        "review_date" timestamp,
        "batch_id" numeric(10),
        "radiographer_id" numeric(10),
        "iqa_date" timestamp,
        "pcr_date" timestamp,
        "iqa_process_by" numeric(10),
        "autorelease" numeric(1),
        "autorelease_iqa" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM');

    raise notice 'created foreign table for DXREVIEW_FILM';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXREVIEW_FILM;

    -- create table if not exists nios.DXREVIEW_FILM as select * from nios_foreign.DXREVIEW_FILM;

    raise notice 'copied table nios.DXREVIEW_FILM';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXREVIEW_FILM_COMMENT', 94 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXREVIEW_FILM_COMMENT;

    create foreign table if not exists nios_foreign.DXREVIEW_FILM_COMMENT (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(2000),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "dxry_id" numeric(19),
        "modify_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_COMMENT');

    raise notice 'created foreign table for DXREVIEW_FILM_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXREVIEW_FILM_COMMENT;

    -- create table if not exists nios.DXREVIEW_FILM_COMMENT as select * from nios_foreign.DXREVIEW_FILM_COMMENT;

    raise notice 'copied table nios.DXREVIEW_FILM_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXREVIEW_FILM_DETAIL', 95 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXREVIEW_FILM_DETAIL;

    create foreign table if not exists nios_foreign.DXREVIEW_FILM_DETAIL (
        "id" numeric(19),
        "version" numeric(19),
        "dxry_id" numeric(19),
        "parameter_code" varchar(20),
        "parameter_value" varchar(8)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_DETAIL');

    raise notice 'created foreign table for DXREVIEW_FILM_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXREVIEW_FILM_DETAIL;

    -- create table if not exists nios.DXREVIEW_FILM_DETAIL as select * from nios_foreign.DXREVIEW_FILM_DETAIL;

    raise notice 'copied table nios.DXREVIEW_FILM_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXREVIEW_FILM_IDENTICAL', 96 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXREVIEW_FILM_IDENTICAL;

    create foreign table if not exists nios_foreign.DXREVIEW_FILM_IDENTICAL (
        "id" numeric(19),
        "version" numeric(19),
        "dxry_id" numeric(19),
        "trans_id" varchar(56),
        "worker_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_IDENTICAL');

    raise notice 'created foreign table for DXREVIEW_FILM_IDENTICAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXREVIEW_FILM_IDENTICAL;

    -- create table if not exists nios.DXREVIEW_FILM_IDENTICAL as select * from nios_foreign.DXREVIEW_FILM_IDENTICAL;

    raise notice 'copied table nios.DXREVIEW_FILM_IDENTICAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DXXRAY_AUDIT', 97 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DXXRAY_AUDIT;

    create foreign table if not exists nios_foreign.DXXRAY_AUDIT (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(2000),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "modify_date" timestamp,
        "modify_id" numeric(10),
        "ref_trans_id" varchar(56),
        "trans_id" varchar(56),
        "worker_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'DXXRAY_AUDIT');

    raise notice 'created foreign table for DXXRAY_AUDIT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DXXRAY_AUDIT;

    -- create table if not exists nios.DXXRAY_AUDIT as select * from nios_foreign.DXXRAY_AUDIT;

    raise notice 'copied table nios.DXXRAY_AUDIT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table DX_PAYBLOCK', 98 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.DX_PAYBLOCK;

    create foreign table if not exists nios_foreign.DX_PAYBLOCK (
        "doc_xray_code" varchar(10),
        "doc_xray_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'DX_PAYBLOCK');

    raise notice 'created foreign table for DX_PAYBLOCK';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.DX_PAYBLOCK;

    -- create table if not exists nios.DX_PAYBLOCK as select * from nios_foreign.DX_PAYBLOCK;

    raise notice 'copied table nios.DX_PAYBLOCK';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_ACCOUNT', 99 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_ACCOUNT;

    create foreign table if not exists nios_foreign.EMPLOYER_ACCOUNT (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_id" numeric(19),
        "draft_allocation_id" numeric(19),
        "draft_usage_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(126),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "type" numeric(10),
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "branch_code" varchar(2),
        "description" varchar(4000),
        "sex" varchar(1),
        "ap_group_id" numeric(19),
        "ap_id" numeric(19),
        "refund_id" numeric(19),
        "portal_batchid" numeric(10),
        "other_amount" numeric(126),
        "other_amount_gst" numeric(126),
        "gst_tax" numeric,
        "process_fee" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_ACCOUNT');

    raise notice 'created foreign table for EMPLOYER_ACCOUNT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_ACCOUNT;

    -- create table if not exists nios.EMPLOYER_ACCOUNT as select * from nios_foreign.EMPLOYER_ACCOUNT;

    raise notice 'copied table nios.EMPLOYER_ACCOUNT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_ALLOC_DETAIL', 100 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_ALLOC_DETAIL;

    create foreign table if not exists nios_foreign.EMPLOYER_ALLOC_DETAIL (
        "id" numeric(19),
        "version" numeric(19),
        "allocation_amount" numeric(126),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "employer_alloc_master_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(126),
        "invoice_no" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_ALLOC_DETAIL');

    raise notice 'created foreign table for EMPLOYER_ALLOC_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_ALLOC_DETAIL;

    -- create table if not exists nios.EMPLOYER_ALLOC_DETAIL as select * from nios_foreign.EMPLOYER_ALLOC_DETAIL;

    raise notice 'copied table nios.EMPLOYER_ALLOC_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_ALLOC_MASTER', 101 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_ALLOC_MASTER;

    create foreign table if not exists nios_foreign.EMPLOYER_ALLOC_MASTER (
        "id" numeric(19),
        "version" numeric(19),
        "approval_code" varchar(80),
        "bank_area" varchar(400),
        "bank_code" varchar(32),
        "branch_code" varchar(8),
        "card_type" varchar(80),
        "collection_status" varchar(1020),
        "collection_uuid" varchar(1020),
        "comments" varchar(2000),
        "contact_address1" varchar(200),
        "contact_address2" varchar(200),
        "contact_address3" varchar(200),
        "contact_address4" varchar(200),
        "contact_district_code" varchar(28),
        "contact_fax" varchar(400),
        "contact_name" varchar(200),
        "contact_phone" varchar(400),
        "contact_post_code" varchar(28),
        "contact_state_code" varchar(28),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "date_issue" timestamp,
        "draft_type" numeric(10),
        "expiry_date" timestamp,
        "gst_amount" numeric(126),
        "gst_percentage" numeric(126),
        "invoice_batch" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "name_on_card" varchar(400),
        "payment_amount" numeric(126),
        "payment_no" varchar(64),
        "payment_surcharge" numeric(126),
        "payment_type" numeric(10),
        "receipt_payment_no" varchar(64),
        "receipt_payment_type" numeric(10),
        "receipt_tranno" varchar(40),
        "ref_no" varchar(200),
        "replacement_draft_id" numeric(19),
        "source" numeric(10),
        "status" numeric(10),
        "tranno" varchar(40),
        "transdate" timestamp,
        "voided_date" timestamp,
        "voided_reason" varchar(1020),
        "zone_code" varchar(8)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_ALLOC_MASTER');

    raise notice 'created foreign table for EMPLOYER_ALLOC_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_ALLOC_MASTER;

    -- create table if not exists nios.EMPLOYER_ALLOC_MASTER as select * from nios_foreign.EMPLOYER_ALLOC_MASTER;

    raise notice 'copied table nios.EMPLOYER_ALLOC_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_CN', 102 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_CN;

    create foreign table if not exists nios_foreign.EMPLOYER_CN (
        "id" numeric(19),
        "version" numeric(19),
        "account_concile_id" numeric(19),
        "allocation_amount" numeric(126),
        "branch_code" varchar(1020),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "credit_note_no" varchar(40),
        "draft_allocation_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(126),
        "is_posted" numeric(10),
        "gst_percentage" numeric(126),
        "nios_reference_no" numeric(19),
        "mystics_reference_no" numeric(19),
        "type" numeric(10),
        "posted_date" timestamp,
        "ap_group_id" numeric(19),
        "payment_refund_id" numeric(19),
        "other_amount" numeric(126),
        "other_amount_gst" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_CN');

    raise notice 'created foreign table for EMPLOYER_CN';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_CN;

    -- create table if not exists nios.EMPLOYER_CN as select * from nios_foreign.EMPLOYER_CN;

    raise notice 'copied table nios.EMPLOYER_CN';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_HISTORY', 103 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_HISTORY;

    create foreign table if not exists nios_foreign.EMPLOYER_HISTORY (
        "creation_date" timestamp,
        "employer_name" varchar(150),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "comments" varchar(4000),
        "district_code" varchar(7),
        "employer_code" varchar(10),
        "version_no" varchar(10),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "business_code" varchar(10),
        "country_code" varchar(3),
        "state_code" varchar(7),
        "primary_contact_phone" varchar(20),
        "doctor_code" varchar(10),
        "district_name" varchar(40),
        "modification_date" timestamp,
        "bc_employer_code" varchar(13),
        "bc_doctor_code" varchar(13),
        "status_code" varchar(5),
        "branch_code" varchar(2),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "classification" varchar(5),
        "action" varchar(10),
        "action_date" timestamp,
        "company_regno" varchar(20),
        "icpassport_no" varchar(20),
        "employer_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_HISTORY');

    raise notice 'created foreign table for EMPLOYER_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_HISTORY;

    -- create table if not exists nios.EMPLOYER_HISTORY as select * from nios_foreign.EMPLOYER_HISTORY;

    raise notice 'copied table nios.EMPLOYER_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_MASTER', 104 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_MASTER;

    create foreign table if not exists nios_foreign.EMPLOYER_MASTER (
        "employer_code" varchar(10),
        "employer_name" varchar(150),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "business_code" varchar(10),
        "country_code" varchar(3),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "status_code" varchar(5),
        "creation_date" timestamp,
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone" varchar(20),
        "doctor_code" varchar(10),
        "version_no" varchar(10),
        "comments" varchar(4000),
        "bc_employer_code" varchar(13),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "branch_code" varchar(2),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "bc_doctor_code" varchar(13),
        "classification" varchar(5),
        "company_regno" varchar(20),
        "icpassport_no" varchar(20),
        "badpayment_ind" numeric(1),
        "ap_group_id" numeric(19),
        "employer_account_type" numeric(1),
        "employer_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_MASTER');

    raise notice 'created foreign table for EMPLOYER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_MASTER;

    -- create table if not exists nios.EMPLOYER_MASTER as select * from nios_foreign.EMPLOYER_MASTER;

    raise notice 'copied table nios.EMPLOYER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_NOTIFICATION', 105 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_NOTIFICATION;

    create foreign table if not exists nios_foreign.EMPLOYER_NOTIFICATION (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "passport_no" varchar(20),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "doctor_code" varchar(10),
        "expiry_date" timestamp,
        "expiry_ind" varchar(1),
        "branch_code" varchar(2),
        "state_code" varchar(1),
        "creation_date" timestamp,
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_NOTIFICATION');

    raise notice 'created foreign table for EMPLOYER_NOTIFICATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_NOTIFICATION;

    -- create table if not exists nios.EMPLOYER_NOTIFICATION as select * from nios_foreign.EMPLOYER_NOTIFICATION;

    raise notice 'copied table nios.EMPLOYER_NOTIFICATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_NOTIFICATION_COUNT', 106 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.EMPLOYER_NOTIFICATION_COUNT;

    create foreign table if not exists nios_foreign.EMPLOYER_NOTIFICATION_COUNT (
        "employer_code" varchar(10),
        "total" numeric(5)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_NOTIFICATION_COUNT');

    raise notice 'created foreign table for EMPLOYER_NOTIFICATION_COUNT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.EMPLOYER_NOTIFICATION_COUNT;

    -- create table if not exists nios.EMPLOYER_NOTIFICATION_COUNT as select * from nios_foreign.EMPLOYER_NOTIFICATION_COUNT;

    raise notice 'copied table nios.EMPLOYER_NOTIFICATION_COUNT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ERRORMSG_FROM_KK', 107 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ERRORMSG_FROM_KK;

    create foreign table if not exists nios_foreign.ERRORMSG_FROM_KK (
        "msgtime" timestamp,
        "msgtext" varchar(1000),
        "msgid" numeric
    ) server nios_server options (schema 'NIOS1', table 'ERRORMSG_FROM_KK');

    raise notice 'created foreign table for ERRORMSG_FROM_KK';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ERRORMSG_FROM_KK;

    -- create table if not exists nios.ERRORMSG_FROM_KK as select * from nios_foreign.ERRORMSG_FROM_KK;

    raise notice 'copied table nios.ERRORMSG_FROM_KK';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FINANCE_PAYMENT', 108 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FINANCE_PAYMENT;

    create foreign table if not exists nios_foreign.FINANCE_PAYMENT (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "certify_date" timestamp,
        "report_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FINANCE_PAYMENT');

    raise notice 'created foreign table for FINANCE_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FINANCE_PAYMENT;

    -- create table if not exists nios.FINANCE_PAYMENT as select * from nios_foreign.FINANCE_PAYMENT;

    raise notice 'copied table nios.FINANCE_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FIN_BATCH_MASTER', 109 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FIN_BATCH_MASTER;

    create foreign table if not exists nios_foreign.FIN_BATCH_MASTER (
        "batch_number" numeric,
        "batch_startdate" timestamp,
        "batch_enddate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FIN_BATCH_MASTER');

    raise notice 'created foreign table for FIN_BATCH_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FIN_BATCH_MASTER;

    -- create table if not exists nios.FIN_BATCH_MASTER as select * from nios_foreign.FIN_BATCH_MASTER;

    raise notice 'copied table nios.FIN_BATCH_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FIN_BATCH_TRANS', 110 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FIN_BATCH_TRANS;

    create foreign table if not exists nios_foreign.FIN_BATCH_TRANS (
        "batch_number" numeric,
        "trans_id" varchar(14),
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FIN_BATCH_TRANS');

    raise notice 'created foreign table for FIN_BATCH_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FIN_BATCH_TRANS;

    -- create table if not exists nios.FIN_BATCH_TRANS as select * from nios_foreign.FIN_BATCH_TRANS;

    raise notice 'copied table nios.FIN_BATCH_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_DOCTOR_QUOTA_BKP', 111 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_DOCTOR_QUOTA_BKP;

    create foreign table if not exists nios_foreign.FOM_DOCTOR_QUOTA_BKP (
        "doctor_code" varchar(10),
        "laboratory_code" varchar(10),
        "xray_code" varchar(10),
        "quota" numeric,
        "quota_use" numeric,
        "creation_date" timestamp,
        "status_code" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'FOM_DOCTOR_QUOTA_BKP');

    raise notice 'created foreign table for FOM_DOCTOR_QUOTA_BKP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_DOCTOR_QUOTA_BKP;

    -- create table if not exists nios.FOM_DOCTOR_QUOTA_BKP as select * from nios_foreign.FOM_DOCTOR_QUOTA_BKP;

    raise notice 'copied table nios.FOM_DOCTOR_QUOTA_BKP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_LAB_PAYMENT_MISSED', 112 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_LAB_PAYMENT_MISSED;

    create foreign table if not exists nios_foreign.FOM_LAB_PAYMENT_MISSED (
        "trans_id" varchar(14),
        "lab_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_LAB_PAYMENT_MISSED');

    raise notice 'created foreign table for FOM_LAB_PAYMENT_MISSED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_LAB_PAYMENT_MISSED;

    -- create table if not exists nios.FOM_LAB_PAYMENT_MISSED as select * from nios_foreign.FOM_LAB_PAYMENT_MISSED;

    raise notice 'copied table nios.FOM_LAB_PAYMENT_MISSED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_LAB_UNPAID', 113 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_LAB_UNPAID;

    create foreign table if not exists nios_foreign.FOM_LAB_UNPAID (
        "l_order_no" numeric,
        "l_trans_id" varchar(14),
        "l_lab_code" varchar(10),
        "l_worker_code" varchar(10),
        "l_specimen_date" timestamp,
        "l_submit_date" timestamp,
        "l_batch_no" varchar(100),
        "f_ref_no" varchar(100),
        "f_trans_id" varchar(14),
        "f_lab_code" varchar(10),
        "f_specimen_date" timestamp,
        "f_submit_date" timestamp,
        "f_certify_date" timestamp,
        "f_remark" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'FOM_LAB_UNPAID');

    raise notice 'created foreign table for FOM_LAB_UNPAID';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_LAB_UNPAID;

    -- create table if not exists nios.FOM_LAB_UNPAID as select * from nios_foreign.FOM_LAB_UNPAID;

    raise notice 'copied table nios.FOM_LAB_UNPAID';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_MODULE_MASTER', 114 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_MODULE_MASTER;

    create foreign table if not exists nios_foreign.FOM_MODULE_MASTER (
        "mod_id" numeric,
        "parent_mod_id" numeric,
        "mod_desc" varchar(50),
        "description" varchar(250),
        "modified_date" timestamp,
        "created_date" timestamp,
        "sort_order" numeric,
        "isactive" numeric,
        "url" varchar(250)
    ) server nios_server options (schema 'NIOS1', table 'FOM_MODULE_MASTER');

    raise notice 'created foreign table for FOM_MODULE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_MODULE_MASTER;

    -- create table if not exists nios.FOM_MODULE_MASTER as select * from nios_foreign.FOM_MODULE_MASTER;

    raise notice 'copied table nios.FOM_MODULE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_PARAMS', 115 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_PARAMS;

    create foreign table if not exists nios_foreign.FOM_PARAMS (
        "param_code" varchar(100),
        "param_value" varchar(1000),
        "isactive" numeric,
        "created_date" timestamp,
        "remark" varchar(1000),
        "refid" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'FOM_PARAMS');

    raise notice 'created foreign table for FOM_PARAMS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_PARAMS;

    -- create table if not exists nios.FOM_PARAMS as select * from nios_foreign.FOM_PARAMS;

    raise notice 'copied table nios.FOM_PARAMS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_PAYMENT_STATUS_MISSED', 116 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_PAYMENT_STATUS_MISSED;

    create foreign table if not exists nios_foreign.FOM_PAYMENT_STATUS_MISSED (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "doc_pay_ind" varchar(1),
        "doctor_paid" timestamp,
        "xray_code" varchar(10),
        "xray_pay_ind" varchar(1),
        "xray_paid" timestamp,
        "lab_code" varchar(10),
        "lab_pay_ind" varchar(1),
        "lab_paid" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_PAYMENT_STATUS_MISSED');

    raise notice 'created foreign table for FOM_PAYMENT_STATUS_MISSED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_PAYMENT_STATUS_MISSED;

    -- create table if not exists nios.FOM_PAYMENT_STATUS_MISSED as select * from nios_foreign.FOM_PAYMENT_STATUS_MISSED;

    raise notice 'copied table nios.FOM_PAYMENT_STATUS_MISSED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_PAY_TRANSACTION', 117 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_PAY_TRANSACTION;

    create foreign table if not exists nios_foreign.FOM_PAY_TRANSACTION (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "sex" varchar(1),
        "branch_code" varchar(2),
        "certify_date" timestamp,
        "sp_type" varchar(1),
        "sp_code" varchar(10),
        "sp_group_id" numeric,
        "sp_state_code" varchar(20),
        "amount" numeric(126),
        "xray_notdone_ind" varchar(120),
        "created_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "gst_type" numeric(10),
        "gstamount" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'FOM_PAY_TRANSACTION');

    raise notice 'created foreign table for FOM_PAY_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_PAY_TRANSACTION;

    -- create table if not exists nios.FOM_PAY_TRANSACTION as select * from nios_foreign.FOM_PAY_TRANSACTION;

    raise notice 'copied table nios.FOM_PAY_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_PAY_TRANSACTION_MISSED', 118 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_PAY_TRANSACTION_MISSED;

    create foreign table if not exists nios_foreign.FOM_PAY_TRANSACTION_MISSED (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "name" varchar(50),
        "certify_date" timestamp,
        "doc_amount" numeric(6),
        "doc_ded" numeric(3),
        "xray_code" varchar(10),
        "xray_amount" numeric(6),
        "xray_ded" numeric(3),
        "doc_pb_ind" varchar(1),
        "xray_pb_ind" varchar(1),
        "doc_pb_date" timestamp,
        "xray_pb_date" timestamp,
        "doc_unb_date" timestamp,
        "xray_unb_date" timestamp,
        "sex" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FOM_PAY_TRANSACTION_MISSED');

    raise notice 'created foreign table for FOM_PAY_TRANSACTION_MISSED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_PAY_TRANSACTION_MISSED;

    -- create table if not exists nios.FOM_PAY_TRANSACTION_MISSED as select * from nios_foreign.FOM_PAY_TRANSACTION_MISSED;

    raise notice 'copied table nios.FOM_PAY_TRANSACTION_MISSED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_SPECIAL_PAYMENT', 119 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_SPECIAL_PAYMENT;

    create foreign table if not exists nios_foreign.FOM_SPECIAL_PAYMENT (
        "trans_id" varchar(14),
        "sp_type" varchar(1),
        "payment_date" timestamp,
        "payment_amount" numeric,
        "created_by" varchar(20),
        "created_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_SPECIAL_PAYMENT');

    raise notice 'created foreign table for FOM_SPECIAL_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_SPECIAL_PAYMENT;

    -- create table if not exists nios.FOM_SPECIAL_PAYMENT as select * from nios_foreign.FOM_SPECIAL_PAYMENT;

    raise notice 'copied table nios.FOM_SPECIAL_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_TEMPMYEG', 120 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_TEMPMYEG;

    create foreign table if not exists nios_foreign.FOM_TEMPMYEG (
        "worker_name" varchar(50),
        "passport_no" varchar(25),
        "country" varchar(50),
        "old_passport_no" varchar(25)
    ) server nios_server options (schema 'NIOS1', table 'FOM_TEMPMYEG');

    raise notice 'created foreign table for FOM_TEMPMYEG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_TEMPMYEG;

    -- create table if not exists nios.FOM_TEMPMYEG as select * from nios_foreign.FOM_TEMPMYEG;

    raise notice 'copied table nios.FOM_TEMPMYEG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_TMP_JIM', 121 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_TMP_JIM;

    create foreign table if not exists nios_foreign.FOM_TMP_JIM (
        "mfo_doc_no" varchar(20),
        "mfo_nat" varchar(20),
        "mfo_txn_id" varchar(20),
        "created_date" timestamp,
        "modified_date" timestamp,
        "diseases" varchar(4000),
        "unfit_comment" varchar(4000),
        "old_fit_ind" varchar(1),
        "new_fit_ind" varchar(1),
        "fit_ind_changed_date" timestamp,
        "mfo_exam_date" timestamp,
        "trans_id" varchar(20),
        "dfit_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FOM_TMP_JIM');

    raise notice 'created foreign table for FOM_TMP_JIM';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_TMP_JIM;

    -- create table if not exists nios.FOM_TMP_JIM as select * from nios_foreign.FOM_TMP_JIM;

    raise notice 'copied table nios.FOM_TMP_JIM';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_USER_CAPABILITY', 122 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_USER_CAPABILITY;

    create foreign table if not exists nios_foreign.FOM_USER_CAPABILITY (
        "uuid" numeric(10),
        "mod_id" numeric(38),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_USER_CAPABILITY');

    raise notice 'created foreign table for FOM_USER_CAPABILITY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_USER_CAPABILITY;

    -- create table if not exists nios.FOM_USER_CAPABILITY as select * from nios_foreign.FOM_USER_CAPABILITY;

    raise notice 'copied table nios.FOM_USER_CAPABILITY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_USER_MASTER', 123 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_USER_MASTER;

    create foreign table if not exists nios_foreign.FOM_USER_MASTER (
        "uuid" numeric(10),
        "passwordcount" numeric,
        "attempdate" timestamp,
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_USER_MASTER');

    raise notice 'created foreign table for FOM_USER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_USER_MASTER;

    -- create table if not exists nios.FOM_USER_MASTER as select * from nios_foreign.FOM_USER_MASTER;

    raise notice 'copied table nios.FOM_USER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_XRAY_NOT_DONE_MISSED', 124 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_XRAY_NOT_DONE_MISSED;

    create foreign table if not exists nios_foreign.FOM_XRAY_NOT_DONE_MISSED (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'FOM_XRAY_NOT_DONE_MISSED');

    raise notice 'created foreign table for FOM_XRAY_NOT_DONE_MISSED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_XRAY_NOT_DONE_MISSED;

    -- create table if not exists nios.FOM_XRAY_NOT_DONE_MISSED as select * from nios_foreign.FOM_XRAY_NOT_DONE_MISSED;

    raise notice 'copied table nios.FOM_XRAY_NOT_DONE_MISSED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_XRAY_NOT_RECEIVE', 125 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_XRAY_NOT_RECEIVE;

    create foreign table if not exists nios_foreign.FOM_XRAY_NOT_RECEIVE (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(250),
        "phone" varchar(100),
        "fax" varchar(100),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "certify_date" timestamp,
        "xray_testdone_date" timestamp,
        "xray_submit_date" timestamp,
        "target_receive_date" timestamp,
        "day_delay" numeric,
        "fit_ind" varchar(1),
        "dfit_ind" varchar(1),
        "xray_film_type" varchar(1),
        "modified_date" timestamp,
        "created_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_XRAY_NOT_RECEIVE');

    raise notice 'created foreign table for FOM_XRAY_NOT_RECEIVE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_XRAY_NOT_RECEIVE;

    -- create table if not exists nios.FOM_XRAY_NOT_RECEIVE as select * from nios_foreign.FOM_XRAY_NOT_RECEIVE;

    raise notice 'copied table nios.FOM_XRAY_NOT_RECEIVE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOM_XRAY_USE_SWAST', 126 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOM_XRAY_USE_SWAST;

    create foreign table if not exists nios_foreign.FOM_XRAY_USE_SWAST (
        "xray_code" varchar(10),
        "install_date" timestamp,
        "created_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_XRAY_USE_SWAST');

    raise notice 'created foreign table for FOM_XRAY_USE_SWAST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOM_XRAY_USE_SWAST;

    -- create table if not exists nios.FOM_XRAY_USE_SWAST as select * from nios_foreign.FOM_XRAY_USE_SWAST;

    raise notice 'copied table nios.FOM_XRAY_USE_SWAST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOREIGN_CLINIC_MASTER', 127 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOREIGN_CLINIC_MASTER;

    create foreign table if not exists nios_foreign.FOREIGN_CLINIC_MASTER (
        "clinic_code" varchar(10),
        "country_code" varchar(3),
        "region" varchar(50),
        "clinic_name" varchar(100),
        "address" varchar(255),
        "phone_no" varchar(50),
        "status_code" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOREIGN_CLINIC_MASTER');

    raise notice 'created foreign table for FOREIGN_CLINIC_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOREIGN_CLINIC_MASTER;

    -- create table if not exists nios.FOREIGN_CLINIC_MASTER as select * from nios_foreign.FOREIGN_CLINIC_MASTER;

    raise notice 'copied table nios.FOREIGN_CLINIC_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOREIGN_WORKER_BIODATA', 128 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOREIGN_WORKER_BIODATA;

    create foreign table if not exists nios_foreign.FOREIGN_WORKER_BIODATA (
        "worker_code" varchar(10),
        "nationality" varchar(3),
        "date_of_birth" varchar(8),
        "gender" varchar(1),
        "worker_name" varchar(150),
        "doc_expiry_date" varchar(8),
        "doc_issue_authority" varchar(3),
        "application_number" varchar(45),
        "afis_id" varchar(15),
        "ners_reason_code" varchar(5),
        "date_of_arrival" varchar(8),
        "employer_name" varchar(150),
        "employer_id" varchar(20),
        "employer_type" varchar(3),
        "employer_address1" varchar(40),
        "employer_address2" varchar(40),
        "employer_address3" varchar(40),
        "employer_address4" varchar(40),
        "employer_postcode" varchar(15),
        "employer_city" varchar(6),
        "employer_state" varchar(3),
        "employer_email" varchar(60),
        "employer_phone_no" varchar(25),
        "ners_status" varchar(3),
        "ners_message" varchar(100),
        "transaction_id" varchar(30),
        "uuid" numeric(10),
        "creation_date" timestamp,
        "surname" varchar(150),
        "passport_no" varchar(20),
        "fp_biosl" varchar(2),
        "trans_id" varchar(14),
        "fp_availability_status" varchar(3),
        "fp_avail" varchar(30),
        "renew_count_year" varchar(2),
        "pra_create_id" varchar(30),
        "verify_ind" numeric(1),
        "error_desc" varchar(100),
        "error_ind" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FOREIGN_WORKER_BIODATA');

    raise notice 'created foreign table for FOREIGN_WORKER_BIODATA';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOREIGN_WORKER_BIODATA;

    -- create table if not exists nios.FOREIGN_WORKER_BIODATA as select * from nios_foreign.FOREIGN_WORKER_BIODATA;

    raise notice 'copied table nios.FOREIGN_WORKER_BIODATA';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOREIGN_WORKER_MASTER_CANCEL', 131 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOREIGN_WORKER_MASTER_CANCEL;

    create foreign table if not exists nios_foreign.FOREIGN_WORKER_MASTER_CANCEL (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "creation_date" timestamp,
        "fathers_name" varchar(50),
        "date_of_birth" timestamp,
        "passport_no" varchar(20),
        "visa_no" varchar(20),
        "sex" varchar(1),
        "job_type" varchar(50),
        "arrival_date" timestamp,
        "version_no" varchar(10),
        "blood_group" varchar(3),
        "country_code" varchar(3),
        "departure_date" timestamp,
        "last_examine_date" timestamp,
        "employer_pref_ind" varchar(1),
        "imm_name" varchar(50),
        "agent_code" varchar(10),
        "employer_code" varchar(10),
        "fit_ind" varchar(1),
        "fomema_ind" varchar(1),
        "renewal_date" timestamp,
        "bc_worker_code" varchar(13),
        "bc_agent_code" varchar(13),
        "bc_employer_code" varchar(13),
        "can_renew" varchar(5),
        "ismonitor" varchar(5),
        "isimmblock" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "status_code" varchar(5),
        "ply_count" numeric(10),
        "ply_printed" varchar(5),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "visa_expiry_date" timestamp,
        "rh" varchar(1),
        "classification" varchar(5),
        "clinic_code" varchar(10),
        "clinic_examdate" timestamp,
        "created_by" varchar(10),
        "immblocked_by" varchar(3),
        "pati" varchar(1),
        "cancel_by" numeric(10),
        "cancel_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOREIGN_WORKER_MASTER_CANCEL');

    raise notice 'created foreign table for FOREIGN_WORKER_MASTER_CANCEL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOREIGN_WORKER_MASTER_CANCEL;

    -- create table if not exists nios.FOREIGN_WORKER_MASTER_CANCEL as select * from nios_foreign.FOREIGN_WORKER_MASTER_CANCEL;

    raise notice 'copied table nios.FOREIGN_WORKER_MASTER_CANCEL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FOREIGN_WORKER_MASTER_DELETE', 132 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FOREIGN_WORKER_MASTER_DELETE;

    create foreign table if not exists nios_foreign.FOREIGN_WORKER_MASTER_DELETE (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "creation_date" timestamp,
        "fathers_name" varchar(50),
        "date_of_birth" timestamp,
        "passport_no" varchar(20),
        "visa_no" varchar(20),
        "sex" varchar(1),
        "job_type" varchar(50),
        "arrival_date" timestamp,
        "version_no" varchar(10),
        "blood_group" varchar(3),
        "country_code" varchar(3),
        "departure_date" timestamp,
        "last_examine_date" timestamp,
        "employer_pref_ind" varchar(1),
        "imm_name" varchar(50),
        "agent_code" varchar(10),
        "employer_code" varchar(10),
        "fit_ind" varchar(1),
        "fomema_ind" varchar(1),
        "renewal_date" timestamp,
        "bc_worker_code" varchar(13),
        "bc_agent_code" varchar(13),
        "bc_employer_code" varchar(13),
        "can_renew" varchar(5),
        "ismonitor" varchar(5),
        "isimmblock" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "status_code" varchar(5),
        "ply_count" numeric(10),
        "ply_printed" varchar(5),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "visa_expiry_date" timestamp,
        "rh" varchar(1),
        "classification" varchar(5),
        "clinic_code" varchar(10),
        "clinic_examdate" timestamp,
        "created_by" varchar(10),
        "del_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOREIGN_WORKER_MASTER_DELETE');

    raise notice 'created foreign table for FOREIGN_WORKER_MASTER_DELETE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FOREIGN_WORKER_MASTER_DELETE;

    -- create table if not exists nios.FOREIGN_WORKER_MASTER_DELETE as select * from nios_foreign.FOREIGN_WORKER_MASTER_DELETE;

    raise notice 'copied table nios.FOREIGN_WORKER_MASTER_DELETE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWM_CHANGE_TRANS', 133 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWM_CHANGE_TRANS;

    create foreign table if not exists nios_foreign.FWM_CHANGE_TRANS (
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "old_value" varchar(100),
        "new_value" varchar(100),
        "reason_code" varchar(5),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_CHANGE_TRANS');

    raise notice 'created foreign table for FWM_CHANGE_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWM_CHANGE_TRANS;

    -- create table if not exists nios.FWM_CHANGE_TRANS as select * from nios_foreign.FWM_CHANGE_TRANS;

    raise notice 'copied table nios.FWM_CHANGE_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWM_CHANGE_TRANS_ORG', 134 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWM_CHANGE_TRANS_ORG;

    create foreign table if not exists nios_foreign.FWM_CHANGE_TRANS_ORG (
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "old_value" varchar(100),
        "new_value" varchar(100),
        "reason_code" varchar(5),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_CHANGE_TRANS_ORG');

    raise notice 'created foreign table for FWM_CHANGE_TRANS_ORG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWM_CHANGE_TRANS_ORG;

    -- create table if not exists nios.FWM_CHANGE_TRANS_ORG as select * from nios_foreign.FWM_CHANGE_TRANS_ORG;

    raise notice 'copied table nios.FWM_CHANGE_TRANS_ORG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWM_MODULECODE', 135 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWM_MODULECODE;

    create foreign table if not exists nios_foreign.FWM_MODULECODE (
        "module_code" numeric(5),
        "description" varchar(255),
        "status" numeric(1),
        "creator_id" varchar(20),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_MODULECODE');

    raise notice 'created foreign table for FWM_MODULECODE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWM_MODULECODE;

    -- create table if not exists nios.FWM_MODULECODE as select * from nios_foreign.FWM_MODULECODE;

    raise notice 'copied table nios.FWM_MODULECODE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWM_MON', 136 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWM_MON;

    create foreign table if not exists nios_foreign.FWM_MON (
        "worker_code" varchar(10),
        "ismonitor" varchar(5),
        "passport_no" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'FWM_MON');

    raise notice 'created foreign table for FWM_MON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWM_MON;

    -- create table if not exists nios.FWM_MON as select * from nios_foreign.FWM_MON;

    raise notice 'copied table nios.FWM_MON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_AUDIT_LOG', 137 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_AUDIT_LOG;

    create foreign table if not exists nios_foreign.FWT_AUDIT_LOG (
        "username" varchar(50),
        "osuser" varchar(30),
        "machine" varchar(64),
        "action" varchar(9),
        "audit_date" timestamp,
        "trans_id" varchar(14),
        "old_fit_ind" varchar(1),
        "new_fit_ind" varchar(1),
        "old_version_no" varchar(10),
        "new_version_no" varchar(10),
        "userid" varchar(30),
        "modify_id" numeric,
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWT_AUDIT_LOG');

    raise notice 'created foreign table for FWT_AUDIT_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_AUDIT_LOG;

    -- create table if not exists nios.FWT_AUDIT_LOG as select * from nios_foreign.FWT_AUDIT_LOG;

    raise notice 'copied table nios.FWT_AUDIT_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_AUDIT_LOG_HISTORY', 138 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_AUDIT_LOG_HISTORY;

    create foreign table if not exists nios_foreign.FWT_AUDIT_LOG_HISTORY (
        "username" varchar(50),
        "osuser" varchar(30),
        "machine" varchar(64),
        "action" varchar(9),
        "audit_date" timestamp,
        "trans_id" varchar(14),
        "old_fit_ind" varchar(1),
        "new_fit_ind" varchar(1),
        "old_version_no" varchar(10),
        "new_version_no" varchar(10),
        "userid" varchar(30),
        "modify_id" numeric,
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWT_AUDIT_LOG_HISTORY');

    raise notice 'created foreign table for FWT_AUDIT_LOG_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_AUDIT_LOG_HISTORY;

    -- create table if not exists nios.FWT_AUDIT_LOG_HISTORY as select * from nios_foreign.FWT_AUDIT_LOG_HISTORY;

    raise notice 'copied table nios.FWT_AUDIT_LOG_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_CHANGE_CLINIC_APPROVAL', 139 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_CHANGE_CLINIC_APPROVAL;

    create foreign table if not exists nios_foreign.FWT_CHANGE_CLINIC_APPROVAL (
        "req_id" numeric(10),
        "trans_id" varchar(16),
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "payment_mode" varchar(20),
        "payment_amount" numeric(126),
        "foc_reason" varchar(2000),
        "approval_status" numeric,
        "creation_date" timestamp,
        "created_by" numeric(10),
        "modification_date" timestamp,
        "modified_by" numeric(10),
        "branch_code" varchar(2),
        "approval_comment" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_CLINIC_APPROVAL');

    raise notice 'created foreign table for FWT_CHANGE_CLINIC_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_CHANGE_CLINIC_APPROVAL;

    -- create table if not exists nios.FWT_CHANGE_CLINIC_APPROVAL as select * from nios_foreign.FWT_CHANGE_CLINIC_APPROVAL;

    raise notice 'copied table nios.FWT_CHANGE_CLINIC_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_CHANGE_JOURNAL', 140 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_CHANGE_JOURNAL;

    create foreign table if not exists nios_foreign.FWT_CHANGE_JOURNAL (
        "chgjl_id" varchar(14),
        "chgjl_date" timestamp,
        "trans_id" varchar(14),
        "userid" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_JOURNAL');

    raise notice 'created foreign table for FWT_CHANGE_JOURNAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_CHANGE_JOURNAL;

    -- create table if not exists nios.FWT_CHANGE_JOURNAL as select * from nios_foreign.FWT_CHANGE_JOURNAL;

    raise notice 'copied table nios.FWT_CHANGE_JOURNAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_CHANGE_JOURNAL_DETAIL', 141 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_CHANGE_JOURNAL_DETAIL;

    create foreign table if not exists nios_foreign.FWT_CHANGE_JOURNAL_DETAIL (
        "chgjl_id" varchar(14),
        "chgtype" varchar(1),
        "old_code" varchar(10),
        "new_code" varchar(10),
        "reason" varchar(240)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_JOURNAL_DETAIL');

    raise notice 'created foreign table for FWT_CHANGE_JOURNAL_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_CHANGE_JOURNAL_DETAIL;

    -- create table if not exists nios.FWT_CHANGE_JOURNAL_DETAIL as select * from nios_foreign.FWT_CHANGE_JOURNAL_DETAIL;

    raise notice 'copied table nios.FWT_CHANGE_JOURNAL_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_DEFERRED', 142 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_DEFERRED;

    create foreign table if not exists nios_foreign.FWT_DEFERRED (
        "trans_id" varchar(14),
        "creation_date" timestamp,
        "created_by" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'FWT_DEFERRED');

    raise notice 'created foreign table for FWT_DEFERRED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_DEFERRED;

    -- create table if not exists nios.FWT_DEFERRED as select * from nios_foreign.FWT_DEFERRED;

    raise notice 'copied table nios.FWT_DEFERRED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_EXAMDATE_CHANGE_TRANS', 143 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_EXAMDATE_CHANGE_TRANS;

    create foreign table if not exists nios_foreign.FWT_EXAMDATE_CHANGE_TRANS (
        "change_id" numeric(9),
        "trans_id" varchar(14),
        "old_exam_date" timestamp,
        "new_exam_date" timestamp,
        "initiated_by" varchar(20),
        "date_initiated" timestamp,
        "status" char(1),
        "concur_by" varchar(20),
        "concur_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWT_EXAMDATE_CHANGE_TRANS');

    raise notice 'created foreign table for FWT_EXAMDATE_CHANGE_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_EXAMDATE_CHANGE_TRANS;

    -- create table if not exists nios.FWT_EXAMDATE_CHANGE_TRANS as select * from nios_foreign.FWT_EXAMDATE_CHANGE_TRANS;

    raise notice 'copied table nios.FWT_EXAMDATE_CHANGE_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_REGMED', 144 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_REGMED;

    create foreign table if not exists nios_foreign.FWT_REGMED (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "med_ind" numeric,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_REGMED');

    raise notice 'created foreign table for FWT_REGMED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_REGMED;

    -- create table if not exists nios.FWT_REGMED as select * from nios_foreign.FWT_REGMED;

    raise notice 'copied table nios.FWT_REGMED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_REGMED_DELTA', 145 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_REGMED_DELTA;

    create foreign table if not exists nios_foreign.FWT_REGMED_DELTA (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "med_ind" numeric,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_REGMED_DELTA');

    raise notice 'created foreign table for FWT_REGMED_DELTA';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_REGMED_DELTA;

    -- create table if not exists nios.FWT_REGMED_DELTA as select * from nios_foreign.FWT_REGMED_DELTA;

    raise notice 'copied table nios.FWT_REGMED_DELTA';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_SHADOW', 146 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_SHADOW;

    create foreign table if not exists nios_foreign.FWT_SHADOW (
        "trans_id" varchar(14),
        "shadow_id" varchar(14),
        "xray_code" varchar(10),
        "xray_submit_date" timestamp,
        "type" numeric(1),
        "radiologist_code" varchar(10),
        "xray_testdone_date" timestamp,
        "xray_notdone_ind" varchar(1),
        "xray_ref_no" varchar(20),
        "appeal_id" numeric(10),
        "retake_id" numeric(10),
        "pool_id" numeric(19),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "retake_pool_id" numeric(19),
        "provider_id" varchar(3),
        "xray_upload_status" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'FWT_SHADOW');

    raise notice 'created foreign table for FWT_SHADOW';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_SHADOW;

    -- create table if not exists nios.FWT_SHADOW as select * from nios_foreign.FWT_SHADOW;

    raise notice 'copied table nios.FWT_SHADOW';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_UPDATE_TCUPI', 147 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_UPDATE_TCUPI;

    create foreign table if not exists nios_foreign.FWT_UPDATE_TCUPI (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "old_fit_ind" varchar(1),
        "new_fit_ind" varchar(1),
        "old_tcupi_ind" varchar(1),
        "new_tcupi_ind" varchar(1),
        "mod_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FWT_UPDATE_TCUPI');

    raise notice 'created foreign table for FWT_UPDATE_TCUPI';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_UPDATE_TCUPI;

    -- create table if not exists nios.FWT_UPDATE_TCUPI as select * from nios_foreign.FWT_UPDATE_TCUPI;

    raise notice 'copied table nios.FWT_UPDATE_TCUPI';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FWT_XRAY_UNMATCH', 148 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FWT_XRAY_UNMATCH;

    create foreign table if not exists nios_foreign.FWT_XRAY_UNMATCH (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(14),
        "bc_xray_code" varchar(14),
        "xray_code" varchar(14),
        "modify_id" numeric,
        "modification_date" timestamp,
        "version_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_XRAY_UNMATCH');

    raise notice 'created foreign table for FWT_XRAY_UNMATCH';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FWT_XRAY_UNMATCH;

    -- create table if not exists nios.FWT_XRAY_UNMATCH as select * from nios_foreign.FWT_XRAY_UNMATCH;

    raise notice 'copied table nios.FWT_XRAY_UNMATCH';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL', 149 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL;

    create foreign table if not exists nios_foreign.FW_APPEAL (
        "appealid" numeric(10),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "appeal_doctor_code" varchar(13),
        "letter_apointment_date" timestamp,
        "result_date" timestamp,
        "idemnity_date" timestamp,
        "letter_notification" timestamp,
        "comments" varchar(4000),
        "follow_up" varchar(13),
        "status" varchar(5),
        "appeal_success" varchar(5),
        "creation_date" timestamp,
        "modification_date" timestamp,
        "phase_status" varchar(2),
        "blood_group" varchar(3),
        "rh" varchar(1),
        "appeal_close_comments" varchar(4000),
        "officer_incharge" varchar(50),
        "iscancelled" varchar(1),
        "appeal_type" varchar(3),
        "appeal_start_comments" varchar(4000),
        "creator_id" varchar(10),
        "modification_id" varchar(10),
        "appeal_summary_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL');

    raise notice 'created foreign table for FW_APPEAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL;

    -- create table if not exists nios.FW_APPEAL as select * from nios_foreign.FW_APPEAL;

    raise notice 'copied table nios.FW_APPEAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_APPROVAL', 150 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_APPROVAL;

    create foreign table if not exists nios_foreign.FW_APPEAL_APPROVAL (
        "appealappid" numeric(10),
        "appealid" numeric(10),
        "req_userid" numeric(10),
        "req_date" timestamp,
        "req_comments" varchar(4000),
        "approval_userid" numeric(10),
        "approval_date" timestamp,
        "approval_comments" varchar(4000),
        "status" varchar(1),
        "appeal_result" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_APPROVAL');

    raise notice 'created foreign table for FW_APPEAL_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_APPROVAL;

    -- create table if not exists nios.FW_APPEAL_APPROVAL as select * from nios_foreign.FW_APPEAL_APPROVAL;

    raise notice 'copied table nios.FW_APPEAL_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_APPROVAL_HISTORY', 151 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_APPROVAL_HISTORY;

    create foreign table if not exists nios_foreign.FW_APPEAL_APPROVAL_HISTORY (
        "appealappid" numeric(10),
        "appealid" numeric(10),
        "req_userid" numeric(10),
        "req_date" timestamp,
        "req_comments" varchar(4000),
        "approval_userid" numeric(10),
        "approval_date" timestamp,
        "approval_comments" varchar(4000),
        "status" varchar(1),
        "appeal_result" varchar(1),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_APPROVAL_HISTORY');

    raise notice 'created foreign table for FW_APPEAL_APPROVAL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_APPROVAL_HISTORY;

    -- create table if not exists nios.FW_APPEAL_APPROVAL_HISTORY as select * from nios_foreign.FW_APPEAL_APPROVAL_HISTORY;

    raise notice 'copied table nios.FW_APPEAL_APPROVAL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_COMMENT', 152 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_COMMENT;

    create foreign table if not exists nios_foreign.FW_APPEAL_COMMENT (
        "appeal_commentid" numeric(10),
        "appealid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_COMMENT');

    raise notice 'created foreign table for FW_APPEAL_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_COMMENT;

    -- create table if not exists nios.FW_APPEAL_COMMENT as select * from nios_foreign.FW_APPEAL_COMMENT;

    raise notice 'copied table nios.FW_APPEAL_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_DOC_CHANGE', 153 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_DOC_CHANGE;

    create foreign table if not exists nios_foreign.FW_APPEAL_DOC_CHANGE (
        "appealid" numeric(10),
        "comments" varchar(4000),
        "old_doctor_code" varchar(13),
        "new_doctor_code" varchar(13),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_DOC_CHANGE');

    raise notice 'created foreign table for FW_APPEAL_DOC_CHANGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_DOC_CHANGE;

    -- create table if not exists nios.FW_APPEAL_DOC_CHANGE as select * from nios_foreign.FW_APPEAL_DOC_CHANGE;

    raise notice 'copied table nios.FW_APPEAL_DOC_CHANGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_FOLLOW_UP', 154 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_FOLLOW_UP;

    create foreign table if not exists nios_foreign.FW_APPEAL_FOLLOW_UP (
        "followupid" numeric(10),
        "appealid" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_FOLLOW_UP');

    raise notice 'created foreign table for FW_APPEAL_FOLLOW_UP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_FOLLOW_UP;

    -- create table if not exists nios.FW_APPEAL_FOLLOW_UP as select * from nios_foreign.FW_APPEAL_FOLLOW_UP;

    raise notice 'copied table nios.FW_APPEAL_FOLLOW_UP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_FOLLOW_UP_DETAIL', 155 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_FOLLOW_UP_DETAIL;

    create foreign table if not exists nios_foreign.FW_APPEAL_FOLLOW_UP_DETAIL (
        "followdetid" numeric(10),
        "followupid" numeric(10),
        "followup_date" timestamp,
        "followed_up" varchar(5),
        "followed_up_date" timestamp,
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_FOLLOW_UP_DETAIL');

    raise notice 'created foreign table for FW_APPEAL_FOLLOW_UP_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_FOLLOW_UP_DETAIL;

    -- create table if not exists nios.FW_APPEAL_FOLLOW_UP_DETAIL as select * from nios_foreign.FW_APPEAL_FOLLOW_UP_DETAIL;

    raise notice 'copied table nios.FW_APPEAL_FOLLOW_UP_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_HISTORY', 156 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_HISTORY;

    create foreign table if not exists nios_foreign.FW_APPEAL_HISTORY (
        "appealid" numeric(10),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "appeal_doctor_code" varchar(13),
        "letter_apointment_date" timestamp,
        "result_date" timestamp,
        "idemnity_date" timestamp,
        "letter_notification" timestamp,
        "comments" varchar(4000),
        "follow_up" varchar(13),
        "status" varchar(5),
        "appeal_success" varchar(5),
        "creation_date" timestamp,
        "modification_date" timestamp,
        "phase_status" varchar(2),
        "blood_group" varchar(3),
        "rh" varchar(1),
        "appeal_close_comments" varchar(4000),
        "officer_incharge" varchar(50),
        "iscancelled" varchar(1),
        "action" varchar(10),
        "action_date" timestamp,
        "appeal_type" varchar(3),
        "appeal_start_comments" varchar(4000),
        "creator_id" varchar(10),
        "modification_id" varchar(10),
        "appeal_summary_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_HISTORY');

    raise notice 'created foreign table for FW_APPEAL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_HISTORY;

    -- create table if not exists nios.FW_APPEAL_HISTORY as select * from nios_foreign.FW_APPEAL_HISTORY;

    raise notice 'copied table nios.FW_APPEAL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_PASSFAIL_REASON', 157 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_PASSFAIL_REASON;

    create foreign table if not exists nios_foreign.FW_APPEAL_PASSFAIL_REASON (
        "reasonid" numeric(10),
        "appeal_param_code" varchar(10),
        "reason_code" varchar(10),
        "reason_description" varchar(250),
        "passfail" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_PASSFAIL_REASON');

    raise notice 'created foreign table for FW_APPEAL_PASSFAIL_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_PASSFAIL_REASON;

    -- create table if not exists nios.FW_APPEAL_PASSFAIL_REASON as select * from nios_foreign.FW_APPEAL_PASSFAIL_REASON;

    raise notice 'copied table nios.FW_APPEAL_PASSFAIL_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_TODOLIST', 158 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_TODOLIST;

    create foreign table if not exists nios_foreign.FW_APPEAL_TODOLIST (
        "appeal_todolist_id" numeric(10),
        "todoid" numeric(10),
        "parameter_code" varchar(10),
        "dr_date" timestamp,
        "fo_date" timestamp,
        "dr_done" varchar(1),
        "fo_done" varchar(1),
        "comments" varchar(1000),
        "appealid" numeric(10),
        "createid" varchar(10),
        "createdate" timestamp,
        "modifyid" varchar(10),
        "modifydate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_TODOLIST');

    raise notice 'created foreign table for FW_APPEAL_TODOLIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_TODOLIST;

    -- create table if not exists nios.FW_APPEAL_TODOLIST as select * from nios_foreign.FW_APPEAL_TODOLIST;

    raise notice 'copied table nios.FW_APPEAL_TODOLIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_APPEAL_UNFIT_DETAILS', 159 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_APPEAL_UNFIT_DETAILS;

    create foreign table if not exists nios_foreign.FW_APPEAL_UNFIT_DETAILS (
        "appealid" numeric(10),
        "merts_param_code" varchar(10),
        "appeal_param_code" varchar(10),
        "reason_code" varchar(10),
        "passfail" varchar(1),
        "remarks" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_UNFIT_DETAILS');

    raise notice 'created foreign table for FW_APPEAL_UNFIT_DETAILS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_APPEAL_UNFIT_DETAILS;

    -- create table if not exists nios.FW_APPEAL_UNFIT_DETAILS as select * from nios_foreign.FW_APPEAL_UNFIT_DETAILS;

    raise notice 'copied table nios.FW_APPEAL_UNFIT_DETAILS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_BIODATA_REENROLMENT', 160 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_BIODATA_REENROLMENT;

    create foreign table if not exists nios_foreign.FW_BIODATA_REENROLMENT (
        "worker_code" varchar(10),
        "afis_id" varchar(15),
        "error_ind" numeric(10),
        "passport_no" varchar(20),
        "nationality" varchar(3),
        "date_of_birth" varchar(8),
        "gender" varchar(1),
        "insertdate" timestamp,
        "userid" numeric(10),
        "sp_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_BIODATA_REENROLMENT');

    raise notice 'created foreign table for FW_BIODATA_REENROLMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_BIODATA_REENROLMENT;

    -- create table if not exists nios.FW_BIODATA_REENROLMENT as select * from nios_foreign.FW_BIODATA_REENROLMENT;

    raise notice 'copied table nios.FW_BIODATA_REENROLMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_BLOCK', 161 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_BLOCK;

    create foreign table if not exists nios_foreign.FW_BLOCK (
        "fw_block_id" numeric(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "date_of_birth" timestamp,
        "country" varchar(3),
        "type" varchar(1),
        "employer_code" varchar(13),
        "request_comment" varchar(4000),
        "imm_send_ind" varchar(1),
        "can_renew" varchar(5),
        "status" varchar(1),
        "approved_by" numeric(10),
        "approved_date" timestamp,
        "approved_comment" varchar(4000),
        "unblocked_by" numeric,
        "unblocked_date" timestamp,
        "unblocked_comment" varchar(4000),
        "creator_id" numeric(10),
        "created_date" timestamp,
        "isimmblock" varchar(5),
        "unblock_requestby" numeric,
        "unblock_requestdate" timestamp,
        "unblock_request_comment" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_BLOCK');

    raise notice 'created foreign table for FW_BLOCK';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_BLOCK;

    -- create table if not exists nios.FW_BLOCK as select * from nios_foreign.FW_BLOCK;

    raise notice 'copied table nios.FW_BLOCK';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_CHANGE_TRANS', 162 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_CHANGE_TRANS;

    create foreign table if not exists nios_foreign.FW_CHANGE_TRANS (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "table_name" varchar(50),
        "field_name" varchar(50),
        "old_value" varchar(100),
        "new_value" varchar(100),
        "record_version" varchar(10),
        "comments" varchar(255),
        "userid" varchar(20),
        "modify_date" timestamp,
        "ip" varchar(20),
        "module_id" numeric(9)
    ) server nios_server options (schema 'NIOS1', table 'FW_CHANGE_TRANS');

    raise notice 'created foreign table for FW_CHANGE_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_CHANGE_TRANS;

    -- create table if not exists nios.FW_CHANGE_TRANS as select * from nios_foreign.FW_CHANGE_TRANS;

    raise notice 'copied table nios.FW_CHANGE_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_COMMENT', 163 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_COMMENT;

    create foreign table if not exists nios_foreign.FW_COMMENT (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_COMMENT');

    raise notice 'created foreign table for FW_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_COMMENT;

    -- create table if not exists nios.FW_COMMENT as select * from nios_foreign.FW_COMMENT;

    raise notice 'copied table nios.FW_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_COMMENT_HISTORY', 164 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_COMMENT_HISTORY;

    create foreign table if not exists nios_foreign.FW_COMMENT_HISTORY (
        "log_date" timestamp,
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_COMMENT_HISTORY');

    raise notice 'created foreign table for FW_COMMENT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_COMMENT_HISTORY;

    -- create table if not exists nios.FW_COMMENT_HISTORY as select * from nios_foreign.FW_COMMENT_HISTORY;

    raise notice 'copied table nios.FW_COMMENT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_CRITICAL_INFO', 165 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_CRITICAL_INFO;

    create foreign table if not exists nios_foreign.FW_CRITICAL_INFO (
        "fw_critical_id" numeric(10),
        "worker_code" varchar(10),
        "request_date" timestamp,
        "reason" numeric(10),
        "reason_others" varchar(1000),
        "approvedby" numeric(10),
        "approved_date" timestamp,
        "approved_comment" varchar(1000),
        "status" varchar(1),
        "createby" numeric(10),
        "createdate" timestamp,
        "modifyby" numeric(10),
        "modifydate" timestamp,
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'FW_CRITICAL_INFO');

    raise notice 'created foreign table for FW_CRITICAL_INFO';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_CRITICAL_INFO;

    -- create table if not exists nios.FW_CRITICAL_INFO as select * from nios_foreign.FW_CRITICAL_INFO;

    raise notice 'copied table nios.FW_CRITICAL_INFO';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_CRITICAL_INFO_DETAIL', 166 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_CRITICAL_INFO_DETAIL;

    create foreign table if not exists nios_foreign.FW_CRITICAL_INFO_DETAIL (
        "fw_critical_id" numeric(10),
        "critical_column" varchar(100),
        "critical_old" varchar(50),
        "critical_new" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'FW_CRITICAL_INFO_DETAIL');

    raise notice 'created foreign table for FW_CRITICAL_INFO_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_CRITICAL_INFO_DETAIL;

    -- create table if not exists nios.FW_CRITICAL_INFO_DETAIL as select * from nios_foreign.FW_CRITICAL_INFO_DETAIL;

    raise notice 'copied table nios.FW_CRITICAL_INFO_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_DETAIL', 167 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_DETAIL;

    create foreign table if not exists nios_foreign.FW_DETAIL (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_DETAIL');

    raise notice 'created foreign table for FW_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_DETAIL;

    -- create table if not exists nios.FW_DETAIL as select * from nios_foreign.FW_DETAIL;

    raise notice 'copied table nios.FW_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_DETAIL_HISTORY', 168 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_DETAIL_HISTORY;

    create foreign table if not exists nios_foreign.FW_DETAIL_HISTORY (
        "parameter_code" varchar(10),
        "trans_id" varchar(14),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "modification_date" timestamp,
        "parameter_value" varchar(20),
        "action" varchar(10),
        "action_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_DETAIL_HISTORY');

    raise notice 'created foreign table for FW_DETAIL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_DETAIL_HISTORY;

    -- create table if not exists nios.FW_DETAIL_HISTORY as select * from nios_foreign.FW_DETAIL_HISTORY;

    raise notice 'copied table nios.FW_DETAIL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_EXTRA_COMMENTS', 169 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_EXTRA_COMMENTS;

    create foreign table if not exists nios_foreign.FW_EXTRA_COMMENTS (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_EXTRA_COMMENTS');

    raise notice 'created foreign table for FW_EXTRA_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_EXTRA_COMMENTS;

    -- create table if not exists nios.FW_EXTRA_COMMENTS as select * from nios_foreign.FW_EXTRA_COMMENTS;

    raise notice 'copied table nios.FW_EXTRA_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_EXTRA_COMMENTS_HISTORY', 170 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_EXTRA_COMMENTS_HISTORY;

    create foreign table if not exists nios_foreign.FW_EXTRA_COMMENTS_HISTORY (
        "trans_id" varchar(14),
        "log_date" timestamp,
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "action" varchar(10),
        "action_date" timestamp,
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_EXTRA_COMMENTS_HISTORY');

    raise notice 'created foreign table for FW_EXTRA_COMMENTS_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_EXTRA_COMMENTS_HISTORY;

    -- create table if not exists nios.FW_EXTRA_COMMENTS_HISTORY as select * from nios_foreign.FW_EXTRA_COMMENTS_HISTORY;

    raise notice 'copied table nios.FW_EXTRA_COMMENTS_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_MEDBLOCKED', 171 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_MEDBLOCKED;

    create foreign table if not exists nios_foreign.FW_MEDBLOCKED (
        "blk_tranno" varchar(10),
        "receipt_tranno" varchar(10),
        "isblock" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_MEDBLOCKED');

    raise notice 'created foreign table for FW_MEDBLOCKED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_MEDBLOCKED;

    -- create table if not exists nios.FW_MEDBLOCKED as select * from nios_foreign.FW_MEDBLOCKED;

    raise notice 'copied table nios.FW_MEDBLOCKED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_MONITOR', 172 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_MONITOR;

    create foreign table if not exists nios_foreign.FW_MONITOR (
        "monitorid" numeric(10),
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "reason_code" varchar(5),
        "comments" varchar(4000),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "removal_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_MONITOR');

    raise notice 'created foreign table for FW_MONITOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_MONITOR;

    -- create table if not exists nios.FW_MONITOR as select * from nios_foreign.FW_MONITOR;

    raise notice 'copied table nios.FW_MONITOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_MONITOR_REASON', 173 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_MONITOR_REASON;

    create foreign table if not exists nios_foreign.FW_MONITOR_REASON (
        "reason_code" varchar(5),
        "description" varchar(100),
        "capid" numeric(10),
        "shortdesc" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_MONITOR_REASON');

    raise notice 'created foreign table for FW_MONITOR_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_MONITOR_REASON;

    -- create table if not exists nios.FW_MONITOR_REASON as select * from nios_foreign.FW_MONITOR_REASON;

    raise notice 'copied table nios.FW_MONITOR_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_MOVEMENT', 174 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_MOVEMENT;

    create foreign table if not exists nios_foreign.FW_MOVEMENT (
        "id" numeric(19),
        "branch_code" varchar(8),
        "log_date" timestamp,
        "module_code" numeric(10),
        "remarks" varchar(4000),
        "trans_id" varchar(56),
        "userid" varchar(80),
        "worker_code" varchar(1020)
    ) server nios_server options (schema 'NIOS1', table 'FW_MOVEMENT');

    raise notice 'created foreign table for FW_MOVEMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_MOVEMENT;

    -- create table if not exists nios.FW_MOVEMENT as select * from nios_foreign.FW_MOVEMENT;

    raise notice 'copied table nios.FW_MOVEMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_QUARANTINE_REASON', 175 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_QUARANTINE_REASON;

    create foreign table if not exists nios_foreign.FW_QUARANTINE_REASON (
        "trans_id" varchar(14),
        "reason_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_QUARANTINE_REASON');

    raise notice 'created foreign table for FW_QUARANTINE_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_QUARANTINE_REASON;

    -- create table if not exists nios.FW_QUARANTINE_REASON as select * from nios_foreign.FW_QUARANTINE_REASON;

    raise notice 'copied table nios.FW_QUARANTINE_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_QUARANTINE_REASON_HISTORY', 176 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_QUARANTINE_REASON_HISTORY;

    create foreign table if not exists nios_foreign.FW_QUARANTINE_REASON_HISTORY (
        "trans_id" varchar(14),
        "reason_code" varchar(10),
        "log_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_QUARANTINE_REASON_HISTORY');

    raise notice 'created foreign table for FW_QUARANTINE_REASON_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_QUARANTINE_REASON_HISTORY;

    -- create table if not exists nios.FW_QUARANTINE_REASON_HISTORY as select * from nios_foreign.FW_QUARANTINE_REASON_HISTORY;

    raise notice 'copied table nios.FW_QUARANTINE_REASON_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION', 177 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_TRANSACTION;

    create foreign table if not exists nios_foreign.FW_TRANSACTION (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "laboratory_code" varchar(10),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "org_bit" varchar(1),
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "systolic" varchar(6),
        "diastolic" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "imm_ind" varchar(1),
        "renew_ind" varchar(1),
        "qrtn_ind" varchar(1),
        "imm_send_ind" varchar(1),
        "lab_notdone_ind" varchar(1),
        "xray_notdone_ind" varchar(1),
        "release_date" timestamp,
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "imm_send_date" timestamp,
        "user_id" varchar(30),
        "bc_doctor_code" varchar(13),
        "bc_employer_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "version_no" varchar(10),
        "xray_testdone_date" timestamp,
        "taken_drugs" varchar(1),
        "tcupi_ind" varchar(1),
        "lab_specimen_date" timestamp,
        "last_pms_date" timestamp,
        "worker_consent" varchar(1),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "created_by" varchar(30),
        "ismonitor" char(1),
        "doctor_state_code" varchar(7),
        "ply_count" numeric,
        "irr_ind" varchar(1),
        "imr_ind" varchar(1),
        "med_ind" numeric,
        "reg_ind" numeric,
        "xray_film_type" varchar(1),
        "dfit_ind" numeric(1),
        "mfit_ind" numeric(1),
        "xfit_ind" numeric(1),
        "mr" numeric(1),
        "xr" numeric(1),
        "revenue_ind" numeric(1),
        "badpayment_ind" numeric(1),
        "payment_ind" numeric(1),
        "xqrtn_ind" varchar(1),
        "xrelease_date" timestamp,
        "unfit_printed" varchar(1),
        "sex" varchar(1),
        "docfp" numeric(1),
        "docfp_date" timestamp,
        "xrayfp" numeric(1),
        "xrayfp_date" timestamp,
        "plks_no" numeric(3),
        "ispra" numeric(1),
        "lab_specimen_taken_date" timestamp,
        "blood_barcode_no" varchar(20),
        "urine_barcode_no" varchar(20),
        "xray_ref_no" varchar(20),
        "icr_ind" numeric(1),
        "provider_id" varchar(3),
        "xray_upload_status" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'FW_TRANSACTION');

    raise notice 'created foreign table for FW_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_TRANSACTION;

    -- create table if not exists nios.FW_TRANSACTION as select * from nios_foreign.FW_TRANSACTION;

    raise notice 'copied table nios.FW_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_CANCEL', 178 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_TRANSACTION_CANCEL;

    create foreign table if not exists nios_foreign.FW_TRANSACTION_CANCEL (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "laboratory_code" varchar(10),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "org_bit" varchar(1),
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "systolic" varchar(6),
        "diastolic" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "imm_ind" varchar(1),
        "renew_ind" varchar(1),
        "qrtn_ind" varchar(1),
        "imm_send_ind" varchar(1),
        "lab_notdone_ind" varchar(1),
        "xray_notdone_ind" varchar(1),
        "release_date" timestamp,
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "imm_send_date" timestamp,
        "user_id" varchar(30),
        "bc_doctor_code" varchar(13),
        "bc_employer_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "version_no" varchar(10),
        "xray_testdone_date" timestamp,
        "taken_drugs" varchar(1),
        "tcupi_ind" varchar(1),
        "lab_specimen_date" timestamp,
        "last_pms_date" timestamp,
        "worker_consent" varchar(1),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "created_by" varchar(30),
        "ismonitor" char(1),
        "doctor_state_code" varchar(7),
        "ply_count" numeric,
        "irr_ind" varchar(1),
        "imr_ind" varchar(1),
        "med_ind" numeric,
        "reg_ind" numeric,
        "xray_film_type" varchar(1),
        "dfit_ind" numeric(1),
        "mfit_ind" numeric(1),
        "xfit_ind" numeric(1),
        "mr" numeric(1),
        "xr" numeric(1),
        "revenue_ind" numeric(1),
        "badpayment_ind" numeric(1),
        "xqrtn_ind" varchar(1),
        "payment_ind" numeric(1),
        "cancel_by" numeric(10),
        "cancel_date" timestamp,
        "sex" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FW_TRANSACTION_CANCEL');

    raise notice 'created foreign table for FW_TRANSACTION_CANCEL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_TRANSACTION_CANCEL;

    -- create table if not exists nios.FW_TRANSACTION_CANCEL as select * from nios_foreign.FW_TRANSACTION_CANCEL;

    raise notice 'copied table nios.FW_TRANSACTION_CANCEL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_DELETE', 179 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_TRANSACTION_DELETE;

    create foreign table if not exists nios_foreign.FW_TRANSACTION_DELETE (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "laboratory_code" varchar(10),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "org_bit" varchar(1),
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "systolic" varchar(6),
        "diastolic" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "imm_ind" varchar(1),
        "renew_ind" varchar(1),
        "qrtn_ind" varchar(1),
        "imm_send_ind" varchar(1),
        "lab_notdone_ind" varchar(1),
        "xray_notdone_ind" varchar(1),
        "release_date" timestamp,
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "imm_send_date" timestamp,
        "user_id" varchar(30),
        "bc_doctor_code" varchar(13),
        "bc_employer_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "version_no" varchar(10),
        "xray_testdone_date" timestamp,
        "taken_drugs" varchar(1),
        "tcupi_ind" varchar(1),
        "lab_specimen_date" timestamp,
        "last_pms_date" timestamp,
        "worker_consent" varchar(1),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "created_by" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'FW_TRANSACTION_DELETE');

    raise notice 'created foreign table for FW_TRANSACTION_DELETE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_TRANSACTION_DELETE;

    -- create table if not exists nios.FW_TRANSACTION_DELETE as select * from nios_foreign.FW_TRANSACTION_DELETE;

    raise notice 'copied table nios.FW_TRANSACTION_DELETE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_HISTORY', 180 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_TRANSACTION_HISTORY;

    create foreign table if not exists nios_foreign.FW_TRANSACTION_HISTORY (
        "trans_id" varchar(14),
        "log_date" timestamp,
        "worker_code" varchar(10),
        "xray_code" varchar(10),
        "radiologist_code" varchar(10),
        "doctor_code" varchar(10),
        "laboratory_code" varchar(10),
        "employer_code" varchar(10),
        "transdate" timestamp,
        "org_bit" varchar(1),
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "systolic" varchar(6),
        "diastolic" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "imm_ind" varchar(1),
        "renew_ind" varchar(1),
        "qrtn_ind" varchar(1),
        "imm_send_ind" varchar(1),
        "lab_notdone_ind" varchar(1),
        "xray_notdone_ind" varchar(1),
        "release_date" timestamp,
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "imm_send_date" timestamp,
        "user_id" varchar(30),
        "modification_date" timestamp,
        "bc_doctor_code" varchar(13),
        "bc_employer_code" varchar(13),
        "bc_laboratory_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "version_no" varchar(10),
        "xray_testdone_date" timestamp,
        "tcupi_ind" varchar(1),
        "taken_drugs" varchar(1),
        "lab_specimen_date" timestamp,
        "worker_consent" varchar(1),
        "action" varchar(10),
        "action_date" timestamp,
        "last_pms_date" timestamp,
        "modify_id" numeric(10),
        "created_by" varchar(30),
        "ismonitor" char(1),
        "doctor_state_code" varchar(7),
        "ply_count" numeric,
        "irr_ind" varchar(1),
        "imr_ind" varchar(1),
        "med_ind" numeric,
        "reg_ind" numeric,
        "xray_film_type" varchar(1),
        "xqrtn_ind" varchar(1),
        "badpayment_ind" numeric(1),
        "xrelease_date" timestamp,
        "unfit_printed" varchar(1),
        "dfit_ind" numeric(1),
        "mfit_ind" numeric(1),
        "xfit_ind" numeric(1),
        "mr" numeric(1),
        "xr" numeric(1),
        "payment_ind" numeric(1),
        "sex" varchar(1),
        "plks_no" numeric(3),
        "ispra" numeric(1),
        "lab_specimen_taken_date" timestamp,
        "blood_barcode_no" varchar(20),
        "urine_barcode_no" varchar(20),
        "xray_ref_no" varchar(20),
        "provider_id" varchar(3),
        "xray_upload_status" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'FW_TRANSACTION_HISTORY');

    raise notice 'created foreign table for FW_TRANSACTION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_TRANSACTION_HISTORY;

    -- create table if not exists nios.FW_TRANSACTION_HISTORY as select * from nios_foreign.FW_TRANSACTION_HISTORY;

    raise notice 'copied table nios.FW_TRANSACTION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_UPDATE', 181 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_TRANSACTION_UPDATE;

    create foreign table if not exists nios_foreign.FW_TRANSACTION_UPDATE (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "laboratory_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "height" varchar(6),
        "weight" varchar(6),
        "pulse" varchar(6),
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "fit_ind" varchar(1),
        "invalidate_result" varchar(1),
        "invalidate_date" timestamp,
        "username" varchar(30),
        "osuser" varchar(30),
        "machine" varchar(100),
        "action" varchar(9),
        "audit_date" timestamp,
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_TRANSACTION_UPDATE');

    raise notice 'created foreign table for FW_TRANSACTION_UPDATE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_TRANSACTION_UPDATE;

    -- create table if not exists nios.FW_TRANSACTION_UPDATE as select * from nios_foreign.FW_TRANSACTION_UPDATE;

    raise notice 'copied table nios.FW_TRANSACTION_UPDATE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_UNSUITABLE_REASONS', 182 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_UNSUITABLE_REASONS;

    create foreign table if not exists nios_foreign.FW_UNSUITABLE_REASONS (
        "trans_id" varchar(14),
        "unsuitable_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_UNSUITABLE_REASONS');

    raise notice 'created foreign table for FW_UNSUITABLE_REASONS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_UNSUITABLE_REASONS;

    -- create table if not exists nios.FW_UNSUITABLE_REASONS as select * from nios_foreign.FW_UNSUITABLE_REASONS;

    raise notice 'copied table nios.FW_UNSUITABLE_REASONS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_WORKER_REPLACEMENT', 183 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.FW_WORKER_REPLACEMENT;

    create foreign table if not exists nios_foreign.FW_WORKER_REPLACEMENT (
        "wk_tranno" varchar(10),
        "wr_tranno" varchar(10),
        "wk_transid" varchar(14),
        "wr_transid" varchar(14),
        "reason" varchar(4000),
        "creator_id" numeric(10),
        "create_date" timestamp,
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "status" varchar(1),
        "worker_code" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'FW_WORKER_REPLACEMENT');

    raise notice 'created foreign table for FW_WORKER_REPLACEMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.FW_WORKER_REPLACEMENT;

    -- create table if not exists nios.FW_WORKER_REPLACEMENT as select * from nios_foreign.FW_WORKER_REPLACEMENT;

    raise notice 'copied table nios.FW_WORKER_REPLACEMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_DETAILS', 184 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_DETAILS;

    create foreign table if not exists nios_foreign.GROUP_DETAILS (
        "group_code" varchar(6),
        "group_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "district_name" varchar(40),
        "state_name" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'GROUP_DETAILS');

    raise notice 'created foreign table for GROUP_DETAILS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_DETAILS;

    -- create table if not exists nios.GROUP_DETAILS as select * from nios_foreign.GROUP_DETAILS;

    raise notice 'copied table nios.GROUP_DETAILS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_DOCTOR_PAY', 185 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_DOCTOR_PAY;

    create foreign table if not exists nios_foreign.GROUP_DOCTOR_PAY (
        "group_code" varchar(6),
        "pay_ind" varchar(1),
        "doctor_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_DOCTOR_PAY');

    raise notice 'created foreign table for GROUP_DOCTOR_PAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_DOCTOR_PAY;

    -- create table if not exists nios.GROUP_DOCTOR_PAY as select * from nios_foreign.GROUP_DOCTOR_PAY;

    raise notice 'copied table nios.GROUP_DOCTOR_PAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_DOCTOR_PAY_HISTORY', 186 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_DOCTOR_PAY_HISTORY;

    create foreign table if not exists nios_foreign.GROUP_DOCTOR_PAY_HISTORY (
        "group_code" varchar(6),
        "doctor_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp,
        "action" varchar(6),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_DOCTOR_PAY_HISTORY');

    raise notice 'created foreign table for GROUP_DOCTOR_PAY_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_DOCTOR_PAY_HISTORY;

    -- create table if not exists nios.GROUP_DOCTOR_PAY_HISTORY as select * from nios_foreign.GROUP_DOCTOR_PAY_HISTORY;

    raise notice 'copied table nios.GROUP_DOCTOR_PAY_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_WORKER', 187 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_WORKER;

    create foreign table if not exists nios_foreign.GROUP_WORKER (
        "passport" varchar(20),
        "country" varchar(3),
        "creation_date" timestamp,
        "name" varchar(60),
        "sex" varchar(1),
        "modify_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'GROUP_WORKER');

    raise notice 'created foreign table for GROUP_WORKER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_WORKER;

    -- create table if not exists nios.GROUP_WORKER as select * from nios_foreign.GROUP_WORKER;

    raise notice 'copied table nios.GROUP_WORKER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_XRAY_PAY', 188 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_XRAY_PAY;

    create foreign table if not exists nios_foreign.GROUP_XRAY_PAY (
        "group_code" varchar(6),
        "pay_ind" varchar(1),
        "xray_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_XRAY_PAY');

    raise notice 'created foreign table for GROUP_XRAY_PAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_XRAY_PAY;

    -- create table if not exists nios.GROUP_XRAY_PAY as select * from nios_foreign.GROUP_XRAY_PAY;

    raise notice 'copied table nios.GROUP_XRAY_PAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table GROUP_XRAY_PAY_HISTORY', 189 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.GROUP_XRAY_PAY_HISTORY;

    create foreign table if not exists nios_foreign.GROUP_XRAY_PAY_HISTORY (
        "group_code" varchar(6),
        "pay_ind" varchar(1),
        "xray_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp,
        "action" varchar(6),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_XRAY_PAY_HISTORY');

    raise notice 'created foreign table for GROUP_XRAY_PAY_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.GROUP_XRAY_PAY_HISTORY;

    -- create table if not exists nios.GROUP_XRAY_PAY_HISTORY as select * from nios_foreign.GROUP_XRAY_PAY_HISTORY;

    raise notice 'copied table nios.GROUP_XRAY_PAY_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ICON_MASTER', 190 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ICON_MASTER;

    create foreign table if not exists nios_foreign.ICON_MASTER (
        "iconid" numeric(10),
        "parenticonid" numeric(10),
        "isfolder" varchar(5),
        "icondesc" varchar(255),
        "capid" numeric(10),
        "identifier" numeric(10),
        "imagefile1" varchar(50),
        "imagefile2" varchar(50),
        "contextname" varchar(50),
        "indexpage" varchar(50),
        "parameter" varchar(200),
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ICON_MASTER');

    raise notice 'created foreign table for ICON_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ICON_MASTER;

    -- create table if not exists nios.ICON_MASTER as select * from nios_foreign.ICON_MASTER;

    raise notice 'copied table nios.ICON_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table IMM_BLOCK_WORKERS', 191 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.IMM_BLOCK_WORKERS;

    create foreign table if not exists nios_foreign.IMM_BLOCK_WORKERS (
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'IMM_BLOCK_WORKERS');

    raise notice 'created foreign table for IMM_BLOCK_WORKERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.IMM_BLOCK_WORKERS;

    -- create table if not exists nios.IMM_BLOCK_WORKERS as select * from nios_foreign.IMM_BLOCK_WORKERS;

    raise notice 'copied table nios.IMM_BLOCK_WORKERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table IMM_MED_RECEIVE', 192 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.IMM_MED_RECEIVE;

    create foreign table if not exists nios_foreign.IMM_MED_RECEIVE (
        "jim_doc_no" varchar(20),
        "jim_nat" varchar(3),
        "jim_dob" timestamp,
        "jim_name" varchar(60),
        "jim_sex" varchar(1),
        "jim_medsts" varchar(1),
        "jim_meddt" timestamp,
        "jim_respond_flag" varchar(1),
        "jim_respond" varchar(50),
        "jim_receive" timestamp
    ) server nios_server options (schema 'NIOS1', table 'IMM_MED_RECEIVE');

    raise notice 'created foreign table for IMM_MED_RECEIVE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.IMM_MED_RECEIVE;

    -- create table if not exists nios.IMM_MED_RECEIVE as select * from nios_foreign.IMM_MED_RECEIVE;

    raise notice 'copied table nios.IMM_MED_RECEIVE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table IMM_MED_SEND', 193 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.IMM_MED_SEND;

    create foreign table if not exists nios_foreign.IMM_MED_SEND (
        "imm_doc_no" varchar(15),
        "imm_nat" varchar(3),
        "imm_dob" timestamp,
        "imm_name" varchar(60),
        "imm_sex" varchar(1),
        "imm_medsts" varchar(1),
        "imm_meddt" timestamp,
        "imm_moddt" timestamp,
        "imm_send" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'IMM_MED_SEND');

    raise notice 'created foreign table for IMM_MED_SEND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.IMM_MED_SEND;

    -- create table if not exists nios.IMM_MED_SEND as select * from nios_foreign.IMM_MED_SEND;

    raise notice 'copied table nios.IMM_MED_SEND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table INACTIVE_DOCTORS', 194 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.INACTIVE_DOCTORS;

    create foreign table if not exists nios_foreign.INACTIVE_DOCTORS (
        "doctor_code" varchar(10),
        "date_of_inactive" timestamp,
        "reason" varchar(500)
    ) server nios_server options (schema 'NIOS1', table 'INACTIVE_DOCTORS');

    raise notice 'created foreign table for INACTIVE_DOCTORS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.INACTIVE_DOCTORS;

    -- create table if not exists nios.INACTIVE_DOCTORS as select * from nios_foreign.INACTIVE_DOCTORS;

    raise notice 'copied table nios.INACTIVE_DOCTORS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table IND_MASTER', 195 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.IND_MASTER;

    create foreign table if not exists nios_foreign.IND_MASTER (
        "ind" varchar(1),
        "req_type" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'IND_MASTER');

    raise notice 'created foreign table for IND_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.IND_MASTER;

    -- create table if not exists nios.IND_MASTER as select * from nios_foreign.IND_MASTER;

    raise notice 'copied table nios.IND_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table INVOICE_DETAIL', 196 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.INVOICE_DETAIL;

    create foreign table if not exists nios_foreign.INVOICE_DETAIL (
        "invoice_no" varchar(20),
        "service_provider_code" varchar(10),
        "trans_id" varchar(14),
        "member_code" varchar(10),
        "sex" varchar(1),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'INVOICE_DETAIL');

    raise notice 'created foreign table for INVOICE_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.INVOICE_DETAIL;

    -- create table if not exists nios.INVOICE_DETAIL as select * from nios_foreign.INVOICE_DETAIL;

    raise notice 'copied table nios.INVOICE_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table INVOICE_MASTER', 197 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.INVOICE_MASTER;

    create foreign table if not exists nios_foreign.INVOICE_MASTER (
        "invoice_no" varchar(20),
        "service_provider_code" varchar(10),
        "status" char(1),
        "bill_amount" numeric(10, 2),
        "gst_amount" numeric(10, 2),
        "invoice_amount" numeric(10, 2),
        "invoice_rounding_amount" numeric(10, 2),
        "group_invoice" char(1),
        "service_providers_group_id" numeric,
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "gst_type" numeric(10),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modification_date" timestamp,
        "batch_number" numeric
    ) server nios_server options (schema 'NIOS1', table 'INVOICE_MASTER');

    raise notice 'created foreign table for INVOICE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.INVOICE_MASTER;

    -- create table if not exists nios.INVOICE_MASTER as select * from nios_foreign.INVOICE_MASTER;

    raise notice 'copied table nios.INVOICE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table JOBTYPE_MASTER', 198 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.JOBTYPE_MASTER;

    create foreign table if not exists nios_foreign.JOBTYPE_MASTER (
        "job_type" varchar(40),
        "description" varchar(255),
        "status_code" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'JOBTYPE_MASTER');

    raise notice 'created foreign table for JOBTYPE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.JOBTYPE_MASTER;

    -- create table if not exists nios.JOBTYPE_MASTER as select * from nios_foreign.JOBTYPE_MASTER;

    raise notice 'copied table nios.JOBTYPE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table JOB_LOG', 199 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.JOB_LOG;

    create foreign table if not exists nios_foreign.JOB_LOG (
        "job_id" numeric,
        "start_time" timestamp,
        "end_time" timestamp
    ) server nios_server options (schema 'NIOS1', table 'JOB_LOG');

    raise notice 'created foreign table for JOB_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.JOB_LOG;

    -- create table if not exists nios.JOB_LOG as select * from nios_foreign.JOB_LOG;

    raise notice 'copied table nios.JOB_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABORATORY_GROUP', 200 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABORATORY_GROUP;

    create foreign table if not exists nios_foreign.LABORATORY_GROUP (
        "lab_group" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_GROUP');

    raise notice 'created foreign table for LABORATORY_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABORATORY_GROUP;

    -- create table if not exists nios.LABORATORY_GROUP as select * from nios_foreign.LABORATORY_GROUP;

    raise notice 'copied table nios.LABORATORY_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABORATORY_HISTORY', 201 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABORATORY_HISTORY;

    create foreign table if not exists nios_foreign.LABORATORY_HISTORY (
        "laboratory_code" varchar(10),
        "version_no" varchar(10),
        "creation_date" timestamp,
        "laboratory_name" varchar(50),
        "registration_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone" varchar(20),
        "lab_type" varchar(1),
        "qualification" varchar(50),
        "comments" varchar(4000),
        "district_name" varchar(40),
        "modification_date" timestamp,
        "bc_laboratory_code" varchar(13),
        "status_code" varchar(5),
        "nearest_district_office" varchar(7),
        "classification" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "lab_group" varchar(2),
        "grade_point" numeric(3),
        "license" varchar(20),
        "license_year" varchar(4),
        "lregid" numeric(10),
        "action" varchar(10),
        "action_date" timestamp,
        "web_service_access" char(1),
        "passphrase" varchar(100),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "laboratory_logo" varchar(50),
        "web_taxinvoice" numeric(1),
        "bank_code" varchar(8),
        "gst_type" numeric(1),
        "gst_effective_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_HISTORY');

    raise notice 'created foreign table for LABORATORY_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABORATORY_HISTORY;

    -- create table if not exists nios.LABORATORY_HISTORY as select * from nios_foreign.LABORATORY_HISTORY;

    raise notice 'copied table nios.LABORATORY_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABORATORY_MASTER', 202 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABORATORY_MASTER;

    create foreign table if not exists nios_foreign.LABORATORY_MASTER (
        "laboratory_code" varchar(10),
        "laboratory_name" varchar(50),
        "creation_date" timestamp,
        "registration_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone" varchar(20),
        "lab_type" varchar(1),
        "version_no" varchar(10),
        "qualification" varchar(50),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "bc_laboratory_code" varchar(13),
        "nearest_district_office" varchar(7),
        "classification" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "lab_group" varchar(2),
        "grade_point" numeric(3),
        "license" varchar(20),
        "license_year" varchar(4),
        "lregid" numeric(10),
        "web_service_access" char(1),
        "passphrase" varchar(100),
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "laboratory_logo" varchar(50),
        "web_taxinvoice" numeric(1),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "gst_effective_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_MASTER');

    raise notice 'created foreign table for LABORATORY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABORATORY_MASTER;

    -- create table if not exists nios.LABORATORY_MASTER as select * from nios_foreign.LABORATORY_MASTER;

    raise notice 'copied table nios.LABORATORY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABORATORY_REGISTRATION', 203 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABORATORY_REGISTRATION;

    create foreign table if not exists nios_foreign.LABORATORY_REGISTRATION (
        "lregid" numeric(10),
        "laboratory_name" varchar(50),
        "registration_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone" varchar(20),
        "lab_type" varchar(1),
        "lab_group" varchar(2),
        "qualification" varchar(50),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "tranno" varchar(10),
        "license" varchar(20),
        "license_year" varchar(4),
        "nearest_district_office" varchar(7),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_REGISTRATION');

    raise notice 'created foreign table for LABORATORY_REGISTRATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABORATORY_REGISTRATION;

    -- create table if not exists nios.LABORATORY_REGISTRATION as select * from nios_foreign.LABORATORY_REGISTRATION;

    raise notice 'copied table nios.LABORATORY_REGISTRATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABORATORY_REQUEST', 204 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABORATORY_REQUEST;

    create foreign table if not exists nios_foreign.LABORATORY_REQUEST (
        "lregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_REQUEST');

    raise notice 'created foreign table for LABORATORY_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABORATORY_REQUEST;

    -- create table if not exists nios.LABORATORY_REQUEST as select * from nios_foreign.LABORATORY_REQUEST;

    raise notice 'copied table nios.LABORATORY_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABUAN_G_WORKERS', 205 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABUAN_G_WORKERS;

    create foreign table if not exists nios_foreign.LABUAN_G_WORKERS (
        "worker_code" varchar(10),
        "created_by" varchar(30),
        "transdate" timestamp,
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'LABUAN_G_WORKERS');

    raise notice 'created foreign table for LABUAN_G_WORKERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABUAN_G_WORKERS;

    -- create table if not exists nios.LABUAN_G_WORKERS as select * from nios_foreign.LABUAN_G_WORKERS;

    raise notice 'copied table nios.LABUAN_G_WORKERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LABWS_APPLICATIONID', 206 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LABWS_APPLICATIONID;

    create foreign table if not exists nios_foreign.LABWS_APPLICATIONID (
        "appid" varchar(3),
        "active" char(1),
        "description" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'LABWS_APPLICATIONID');

    raise notice 'created foreign table for LABWS_APPLICATIONID';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LABWS_APPLICATIONID;

    -- create table if not exists nios.LABWS_APPLICATIONID as select * from nios_foreign.LABWS_APPLICATIONID;

    raise notice 'copied table nios.LABWS_APPLICATIONID';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAB_CHANGE_REQUEST', 207 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAB_CHANGE_REQUEST;

    create foreign table if not exists nios_foreign.LAB_CHANGE_REQUEST (
        "lab_cr_id" numeric(10),
        "lab_code" varchar(10),
        "request_date" timestamp,
        "request_comment" varchar(1000),
        "status" varchar(20),
        "approvedby" numeric(10),
        "approved_date" timestamp,
        "approved_comment" varchar(1000),
        "createby" numeric(10),
        "createdate" timestamp,
        "modifyby" numeric(10),
        "modifydate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAB_CHANGE_REQUEST');

    raise notice 'created foreign table for LAB_CHANGE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAB_CHANGE_REQUEST;

    -- create table if not exists nios.LAB_CHANGE_REQUEST as select * from nios_foreign.LAB_CHANGE_REQUEST;

    raise notice 'copied table nios.LAB_CHANGE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAB_CHANGE_REQUEST_DETAIL', 208 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAB_CHANGE_REQUEST_DETAIL;

    create foreign table if not exists nios_foreign.LAB_CHANGE_REQUEST_DETAIL (
        "lab_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'LAB_CHANGE_REQUEST_DETAIL');

    raise notice 'created foreign table for LAB_CHANGE_REQUEST_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAB_CHANGE_REQUEST_DETAIL;

    -- create table if not exists nios.LAB_CHANGE_REQUEST_DETAIL as select * from nios_foreign.LAB_CHANGE_REQUEST_DETAIL;

    raise notice 'copied table nios.LAB_CHANGE_REQUEST_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAB_PAYMENT', 209 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAB_PAYMENT;

    create foreign table if not exists nios_foreign.LAB_PAYMENT (
        "trans_id" varchar(14),
        "lab_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAB_PAYMENT');

    raise notice 'created foreign table for LAB_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAB_PAYMENT;

    -- create table if not exists nios.LAB_PAYMENT as select * from nios_foreign.LAB_PAYMENT;

    raise notice 'copied table nios.LAB_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAB_RATES_MASTER', 210 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAB_RATES_MASTER;

    create foreign table if not exists nios_foreign.LAB_RATES_MASTER (
        "lab_code" varchar(10),
        "male" numeric(6, 2),
        "female" numeric(6, 2)
    ) server nios_server options (schema 'NIOS1', table 'LAB_RATES_MASTER');

    raise notice 'created foreign table for LAB_RATES_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAB_RATES_MASTER;

    -- create table if not exists nios.LAB_RATES_MASTER as select * from nios_foreign.LAB_RATES_MASTER;

    raise notice 'copied table nios.LAB_RATES_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAST_MONITOR', 211 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAST_MONITOR;

    create foreign table if not exists nios_foreign.LAST_MONITOR (
        "monitor_type" varchar(50),
        "last_run" timestamp,
        "last_start" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_MONITOR');

    raise notice 'created foreign table for LAST_MONITOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAST_MONITOR;

    -- create table if not exists nios.LAST_MONITOR as select * from nios_foreign.LAST_MONITOR;

    raise notice 'copied table nios.LAST_MONITOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAST_REV_SYNC', 212 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAST_REV_SYNC;

    create foreign table if not exists nios_foreign.LAST_REV_SYNC (
        "table_name" varchar(100),
        "sync_start" timestamp,
        "sync_end" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_REV_SYNC');

    raise notice 'created foreign table for LAST_REV_SYNC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAST_REV_SYNC;

    -- create table if not exists nios.LAST_REV_SYNC as select * from nios_foreign.LAST_REV_SYNC;

    raise notice 'copied table nios.LAST_REV_SYNC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LAST_SYNC', 213 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LAST_SYNC;

    create foreign table if not exists nios_foreign.LAST_SYNC (
        "table_name" varchar(100),
        "sync_start" timestamp,
        "sync_end" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_SYNC');

    raise notice 'created foreign table for LAST_SYNC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LAST_SYNC;

    -- create table if not exists nios.LAST_SYNC as select * from nios_foreign.LAST_SYNC;

    raise notice 'copied table nios.LAST_SYNC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LETTER_MONITOR', 214 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LETTER_MONITOR;

    create foreign table if not exists nios_foreign.LETTER_MONITOR (
        "id" numeric,
        "report_id" varchar(20),
        "sp_type" varchar(2),
        "sp_code" varchar(10),
        "sp_name" varchar(50),
        "state_code" varchar(20),
        "reference_no" varchar(20),
        "visit_letter" varchar(2),
        "visit_date" timestamp,
        "prepared_by" varchar(20),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "sp_code2" varchar(10),
        "report_id2" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'LETTER_MONITOR');

    raise notice 'created foreign table for LETTER_MONITOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LETTER_MONITOR;

    -- create table if not exists nios.LETTER_MONITOR as select * from nios_foreign.LETTER_MONITOR;

    raise notice 'copied table nios.LETTER_MONITOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LETTER_MONITOR_DETAIL', 215 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LETTER_MONITOR_DETAIL;

    create foreign table if not exists nios_foreign.LETTER_MONITOR_DETAIL (
        "letter_monitor_id" numeric,
        "nc_letter" varchar(2),
        "nc_date" timestamp,
        "reminder_letter" varchar(2),
        "reminder_date" timestamp,
        "reply_letter" varchar(2),
        "reply_date" timestamp,
        "mspd_letter" varchar(2),
        "mspd_date" timestamp,
        "mspc_letter" varchar(2),
        "mspc_date" timestamp,
        "reprimand_letter" varchar(2),
        "reprimand_date" timestamp,
        "suspension_letter" varchar(2),
        "suspension_date" timestamp,
        "other_letter" varchar(2),
        "other_date" timestamp,
        "remarks" varchar(4000),
        "id" varchar(20),
        "status" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'LETTER_MONITOR_DETAIL');

    raise notice 'created foreign table for LETTER_MONITOR_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LETTER_MONITOR_DETAIL;

    -- create table if not exists nios.LETTER_MONITOR_DETAIL as select * from nios_foreign.LETTER_MONITOR_DETAIL;

    raise notice 'copied table nios.LETTER_MONITOR_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LOAD_INFO', 216 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LOAD_INFO;

    create foreign table if not exists nios_foreign.LOAD_INFO (
        "last_exam_date" timestamp,
        "passport_no" varchar(20),
        "fit_ind" varchar(1),
        "arrival_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LOAD_INFO');

    raise notice 'created foreign table for LOAD_INFO';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LOAD_INFO;

    -- create table if not exists nios.LOAD_INFO as select * from nios_foreign.LOAD_INFO;

    raise notice 'copied table nios.LOAD_INFO';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LOG_MASTER', 217 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LOG_MASTER;

    create foreign table if not exists nios_foreign.LOG_MASTER (
        "id" numeric,
        "uuid" numeric(10),
        "ip" varchar(20),
        "moduleid" numeric(10),
        "pageid" numeric(10),
        "action" varchar(4000),
        "action_type" varchar(5),
        "logdate" timestamp,
        "client_name" varchar(50),
        "client_ip" varchar(255),
        "client_mac" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'LOG_MASTER');

    raise notice 'created foreign table for LOG_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LOG_MASTER;

    -- create table if not exists nios.LOG_MASTER as select * from nios_foreign.LOG_MASTER;

    raise notice 'copied table nios.LOG_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LOG_MASTER_ARC', 218 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LOG_MASTER_ARC;

    create foreign table if not exists nios_foreign.LOG_MASTER_ARC (
        "uuid" numeric(10),
        "ip" varchar(20),
        "moduleid" numeric(10),
        "pageid" numeric(10),
        "action" varchar(4000),
        "action_type" varchar(5),
        "logdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LOG_MASTER_ARC');

    raise notice 'created foreign table for LOG_MASTER_ARC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LOG_MASTER_ARC;

    -- create table if not exists nios.LOG_MASTER_ARC as select * from nios_foreign.LOG_MASTER_ARC;

    raise notice 'copied table nios.LOG_MASTER_ARC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LQCC_COMMENTS', 219 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LQCC_COMMENTS;

    create foreign table if not exists nios_foreign.LQCC_COMMENTS (
        "lq_commentid" numeric(10),
        "lqccid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LQCC_COMMENTS');

    raise notice 'created foreign table for LQCC_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LQCC_COMMENTS;

    -- create table if not exists nios.LQCC_COMMENTS as select * from nios_foreign.LQCC_COMMENTS;

    raise notice 'copied table nios.LQCC_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table LQCC_REPORT', 220 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.LQCC_REPORT;

    create foreign table if not exists nios_foreign.LQCC_REPORT (
        "lqccid" numeric(10),
        "reference_no" varchar(20),
        "trans_id" varchar(14),
        "bc_laboratory_code" varchar(13),
        "bc_worker_code" varchar(13),
        "date_received" timestamp,
        "isquestionable" varchar(5),
        "date_questionable" timestamp,
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LQCC_REPORT');

    raise notice 'created foreign table for LQCC_REPORT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.LQCC_REPORT;

    -- create table if not exists nios.LQCC_REPORT as select * from nios_foreign.LQCC_REPORT;

    raise notice 'copied table nios.LQCC_REPORT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MAXIGRID', 221 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MAXIGRID;

    create foreign table if not exists nios_foreign.MAXIGRID (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "sex" char(1),
        "bank_code" varchar(8),
        "status" varchar(5),
        "date_issued" timestamp,
        "date_imported" timestamp,
        "certify_date" timestamp,
        "bc_doctor_code" varchar(13),
        "doctor_amount" numeric(10, 2),
        "doctor_cheque" varchar(20),
        "bc_xray_code" varchar(13),
        "xray_amount" numeric(10, 2),
        "xray_cheque" varchar(20),
        "bc_lab_code" varchar(13),
        "lab_amount" numeric(10, 2),
        "lab_cheque" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'MAXIGRID');

    raise notice 'created foreign table for MAXIGRID';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MAXIGRID;

    -- create table if not exists nios.MAXIGRID as select * from nios_foreign.MAXIGRID;

    raise notice 'copied table nios.MAXIGRID';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MERTS_DOC_STARTPAGE_STATS', 222 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MERTS_DOC_STARTPAGE_STATS;

    create foreign table if not exists nios_foreign.MERTS_DOC_STARTPAGE_STATS (
        "doctor_code" varchar(10),
        "delayed_transmission" numeric,
        "delayed_transmission_14" numeric,
        "delayed_certification" numeric,
        "delayed_certification_2" numeric,
        "delayed_appeal" numeric,
        "delayed_appeal_21" numeric,
        "delayed_review" numeric,
        "delayed_review_14" numeric,
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MERTS_DOC_STARTPAGE_STATS');

    raise notice 'created foreign table for MERTS_DOC_STARTPAGE_STATS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MERTS_DOC_STARTPAGE_STATS;

    -- create table if not exists nios.MERTS_DOC_STARTPAGE_STATS as select * from nios_foreign.MERTS_DOC_STARTPAGE_STATS;

    raise notice 'copied table nios.MERTS_DOC_STARTPAGE_STATS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MERTS_LAB_STARTPAGE_STATS', 223 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MERTS_LAB_STARTPAGE_STATS;

    create foreign table if not exists nios_foreign.MERTS_LAB_STARTPAGE_STATS (
        "lab_code" varchar(10),
        "delayed_transmission" numeric,
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MERTS_LAB_STARTPAGE_STATS');

    raise notice 'created foreign table for MERTS_LAB_STARTPAGE_STATS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MERTS_LAB_STARTPAGE_STATS;

    -- create table if not exists nios.MERTS_LAB_STARTPAGE_STATS as select * from nios_foreign.MERTS_LAB_STARTPAGE_STATS;

    raise notice 'copied table nios.MERTS_LAB_STARTPAGE_STATS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MERTS_XRAY_STARTPAGE_STATS', 224 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MERTS_XRAY_STARTPAGE_STATS;

    create foreign table if not exists nios_foreign.MERTS_XRAY_STARTPAGE_STATS (
        "xray_code" varchar(10),
        "delayed_transmission" numeric,
        "film_notyet_send" numeric,
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MERTS_XRAY_STARTPAGE_STATS');

    raise notice 'created foreign table for MERTS_XRAY_STARTPAGE_STATS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MERTS_XRAY_STARTPAGE_STATS;

    -- create table if not exists nios.MERTS_XRAY_STARTPAGE_STATS as select * from nios_foreign.MERTS_XRAY_STARTPAGE_STATS;

    raise notice 'copied table nios.MERTS_XRAY_STARTPAGE_STATS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MISSING_PAYMENT', 225 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MISSING_PAYMENT;

    create foreign table if not exists nios_foreign.MISSING_PAYMENT (
        "missingpayment_id" numeric,
        "reporter_name" varchar(100),
        "reporter_contact" varchar(30),
        "reporter_icpassport" varchar(20),
        "police_reportno" varchar(30),
        "document_no" varchar(20),
        "bank_code" varchar(8),
        "issue_date" timestamp,
        "amount" numeric(10, 2),
        "place_of_issue" varchar(50),
        "name_on_card" varchar(100),
        "expiry_date" timestamp,
        "status" char(1),
        "insertion_comments" varchar(4000),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "removal_comments" varchar(4000),
        "modify_id" varchar(20),
        "modify_date" timestamp,
        "payment_type" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'MISSING_PAYMENT');

    raise notice 'created foreign table for MISSING_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MISSING_PAYMENT;

    -- create table if not exists nios.MISSING_PAYMENT as select * from nios_foreign.MISSING_PAYMENT;

    raise notice 'copied table nios.MISSING_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MODULE_MASTER', 226 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MODULE_MASTER;

    create foreign table if not exists nios_foreign.MODULE_MASTER (
        "moduleid" numeric(10),
        "modulename" varchar(50),
        "description" varchar(255),
        "capid" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MODULE_MASTER');

    raise notice 'created foreign table for MODULE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MODULE_MASTER;

    -- create table if not exists nios.MODULE_MASTER as select * from nios_foreign.MODULE_MASTER;

    raise notice 'copied table nios.MODULE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MODULE_PAGE', 227 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MODULE_PAGE;

    create foreign table if not exists nios_foreign.MODULE_PAGE (
        "pageid" numeric(10),
        "moduleid" numeric(10),
        "filename" varchar(50),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MODULE_PAGE');

    raise notice 'created foreign table for MODULE_PAGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MODULE_PAGE;

    -- create table if not exists nios.MODULE_PAGE as select * from nios_foreign.MODULE_PAGE;

    raise notice 'copied table nios.MODULE_PAGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_DOC_REPORT', 228 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MOH_DOC_REPORT;

    create foreign table if not exists nios_foreign.MOH_DOC_REPORT (
        "state_name" varchar(20),
        "slab0" numeric(6),
        "slab20" numeric(6),
        "slab50" numeric(6),
        "slab100" numeric(6),
        "slab200" numeric(6),
        "slab300" numeric(6),
        "slab400" numeric(6),
        "slab500" numeric(6),
        "slab600" numeric(6),
        "slab700" numeric(6),
        "slab800" numeric(6),
        "slab900" numeric(6),
        "slab1000" numeric(6),
        "slab1kplus" numeric(6)
    ) server nios_server options (schema 'NIOS1', table 'MOH_DOC_REPORT');

    raise notice 'created foreign table for MOH_DOC_REPORT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MOH_DOC_REPORT;

    -- create table if not exists nios.MOH_DOC_REPORT as select * from nios_foreign.MOH_DOC_REPORT;

    raise notice 'copied table nios.MOH_DOC_REPORT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_DOC_STAT', 229 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MOH_DOC_STAT;

    create foreign table if not exists nios_foreign.MOH_DOC_STAT (
        "state_name" varchar(20),
        "slab0" numeric(6),
        "slab20" numeric(6),
        "slab50" numeric(6),
        "slab100" numeric(6),
        "slab200" numeric(6),
        "slab300" numeric(6),
        "slab400" numeric(6),
        "slab500" numeric(6),
        "slab600" numeric(6),
        "slab700" numeric(6),
        "slab800" numeric(6),
        "slab900" numeric(6),
        "slab1000" numeric(6),
        "slab1kplus" numeric(6)
    ) server nios_server options (schema 'NIOS1', table 'MOH_DOC_STAT');

    raise notice 'created foreign table for MOH_DOC_STAT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MOH_DOC_STAT;

    -- create table if not exists nios.MOH_DOC_STAT as select * from nios_foreign.MOH_DOC_STAT;

    raise notice 'copied table nios.MOH_DOC_STAT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_MASTER_QUOTA', 230 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MOH_MASTER_QUOTA;

    create foreign table if not exists nios_foreign.MOH_MASTER_QUOTA (
        "quota_type" varchar(20),
        "apply_to" varchar(10),
        "quota" numeric,
        "comments" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'MOH_MASTER_QUOTA');

    raise notice 'created foreign table for MOH_MASTER_QUOTA';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MOH_MASTER_QUOTA;

    -- create table if not exists nios.MOH_MASTER_QUOTA as select * from nios_foreign.MOH_MASTER_QUOTA;

    raise notice 'copied table nios.MOH_MASTER_QUOTA';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MONITORING', 231 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MONITORING;

    create foreign table if not exists nios_foreign.MONITORING (
        "worker_code" varchar(10),
        "worker_name" varchar(30),
        "passport_no" varchar(10),
        "renewal_date" timestamp,
        "certify_date" timestamp,
        "status" varchar(5),
        "remarks" varchar(200)
    ) server nios_server options (schema 'NIOS1', table 'MONITORING');

    raise notice 'created foreign table for MONITORING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MONITORING;

    -- create table if not exists nios.MONITORING as select * from nios_foreign.MONITORING;

    raise notice 'copied table nios.MONITORING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MONITOR_EXAM', 232 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MONITOR_EXAM;

    create foreign table if not exists nios_foreign.MONITOR_EXAM (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "issue_letter_ind" varchar(1),
        "issue_date" timestamp,
        "ins_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MONITOR_EXAM');

    raise notice 'created foreign table for MONITOR_EXAM';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MONITOR_EXAM;

    -- create table if not exists nios.MONITOR_EXAM as select * from nios_foreign.MONITOR_EXAM;

    raise notice 'copied table nios.MONITOR_EXAM';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MYIMMS_COUNTRY_MASTER', 233 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MYIMMS_COUNTRY_MASTER;

    create foreign table if not exists nios_foreign.MYIMMS_COUNTRY_MASTER (
        "nios_country_code" varchar(3),
        "myimms_country_code" varchar(3),
        "country_name" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'MYIMMS_COUNTRY_MASTER');

    raise notice 'created foreign table for MYIMMS_COUNTRY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MYIMMS_COUNTRY_MASTER;

    -- create table if not exists nios.MYIMMS_COUNTRY_MASTER as select * from nios_foreign.MYIMMS_COUNTRY_MASTER;

    raise notice 'copied table nios.MYIMMS_COUNTRY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MYIMMS_MON_TCUPI', 234 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MYIMMS_MON_TCUPI;

    create foreign table if not exists nios_foreign.MYIMMS_MON_TCUPI (
        "trans_id" varchar(14),
        "passport_no" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'MYIMMS_MON_TCUPI');

    raise notice 'created foreign table for MYIMMS_MON_TCUPI';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MYIMMS_MON_TCUPI;

    -- create table if not exists nios.MYIMMS_MON_TCUPI as select * from nios_foreign.MYIMMS_MON_TCUPI;

    raise notice 'copied table nios.MYIMMS_MON_TCUPI';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MYIMMS_QUEUE', 235 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MYIMMS_QUEUE;

    create foreign table if not exists nios_foreign.MYIMMS_QUEUE (
        "batch_num" numeric,
        "trans_id" varchar(14),
        "passport_no" varchar(20),
        "nationality" varchar(3),
        "date_of_birth" varchar(8),
        "name" varchar(150),
        "sex" varchar(1),
        "exam_date" varchar(8),
        "medical_status" varchar(1),
        "modify_date" timestamp,
        "is_labuan" char(1),
        "queue_date" timestamp,
        "queue_op" varchar(1),
        "queue_by" varchar(50),
        "myimms_reply" varchar(1),
        "myimms_error" varchar(255),
        "reply_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MYIMMS_QUEUE');

    raise notice 'created foreign table for MYIMMS_QUEUE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MYIMMS_QUEUE;

    -- create table if not exists nios.MYIMMS_QUEUE as select * from nios_foreign.MYIMMS_QUEUE;

    raise notice 'copied table nios.MYIMMS_QUEUE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MYIMMS_QUEUE_HIST', 236 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MYIMMS_QUEUE_HIST;

    create foreign table if not exists nios_foreign.MYIMMS_QUEUE_HIST (
        "batch_num" numeric,
        "trans_id" varchar(14),
        "passport_no" varchar(20),
        "nationality" varchar(3),
        "date_of_birth" varchar(8),
        "name" varchar(150),
        "sex" varchar(1),
        "exam_date" varchar(8),
        "medical_status" varchar(1),
        "modify_date" timestamp,
        "is_labuan" char(1),
        "queue_date" timestamp,
        "queue_op" varchar(1),
        "queue_by" varchar(50),
        "myimms_reply" varchar(1),
        "myimms_error" varchar(255),
        "reply_date" timestamp,
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MYIMMS_QUEUE_HIST');

    raise notice 'created foreign table for MYIMMS_QUEUE_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MYIMMS_QUEUE_HIST;

    -- create table if not exists nios.MYIMMS_QUEUE_HIST as select * from nios_foreign.MYIMMS_QUEUE_HIST;

    raise notice 'copied table nios.MYIMMS_QUEUE_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MYSTICS_LOG', 237 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.MYSTICS_LOG;

    create foreign table if not exists nios_foreign.MYSTICS_LOG (
        "log_id" numeric(19),
        "type" varchar(2),
        "subtype" varchar(10),
        "logdate" timestamp,
        "transdate" timestamp,
        "amount" numeric(14, 2),
        "sex" char(1),
        "branch_code" varchar(2),
        "err#" numeric(6),
        "errm" varchar(250),
        "reccount" numeric(8),
        "mystics_ref" numeric(16),
        "drdept" varchar(6),
        "drdiv" varchar(3),
        "drsection" varchar(6),
        "drgl" varchar(6),
        "crdept" varchar(6),
        "crdiv" varchar(3),
        "crsection" varchar(6),
        "crgl" varchar(6)
    ) server nios_server options (schema 'NIOS1', table 'MYSTICS_LOG');

    raise notice 'created foreign table for MYSTICS_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.MYSTICS_LOG;

    -- create table if not exists nios.MYSTICS_LOG as select * from nios_foreign.MYSTICS_LOG;

    raise notice 'copied table nios.MYSTICS_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NEW_ARRI', 238 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.NEW_ARRI;

    create foreign table if not exists nios_foreign.NEW_ARRI (
        "regn_date" timestamp,
        "old_clinic" varchar(70),
        "new_clinic" varchar(50),
        "doctor_code" varchar(10),
        "worker_code" varchar(10),
        "country_name" varchar(50),
        "fitness" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'NEW_ARRI');

    raise notice 'created foreign table for NEW_ARRI';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.NEW_ARRI;

    -- create table if not exists nios.NEW_ARRI as select * from nios_foreign.NEW_ARRI;

    raise notice 'copied table nios.NEW_ARRI';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NIOS_LAB_PAYMENT', 239 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.NIOS_LAB_PAYMENT;

    create foreign table if not exists nios_foreign.NIOS_LAB_PAYMENT (
        "laboratory_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'NIOS_LAB_PAYMENT');

    raise notice 'created foreign table for NIOS_LAB_PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.NIOS_LAB_PAYMENT;

    -- create table if not exists nios.NIOS_LAB_PAYMENT as select * from nios_foreign.NIOS_LAB_PAYMENT;

    raise notice 'copied table nios.NIOS_LAB_PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NIOS_SETTING', 240 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.NIOS_SETTING;

    create foreign table if not exists nios_foreign.NIOS_SETTING (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "description" varchar(400),
        "parameter" varchar(120),
        "value" varchar(200)
    ) server nios_server options (schema 'NIOS1', table 'NIOS_SETTING');

    raise notice 'created foreign table for NIOS_SETTING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.NIOS_SETTING;

    -- create table if not exists nios.NIOS_SETTING as select * from nios_foreign.NIOS_SETTING;

    raise notice 'copied table nios.NIOS_SETTING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NON_TRANSMISSION', 241 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.NON_TRANSMISSION;

    create foreign table if not exists nios_foreign.NON_TRANSMISSION (
        "doctor_code" varchar(10),
        "worker_code" varchar(10),
        "exam_date" timestamp,
        "lab_specimen_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_testdone_date" timestamp,
        "xray_submit_date" timestamp,
        "transid" varchar(14),
        "start_date" timestamp,
        "duration" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'NON_TRANSMISSION');

    raise notice 'created foreign table for NON_TRANSMISSION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.NON_TRANSMISSION;

    -- create table if not exists nios.NON_TRANSMISSION as select * from nios_foreign.NON_TRANSMISSION;

    raise notice 'copied table nios.NON_TRANSMISSION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NOTIFICATION', 242 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.NOTIFICATION;

    create foreign table if not exists nios_foreign.NOTIFICATION (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "certify_date" timestamp,
        "transdate" timestamp,
        "creation_date" timestamp,
        "disease" varchar(8),
        "release_flag" varchar(1),
        "action_date" timestamp,
        "created_by" varchar(20),
        "unknown" varchar(1),
        "worker_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'NOTIFICATION');

    raise notice 'created foreign table for NOTIFICATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.NOTIFICATION;

    -- create table if not exists nios.NOTIFICATION as select * from nios_foreign.NOTIFICATION;

    raise notice 'copied table nios.NOTIFICATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table OPERATION_COMMENTS', 243 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.OPERATION_COMMENTS;

    create foreign table if not exists nios_foreign.OPERATION_COMMENTS (
        "commentid" numeric(10),
        "bc_user_code" varchar(13),
        "category" varchar(5),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'OPERATION_COMMENTS');

    raise notice 'created foreign table for OPERATION_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.OPERATION_COMMENTS;

    -- create table if not exists nios.OPERATION_COMMENTS as select * from nios_foreign.OPERATION_COMMENTS;

    raise notice 'copied table nios.OPERATION_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PATI_RENEW', 244 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PATI_RENEW;

    create foreign table if not exists nios_foreign.PATI_RENEW (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'PATI_RENEW');

    raise notice 'created foreign table for PATI_RENEW';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PATI_RENEW;

    -- create table if not exists nios.PATI_RENEW as select * from nios_foreign.PATI_RENEW;

    raise notice 'copied table nios.PATI_RENEW';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT', 245 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT;

    create foreign table if not exists nios_foreign.PAYMENT (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "bank_account_no" varchar(80),
        "bank_code" varchar(32),
        "certify_date" timestamp,
        "create_date" timestamp,
        "creator_id" varchar(40),
        "reference_id" varchar(1020),
        "request_date" timestamp,
        "sp_code" varchar(40),
        "sp_type" varchar(4),
        "trans_type" numeric(10),
        "gst_code" varchar(80),
        "gst_tax" numeric(126),
        "invoice_date" timestamp,
        "invoice_no" varchar(120),
        "gst_type" numeric(1),
        "service_provider_group_id" varchar(30),
        "gstamount" numeric(126),
        "fin_batch_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT');

    raise notice 'created foreign table for PAYMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT;

    -- create table if not exists nios.PAYMENT as select * from nios_foreign.PAYMENT;

    raise notice 'copied table nios.PAYMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_METHOD', 246 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_METHOD;

    create foreign table if not exists nios_foreign.PAYMENT_METHOD (
        "payment_type" numeric(4),
        "description" varchar(255),
        "service_type" varchar(2),
        "status" numeric(1),
        "isfoc" numeric,
        "surcharge" numeric(126)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_METHOD');

    raise notice 'created foreign table for PAYMENT_METHOD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_METHOD;

    -- create table if not exists nios.PAYMENT_METHOD as select * from nios_foreign.PAYMENT_METHOD;

    raise notice 'copied table nios.PAYMENT_METHOD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REFUND', 247 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REFUND;

    create foreign table if not exists nios_foreign.PAYMENT_REFUND (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "ap_group_id" numeric(19),
        "old_bank_account_no" varchar(80),
        "old_bank_code" varchar(32),
        "branch_code" varchar(8),
        "old_company_regno" varchar(60),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "old_email_id" varchar(400),
        "employer_code" varchar(40),
        "old_ic_no" varchar(80),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "refund_method" numeric(10),
        "status" numeric(10),
        "gst_amount" numeric(126),
        "old_bank_account_holder_name" varchar(50),
        "refund_fee" numeric(126),
        "refund_type" numeric(10),
        "payment_type" numeric(10),
        "payment_date" timestamp,
        "reference_no" varchar(50),
        "comments" varchar(255),
        "new_bank_account_no" varchar(80),
        "new_bank_code" varchar(32),
        "new_bank_account_holder_name" varchar(50),
        "new_company_regno" varchar(60),
        "new_email_id" varchar(400),
        "new_ic_no" varchar(20),
        "finance_id" numeric(10),
        "finance_approve_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REFUND');

    raise notice 'created foreign table for PAYMENT_REFUND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REFUND;

    -- create table if not exists nios.PAYMENT_REFUND as select * from nios_foreign.PAYMENT_REFUND;

    raise notice 'copied table nios.PAYMENT_REFUND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REFUND_APPROVAL', 248 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REFUND_APPROVAL;

    create foreign table if not exists nios_foreign.PAYMENT_REFUND_APPROVAL (
        "id" numeric(19),
        "version" numeric(19),
        "approval_id" numeric(10),
        "approve_status" varchar(1020),
        "comments" varchar(1600),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "refund_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REFUND_APPROVAL');

    raise notice 'created foreign table for PAYMENT_REFUND_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REFUND_APPROVAL;

    -- create table if not exists nios.PAYMENT_REFUND_APPROVAL as select * from nios_foreign.PAYMENT_REFUND_APPROVAL;

    raise notice 'copied table nios.PAYMENT_REFUND_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REJECT', 249 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REJECT;

    create foreign table if not exists nios_foreign.PAYMENT_REJECT (
        "id" numeric(19),
        "reject_code" varchar(5),
        "reference_id" varchar(20),
        "service_provider" varchar(1500),
        "group_pay" varchar(1),
        "payable_amount" numeric(126),
        "gst_amount" numeric(126),
        "isread" numeric,
        "read_date" timestamp,
        "creator_id" varchar(7),
        "create_date" timestamp,
        "modify_id" varchar(7),
        "modification_date" timestamp,
        "type" numeric(19),
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REJECT');

    raise notice 'created foreign table for PAYMENT_REJECT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REJECT;

    -- create table if not exists nios.PAYMENT_REJECT as select * from nios_foreign.PAYMENT_REJECT;

    raise notice 'copied table nios.PAYMENT_REJECT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REJECT_LOG', 250 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REJECT_LOG;

    create foreign table if not exists nios_foreign.PAYMENT_REJECT_LOG (
        "log_id" numeric(19),
        "payment_reject_id" numeric(19),
        "logdate" timestamp,
        "err#" numeric(6),
        "errm" varchar(250),
        "msg" varchar(250),
        "status" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REJECT_LOG');

    raise notice 'created foreign table for PAYMENT_REJECT_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REJECT_LOG;

    -- create table if not exists nios.PAYMENT_REJECT_LOG as select * from nios_foreign.PAYMENT_REJECT_LOG;

    raise notice 'copied table nios.PAYMENT_REJECT_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REQ', 251 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REQ;

    create foreign table if not exists nios_foreign.PAYMENT_REQ (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "branch_code" varchar(8),
        "certify_date" timestamp,
        "create_date" timestamp,
        "creator_id" varchar(40),
        "request_date" timestamp,
        "sp_code" varchar(40),
        "sp_type" varchar(4),
        "status" numeric(10),
        "trans_type" numeric(10),
        "transid" varchar(56),
        "invoice_no" varchar(20),
        "invoice_date" timestamp,
        "gst_tax" numeric(3, 2),
        "gst_code" varchar(20),
        "service_provider_group_id" varchar(120),
        "gst_type" numeric(1),
        "service_provider_code" varchar(10),
        "gstamount" numeric(126),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "fin_batch_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REQ');

    raise notice 'created foreign table for PAYMENT_REQ';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REQ;

    -- create table if not exists nios.PAYMENT_REQ as select * from nios_foreign.PAYMENT_REQ;

    raise notice 'copied table nios.PAYMENT_REQ';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_REQ_HISTORY', 252 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_REQ_HISTORY;

    create foreign table if not exists nios_foreign.PAYMENT_REQ_HISTORY (
        "id" numeric(19),
        "amount" numeric(126),
        "branch_code" varchar(8),
        "certify_date" timestamp,
        "create_date" timestamp,
        "creator_id" varchar(40),
        "fin_batch_no" numeric(10),
        "gst_code" varchar(80),
        "gst_tax" numeric(126),
        "gst_type" numeric(10),
        "gstamount" numeric(126),
        "invoice_date" timestamp,
        "invoice_no" varchar(120),
        "payment_req_id" numeric(10),
        "reference_id" varchar(1020),
        "request_date" timestamp,
        "service_provider_code" varchar(40),
        "service_provider_group_id" varchar(120),
        "sex" varchar(4),
        "sp_code" varchar(40),
        "sp_type" varchar(4),
        "status" numeric(10),
        "trans_type" numeric(10),
        "transid" varchar(56),
        "worker_code" varchar(40),
        "worker_name" varchar(200),
        "isread" numeric,
        "read_date" timestamp,
        "read_by" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REQ_HISTORY');

    raise notice 'created foreign table for PAYMENT_REQ_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_REQ_HISTORY;

    -- create table if not exists nios.PAYMENT_REQ_HISTORY as select * from nios_foreign.PAYMENT_REQ_HISTORY;

    raise notice 'copied table nios.PAYMENT_REQ_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_STATUS', 253 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAYMENT_STATUS;

    create foreign table if not exists nios_foreign.PAYMENT_STATUS (
        "trans_id" varchar(14),
        "doctor_code" varchar(10),
        "doc_pay_ind" varchar(1),
        "doctor_paid" timestamp,
        "xray_code" varchar(10),
        "xray_pay_ind" varchar(1),
        "xray_paid" timestamp,
        "lab_code" varchar(10),
        "lab_pay_ind" varchar(1),
        "lab_paid" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_STATUS');

    raise notice 'created foreign table for PAYMENT_STATUS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAYMENT_STATUS;

    -- create table if not exists nios.PAYMENT_STATUS as select * from nios_foreign.PAYMENT_STATUS;

    raise notice 'copied table nios.PAYMENT_STATUS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAY_TRANSACTION', 254 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAY_TRANSACTION;

    create foreign table if not exists nios_foreign.PAY_TRANSACTION (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "name" varchar(50),
        "certify_date" timestamp,
        "doc_amount" numeric(6),
        "doc_ded" numeric(3),
        "xray_code" varchar(10),
        "xray_amount" numeric(6),
        "xray_ded" numeric(3),
        "doc_pb_ind" varchar(1),
        "xray_pb_ind" varchar(1),
        "doc_pb_date" timestamp,
        "xray_pb_date" timestamp,
        "doc_unb_date" timestamp,
        "xray_unb_date" timestamp,
        "sex" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'PAY_TRANSACTION');

    raise notice 'created foreign table for PAY_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAY_TRANSACTION;

    -- create table if not exists nios.PAY_TRANSACTION as select * from nios_foreign.PAY_TRANSACTION;

    raise notice 'copied table nios.PAY_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAY_TRANS_MANUAL', 255 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PAY_TRANS_MANUAL;

    create foreign table if not exists nios_foreign.PAY_TRANS_MANUAL (
        "id" numeric,
        "sp_code" varchar(10),
        "trans_id" varchar(14),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "amount" numeric(6),
        "sp_type" varchar(1),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "payment_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'PAY_TRANS_MANUAL');

    raise notice 'created foreign table for PAY_TRANS_MANUAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PAY_TRANS_MANUAL;

    -- create table if not exists nios.PAY_TRANS_MANUAL as select * from nios_foreign.PAY_TRANS_MANUAL;

    raise notice 'copied table nios.PAY_TRANS_MANUAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATCOL', 256 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PBCATCOL;

    create foreign table if not exists nios_foreign.PBCATCOL (
        "pbc_tnam" varchar(30),
        "pbc_tid" numeric,
        "pbc_ownr" varchar(30),
        "pbc_cnam" varchar(30),
        "pbc_cid" numeric,
        "pbc_labl" varchar(254),
        "pbc_lpos" numeric,
        "pbc_hdr" varchar(254),
        "pbc_hpos" numeric,
        "pbc_jtfy" numeric,
        "pbc_mask" varchar(31),
        "pbc_case" numeric,
        "pbc_hght" numeric,
        "pbc_wdth" numeric,
        "pbc_ptrn" varchar(31),
        "pbc_bmap" char(1),
        "pbc_init" varchar(254),
        "pbc_cmnt" varchar(254),
        "pbc_edit" varchar(31),
        "pbc_tag" varchar(254)
    ) server nios_server options (schema 'NIOS1', table 'PBCATCOL');

    raise notice 'created foreign table for PBCATCOL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PBCATCOL;

    -- create table if not exists nios.PBCATCOL as select * from nios_foreign.PBCATCOL;

    raise notice 'copied table nios.PBCATCOL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATEDT', 257 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PBCATEDT;

    create foreign table if not exists nios_foreign.PBCATEDT (
        "pbe_name" varchar(30),
        "pbe_edit" varchar(254),
        "pbe_type" numeric,
        "pbe_cntr" numeric,
        "pbe_seqn" numeric,
        "pbe_flag" numeric,
        "pbe_work" varchar(32)
    ) server nios_server options (schema 'NIOS1', table 'PBCATEDT');

    raise notice 'created foreign table for PBCATEDT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PBCATEDT;

    -- create table if not exists nios.PBCATEDT as select * from nios_foreign.PBCATEDT;

    raise notice 'copied table nios.PBCATEDT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATFMT', 258 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PBCATFMT;

    create foreign table if not exists nios_foreign.PBCATFMT (
        "pbf_name" varchar(30),
        "pbf_frmt" varchar(254),
        "pbf_type" numeric,
        "pbf_cntr" numeric
    ) server nios_server options (schema 'NIOS1', table 'PBCATFMT');

    raise notice 'created foreign table for PBCATFMT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PBCATFMT;

    -- create table if not exists nios.PBCATFMT as select * from nios_foreign.PBCATFMT;

    raise notice 'copied table nios.PBCATFMT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATTBL', 259 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PBCATTBL;

    create foreign table if not exists nios_foreign.PBCATTBL (
        "pbt_tnam" varchar(30),
        "pbt_tid" numeric,
        "pbt_ownr" varchar(30),
        "pbd_fhgt" numeric,
        "pbd_fwgt" numeric,
        "pbd_fitl" char(1),
        "pbd_funl" char(1),
        "pbd_fchr" numeric,
        "pbd_fptc" numeric,
        "pbd_ffce" varchar(18),
        "pbh_fhgt" numeric,
        "pbh_fwgt" numeric,
        "pbh_fitl" char(1),
        "pbh_funl" char(1),
        "pbh_fchr" numeric,
        "pbh_fptc" numeric,
        "pbh_ffce" varchar(18),
        "pbl_fhgt" numeric,
        "pbl_fwgt" numeric,
        "pbl_fitl" char(1),
        "pbl_funl" char(1),
        "pbl_fchr" numeric,
        "pbl_fptc" numeric,
        "pbl_ffce" varchar(18),
        "pbt_cmnt" varchar(254)
    ) server nios_server options (schema 'NIOS1', table 'PBCATTBL');

    raise notice 'created foreign table for PBCATTBL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PBCATTBL;

    -- create table if not exists nios.PBCATTBL as select * from nios_foreign.PBCATTBL;

    raise notice 'copied table nios.PBCATTBL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATVLD', 260 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PBCATVLD;

    create foreign table if not exists nios_foreign.PBCATVLD (
        "pbv_name" varchar(30),
        "pbv_vald" varchar(254),
        "pbv_type" numeric,
        "pbv_cntr" numeric,
        "pbv_msg" varchar(254)
    ) server nios_server options (schema 'NIOS1', table 'PBCATVLD');

    raise notice 'created foreign table for PBCATVLD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PBCATVLD;

    -- create table if not exists nios.PBCATVLD as select * from nios_foreign.PBCATVLD;

    raise notice 'copied table nios.PBCATVLD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PCR_TRANSACTION', 261 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PCR_TRANSACTION;

    create foreign table if not exists nios_foreign.PCR_TRANSACTION (
        "trans_id" varchar(15),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "date_sent2pcr" timestamp,
        "date_audited" timestamp,
        "audit_ind" char(1),
        "version_no" numeric,
        "create_date" timestamp,
        "creator_id" numeric,
        "modify_date" timestamp,
        "modify_id" numeric,
        "pcr_trans_id" numeric
    ) server nios_server options (schema 'NIOS1', table 'PCR_TRANSACTION');

    raise notice 'created foreign table for PCR_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PCR_TRANSACTION;

    -- create table if not exists nios.PCR_TRANSACTION as select * from nios_foreign.PCR_TRANSACTION;

    raise notice 'copied table nios.PCR_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PCR_TRANS_COMMENTS', 262 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PCR_TRANS_COMMENTS;

    create foreign table if not exists nios_foreign.PCR_TRANS_COMMENTS (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'PCR_TRANS_COMMENTS');

    raise notice 'created foreign table for PCR_TRANS_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PCR_TRANS_COMMENTS;

    -- create table if not exists nios.PCR_TRANS_COMMENTS as select * from nios_foreign.PCR_TRANS_COMMENTS;

    raise notice 'copied table nios.PCR_TRANS_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PCR_TRANS_DETAIL', 263 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PCR_TRANS_DETAIL;

    create foreign table if not exists nios_foreign.PCR_TRANS_DETAIL (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "parameter_value" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'PCR_TRANS_DETAIL');

    raise notice 'created foreign table for PCR_TRANS_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PCR_TRANS_DETAIL;

    -- create table if not exists nios.PCR_TRANS_DETAIL as select * from nios_foreign.PCR_TRANS_DETAIL;

    raise notice 'copied table nios.PCR_TRANS_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PINCODE_REQ', 264 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PINCODE_REQ;

    create foreign table if not exists nios_foreign.PINCODE_REQ (
        "id" numeric(19),
        "version" numeric(19),
        "approved_id" numeric(10),
        "branch_code" varchar(8),
        "creation_date" timestamp,
        "employer_code" varchar(40),
        "expired_time" timestamp,
        "modify_date" timestamp,
        "pin_code" varchar(40),
        "request_time" timestamp,
        "status" numeric(10),
        "uuid" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'PINCODE_REQ');

    raise notice 'created foreign table for PINCODE_REQ';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PINCODE_REQ;

    -- create table if not exists nios.PINCODE_REQ as select * from nios_foreign.PINCODE_REQ;

    raise notice 'copied table nios.PINCODE_REQ';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PLY_TRANSACTION', 265 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PLY_TRANSACTION;

    create foreign table if not exists nios_foreign.PLY_TRANSACTION (
        "plyid" numeric(10),
        "tranno" varchar(10),
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "status" varchar(5),
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'PLY_TRANSACTION');

    raise notice 'created foreign table for PLY_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PLY_TRANSACTION;

    -- create table if not exists nios.PLY_TRANSACTION as select * from nios_foreign.PLY_TRANSACTION;

    raise notice 'copied table nios.PLY_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PLY_TRANSACTION_HIST', 266 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PLY_TRANSACTION_HIST;

    create foreign table if not exists nios_foreign.PLY_TRANSACTION_HIST (
        "plyid" numeric(10),
        "tranno" varchar(10),
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "status" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'PLY_TRANSACTION_HIST');

    raise notice 'created foreign table for PLY_TRANSACTION_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PLY_TRANSACTION_HIST;

    -- create table if not exists nios.PLY_TRANSACTION_HIST as select * from nios_foreign.PLY_TRANSACTION_HIST;

    raise notice 'copied table nios.PLY_TRANSACTION_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table POST_MASTER', 267 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.POST_MASTER;

    create foreign table if not exists nios_foreign.POST_MASTER (
        "district" varchar(100),
        "post_code" varchar(6),
        "post_office" varchar(100),
        "state" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'POST_MASTER');

    raise notice 'created foreign table for POST_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.POST_MASTER;

    -- create table if not exists nios.POST_MASTER as select * from nios_foreign.POST_MASTER;

    raise notice 'copied table nios.POST_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PROVIDER_HISTORY', 268 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.PROVIDER_HISTORY;

    create foreign table if not exists nios_foreign.PROVIDER_HISTORY (
        "service_provider" varchar(10),
        "action_date" timestamp,
        "old_status" varchar(5),
        "new_status" varchar(5),
        "old_state" varchar(7),
        "new_state" varchar(7),
        "action" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'PROVIDER_HISTORY');

    raise notice 'created foreign table for PROVIDER_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.PROVIDER_HISTORY;

    -- create table if not exists nios.PROVIDER_HISTORY as select * from nios_foreign.PROVIDER_HISTORY;

    raise notice 'copied table nios.PROVIDER_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_FW_DOC', 269 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_FW_DOC;

    create foreign table if not exists nios_foreign.QUARANTINE_FW_DOC (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "doc_code" varchar(13),
        "d1_hiv" char(1),
        "d1_hiv_date" timestamp,
        "d1_tb" char(1),
        "d1_tb_date" timestamp,
        "d1_leprosy" char(1),
        "d1_leprosy_date" timestamp,
        "d1_hepatitis" char(1),
        "d1_hepatitis_date" timestamp,
        "d1_psych" char(1),
        "d1_psych_date" timestamp,
        "d1_epilepsy" char(1),
        "d1_epilepsy_date" timestamp,
        "d1_cancer" char(1),
        "d1_cancer_date" timestamp,
        "d1_std" char(1),
        "d1_std_date" timestamp,
        "d1_malaria" char(1),
        "d1_malaria_date" timestamp,
        "d2_hypertension" char(1),
        "d2_hypertension_date" timestamp,
        "d2_heartdisease" char(1),
        "d2_heartdisease_date" timestamp,
        "d2_asthma" char(1),
        "d2_asthma_date" timestamp,
        "d2_diabetes" char(1),
        "d2_diabetes_date" timestamp,
        "d2_ulcer" char(1),
        "d2_ulcer_date" timestamp,
        "d2_kidney" char(1),
        "d2_kidney_date" timestamp,
        "d2_others" char(1),
        "d2_others_date" timestamp,
        "d2_comments" varchar(4000),
        "d3_heartsize" char(1),
        "d3_heartsound" char(1),
        "d3_othercardio" char(1),
        "d3_breathsound" char(1),
        "d3_otherrespiratory" char(1),
        "d3_liver" char(1),
        "d3_spleen" char(1),
        "d3_swelling" char(1),
        "d3_lymphnodes" char(1),
        "d3_rectal" char(1),
        "d4_mental" char(1),
        "d4_speech" char(1),
        "d4_cognitive" char(1),
        "d4_peripheralnerves" char(1),
        "d4_motorpower" char(1),
        "d4_sensory" char(1),
        "d4_reflexes" char(1),
        "d4_kidney" char(1),
        "d4_gendischarge" char(1),
        "d4_gensores" char(1),
        "d4_comments" varchar(4000),
        "d5_height" numeric(10, 2),
        "d5_weight" numeric(10, 2),
        "d5_pulse" numeric(10, 2),
        "d5_systolic" numeric(10, 2),
        "d5_diastolic" numeric(10, 2),
        "d5_skinrash" char(1),
        "d5_skinpatch" char(1),
        "d5_deformities" char(1),
        "d5_anaemia" char(1),
        "d5_jaundice" char(1),
        "d5_enlargement" char(1),
        "d5_vision_unaidedleft" char(1),
        "d5_vision_unaidedright" char(1),
        "d5_vision_aidedleft" char(1),
        "d5_vision_aidedright" char(1),
        "d5_hearingleft" char(1),
        "d5_hearingright" char(1),
        "d5_others" char(1),
        "d5_comments" varchar(4000),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "d7_fw_medstatus" char(1),
        "d7_comments" varchar(4000),
        "d7_unfit_reason" varchar(4000),
        "d8_notifymoh" char(1),
        "d8_notifymoh_date" timestamp,
        "d8_refergh" char(1),
        "d8_refergh_date" timestamp,
        "d8_referph" char(1),
        "d8_referph_date" timestamp,
        "d8_treatpatient" char(1),
        "d8_treatpatient_date" timestamp,
        "d8_ongoingtreatment" char(1),
        "d8_ongoingtreatment_date" timestamp,
        "examination_date" timestamp,
        "certification_date" timestamp,
        "l1_flag" char(1),
        "l1_bloodgroup" char(2),
        "l1_bloodrh" char(1),
        "l1_elisa" char(1),
        "l1_hbsag" char(1),
        "l1_vdrltpha" char(1),
        "l1_malaria" char(1),
        "l1_urineopiates" char(1),
        "l1_urinecannabis" char(1),
        "l1_urinepregnancy" char(1),
        "l1_urinecolor" char(1),
        "l1_urinegravity" char(1),
        "l1_urinesugar" char(1),
        "l1_urinesugar1plus" char(1),
        "l1_urinesugar2plus" char(1),
        "l1_urinesugar3plus" char(1),
        "l1_urinesugar4plus" char(1),
        "l1_sugarmilimoles" varchar(7),
        "l1_urinealbumin" char(1),
        "l1_urinealbumin1plus" char(1),
        "l1_urinealbumin2plus" char(1),
        "l1_urinealbumin3plus" char(1),
        "l1_urinealbumin4plus" char(1),
        "l1_albuminmilimoles" varchar(5),
        "l1_urinemicroexam" char(1),
        "l1_reason" varchar(4000),
        "l1_labresultdate" timestamp,
        "l1_specimendate" timestamp,
        "r1_flag" char(1),
        "r1_thoraciccage" char(1),
        "r1_heartszshape" char(1),
        "r1_lungfields" char(1),
        "r1_xrayresultdate" timestamp,
        "r1_xraydonedate" timestamp,
        "fw_name" varchar(50),
        "fw_dateofbirth" timestamp,
        "fw_sex" char(1),
        "fw_jobtype" varchar(50),
        "fw_passportno" varchar(30),
        "employer_code" varchar(10),
        "fw_countryname" varchar(50),
        "lab_code" varchar(13),
        "rad_code" varchar(13),
        "xray_code" varchar(13),
        "quarantine_reason" varchar(4000),
        "status" varchar(5),
        "inspstatus" char(1),
        "time_inserted" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "last_pms_date" timestamp,
        "d2_taken_drugs" char(1),
        "r1_focallesion" char(1),
        "r1_otherabnormalities" char(1),
        "r1_impression" varchar(4000),
        "r1_mediastinum" char(1),
        "r1_pleura" char(1),
        "r1_thoraciccage_detail" varchar(1000),
        "r1_heartszshape_detail" varchar(1000),
        "r1_lungfields_detail" varchar(1000),
        "r1_mediastinum_detail" varchar(1000),
        "r1_pleura_detail" varchar(1000),
        "r1_focallesion_detail" varchar(1000),
        "r1_otherabnormalities_detail" varchar(1000),
        "l1_tpha" char(1),
        "l1_sgvalue" varchar(20),
        "l1_urinemicroexam_reason" varchar(4000),
        "source" char(1),
        "l1_ibtv2" char(1),
        "l1_batchnum" varchar(10),
        "tcupi_letter_refid" numeric(10),
        "tcupi_xrayletter_refid" numeric(10),
        "qrtn_source" numeric(1),
        "l1_specimentakendate" timestamp,
        "l1_blood_barcodeno" varchar(20),
        "l1_urine_barcodeno" varchar(20),
        "r1_xrayrefno" varchar(20),
        "d3_other" char(1),
        "d4_appearance" char(1),
        "d4_speechquality" char(1),
        "d4_coherent" char(1),
        "d4_relevant" char(1),
        "d4_mood" char(1),
        "d4_depressed" char(1),
        "d4_depressed1" char(1),
        "d4_depressed2" char(1),
        "d4_anxious" char(1),
        "d4_irritable" char(1),
        "d4_affect" char(1),
        "d4_thought" char(1),
        "d4_delusion" char(1),
        "d4_suicidality" char(1),
        "d4_suicidality1" char(1),
        "d4_suicidality2" char(1),
        "d4_perception" char(1),
        "d4_orientation" char(1),
        "d4_time" char(1),
        "d4_place" char(1),
        "d4_person" char(1),
        "d4_other" char(1),
        "d4_discharge" char(1),
        "d4_lump" char(1),
        "d4_axillary" char(1),
        "d4_other6" char(1),
        "l1_bloodgroup_reason" varchar(4000),
        "l1_bfmp" char(1),
        "l1_hcg" char(1),
        "d6_hypertension" char(1),
        "d6_heart_diseases" char(1),
        "d6_asthma" char(1),
        "d6_diabetes" char(1),
        "d6_ulcer" char(1),
        "d6_kidney" char(1),
        "d6_others6" char(1)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_DOC');

    raise notice 'created foreign table for QUARANTINE_FW_DOC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_FW_DOC;

    -- create table if not exists nios.QUARANTINE_FW_DOC as select * from nios_foreign.QUARANTINE_FW_DOC;

    raise notice 'copied table nios.QUARANTINE_FW_DOC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_FW_DOC_HIST', 270 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_FW_DOC_HIST;

    create foreign table if not exists nios_foreign.QUARANTINE_FW_DOC_HIST (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "doc_code" varchar(13),
        "d1_hiv" char(1),
        "d1_hiv_date" timestamp,
        "d1_tb" char(1),
        "d1_tb_date" timestamp,
        "d1_leprosy" char(1),
        "d1_leprosy_date" timestamp,
        "d1_hepatitis" char(1),
        "d1_hepatitis_date" timestamp,
        "d1_psych" char(1),
        "d1_psych_date" timestamp,
        "d1_epilepsy" char(1),
        "d1_epilepsy_date" timestamp,
        "d1_cancer" char(1),
        "d1_cancer_date" timestamp,
        "d1_std" char(1),
        "d1_std_date" timestamp,
        "d1_malaria" char(1),
        "d1_malaria_date" timestamp,
        "d2_hypertension" char(1),
        "d2_hypertension_date" timestamp,
        "d2_heartdisease" char(1),
        "d2_heartdisease_date" timestamp,
        "d2_asthma" char(1),
        "d2_asthma_date" timestamp,
        "d2_diabetes" char(1),
        "d2_diabetes_date" timestamp,
        "d2_ulcer" char(1),
        "d2_ulcer_date" timestamp,
        "d2_kidney" char(1),
        "d2_kidney_date" timestamp,
        "d2_others" char(1),
        "d2_others_date" timestamp,
        "d2_comments" varchar(4000),
        "d3_heartsize" char(1),
        "d3_heartsound" char(1),
        "d3_othercardio" char(1),
        "d3_breathsound" char(1),
        "d3_otherrespiratory" char(1),
        "d3_liver" char(1),
        "d3_spleen" char(1),
        "d3_swelling" char(1),
        "d3_lymphnodes" char(1),
        "d3_rectal" char(1),
        "d4_mental" char(1),
        "d4_speech" char(1),
        "d4_cognitive" char(1),
        "d4_peripheralnerves" char(1),
        "d4_motorpower" char(1),
        "d4_sensory" char(1),
        "d4_reflexes" char(1),
        "d4_kidney" char(1),
        "d4_gendischarge" char(1),
        "d4_gensores" char(1),
        "d4_comments" varchar(4000),
        "d5_height" numeric(10, 2),
        "d5_weight" numeric(10, 2),
        "d5_pulse" numeric(10, 2),
        "d5_systolic" numeric(10, 2),
        "d5_diastolic" numeric(10, 2),
        "d5_skinrash" char(1),
        "d5_skinpatch" char(1),
        "d5_deformities" char(1),
        "d5_anaemia" char(1),
        "d5_jaundice" char(1),
        "d5_enlargement" char(1),
        "d5_vision_unaidedleft" char(1),
        "d5_vision_unaidedright" char(1),
        "d5_vision_aidedleft" char(1),
        "d5_vision_aidedright" char(1),
        "d5_hearingleft" char(1),
        "d5_hearingright" char(1),
        "d5_others" char(1),
        "d5_comments" varchar(4000),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "d7_fw_medstatus" char(1),
        "d7_comments" varchar(4000),
        "d7_unfit_reason" varchar(4000),
        "d8_notifymoh" char(1),
        "d8_notifymoh_date" timestamp,
        "d8_refergh" char(1),
        "d8_refergh_date" timestamp,
        "d8_referph" char(1),
        "d8_referph_date" timestamp,
        "d8_treatpatient" char(1),
        "d8_treatpatient_date" timestamp,
        "d8_ongoingtreatment" char(1),
        "d8_ongoingtreatment_date" timestamp,
        "examination_date" timestamp,
        "certification_date" timestamp,
        "l1_flag" char(1),
        "l1_bloodgroup" char(2),
        "l1_bloodrh" char(1),
        "l1_elisa" char(1),
        "l1_hbsag" char(1),
        "l1_vdrltpha" char(1),
        "l1_malaria" char(1),
        "l1_urineopiates" char(1),
        "l1_urinecannabis" char(1),
        "l1_urinepregnancy" char(1),
        "l1_urinecolor" char(1),
        "l1_urinegravity" char(1),
        "l1_urinesugar" char(1),
        "l1_urinesugar1plus" char(1),
        "l1_urinesugar2plus" char(1),
        "l1_urinesugar3plus" char(1),
        "l1_urinesugar4plus" char(1),
        "l1_sugarmilimoles" varchar(7),
        "l1_urinealbumin" char(1),
        "l1_urinealbumin1plus" char(1),
        "l1_urinealbumin2plus" char(1),
        "l1_urinealbumin3plus" char(1),
        "l1_urinealbumin4plus" char(1),
        "l1_albuminmilimoles" varchar(5),
        "l1_urinemicroexam" char(1),
        "l1_reason" varchar(4000),
        "l1_labresultdate" timestamp,
        "l1_specimendate" timestamp,
        "r1_flag" char(1),
        "r1_thoraciccage" char(1),
        "r1_heartszshape" char(1),
        "r1_lungfields" char(1),
        "r1_xrayresultdate" timestamp,
        "r1_xraydonedate" timestamp,
        "fw_name" varchar(50),
        "fw_dateofbirth" timestamp,
        "fw_sex" char(1),
        "fw_jobtype" varchar(50),
        "fw_passportno" varchar(30),
        "employer_code" varchar(10),
        "fw_countryname" varchar(50),
        "lab_code" varchar(13),
        "rad_code" varchar(13),
        "xray_code" varchar(13),
        "quarantine_reason" varchar(4000),
        "status" varchar(5),
        "inspstatus" char(1),
        "time_inserted" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "last_pms_date" timestamp,
        "d2_taken_drugs" char(1),
        "r1_focallesion" char(1),
        "r1_otherabnormalities" char(1),
        "r1_impression" varchar(4000),
        "r1_mediastinum" char(1),
        "r1_pleura" char(1),
        "r1_thoraciccage_detail" varchar(1000),
        "r1_heartszshape_detail" varchar(1000),
        "r1_lungfields_detail" varchar(1000),
        "r1_mediastinum_detail" varchar(1000),
        "r1_pleura_detail" varchar(1000),
        "r1_focallesion_detail" varchar(1000),
        "r1_otherabnormalities_detail" varchar(1000),
        "delete_date" timestamp,
        "delete_by" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_DOC_HIST');

    raise notice 'created foreign table for QUARANTINE_FW_DOC_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_FW_DOC_HIST;

    -- create table if not exists nios.QUARANTINE_FW_DOC_HIST as select * from nios_foreign.QUARANTINE_FW_DOC_HIST;

    raise notice 'copied table nios.QUARANTINE_FW_DOC_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_FW_REASON', 271 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_FW_REASON;

    create foreign table if not exists nios_foreign.QUARANTINE_FW_REASON (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_REASON');

    raise notice 'created foreign table for QUARANTINE_FW_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_FW_REASON;

    -- create table if not exists nios.QUARANTINE_FW_REASON as select * from nios_foreign.QUARANTINE_FW_REASON;

    raise notice 'copied table nios.QUARANTINE_FW_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_FW_REASON_HIST', 272 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_FW_REASON_HIST;

    create foreign table if not exists nios_foreign.QUARANTINE_FW_REASON_HIST (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp,
        "delete_date" timestamp,
        "delete_by" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_REASON_HIST');

    raise notice 'created foreign table for QUARANTINE_FW_REASON_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_FW_REASON_HIST;

    -- create table if not exists nios.QUARANTINE_FW_REASON_HIST as select * from nios_foreign.QUARANTINE_FW_REASON_HIST;

    raise notice 'copied table nios.QUARANTINE_FW_REASON_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_INSP_FINDINGS', 273 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_INSP_FINDINGS;

    create foreign table if not exists nios_foreign.QUARANTINE_INSP_FINDINGS (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "d6_hypertension" char(1),
        "d6_heart_diseases" char(1),
        "d6_asthma" char(1),
        "d6_diabetes" char(1),
        "d6_ulcer" char(1),
        "d6_kidney" char(1),
        "d6_others6" char(1)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_INSP_FINDINGS');

    raise notice 'created foreign table for QUARANTINE_INSP_FINDINGS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_INSP_FINDINGS;

    -- create table if not exists nios.QUARANTINE_INSP_FINDINGS as select * from nios_foreign.QUARANTINE_INSP_FINDINGS;

    raise notice 'copied table nios.QUARANTINE_INSP_FINDINGS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_INSP_FINDINGS_HIST', 274 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_INSP_FINDINGS_HIST;

    create foreign table if not exists nios_foreign.QUARANTINE_INSP_FINDINGS_HIST (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_INSP_FINDINGS_HIST');

    raise notice 'created foreign table for QUARANTINE_INSP_FINDINGS_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_INSP_FINDINGS_HIST;

    -- create table if not exists nios.QUARANTINE_INSP_FINDINGS_HIST as select * from nios_foreign.QUARANTINE_INSP_FINDINGS_HIST;

    raise notice 'copied table nios.QUARANTINE_INSP_FINDINGS_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_REASON', 275 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_REASON;

    create foreign table if not exists nios_foreign.QUARANTINE_REASON (
        "reason_code" varchar(10),
        "reason" varchar(1000),
        "active" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_REASON');

    raise notice 'created foreign table for QUARANTINE_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_REASON;

    -- create table if not exists nios.QUARANTINE_REASON as select * from nios_foreign.QUARANTINE_REASON;

    raise notice 'copied table nios.QUARANTINE_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_REASON_GROUP', 276 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_REASON_GROUP;

    create foreign table if not exists nios_foreign.QUARANTINE_REASON_GROUP (
        "capid" numeric(18),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_REASON_GROUP');

    raise notice 'created foreign table for QUARANTINE_REASON_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_REASON_GROUP;

    -- create table if not exists nios.QUARANTINE_REASON_GROUP as select * from nios_foreign.QUARANTINE_REASON_GROUP;

    raise notice 'copied table nios.QUARANTINE_REASON_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_RELEASE_APPROVAL', 277 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_RELEASE_APPROVAL;

    create foreign table if not exists nios_foreign.QUARANTINE_RELEASE_APPROVAL (
        "qrreqid" numeric(10),
        "qrrid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_RELEASE_APPROVAL');

    raise notice 'created foreign table for QUARANTINE_RELEASE_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_RELEASE_APPROVAL;

    -- create table if not exists nios.QUARANTINE_RELEASE_APPROVAL as select * from nios_foreign.QUARANTINE_RELEASE_APPROVAL;

    raise notice 'copied table nios.QUARANTINE_RELEASE_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_RELEASE_REQUEST', 278 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_RELEASE_REQUEST;

    create foreign table if not exists nios_foreign.QUARANTINE_RELEASE_REQUEST (
        "qrrid" numeric(18),
        "trans_id" varchar(14),
        "comments" varchar(4000),
        "status" varchar(5),
        "medstatus" char(1),
        "request_by" numeric(10),
        "creation_date" timestamp,
        "ismonitor" char(1),
        "mle" numeric(10),
        "assessment_date" timestamp,
        "release_date" timestamp,
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "remove_mon_comment" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_RELEASE_REQUEST');

    raise notice 'created foreign table for QUARANTINE_RELEASE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_RELEASE_REQUEST;

    -- create table if not exists nios.QUARANTINE_RELEASE_REQUEST as select * from nios_foreign.QUARANTINE_RELEASE_REQUEST;

    raise notice 'copied table nios.QUARANTINE_RELEASE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_RELEASE_REQ_HISTORY', 279 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_RELEASE_REQ_HISTORY;

    create foreign table if not exists nios_foreign.QUARANTINE_RELEASE_REQ_HISTORY (
        "qrrid" numeric(18),
        "trans_id" varchar(14),
        "comments" varchar(4000),
        "status" varchar(5),
        "medstatus" char(1),
        "request_by" numeric(10),
        "creation_date" timestamp,
        "ismonitor" char(1),
        "mle" numeric(10),
        "assessment_date" timestamp,
        "release_date" timestamp,
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_RELEASE_REQ_HISTORY');

    raise notice 'created foreign table for QUARANTINE_RELEASE_REQ_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_RELEASE_REQ_HISTORY;

    -- create table if not exists nios.QUARANTINE_RELEASE_REQ_HISTORY as select * from nios_foreign.QUARANTINE_RELEASE_REQ_HISTORY;

    raise notice 'copied table nios.QUARANTINE_RELEASE_REQ_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_STATUS_HISTORY', 280 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_STATUS_HISTORY;

    create foreign table if not exists nios_foreign.QUARANTINE_STATUS_HISTORY (
        "bc_worker_code" varchar(13),
        "old_status" varchar(1),
        "new_status" varchar(1),
        "userid" numeric(10),
        "mod_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_STATUS_HISTORY');

    raise notice 'created foreign table for QUARANTINE_STATUS_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_STATUS_HISTORY;

    -- create table if not exists nios.QUARANTINE_STATUS_HISTORY as select * from nios_foreign.QUARANTINE_STATUS_HISTORY;

    raise notice 'copied table nios.QUARANTINE_STATUS_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_STATUS_PENDING', 281 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_STATUS_PENDING;

    create foreign table if not exists nios_foreign.QUARANTINE_STATUS_PENDING (
        "bc_worker_code" varchar(13),
        "old_status" varchar(1),
        "new_status" varchar(1),
        "userid" numeric(10),
        "mod_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_STATUS_PENDING');

    raise notice 'created foreign table for QUARANTINE_STATUS_PENDING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_STATUS_PENDING;

    -- create table if not exists nios.QUARANTINE_STATUS_PENDING as select * from nios_foreign.QUARANTINE_STATUS_PENDING;

    raise notice 'copied table nios.QUARANTINE_STATUS_PENDING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_TCUPI_TODOLIST', 282 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_TCUPI_TODOLIST;

    create foreign table if not exists nios_foreign.QUARANTINE_TCUPI_TODOLIST (
        "quarantine_todolist_id" numeric(20),
        "tcupi_todolist_id" numeric(20),
        "qrrid" numeric(20),
        "date_completed" timestamp,
        "comments" varchar(255),
        "createby" numeric(20),
        "create_date" timestamp,
        "modify_by" varchar(20),
        "modify_date" timestamp,
        "testdone" varchar(1),
        "others_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_TCUPI_TODOLIST');

    raise notice 'created foreign table for QUARANTINE_TCUPI_TODOLIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_TCUPI_TODOLIST;

    -- create table if not exists nios.QUARANTINE_TCUPI_TODOLIST as select * from nios_foreign.QUARANTINE_TCUPI_TODOLIST;

    raise notice 'copied table nios.QUARANTINE_TCUPI_TODOLIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUARANTINE_TRANSFER', 283 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUARANTINE_TRANSFER;

    create foreign table if not exists nios_foreign.QUARANTINE_TRANSFER (
        "trans_id" varchar(14),
        "worker_code" varchar(13),
        "transfer_mode" numeric(1),
        "comments" varchar(1000),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_TRANSFER');

    raise notice 'created foreign table for QUARANTINE_TRANSFER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUARANTINE_TRANSFER;

    -- create table if not exists nios.QUARANTINE_TRANSFER as select * from nios_foreign.QUARANTINE_TRANSFER;

    raise notice 'copied table nios.QUARANTINE_TRANSFER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUEST_COM_PRODUCTS', 284 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUEST_COM_PRODUCTS;

    create foreign table if not exists nios_foreign.QUEST_COM_PRODUCTS (
        "product_id" numeric,
        "product_name" varchar(30),
        "product_prefix" varchar(8),
        "install_user" varchar(30),
        "grant_procedure" varchar(2000),
        "revoke_procedure" varchar(2000),
        "product_version" varchar(20),
        "deinstall_script" varchar,
        "grant_priv_procedure" varchar(2000),
        "revoke_priv_procedure" varchar(2000),
        "installed_by" varchar(30),
        "product_schema_version" varchar(20),
        "product_base_version" varchar(20),
        "stand_alone_product_flag" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_PRODUCTS');

    raise notice 'created foreign table for QUEST_COM_PRODUCTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUEST_COM_PRODUCTS;

    -- create table if not exists nios.QUEST_COM_PRODUCTS as select * from nios_foreign.QUEST_COM_PRODUCTS;

    raise notice 'copied table nios.QUEST_COM_PRODUCTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUEST_COM_PRODUCTS_USED_BY', 285 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUEST_COM_PRODUCTS_USED_BY;

    create foreign table if not exists nios_foreign.QUEST_COM_PRODUCTS_USED_BY (
        "product_id" numeric,
        "used_by_product_id" numeric,
        "product_version" varchar(20),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_PRODUCTS_USED_BY');

    raise notice 'created foreign table for QUEST_COM_PRODUCTS_USED_BY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUEST_COM_PRODUCTS_USED_BY;

    -- create table if not exists nios.QUEST_COM_PRODUCTS_USED_BY as select * from nios_foreign.QUEST_COM_PRODUCTS_USED_BY;

    raise notice 'copied table nios.QUEST_COM_PRODUCTS_USED_BY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUEST_COM_PRODUCT_PRIVS', 286 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUEST_COM_PRODUCT_PRIVS;

    create foreign table if not exists nios_foreign.QUEST_COM_PRODUCT_PRIVS (
        "product_id" numeric,
        "privilege_id" varchar(60),
        "privilege_description" varchar(256),
        "validation_routine" varchar(2000),
        "privilege_level" varchar(256),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_PRODUCT_PRIVS');

    raise notice 'created foreign table for QUEST_COM_PRODUCT_PRIVS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUEST_COM_PRODUCT_PRIVS;

    -- create table if not exists nios.QUEST_COM_PRODUCT_PRIVS as select * from nios_foreign.QUEST_COM_PRODUCT_PRIVS;

    raise notice 'copied table nios.QUEST_COM_PRODUCT_PRIVS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUEST_COM_USERS', 287 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUEST_COM_USERS;

    create foreign table if not exists nios_foreign.QUEST_COM_USERS (
        "user_id" numeric,
        "product_id" numeric,
        "authorization_level" varchar(60),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_USERS');

    raise notice 'created foreign table for QUEST_COM_USERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUEST_COM_USERS;

    -- create table if not exists nios.QUEST_COM_USERS as select * from nios_foreign.QUEST_COM_USERS;

    raise notice 'copied table nios.QUEST_COM_USERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table QUEST_COM_USER_PRIVILEGES', 288 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.QUEST_COM_USER_PRIVILEGES;

    create foreign table if not exists nios_foreign.QUEST_COM_USER_PRIVILEGES (
        "product_id" numeric,
        "user_id" numeric,
        "privilege_id" varchar(60),
        "privilege_level" varchar(2000),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_USER_PRIVILEGES');

    raise notice 'created foreign table for QUEST_COM_USER_PRIVILEGES';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.QUEST_COM_USER_PRIVILEGES;

    -- create table if not exists nios.QUEST_COM_USER_PRIVILEGES as select * from nios_foreign.QUEST_COM_USER_PRIVILEGES;

    raise notice 'copied table nios.QUEST_COM_USER_PRIVILEGES';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RADIOGRAPHER_MASTER', 289 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RADIOGRAPHER_MASTER;

    create foreign table if not exists nios_foreign.RADIOGRAPHER_MASTER (
        "radiographer_id" numeric(10),
        "radiographer_name" varchar(50),
        "status" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RADIOGRAPHER_MASTER');

    raise notice 'created foreign table for RADIOGRAPHER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RADIOGRAPHER_MASTER;

    -- create table if not exists nios.RADIOGRAPHER_MASTER as select * from nios_foreign.RADIOGRAPHER_MASTER;

    raise notice 'copied table nios.RADIOGRAPHER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RADIOLOGIST_HISTORY', 290 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RADIOLOGIST_HISTORY;

    create foreign table if not exists nios_foreign.RADIOLOGIST_HISTORY (
        "radiologist_code" varchar(10),
        "radiologist_name" varchar(50),
        "creation_date" timestamp,
        "version_no" varchar(10),
        "address3" varchar(50),
        "address4" varchar(50),
        "qualification" varchar(50),
        "comments" varchar(4000),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "state_code" varchar(7),
        "address1" varchar(50),
        "address2" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "district_name" varchar(40),
        "modification_date" timestamp,
        "bc_radiologist_code" varchar(13),
        "xray_regn_no" varchar(20),
        "status_code" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "rdregid" numeric(10),
        "nearest_district_office" varchar(7),
        "radiologist_ic_new" varchar(20),
        "radiologist_ic_old" varchar(20),
        "action" varchar(10),
        "action_date" timestamp,
        "is_pcr" char(1),
        "nios_uuid" numeric,
        "apc_no" varchar(20),
        "nsr_no" varchar(20),
        "xray_name" varchar(50),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "bank_code" varchar(8),
        "gst_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_HISTORY');

    raise notice 'created foreign table for RADIOLOGIST_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RADIOLOGIST_HISTORY;

    -- create table if not exists nios.RADIOLOGIST_HISTORY as select * from nios_foreign.RADIOLOGIST_HISTORY;

    raise notice 'copied table nios.RADIOLOGIST_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RADIOLOGIST_MASTER', 291 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RADIOLOGIST_MASTER;

    create foreign table if not exists nios_foreign.RADIOLOGIST_MASTER (
        "radiologist_code" varchar(10),
        "radiologist_name" varchar(50),
        "creation_date" timestamp,
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "version_no" varchar(10),
        "qualification" varchar(50),
        "xray_regn_no" varchar(20),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "bc_radiologist_code" varchar(13),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "rdregid" numeric(10),
        "nearest_district_office" varchar(7),
        "radiologist_ic_new" varchar(20),
        "radiologist_ic_old" varchar(20),
        "is_pcr" char(1),
        "apc_year" varchar(4),
        "nios_uuid" numeric,
        "apc_no" varchar(20),
        "nsr_no" varchar(20),
        "xray_name" varchar(50),
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "quota" numeric(10),
        "quota_use" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_MASTER');

    raise notice 'created foreign table for RADIOLOGIST_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RADIOLOGIST_MASTER;

    -- create table if not exists nios.RADIOLOGIST_MASTER as select * from nios_foreign.RADIOLOGIST_MASTER;

    raise notice 'copied table nios.RADIOLOGIST_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RADIOLOGIST_REGISTRATION', 292 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RADIOLOGIST_REGISTRATION;

    create foreign table if not exists nios_foreign.RADIOLOGIST_REGISTRATION (
        "rdregid" numeric(10),
        "radiologist_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "qualification" varchar(50),
        "xray_regn_no" varchar(20),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "nearest_district_office" varchar(7),
        "radiologist_ic_new" varchar(20),
        "radiologist_ic_old" varchar(20),
        "tranno" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "apc_year" varchar(4),
        "apc_no" varchar(20),
        "nsr_no" varchar(20),
        "xray_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_REGISTRATION');

    raise notice 'created foreign table for RADIOLOGIST_REGISTRATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RADIOLOGIST_REGISTRATION;

    -- create table if not exists nios.RADIOLOGIST_REGISTRATION as select * from nios_foreign.RADIOLOGIST_REGISTRATION;

    raise notice 'copied table nios.RADIOLOGIST_REGISTRATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RADIOLOGIST_REQUEST', 293 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RADIOLOGIST_REQUEST;

    create foreign table if not exists nios_foreign.RADIOLOGIST_REQUEST (
        "rdregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_REQUEST');

    raise notice 'created foreign table for RADIOLOGIST_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RADIOLOGIST_REQUEST;

    -- create table if not exists nios.RADIOLOGIST_REQUEST as select * from nios_foreign.RADIOLOGIST_REQUEST;

    raise notice 'copied table nios.RADIOLOGIST_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT', 294 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT;

    create foreign table if not exists nios_foreign.RECEIPT (
        "tranno" varchar(10),
        "oldtranno" varchar(10),
        "status" varchar(10),
        "no_male" numeric(5),
        "no_female" numeric(5),
        "amount" numeric(10, 2),
        "amount_paid" numeric(10, 2),
        "service_type" varchar(2),
        "isfoc" varchar(5),
        "isrefunded" varchar(5),
        "foc_reason" varchar(4000),
        "void_reason" varchar(4000),
        "printed" varchar(5),
        "print_count" numeric(5),
        "contact_name" varchar(50),
        "contact_phone" varchar(100),
        "contact_fax" varchar(100),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "contact_post_code" varchar(10),
        "contact_state_code" varchar(7),
        "contact_district_code" varchar(7),
        "branch_code" varchar(2),
        "received_by" varchar(100),
        "trandate" timestamp,
        "expirydate" timestamp,
        "version_no" varchar(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "no_uses" numeric(5),
        "no_uses_count" numeric(5),
        "service_provider" varchar(13),
        "kivexpiry_date" timestamp,
        "gst_amount" numeric(10, 2),
        "isgstmigrated" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT');

    raise notice 'created foreign table for RECEIPT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT;

    -- create table if not exists nios.RECEIPT as select * from nios_foreign.RECEIPT;

    raise notice 'copied table nios.RECEIPT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_CHANGE_REASON', 295 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_CHANGE_REASON;

    create foreign table if not exists nios_foreign.RECEIPT_CHANGE_REASON (
        "rregid" numeric(10),
        "tranno" varchar(10),
        "reason_type" varchar(5),
        "reason" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_CHANGE_REASON');

    raise notice 'created foreign table for RECEIPT_CHANGE_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_CHANGE_REASON;

    -- create table if not exists nios.RECEIPT_CHANGE_REASON as select * from nios_foreign.RECEIPT_CHANGE_REASON;

    raise notice 'copied table nios.RECEIPT_CHANGE_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_CHANGE_TYPE', 296 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_CHANGE_TYPE;

    create foreign table if not exists nios_foreign.RECEIPT_CHANGE_TYPE (
        "reason_type" numeric(10),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_CHANGE_TYPE');

    raise notice 'created foreign table for RECEIPT_CHANGE_TYPE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_CHANGE_TYPE;

    -- create table if not exists nios.RECEIPT_CHANGE_TYPE as select * from nios_foreign.RECEIPT_CHANGE_TYPE;

    raise notice 'copied table nios.RECEIPT_CHANGE_TYPE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_DETAIL', 297 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_DETAIL;

    create foreign table if not exists nios_foreign.RECEIPT_DETAIL (
        "tranno" varchar(10),
        "payment_type" numeric(3),
        "payment_no" varchar(16),
        "payment_amount" numeric(10, 2),
        "bank_code" varchar(8),
        "branch_area" varchar(100),
        "zone_code" varchar(2),
        "version_no" varchar(10),
        "date_issue" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "name_on_card" varchar(100),
        "expiry_date" timestamp,
        "approval_code" varchar(20),
        "ref_no" varchar(50),
        "payment_surcharge" numeric(10, 2),
        "card_type" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_DETAIL');

    raise notice 'created foreign table for RECEIPT_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_DETAIL;

    -- create table if not exists nios.RECEIPT_DETAIL as select * from nios_foreign.RECEIPT_DETAIL;

    raise notice 'copied table nios.RECEIPT_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_DETAIL_HISTORY', 298 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_DETAIL_HISTORY;

    create foreign table if not exists nios_foreign.RECEIPT_DETAIL_HISTORY (
        "tranno" varchar(10),
        "payment_type" numeric(3),
        "payment_no" varchar(16),
        "payment_amount" numeric(10, 2),
        "bank_code" varchar(8),
        "branch_area" varchar(100),
        "zone_code" varchar(2),
        "version_no" varchar(10),
        "date_issue" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "name_on_card" varchar(100),
        "expiry_date" timestamp,
        "approval_code" varchar(20),
        "ref_no" varchar(50),
        "payment_surcharge" numeric(10, 2),
        "card_type" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_DETAIL_HISTORY');

    raise notice 'created foreign table for RECEIPT_DETAIL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_DETAIL_HISTORY;

    -- create table if not exists nios.RECEIPT_DETAIL_HISTORY as select * from nios_foreign.RECEIPT_DETAIL_HISTORY;

    raise notice 'copied table nios.RECEIPT_DETAIL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_DETAIL_SABAH', 299 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_DETAIL_SABAH;

    create foreign table if not exists nios_foreign.RECEIPT_DETAIL_SABAH (
        "tranno" varchar(10),
        "payment_type" numeric(2),
        "payment_no" varchar(10),
        "payment_amount" numeric(10, 2),
        "bank_code" varchar(8),
        "branch_area" varchar(30),
        "zone_code" varchar(2),
        "version_no" varchar(10),
        "date_issue" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_DETAIL_SABAH');

    raise notice 'created foreign table for RECEIPT_DETAIL_SABAH';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_DETAIL_SABAH;

    -- create table if not exists nios.RECEIPT_DETAIL_SABAH as select * from nios_foreign.RECEIPT_DETAIL_SABAH;

    raise notice 'copied table nios.RECEIPT_DETAIL_SABAH';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_GENDER_CHANGE', 300 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_GENDER_CHANGE;

    create foreign table if not exists nios_foreign.RECEIPT_GENDER_CHANGE (
        "receipt_gender_id" numeric(10),
        "tranno" varchar(10),
        "male_diff" numeric(5),
        "female_diff" numeric(5),
        "amount_diff" numeric(10),
        "create_by" numeric(10),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_GENDER_CHANGE');

    raise notice 'created foreign table for RECEIPT_GENDER_CHANGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_GENDER_CHANGE;

    -- create table if not exists nios.RECEIPT_GENDER_CHANGE as select * from nios_foreign.RECEIPT_GENDER_CHANGE;

    raise notice 'copied table nios.RECEIPT_GENDER_CHANGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_HISTORY', 301 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_HISTORY;

    create foreign table if not exists nios_foreign.RECEIPT_HISTORY (
        "tranno" varchar(10),
        "oldtranno" varchar(10),
        "status" varchar(10),
        "no_male" numeric(5),
        "no_female" numeric(5),
        "amount" numeric(10, 2),
        "amount_paid" numeric(10, 2),
        "service_type" varchar(2),
        "isfoc" varchar(5),
        "isrefunded" varchar(5),
        "foc_reason" varchar(4000),
        "void_reason" varchar(4000),
        "printed" varchar(5),
        "print_count" numeric(5),
        "contact_name" varchar(50),
        "contact_phone" varchar(100),
        "contact_fax" varchar(100),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "contact_post_code" varchar(10),
        "contact_state_code" varchar(7),
        "contact_district_code" varchar(7),
        "branch_code" varchar(2),
        "received_by" varchar(100),
        "trandate" timestamp,
        "expirydate" timestamp,
        "version_no" varchar(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "no_uses" numeric(5),
        "no_uses_count" numeric(5),
        "service_provider" varchar(13),
        "action" varchar(10),
        "action_date" timestamp,
        "kivexpiry_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_HISTORY');

    raise notice 'created foreign table for RECEIPT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_HISTORY;

    -- create table if not exists nios.RECEIPT_HISTORY as select * from nios_foreign.RECEIPT_HISTORY;

    raise notice 'copied table nios.RECEIPT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_HISTORY_MEDCON', 302 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_HISTORY_MEDCON;

    create foreign table if not exists nios_foreign.RECEIPT_HISTORY_MEDCON (
        "trandate" timestamp,
        "tranno" varchar(10),
        "cancel" varchar(1),
        "employer" varchar(50),
        "company" varchar(50),
        "no_male" numeric(5),
        "no_female" numeric(5),
        "received_by" varchar(10),
        "amount" numeric(10, 2),
        "service_type" varchar(2),
        "deleted_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_HISTORY_MEDCON');

    raise notice 'created foreign table for RECEIPT_HISTORY_MEDCON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_HISTORY_MEDCON;

    -- create table if not exists nios.RECEIPT_HISTORY_MEDCON as select * from nios_foreign.RECEIPT_HISTORY_MEDCON;

    raise notice 'copied table nios.RECEIPT_HISTORY_MEDCON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_KIV_REQUEST', 303 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_KIV_REQUEST;

    create foreign table if not exists nios_foreign.RECEIPT_KIV_REQUEST (
        "request_id" numeric,
        "tranno" varchar(20),
        "branch_code" varchar(2),
        "creation_date" timestamp,
        "created_by" numeric,
        "approve_status" varchar(20),
        "approve_comment" varchar(255),
        "approve_date" timestamp,
        "approve_by" varchar(20),
        "kiv_male" numeric,
        "kiv_female" numeric
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_KIV_REQUEST');

    raise notice 'created foreign table for RECEIPT_KIV_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_KIV_REQUEST;

    -- create table if not exists nios.RECEIPT_KIV_REQUEST as select * from nios_foreign.RECEIPT_KIV_REQUEST;

    raise notice 'copied table nios.RECEIPT_KIV_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_MEDCON', 304 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_MEDCON;

    create foreign table if not exists nios_foreign.RECEIPT_MEDCON (
        "trandate" timestamp,
        "tranno" varchar(10),
        "cancel" varchar(1),
        "employer" varchar(50),
        "company" varchar(50),
        "no_male" numeric(5),
        "no_female" numeric(5),
        "received_by" varchar(10),
        "amount" numeric(10, 2),
        "service_type" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_MEDCON');

    raise notice 'created foreign table for RECEIPT_MEDCON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_MEDCON;

    -- create table if not exists nios.RECEIPT_MEDCON as select * from nios_foreign.RECEIPT_MEDCON;

    raise notice 'copied table nios.RECEIPT_MEDCON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_PREFER_DOCTOR', 305 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_PREFER_DOCTOR;

    create foreign table if not exists nios_foreign.RECEIPT_PREFER_DOCTOR (
        "tranno" varchar(10),
        "trandate" timestamp,
        "bc_doctor_code" varchar(13),
        "allocation" numeric(10),
        "allocation_use" numeric(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_PREFER_DOCTOR');

    raise notice 'created foreign table for RECEIPT_PREFER_DOCTOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_PREFER_DOCTOR;

    -- create table if not exists nios.RECEIPT_PREFER_DOCTOR as select * from nios_foreign.RECEIPT_PREFER_DOCTOR;

    raise notice 'copied table nios.RECEIPT_PREFER_DOCTOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_PREFER_DOCTOR_HISTORY', 306 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_PREFER_DOCTOR_HISTORY;

    create foreign table if not exists nios_foreign.RECEIPT_PREFER_DOCTOR_HISTORY (
        "tranno" varchar(10),
        "trandate" timestamp,
        "bc_doctor_code" varchar(13),
        "allocation" numeric(10),
        "allocation_use" numeric(10),
        "version_no" varchar(10),
        "log_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_PREFER_DOCTOR_HISTORY');

    raise notice 'created foreign table for RECEIPT_PREFER_DOCTOR_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_PREFER_DOCTOR_HISTORY;

    -- create table if not exists nios.RECEIPT_PREFER_DOCTOR_HISTORY as select * from nios_foreign.RECEIPT_PREFER_DOCTOR_HISTORY;

    raise notice 'copied table nios.RECEIPT_PREFER_DOCTOR_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_SABAH', 307 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_SABAH;

    create foreign table if not exists nios_foreign.RECEIPT_SABAH (
        "tranno" varchar(10),
        "oldtranno" varchar(10),
        "status" varchar(10),
        "no_male" numeric(5),
        "no_female" numeric(5),
        "amount" numeric(10, 2),
        "amount_paid" numeric(10, 2),
        "service_type" varchar(2),
        "isfoc" varchar(5),
        "isrefunded" varchar(5),
        "foc_reason" varchar(4000),
        "void_reason" varchar(4000),
        "printed" varchar(5),
        "print_count" numeric(5),
        "contact_name" varchar(50),
        "contact_phone" varchar(100),
        "contact_fax" varchar(100),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "contact_post_code" varchar(10),
        "contact_state_code" varchar(7),
        "contact_district_code" varchar(7),
        "branch_code" varchar(2),
        "received_by" varchar(100),
        "trandate" timestamp,
        "expirydate" timestamp,
        "version_no" varchar(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "no_uses" numeric(5),
        "no_uses_count" numeric(5),
        "service_provider" varchar(13)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_SABAH');

    raise notice 'created foreign table for RECEIPT_SABAH';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_SABAH;

    -- create table if not exists nios.RECEIPT_SABAH as select * from nios_foreign.RECEIPT_SABAH;

    raise notice 'copied table nios.RECEIPT_SABAH';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_SERVICE', 308 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_SERVICE;

    create foreign table if not exists nios_foreign.RECEIPT_SERVICE (
        "service_type" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "service_charge" numeric,
        "use_by" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_SERVICE');

    raise notice 'created foreign table for RECEIPT_SERVICE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_SERVICE;

    -- create table if not exists nios.RECEIPT_SERVICE as select * from nios_foreign.RECEIPT_SERVICE;

    raise notice 'copied table nios.RECEIPT_SERVICE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_USAGE', 309 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_USAGE;

    create foreign table if not exists nios_foreign.RECEIPT_USAGE (
        "trandate" timestamp,
        "tranno" varchar(10),
        "bc_worker_code" varchar(13),
        "version_no" varchar(5),
        "status_code" varchar(5),
        "trans_id" varchar(14),
        "trans_version_no" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "oldtranno" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_USAGE');

    raise notice 'created foreign table for RECEIPT_USAGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_USAGE;

    -- create table if not exists nios.RECEIPT_USAGE as select * from nios_foreign.RECEIPT_USAGE;

    raise notice 'copied table nios.RECEIPT_USAGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RECEIPT_USAGE_HISTORY', 310 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RECEIPT_USAGE_HISTORY;

    create foreign table if not exists nios_foreign.RECEIPT_USAGE_HISTORY (
        "trandate" timestamp,
        "tranno" varchar(10),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "version_no" varchar(5),
        "trans_version_no" varchar(5),
        "log_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_USAGE_HISTORY');

    raise notice 'created foreign table for RECEIPT_USAGE_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RECEIPT_USAGE_HISTORY;

    -- create table if not exists nios.RECEIPT_USAGE_HISTORY as select * from nios_foreign.RECEIPT_USAGE_HISTORY;

    raise notice 'copied table nios.RECEIPT_USAGE_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND', 311 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND;

    create foreign table if not exists nios_foreign.REFUND (
        "refundid" varchar(15),
        "total_amount" numeric(10, 2),
        "date_received_document" timestamp,
        "cheque_number" varchar(20),
        "cheque_payment_date" timestamp,
        "cheque_release_date" timestamp,
        "contact_name" varchar(50),
        "contact_phone" varchar(100),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "admin_charges" numeric(10, 2),
        "comments" varchar(4000),
        "status_code" varchar(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "refundee_name" varchar(50),
        "refundee_address1" varchar(50),
        "refundee_address2" varchar(50),
        "refundee_address3" varchar(50),
        "refundee_address4" varchar(50),
        "refundee_phone" varchar(100),
        "service_provider" varchar(13),
        "branch_code" varchar(2),
        "cheque_amount" numeric(10, 2)
    ) server nios_server options (schema 'NIOS1', table 'REFUND');

    raise notice 'created foreign table for REFUND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND;

    -- create table if not exists nios.REFUND as select * from nios_foreign.REFUND;

    raise notice 'copied table nios.REFUND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND_DETAIL', 312 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND_DETAIL;

    create foreign table if not exists nios_foreign.REFUND_DETAIL (
        "refund_detailid" varchar(15),
        "refundid" varchar(15),
        "refund_type" varchar(5),
        "amount" numeric(10, 2),
        "admin_charges" numeric(10, 2),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "worker_name" varchar(40),
        "bc_employer_code" varchar(13),
        "receipt_tranno" varchar(10),
        "receipt_trandate" timestamp,
        "registration_date" timestamp,
        "doc_4ply_employer" varchar(1),
        "doc_4ply_doctor" varchar(1),
        "doc_4ply_laboratory" varchar(1),
        "doc_4ply_xray" varchar(1),
        "total_male" numeric(5),
        "total_female" numeric(5),
        "total_worker" numeric(10),
        "total_kiv_male" numeric(5),
        "total_kiv_female" numeric(5),
        "unutilised_amount" numeric(10, 2),
        "payment_mode" varchar(5),
        "payment_amount" numeric(10, 2),
        "doc_letter" varchar(1),
        "doc_receipt" varchar(1),
        "comments" varchar(4000),
        "status_code" varchar(10),
        "ply_reprint_count" numeric(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "receipt_oldno" varchar(10),
        "transdate" timestamp,
        "sex" char(1)
    ) server nios_server options (schema 'NIOS1', table 'REFUND_DETAIL');

    raise notice 'created foreign table for REFUND_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND_DETAIL;

    -- create table if not exists nios.REFUND_DETAIL as select * from nios_foreign.REFUND_DETAIL;

    raise notice 'copied table nios.REFUND_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND_DETAIL_HISTORY', 313 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND_DETAIL_HISTORY;

    create foreign table if not exists nios_foreign.REFUND_DETAIL_HISTORY (
        "refund_detailid" varchar(15),
        "refundid" varchar(15),
        "refund_type" varchar(5),
        "amount" numeric(10, 2),
        "admin_charges" numeric(10, 2),
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "worker_name" varchar(40),
        "bc_employer_code" varchar(13),
        "receipt_tranno" varchar(10),
        "receipt_trandate" timestamp,
        "registration_date" timestamp,
        "doc_4ply_employer" varchar(1),
        "doc_4ply_doctor" varchar(1),
        "doc_4ply_laboratory" varchar(1),
        "doc_4ply_xray" varchar(1),
        "total_male" numeric(5),
        "total_female" numeric(5),
        "total_worker" numeric(10),
        "total_kiv_male" numeric(5),
        "total_kiv_female" numeric(5),
        "unutilised_amount" numeric(10, 2),
        "payment_mode" varchar(5),
        "payment_amount" numeric(10, 2),
        "doc_letter" varchar(1),
        "doc_receipt" varchar(1),
        "comments" varchar(4000),
        "status_code" varchar(10),
        "ply_reprint_count" numeric(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "receipt_oldno" varchar(10),
        "transdate" timestamp,
        "sex" char(1)
    ) server nios_server options (schema 'NIOS1', table 'REFUND_DETAIL_HISTORY');

    raise notice 'created foreign table for REFUND_DETAIL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND_DETAIL_HISTORY;

    -- create table if not exists nios.REFUND_DETAIL_HISTORY as select * from nios_foreign.REFUND_DETAIL_HISTORY;

    raise notice 'copied table nios.REFUND_DETAIL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND_FOMIC', 314 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND_FOMIC;

    create foreign table if not exists nios_foreign.REFUND_FOMIC (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "transdate" timestamp,
        "invalidate_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REFUND_FOMIC');

    raise notice 'created foreign table for REFUND_FOMIC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND_FOMIC;

    -- create table if not exists nios.REFUND_FOMIC as select * from nios_foreign.REFUND_FOMIC;

    raise notice 'copied table nios.REFUND_FOMIC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND_FOMIC_FINAL', 315 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND_FOMIC_FINAL;

    create foreign table if not exists nios_foreign.REFUND_FOMIC_FINAL (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "transdate" timestamp,
        "invalidate_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REFUND_FOMIC_FINAL');

    raise notice 'created foreign table for REFUND_FOMIC_FINAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND_FOMIC_FINAL;

    -- create table if not exists nios.REFUND_FOMIC_FINAL as select * from nios_foreign.REFUND_FOMIC_FINAL;

    raise notice 'copied table nios.REFUND_FOMIC_FINAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REFUND_HISTORY', 316 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REFUND_HISTORY;

    create foreign table if not exists nios_foreign.REFUND_HISTORY (
        "refundid" varchar(15),
        "total_amount" numeric(10, 2),
        "date_received_document" timestamp,
        "cheque_number" varchar(20),
        "cheque_payment_date" timestamp,
        "cheque_release_date" timestamp,
        "contact_name" varchar(50),
        "contact_phone" varchar(100),
        "contact_address1" varchar(50),
        "contact_address2" varchar(50),
        "contact_address3" varchar(50),
        "contact_address4" varchar(50),
        "admin_charges" numeric(10, 2),
        "comments" varchar(4000),
        "status_code" varchar(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "refundee_name" varchar(50),
        "refundee_phone" varchar(100),
        "refundee_address1" varchar(50),
        "refundee_address2" varchar(50),
        "refundee_address3" varchar(50),
        "refundee_address4" varchar(50),
        "service_provider" varchar(13),
        "branch_code" varchar(2),
        "cheque_amount" numeric(10, 2)
    ) server nios_server options (schema 'NIOS1', table 'REFUND_HISTORY');

    raise notice 'created foreign table for REFUND_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REFUND_HISTORY;

    -- create table if not exists nios.REFUND_HISTORY as select * from nios_foreign.REFUND_HISTORY;

    raise notice 'copied table nios.REFUND_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REF_DOUBLE', 317 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REF_DOUBLE;

    create foreign table if not exists nios_foreign.REF_DOUBLE (
        "worker_code" varchar(10),
        "count" numeric
    ) server nios_server options (schema 'NIOS1', table 'REF_DOUBLE');

    raise notice 'created foreign table for REF_DOUBLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REF_DOUBLE;

    -- create table if not exists nios.REF_DOUBLE as select * from nios_foreign.REF_DOUBLE;

    raise notice 'copied table nios.REF_DOUBLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REL_QRTN', 318 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REL_QRTN;

    create foreign table if not exists nios_foreign.REL_QRTN (
        "worker_code" varchar(10),
        "release_date" timestamp,
        "transdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REL_QRTN');

    raise notice 'created foreign table for REL_QRTN';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REL_QRTN;

    -- create table if not exists nios.REL_QRTN as select * from nios_foreign.REL_QRTN;

    raise notice 'copied table nios.REL_QRTN';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RENEWAL_COMMENTS', 319 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RENEWAL_COMMENTS;

    create foreign table if not exists nios_foreign.RENEWAL_COMMENTS (
        "bc_worker_code" varchar(13),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "renew_type" numeric,
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'RENEWAL_COMMENTS');

    raise notice 'created foreign table for RENEWAL_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RENEWAL_COMMENTS;

    -- create table if not exists nios.RENEWAL_COMMENTS as select * from nios_foreign.RENEWAL_COMMENTS;

    raise notice 'copied table nios.RENEWAL_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RENEWAL_WORKER', 320 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RENEWAL_WORKER;

    create foreign table if not exists nios_foreign.RENEWAL_WORKER (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "agent_code" varchar(10),
        "name" varchar(50),
        "father_name" varchar(50),
        "sex" varchar(1),
        "dob" timestamp,
        "passport_nbr" varchar(10),
        "job_type_classification" varchar(50),
        "origin_country" varchar(25),
        "date_of_arrival" timestamp,
        "fitness" varchar(1),
        "blood_group" varchar(3),
        "work_permit_number" varchar(10),
        "last_examined_date" timestamp,
        "employer_code" varchar(10),
        "date_reg_rev" timestamp,
        "updated" varchar(1),
        "created_by" varchar(10),
        "renewal_date" timestamp,
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'RENEWAL_WORKER');

    raise notice 'created foreign table for RENEWAL_WORKER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RENEWAL_WORKER;

    -- create table if not exists nios.RENEWAL_WORKER as select * from nios_foreign.RENEWAL_WORKER;

    raise notice 'copied table nios.RENEWAL_WORKER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPLACE_TABLE', 321 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPLACE_TABLE;

    create foreign table if not exists nios_foreign.REPLACE_TABLE (
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'REPLACE_TABLE');

    raise notice 'created foreign table for REPLACE_TABLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPLACE_TABLE;

    -- create table if not exists nios.REPLACE_TABLE as select * from nios_foreign.REPLACE_TABLE;

    raise notice 'copied table nios.REPLACE_TABLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPLY_TABLE', 322 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPLY_TABLE;

    create foreign table if not exists nios_foreign.REPLY_TABLE (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1),
        "reply_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE');

    raise notice 'created foreign table for REPLY_TABLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPLY_TABLE;

    -- create table if not exists nios.REPLY_TABLE as select * from nios_foreign.REPLY_TABLE;

    raise notice 'copied table nios.REPLY_TABLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPLY_TABLE_ARC', 323 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPLY_TABLE_ARC;

    create foreign table if not exists nios_foreign.REPLY_TABLE_ARC (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1),
        "reply_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE_ARC');

    raise notice 'created foreign table for REPLY_TABLE_ARC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPLY_TABLE_ARC;

    -- create table if not exists nios.REPLY_TABLE_ARC as select * from nios_foreign.REPLY_TABLE_ARC;

    raise notice 'copied table nios.REPLY_TABLE_ARC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPLY_TABLE_OLD', 324 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPLY_TABLE_OLD;

    create foreign table if not exists nios_foreign.REPLY_TABLE_OLD (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE_OLD');

    raise notice 'created foreign table for REPLY_TABLE_OLD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPLY_TABLE_OLD;

    -- create table if not exists nios.REPLY_TABLE_OLD as select * from nios_foreign.REPLY_TABLE_OLD;

    raise notice 'copied table nios.REPLY_TABLE_OLD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPORT_DIFF_BLOODGROUP', 325 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPORT_DIFF_BLOODGROUP;

    create foreign table if not exists nios_foreign.REPORT_DIFF_BLOODGROUP (
        "report_id" numeric(10),
        "report_lastdate" timestamp,
        "report_doccode" varchar(10),
        "created_by" numeric(10),
        "created_date" timestamp,
        "doctor_code_me1" varchar(10),
        "blood_group_me1" varchar(2),
        "trans_id_me1" varchar(14),
        "doctor_code_me2" varchar(10),
        "blood_group_me2" varchar(2),
        "trans_id_me2" varchar(14),
        "doctor_code_me3" varchar(10),
        "blood_group_me3" varchar(2),
        "trans_id_me3" varchar(14),
        "worker_code" varchar(10),
        "rh_me1" varchar(1),
        "rh_me2" varchar(1),
        "rh_me3" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REPORT_DIFF_BLOODGROUP');

    raise notice 'created foreign table for REPORT_DIFF_BLOODGROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPORT_DIFF_BLOODGROUP;

    -- create table if not exists nios.REPORT_DIFF_BLOODGROUP as select * from nios_foreign.REPORT_DIFF_BLOODGROUP;

    raise notice 'copied table nios.REPORT_DIFF_BLOODGROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPORT_GROUP', 326 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPORT_GROUP;

    create foreign table if not exists nios_foreign.REPORT_GROUP (
        "groupid" numeric(10),
        "capid" numeric(10),
        "seq" numeric(10),
        "reportname" varchar(255),
        "contextname" varchar(50),
        "indexpage" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'REPORT_GROUP');

    raise notice 'created foreign table for REPORT_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPORT_GROUP;

    -- create table if not exists nios.REPORT_GROUP as select * from nios_foreign.REPORT_GROUP;

    raise notice 'copied table nios.REPORT_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPORT_GROUP_MASTER', 327 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPORT_GROUP_MASTER;

    create foreign table if not exists nios_foreign.REPORT_GROUP_MASTER (
        "groupid" numeric(10),
        "iconid" numeric(10),
        "description" varchar(50),
        "seq" numeric(10),
        "status" char(1),
        "width" numeric(5)
    ) server nios_server options (schema 'NIOS1', table 'REPORT_GROUP_MASTER');

    raise notice 'created foreign table for REPORT_GROUP_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPORT_GROUP_MASTER;

    -- create table if not exists nios.REPORT_GROUP_MASTER as select * from nios_foreign.REPORT_GROUP_MASTER;

    raise notice 'copied table nios.REPORT_GROUP_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPORT_RECEIVE', 328 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPORT_RECEIVE;

    create foreign table if not exists nios_foreign.REPORT_RECEIVE (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "lab_status" varchar(1),
        "lab_receive_date" timestamp,
        "xray_status" varchar(1),
        "xray_receive_date" timestamp,
        "lab_receive_id" varchar(6),
        "xray_receive_id" varchar(6),
        "lab_wrong_reporting" varchar(1),
        "xray_wrong_reporting" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REPORT_RECEIVE');

    raise notice 'created foreign table for REPORT_RECEIVE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPORT_RECEIVE;

    -- create table if not exists nios.REPORT_RECEIVE as select * from nios_foreign.REPORT_RECEIVE;

    raise notice 'copied table nios.REPORT_RECEIVE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REPORT_SESSION', 329 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REPORT_SESSION;

    create foreign table if not exists nios_foreign.REPORT_SESSION (
        "reportid" numeric(10),
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "timeout" numeric(10),
        "xmldom" varchar
    ) server nios_server options (schema 'NIOS1', table 'REPORT_SESSION');

    raise notice 'created foreign table for REPORT_SESSION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REPORT_SESSION;

    -- create table if not exists nios.REPORT_SESSION as select * from nios_foreign.REPORT_SESSION;

    raise notice 'copied table nios.REPORT_SESSION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REQUEST_TABLE', 330 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REQUEST_TABLE;

    create foreign table if not exists nios_foreign.REQUEST_TABLE (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1),
        "request_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE');

    raise notice 'created foreign table for REQUEST_TABLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REQUEST_TABLE;

    -- create table if not exists nios.REQUEST_TABLE as select * from nios_foreign.REQUEST_TABLE;

    raise notice 'copied table nios.REQUEST_TABLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REQUEST_TABLE_ARC', 331 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REQUEST_TABLE_ARC;

    create foreign table if not exists nios_foreign.REQUEST_TABLE_ARC (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1),
        "request_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE_ARC');

    raise notice 'created foreign table for REQUEST_TABLE_ARC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REQUEST_TABLE_ARC;

    -- create table if not exists nios.REQUEST_TABLE_ARC as select * from nios_foreign.REQUEST_TABLE_ARC;

    raise notice 'copied table nios.REQUEST_TABLE_ARC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REQUEST_TABLE_HIST', 332 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REQUEST_TABLE_HIST;

    create foreign table if not exists nios_foreign.REQUEST_TABLE_HIST (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE_HIST');

    raise notice 'created foreign table for REQUEST_TABLE_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REQUEST_TABLE_HIST;

    -- create table if not exists nios.REQUEST_TABLE_HIST as select * from nios_foreign.REQUEST_TABLE_HIST;

    raise notice 'copied table nios.REQUEST_TABLE_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REQUEST_TABLE_OLD', 333 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REQUEST_TABLE_OLD;

    create foreign table if not exists nios_foreign.REQUEST_TABLE_OLD (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE_OLD');

    raise notice 'created foreign table for REQUEST_TABLE_OLD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REQUEST_TABLE_OLD;

    -- create table if not exists nios.REQUEST_TABLE_OLD as select * from nios_foreign.REQUEST_TABLE_OLD;

    raise notice 'copied table nios.REQUEST_TABLE_OLD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REV_SYNC_LOG', 334 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REV_SYNC_LOG;

    create foreign table if not exists nios_foreign.REV_SYNC_LOG (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'REV_SYNC_LOG');

    raise notice 'created foreign table for REV_SYNC_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REV_SYNC_LOG;

    -- create table if not exists nios.REV_SYNC_LOG as select * from nios_foreign.REV_SYNC_LOG;

    raise notice 'copied table nios.REV_SYNC_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table REV_SYNC_TABLE', 335 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.REV_SYNC_TABLE;

    create foreign table if not exists nios_foreign.REV_SYNC_TABLE (
        "table_name" varchar(100),
        "sequence" numeric
    ) server nios_server options (schema 'NIOS1', table 'REV_SYNC_TABLE');

    raise notice 'created foreign table for REV_SYNC_TABLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.REV_SYNC_TABLE;

    -- create table if not exists nios.REV_SYNC_TABLE as select * from nios_foreign.REV_SYNC_TABLE;

    raise notice 'copied table nios.REV_SYNC_TABLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_BATCH_TRANSACTION', 336 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_BATCH_TRANSACTION;

    create foreign table if not exists nios_foreign.RFW_BATCH_TRANSACTION (
        "rbatch_id" varchar(14),
        "laboratory_code_a" varchar(10),
        "bc_laboratory_code_a" varchar(13),
        "laboratory_code_b" varchar(10),
        "bc_laboratory_code_b" varchar(13),
        "status_code" varchar(1),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "laboratory_code_ori" varchar(10),
        "bc_laboratory_code_ori" varchar(13)
    ) server nios_server options (schema 'NIOS1', table 'RFW_BATCH_TRANSACTION');

    raise notice 'created foreign table for RFW_BATCH_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_BATCH_TRANSACTION;

    -- create table if not exists nios.RFW_BATCH_TRANSACTION as select * from nios_foreign.RFW_BATCH_TRANSACTION;

    raise notice 'copied table nios.RFW_BATCH_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_BATCH_TRANSACTION_HISTORY', 337 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_BATCH_TRANSACTION_HISTORY;

    create foreign table if not exists nios_foreign.RFW_BATCH_TRANSACTION_HISTORY (
        "rbatch_id" varchar(14),
        "laboratory_code_a" varchar(10),
        "bc_laboratory_code_a" varchar(13),
        "laboratory_code_b" varchar(10),
        "bc_laboratory_code_b" varchar(13),
        "status_code" varchar(1),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "laboratory_code_ori" varchar(10),
        "bc_laboratory_code_ori" varchar(13)
    ) server nios_server options (schema 'NIOS1', table 'RFW_BATCH_TRANSACTION_HISTORY');

    raise notice 'created foreign table for RFW_BATCH_TRANSACTION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_BATCH_TRANSACTION_HISTORY;

    -- create table if not exists nios.RFW_BATCH_TRANSACTION_HISTORY as select * from nios_foreign.RFW_BATCH_TRANSACTION_HISTORY;

    raise notice 'copied table nios.RFW_BATCH_TRANSACTION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_CASE_TRANSACTION', 338 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_CASE_TRANSACTION;

    create foreign table if not exists nios_foreign.RFW_CASE_TRANSACTION (
        "rtrans_id" varchar(14),
        "rbatch_id" varchar(14),
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "bc_worker_code" varchar(13),
        "comments" varchar(4000),
        "specimen_type" varchar(5),
        "f1_specimen_takenbygp_date" timestamp,
        "f1_specimen_tested_date" timestamp,
        "f1_comments" varchar(4000),
        "f2_bloodgroup" char(1),
        "f2_elisa" char(1),
        "f2_hbsag" char(1),
        "f2_vdrltpha" char(1),
        "f2_tpha" char(1),
        "f2_malaria" char(1),
        "f2_urineopiates" char(1),
        "f2_urinecannabis" char(1),
        "f2_urinepregnancy" char(1),
        "f2_urinecolor" char(1),
        "f2_urinegravity" char(1),
        "f2_urinesugar" char(1),
        "f2_urinealbumin" char(1),
        "f2_urinemicroexam" char(1),
        "specimen_surrender_date" timestamp,
        "status_code" varchar(1),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "tag_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'RFW_CASE_TRANSACTION');

    raise notice 'created foreign table for RFW_CASE_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_CASE_TRANSACTION;

    -- create table if not exists nios.RFW_CASE_TRANSACTION as select * from nios_foreign.RFW_CASE_TRANSACTION;

    raise notice 'copied table nios.RFW_CASE_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_CASE_TRANSACTION_HISTORY', 339 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_CASE_TRANSACTION_HISTORY;

    create foreign table if not exists nios_foreign.RFW_CASE_TRANSACTION_HISTORY (
        "rtrans_id" varchar(14),
        "rbatch_id" varchar(14),
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "bc_worker_code" varchar(13),
        "comments" varchar(4000),
        "specimen_type" varchar(5),
        "f1_specimen_takenbygp_date" timestamp,
        "f1_specimen_tested_date" timestamp,
        "f1_comments" varchar(4000),
        "f2_bloodgroup" char(1),
        "f2_elisa" char(1),
        "f2_hbsag" char(1),
        "f2_vdrltpha" char(1),
        "f2_tpha" char(1),
        "f2_malaria" char(1),
        "f2_urineopiates" char(1),
        "f2_urinecannabis" char(1),
        "f2_urinepregnancy" char(1),
        "f2_urinecolor" char(1),
        "f2_urinegravity" char(1),
        "f2_urinesugar" char(1),
        "f2_urinealbumin" char(1),
        "f2_urinemicroexam" char(1),
        "specimen_surrender_date" timestamp,
        "status_code" varchar(1),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "tag_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'RFW_CASE_TRANSACTION_HISTORY');

    raise notice 'created foreign table for RFW_CASE_TRANSACTION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_CASE_TRANSACTION_HISTORY;

    -- create table if not exists nios.RFW_CASE_TRANSACTION_HISTORY as select * from nios_foreign.RFW_CASE_TRANSACTION_HISTORY;

    raise notice 'copied table nios.RFW_CASE_TRANSACTION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_COMMENT', 340 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_COMMENT;

    create foreign table if not exists nios_foreign.RFW_COMMENT (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'RFW_COMMENT');

    raise notice 'created foreign table for RFW_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_COMMENT;

    -- create table if not exists nios.RFW_COMMENT as select * from nios_foreign.RFW_COMMENT;

    raise notice 'copied table nios.RFW_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_COMMENT_HISTORY', 341 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_COMMENT_HISTORY;

    create foreign table if not exists nios_foreign.RFW_COMMENT_HISTORY (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_COMMENT_HISTORY');

    raise notice 'created foreign table for RFW_COMMENT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_COMMENT_HISTORY;

    -- create table if not exists nios.RFW_COMMENT_HISTORY as select * from nios_foreign.RFW_COMMENT_HISTORY;

    raise notice 'copied table nios.RFW_COMMENT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_DETAIL', 342 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_DETAIL;

    create foreign table if not exists nios_foreign.RFW_DETAIL (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "parameter_value" varchar(20),
        "med_history" varchar(1),
        "effected_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_DETAIL');

    raise notice 'created foreign table for RFW_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_DETAIL;

    -- create table if not exists nios.RFW_DETAIL as select * from nios_foreign.RFW_DETAIL;

    raise notice 'copied table nios.RFW_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_DETAIL_HISTORY', 343 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_DETAIL_HISTORY;

    create foreign table if not exists nios_foreign.RFW_DETAIL_HISTORY (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "parameter_value" varchar(20),
        "med_history" varchar(1),
        "effected_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_DETAIL_HISTORY');

    raise notice 'created foreign table for RFW_DETAIL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_DETAIL_HISTORY;

    -- create table if not exists nios.RFW_DETAIL_HISTORY as select * from nios_foreign.RFW_DETAIL_HISTORY;

    raise notice 'copied table nios.RFW_DETAIL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_FW_TRANSACTION', 344 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_FW_TRANSACTION;

    create foreign table if not exists nios_foreign.RFW_FW_TRANSACTION (
        "rfwtrans_id" varchar(14),
        "rtrans_id" varchar(14),
        "laboratory_code" varchar(10),
        "bc_laboratory_code" varchar(13),
        "lab_submit_date" timestamp,
        "lab_specimen_date" timestamp,
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "version_no" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'RFW_FW_TRANSACTION');

    raise notice 'created foreign table for RFW_FW_TRANSACTION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_FW_TRANSACTION;

    -- create table if not exists nios.RFW_FW_TRANSACTION as select * from nios_foreign.RFW_FW_TRANSACTION;

    raise notice 'copied table nios.RFW_FW_TRANSACTION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_FW_TRANSACTION_HISTORY', 345 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_FW_TRANSACTION_HISTORY;

    create foreign table if not exists nios_foreign.RFW_FW_TRANSACTION_HISTORY (
        "rfwtrans_id" varchar(14),
        "rtrans_id" varchar(14),
        "laboratory_code" varchar(10),
        "bc_laboratory_code" varchar(13),
        "lab_submit_date" timestamp,
        "lab_specimen_date" timestamp,
        "bld_grp" varchar(2),
        "rh" varchar(1),
        "version_no" varchar(10),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_FW_TRANSACTION_HISTORY');

    raise notice 'created foreign table for RFW_FW_TRANSACTION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_FW_TRANSACTION_HISTORY;

    -- create table if not exists nios.RFW_FW_TRANSACTION_HISTORY as select * from nios_foreign.RFW_FW_TRANSACTION_HISTORY;

    raise notice 'copied table nios.RFW_FW_TRANSACTION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RFW_LABCHANGE_TRANS', 346 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RFW_LABCHANGE_TRANS;

    create foreign table if not exists nios_foreign.RFW_LABCHANGE_TRANS (
        "rfwtrans_id" varchar(14),
        "bc_laboratory_code" varchar(13),
        "bc_old_laboratory_code" varchar(13),
        "comments" varchar(4000),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_LABCHANGE_TRANS');

    raise notice 'created foreign table for RFW_LABCHANGE_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RFW_LABCHANGE_TRANS;

    -- create table if not exists nios.RFW_LABCHANGE_TRANS as select * from nios_foreign.RFW_LABCHANGE_TRANS;

    raise notice 'copied table nios.RFW_LABCHANGE_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ROLE_CAPABILITY', 347 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ROLE_CAPABILITY;

    create foreign table if not exists nios_foreign.ROLE_CAPABILITY (
        "roleid" numeric(10),
        "capid" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ROLE_CAPABILITY');

    raise notice 'created foreign table for ROLE_CAPABILITY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ROLE_CAPABILITY;

    -- create table if not exists nios.ROLE_CAPABILITY as select * from nios_foreign.ROLE_CAPABILITY;

    raise notice 'copied table nios.ROLE_CAPABILITY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ROLE_MASTER', 348 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ROLE_MASTER;

    create foreign table if not exists nios_foreign.ROLE_MASTER (
        "roleid" numeric(10),
        "description" varchar(100),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ROLE_MASTER');

    raise notice 'created foreign table for ROLE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ROLE_MASTER;

    -- create table if not exists nios.ROLE_MASTER as select * from nios_foreign.ROLE_MASTER;

    raise notice 'copied table nios.ROLE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table RP', 349 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.RP;

    create foreign table if not exists nios_foreign.RP (
        "capid" numeric(10),
        "description" varchar(100),
        "category" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "longdesc" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'RP');

    raise notice 'created foreign table for RP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.RP;

    -- create table if not exists nios.RP as select * from nios_foreign.RP;

    raise notice 'copied table nios.RP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table R_DEL_DUP', 350 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.R_DEL_DUP;

    create foreign table if not exists nios_foreign.R_DEL_DUP (
        "worker_code" varchar(10),
        "tot" numeric
    ) server nios_server options (schema 'NIOS1', table 'R_DEL_DUP');

    raise notice 'created foreign table for R_DEL_DUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.R_DEL_DUP;

    -- create table if not exists nios.R_DEL_DUP as select * from nios_foreign.R_DEL_DUP;

    raise notice 'copied table nios.R_DEL_DUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SABAH_DOC_POST', 351 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SABAH_DOC_POST;

    create foreign table if not exists nios_foreign.SABAH_DOC_POST (
        "doctor_code" varchar(10),
        "doctor_name" varchar(50),
        "clinic_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "state_code" varchar(7),
        "district_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SABAH_DOC_POST');

    raise notice 'created foreign table for SABAH_DOC_POST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SABAH_DOC_POST;

    -- create table if not exists nios.SABAH_DOC_POST as select * from nios_foreign.SABAH_DOC_POST;

    raise notice 'copied table nios.SABAH_DOC_POST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SABAH_TRANSID', 352 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SABAH_TRANSID;

    create foreign table if not exists nios_foreign.SABAH_TRANSID (
        "trans_id" varchar(14),
        "new_trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'SABAH_TRANSID');

    raise notice 'created foreign table for SABAH_TRANSID';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SABAH_TRANSID;

    -- create table if not exists nios.SABAH_TRANSID as select * from nios_foreign.SABAH_TRANSID;

    raise notice 'copied table nios.SABAH_TRANSID';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_HP_DX', 353 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_HP_DX;

    create foreign table if not exists nios_foreign.SCB_HP_DX (
        "doc_xray_code" varchar(10),
        "doc_xray_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'SCB_HP_DX');

    raise notice 'created foreign table for SCB_HP_DX';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_HP_DX;

    -- create table if not exists nios.SCB_HP_DX as select * from nios_foreign.SCB_HP_DX;

    raise notice 'copied table nios.SCB_HP_DX';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_PAY_MASTER', 354 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_PAY_MASTER;

    create foreign table if not exists nios_foreign.SCB_PAY_MASTER (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "date_reg_rev" timestamp,
        "name" varchar(50),
        "entry_date" timestamp,
        "amount" numeric(6),
        "amt_ded" numeric(3),
        "xray_clinic_code" varchar(10),
        "xray_amount" numeric(6),
        "doc_payblock_ind" varchar(1),
        "xray_payblock_ind" varchar(1),
        "doc_payblock_date" timestamp,
        "doc_unblock_date" timestamp,
        "xray_payblock_date" timestamp,
        "xray_unblock_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'SCB_PAY_MASTER');

    raise notice 'created foreign table for SCB_PAY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_PAY_MASTER;

    -- create table if not exists nios.SCB_PAY_MASTER as select * from nios_foreign.SCB_PAY_MASTER;

    raise notice 'copied table nios.SCB_PAY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_PAY_MASTER_UPLOAD', 355 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_PAY_MASTER_UPLOAD;

    create foreign table if not exists nios_foreign.SCB_PAY_MASTER_UPLOAD (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "date_reg_rev" timestamp,
        "name" varchar(50),
        "entry_date" timestamp,
        "amount" numeric(6),
        "amt_ded" numeric(3),
        "xray_clinic_code" varchar(10),
        "xray_amount" numeric(6),
        "doc_payblock_ind" varchar(1),
        "xray_payblock_ind" varchar(1),
        "doc_payblock_date" timestamp,
        "doc_unblock_date" timestamp,
        "xray_payblock_date" timestamp,
        "xray_unblock_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'SCB_PAY_MASTER_UPLOAD');

    raise notice 'created foreign table for SCB_PAY_MASTER_UPLOAD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_PAY_MASTER_UPLOAD;

    -- create table if not exists nios.SCB_PAY_MASTER_UPLOAD as select * from nios_foreign.SCB_PAY_MASTER_UPLOAD;

    raise notice 'copied table nios.SCB_PAY_MASTER_UPLOAD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_PAY_XRAY_NAMEANDADD', 356 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_PAY_XRAY_NAMEANDADD;

    create foreign table if not exists nios_foreign.SCB_PAY_XRAY_NAMEANDADD (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_PAY_XRAY_NAMEANDADD');

    raise notice 'created foreign table for SCB_PAY_XRAY_NAMEANDADD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_PAY_XRAY_NAMEANDADD;

    -- create table if not exists nios.SCB_PAY_XRAY_NAMEANDADD as select * from nios_foreign.SCB_PAY_XRAY_NAMEANDADD;

    raise notice 'copied table nios.SCB_PAY_XRAY_NAMEANDADD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_SABAH_DOC_POST', 357 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_SABAH_DOC_POST;

    create foreign table if not exists nios_foreign.SCB_SABAH_DOC_POST (
        "doctor_code" varchar(10),
        "doctor_name" varchar(50),
        "clinic_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "state_code" varchar(7),
        "district_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_SABAH_DOC_POST');

    raise notice 'created foreign table for SCB_SABAH_DOC_POST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_SABAH_DOC_POST;

    -- create table if not exists nios.SCB_SABAH_DOC_POST as select * from nios_foreign.SCB_SABAH_DOC_POST;

    raise notice 'copied table nios.SCB_SABAH_DOC_POST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_XRAY_NOT_DONE', 358 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_XRAY_NOT_DONE;

    create foreign table if not exists nios_foreign.SCB_XRAY_NOT_DONE (
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_NOT_DONE');

    raise notice 'created foreign table for SCB_XRAY_NOT_DONE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_XRAY_NOT_DONE;

    -- create table if not exists nios.SCB_XRAY_NOT_DONE as select * from nios_foreign.SCB_XRAY_NOT_DONE;

    raise notice 'copied table nios.SCB_XRAY_NOT_DONE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_XRAY_PAYIN_LIST', 359 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_XRAY_PAYIN_LIST;

    create foreign table if not exists nios_foreign.SCB_XRAY_PAYIN_LIST (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_PAYIN_LIST');

    raise notice 'created foreign table for SCB_XRAY_PAYIN_LIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_XRAY_PAYIN_LIST;

    -- create table if not exists nios.SCB_XRAY_PAYIN_LIST as select * from nios_foreign.SCB_XRAY_PAYIN_LIST;

    raise notice 'copied table nios.SCB_XRAY_PAYIN_LIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SCB_XRAY_PAY_NEW_ADDRESS', 360 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SCB_XRAY_PAY_NEW_ADDRESS;

    create foreign table if not exists nios_foreign.SCB_XRAY_PAY_NEW_ADDRESS (
        "xray_code" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_PAY_NEW_ADDRESS');

    raise notice 'created foreign table for SCB_XRAY_PAY_NEW_ADDRESS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SCB_XRAY_PAY_NEW_ADDRESS;

    -- create table if not exists nios.SCB_XRAY_PAY_NEW_ADDRESS as select * from nios_foreign.SCB_XRAY_PAY_NEW_ADDRESS;

    raise notice 'copied table nios.SCB_XRAY_PAY_NEW_ADDRESS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SEMINAR', 361 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SEMINAR;

    create foreign table if not exists nios_foreign.SEMINAR (
        "id" varchar(20),
        "sp_type" varchar(2),
        "seminar_name" varchar(50),
        "venue" varchar(50),
        "state_code" varchar(20),
        "start_date" timestamp,
        "end_date" timestamp,
        "status" varchar(20),
        "comments" varchar(4000),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "remarks1" varchar(4000),
        "remarks2" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'SEMINAR');

    raise notice 'created foreign table for SEMINAR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SEMINAR;

    -- create table if not exists nios.SEMINAR as select * from nios_foreign.SEMINAR;

    raise notice 'copied table nios.SEMINAR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SEMINAR_DETAIL', 362 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SEMINAR_DETAIL;

    create foreign table if not exists nios_foreign.SEMINAR_DETAIL (
        "seminar_id" varchar(20),
        "sp_code" varchar(10),
        "phone_no" varchar(20),
        "payment_date" timestamp,
        "amount" numeric(126),
        "payment_type" numeric(4),
        "invoice_no" varchar(20),
        "email" varchar(100),
        "remarks" varchar(4000),
        "attended" varchar(1),
        "laboratory_personnel_name" varchar(50),
        "ic_no" varchar(20),
        "designation" varchar(50),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "reference_number" varchar(20),
        "id" varchar(20),
        "sp_name" varchar(50),
        "clinic_name" varchar(100),
        "address" varchar(4000),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "sp_code2" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'SEMINAR_DETAIL');

    raise notice 'created foreign table for SEMINAR_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SEMINAR_DETAIL;

    -- create table if not exists nios.SEMINAR_DETAIL as select * from nios_foreign.SEMINAR_DETAIL;

    raise notice 'copied table nios.SEMINAR_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SEND_MAIL_IND', 363 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SEND_MAIL_IND;

    create foreign table if not exists nios_foreign.SEND_MAIL_IND (
        "trans_id" varchar(14),
        "send_date" timestamp,
        "status" varchar(20),
        "email_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'SEND_MAIL_IND');

    raise notice 'created foreign table for SEND_MAIL_IND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SEND_MAIL_IND;

    -- create table if not exists nios.SEND_MAIL_IND as select * from nios_foreign.SEND_MAIL_IND;

    raise notice 'copied table nios.SEND_MAIL_IND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SEQUENCE_MASTER', 364 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SEQUENCE_MASTER;

    create foreign table if not exists nios_foreign.SEQUENCE_MASTER (
        "sequencename" varchar(30),
        "lastvalue" numeric(28),
        "description" varchar(100),
        "moduleid" varchar(50),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SEQUENCE_MASTER');

    raise notice 'created foreign table for SEQUENCE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SEQUENCE_MASTER;

    -- create table if not exists nios.SEQUENCE_MASTER as select * from nios_foreign.SEQUENCE_MASTER;

    raise notice 'copied table nios.SEQUENCE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SERVICE_PROVIDERS_BANK_MASTER', 365 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SERVICE_PROVIDERS_BANK_MASTER;

    create foreign table if not exists nios_foreign.SERVICE_PROVIDERS_BANK_MASTER (
        "bank_code" varchar(8),
        "bank_name" varchar(100),
        "isactive" char(1),
        "swift_code" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDERS_BANK_MASTER');

    raise notice 'created foreign table for SERVICE_PROVIDERS_BANK_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SERVICE_PROVIDERS_BANK_MASTER;

    -- create table if not exists nios.SERVICE_PROVIDERS_BANK_MASTER as select * from nios_foreign.SERVICE_PROVIDERS_BANK_MASTER;

    raise notice 'copied table nios.SERVICE_PROVIDERS_BANK_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SERVICE_PROVIDERS_GROUP', 366 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SERVICE_PROVIDERS_GROUP;

    create foreign table if not exists nios_foreign.SERVICE_PROVIDERS_GROUP (
        "id" numeric(19),
        "version" numeric(19),
        "address1" varchar(1020),
        "address2" varchar(1020),
        "address3" varchar(1020),
        "address4" varchar(1020),
        "bank_account_holder_name" varchar(1020),
        "bank_account_no" varchar(80),
        "district_code" varchar(1020),
        "fax" varchar(1020),
        "group_code" varchar(10),
        "group_name" varchar(200),
        "isactive" varchar(1020),
        "phone" varchar(1020),
        "postcode" varchar(1020),
        "service_type" varchar(4),
        "state_code" varchar(1020),
        "roc" varchar(1020),
        "female_rate" numeric(126),
        "male_rate" numeric(126),
        "business_reg_no" varchar(80),
        "email_address" varchar(100),
        "gst_code" varchar(20),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "gst_tax" numeric(126),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "group_logo" varchar(50),
        "service_provider_master_code" varchar(10),
        "web_taxinvoice" numeric(1),
        "gst_effective_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDERS_GROUP');

    raise notice 'created foreign table for SERVICE_PROVIDERS_GROUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SERVICE_PROVIDERS_GROUP;

    -- create table if not exists nios.SERVICE_PROVIDERS_GROUP as select * from nios_foreign.SERVICE_PROVIDERS_GROUP;

    raise notice 'copied table nios.SERVICE_PROVIDERS_GROUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SERVICE_PROVIDERS_GROUP_MEMBER', 367 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SERVICE_PROVIDERS_GROUP_MEMBER;

    create foreign table if not exists nios_foreign.SERVICE_PROVIDERS_GROUP_MEMBER (
        "id" numeric(19),
        "version" numeric(19),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "service_member" varchar(40),
        "service_providers_group_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDERS_GROUP_MEMBER');

    raise notice 'created foreign table for SERVICE_PROVIDERS_GROUP_MEMBER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SERVICE_PROVIDERS_GROUP_MEMBER;

    -- create table if not exists nios.SERVICE_PROVIDERS_GROUP_MEMBER as select * from nios_foreign.SERVICE_PROVIDERS_GROUP_MEMBER;

    raise notice 'copied table nios.SERVICE_PROVIDERS_GROUP_MEMBER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SERVICE_PROVIDER_GROUP_HISTORY', 368 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SERVICE_PROVIDER_GROUP_HISTORY;

    create foreign table if not exists nios_foreign.SERVICE_PROVIDER_GROUP_HISTORY (
        "id" numeric(19),
        "version" numeric(19),
        "address1" varchar(1020),
        "address2" varchar(1020),
        "address3" varchar(1020),
        "address4" varchar(1020),
        "bank_account_holder_name" varchar(1020),
        "bank_account_no" varchar(80),
        "district_code" varchar(1020),
        "fax" varchar(1020),
        "group_code" varchar(10),
        "group_name" varchar(200),
        "isactive" varchar(1020),
        "phone" varchar(1020),
        "postcode" varchar(1020),
        "service_type" varchar(4),
        "state_code" varchar(1020),
        "roc" varchar(1020),
        "female_rate" numeric(126),
        "male_rate" numeric(126),
        "business_reg_no" varchar(80),
        "email_address" varchar(100),
        "gst_code" varchar(20),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "gst_tax" numeric(126),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "group_logo" varchar(50),
        "service_provider_master_code" varchar(10),
        "web_taxinvoice" numeric(1),
        "gst_effective_date" timestamp,
        "comments" varchar(4000),
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDER_GROUP_HISTORY');

    raise notice 'created foreign table for SERVICE_PROVIDER_GROUP_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SERVICE_PROVIDER_GROUP_HISTORY;

    -- create table if not exists nios.SERVICE_PROVIDER_GROUP_HISTORY as select * from nios_foreign.SERVICE_PROVIDER_GROUP_HISTORY;

    raise notice 'copied table nios.SERVICE_PROVIDER_GROUP_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SERVICE_PROVIDE_PAY_RATE', 369 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SERVICE_PROVIDE_PAY_RATE;

    create foreign table if not exists nios_foreign.SERVICE_PROVIDE_PAY_RATE (
        "sp_id" numeric(10),
        "service_type" varchar(5),
        "service_provider" varchar(13),
        "male_rate" numeric,
        "female_rate" numeric,
        "start_date" timestamp,
        "end_date" timestamp,
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDE_PAY_RATE');

    raise notice 'created foreign table for SERVICE_PROVIDE_PAY_RATE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SERVICE_PROVIDE_PAY_RATE;

    -- create table if not exists nios.SERVICE_PROVIDE_PAY_RATE as select * from nios_foreign.SERVICE_PROVIDE_PAY_RATE;

    raise notice 'copied table nios.SERVICE_PROVIDE_PAY_RATE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SHADOW_XRAY_RADIO_ASSIGNMENT', 370 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SHADOW_XRAY_RADIO_ASSIGNMENT;

    create foreign table if not exists nios_foreign.SHADOW_XRAY_RADIO_ASSIGNMENT (
        "bc_xray_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "trans_id" varchar(14),
        "status" varchar(1),
        "assignment_date" timestamp,
        "lock_date" timestamp,
        "report_date" timestamp,
        "acknowledge_date" timestamp,
        "create_date" timestamp,
        "modify_date" timestamp,
        "retake_source" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'SHADOW_XRAY_RADIO_ASSIGNMENT');

    raise notice 'created foreign table for SHADOW_XRAY_RADIO_ASSIGNMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SHADOW_XRAY_RADIO_ASSIGNMENT;

    -- create table if not exists nios.SHADOW_XRAY_RADIO_ASSIGNMENT as select * from nios_foreign.SHADOW_XRAY_RADIO_ASSIGNMENT;

    raise notice 'copied table nios.SHADOW_XRAY_RADIO_ASSIGNMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SPECIAL_RENEWAL_REQUEST', 371 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SPECIAL_RENEWAL_REQUEST;

    create foreign table if not exists nios_foreign.SPECIAL_RENEWAL_REQUEST (
        "request_id" numeric,
        "worker_code" varchar(20),
        "worker_name" varchar(50),
        "user_id" varchar(30),
        "father_name" varchar(50),
        "date_of_birth" timestamp,
        "passport_no" varchar(20),
        "arrival_date" timestamp,
        "examination_date" timestamp,
        "foregin_clinic_name" varchar(100),
        "worker_permit_no" varchar(20),
        "last_examine_date" timestamp,
        "blood_group" varchar(3),
        "fit_ind" varchar(1),
        "employer_code" varchar(10),
        "agent_code" varchar(10),
        "doctor_code" varchar(10),
        "employer_name" varchar(150),
        "agent_name" varchar(50),
        "doctor_name" varchar(50),
        "preferred_doctor_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "reason" varchar(255),
        "modify_id" numeric,
        "modification_date" timestamp,
        "creator_id" numeric(10),
        "created_by" varchar(10),
        "approve_comment" varchar(4000),
        "approve_status" varchar(10),
        "approve_date" timestamp,
        "approve_id" numeric,
        "justification" numeric,
        "tranno" varchar(10),
        "country_name" varchar(50),
        "approve_type" varchar(50),
        "country_code" varchar(3),
        "job_type" varchar(50),
        "state_name" varchar(50),
        "district_name" varchar(50),
        "duration_last_exam" varchar(30),
        "branch_code" varchar(2),
        "remark" varchar(4000),
        "pati" varchar(1),
        "plks_no" numeric(3),
        "ispra" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'SPECIAL_RENEWAL_REQUEST');

    raise notice 'created foreign table for SPECIAL_RENEWAL_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SPECIAL_RENEWAL_REQUEST;

    -- create table if not exists nios.SPECIAL_RENEWAL_REQUEST as select * from nios_foreign.SPECIAL_RENEWAL_REQUEST;

    raise notice 'copied table nios.SPECIAL_RENEWAL_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SPPAYMENT_REFERENCE', 372 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SPPAYMENT_REFERENCE;

    create foreign table if not exists nios_foreign.SPPAYMENT_REFERENCE (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(126),
        "batchid" numeric(10),
        "certify_date" timestamp,
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "payment_req_id" numeric(10),
        "transid" varchar(56),
        "branch_code" varchar(2),
        "service_provider_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'SPPAYMENT_REFERENCE');

    raise notice 'created foreign table for SPPAYMENT_REFERENCE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SPPAYMENT_REFERENCE;

    -- create table if not exists nios.SPPAYMENT_REFERENCE as select * from nios_foreign.SPPAYMENT_REFERENCE;

    raise notice 'copied table nios.SPPAYMENT_REFERENCE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table STATE_MASTER', 373 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.STATE_MASTER;

    create foreign table if not exists nios_foreign.STATE_MASTER (
        "state_code" varchar(7),
        "state_name" varchar(15),
        "state_longname" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'STATE_MASTER');

    raise notice 'created foreign table for STATE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.STATE_MASTER;

    -- create table if not exists nios.STATE_MASTER as select * from nios_foreign.STATE_MASTER;

    raise notice 'copied table nios.STATE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table STATE_MASTER_RPT', 374 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.STATE_MASTER_RPT;

    create foreign table if not exists nios_foreign.STATE_MASTER_RPT (
        "state_code" varchar(7),
        "state_name" varchar(15),
        "state_ref" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'STATE_MASTER_RPT');

    raise notice 'created foreign table for STATE_MASTER_RPT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.STATE_MASTER_RPT;

    -- create table if not exists nios.STATE_MASTER_RPT as select * from nios_foreign.STATE_MASTER_RPT;

    raise notice 'copied table nios.STATE_MASTER_RPT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table STATE_POST_MASTER', 375 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.STATE_POST_MASTER;

    create foreign table if not exists nios_foreign.STATE_POST_MASTER (
        "state_code" varchar(7),
        "post_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'STATE_POST_MASTER');

    raise notice 'created foreign table for STATE_POST_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.STATE_POST_MASTER;

    -- create table if not exists nios.STATE_POST_MASTER as select * from nios_foreign.STATE_POST_MASTER;

    raise notice 'copied table nios.STATE_POST_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table STATUS_CHANGE_HISTORY', 376 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.STATUS_CHANGE_HISTORY;

    create foreign table if not exists nios_foreign.STATUS_CHANGE_HISTORY (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "old_status" varchar(1),
        "new_status" varchar(1),
        "userid" varchar(20),
        "mod_date" timestamp,
        "bc_worker_code" varchar(13),
        "source" numeric,
        "action" varchar(10),
        "action_date" timestamp,
        "wrongtrans_ind" varchar(3),
        "source_id" numeric,
        "decision" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'STATUS_CHANGE_HISTORY');

    raise notice 'created foreign table for STATUS_CHANGE_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.STATUS_CHANGE_HISTORY;

    -- create table if not exists nios.STATUS_CHANGE_HISTORY as select * from nios_foreign.STATUS_CHANGE_HISTORY;

    raise notice 'copied table nios.STATUS_CHANGE_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table STATUS_CHANGE_PENDING', 377 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.STATUS_CHANGE_PENDING;

    create foreign table if not exists nios_foreign.STATUS_CHANGE_PENDING (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "old_status" varchar(1),
        "new_status" varchar(1),
        "userid" varchar(20),
        "mod_date" timestamp,
        "bc_worker_code" varchar(13),
        "source" numeric,
        "wrongtrans_ind" varchar(3),
        "source_id" numeric,
        "decision" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'STATUS_CHANGE_PENDING');

    raise notice 'created foreign table for STATUS_CHANGE_PENDING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.STATUS_CHANGE_PENDING;

    -- create table if not exists nios.STATUS_CHANGE_PENDING as select * from nios_foreign.STATUS_CHANGE_PENDING;

    raise notice 'copied table nios.STATUS_CHANGE_PENDING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SUSPENSION_COMMENTS', 378 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SUSPENSION_COMMENTS;

    create foreign table if not exists nios_foreign.SUSPENSION_COMMENTS (
        "suspendid" numeric(10),
        "bc_user_code" varchar(13),
        "category" varchar(5),
        "message_type" varchar(5),
        "comments" varchar(1000),
        "old_status" varchar(5),
        "new_status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "suspend_start" timestamp,
        "suspend_end" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SUSPENSION_COMMENTS');

    raise notice 'created foreign table for SUSPENSION_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SUSPENSION_COMMENTS;

    -- create table if not exists nios.SUSPENSION_COMMENTS as select * from nios_foreign.SUSPENSION_COMMENTS;

    raise notice 'copied table nios.SUSPENSION_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SYNC_LOG', 379 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SYNC_LOG;

    create foreign table if not exists nios_foreign.SYNC_LOG (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'SYNC_LOG');

    raise notice 'created foreign table for SYNC_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SYNC_LOG;

    -- create table if not exists nios.SYNC_LOG as select * from nios_foreign.SYNC_LOG;

    raise notice 'copied table nios.SYNC_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SYNC_TABLE', 380 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.SYNC_TABLE;

    create foreign table if not exists nios_foreign.SYNC_TABLE (
        "table_name" varchar(100),
        "sequence" numeric
    ) server nios_server options (schema 'NIOS1', table 'SYNC_TABLE');

    raise notice 'created foreign table for SYNC_TABLE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.SYNC_TABLE;

    -- create table if not exists nios.SYNC_TABLE as select * from nios_foreign.SYNC_TABLE;

    raise notice 'copied table nios.SYNC_TABLE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TCUPI_TODOLIST', 381 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.TCUPI_TODOLIST;

    create foreign table if not exists nios_foreign.TCUPI_TODOLIST (
        "tcupi_todolist_id" numeric,
        "tcupi_todolist_desc" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'TCUPI_TODOLIST');

    raise notice 'created foreign table for TCUPI_TODOLIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.TCUPI_TODOLIST;

    -- create table if not exists nios.TCUPI_TODOLIST as select * from nios_foreign.TCUPI_TODOLIST;

    raise notice 'copied table nios.TCUPI_TODOLIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TEMP_PENDING_REVIEW_RESEND', 382 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.TEMP_PENDING_REVIEW_RESEND;

    create foreign table if not exists nios_foreign.TEMP_PENDING_REVIEW_RESEND (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'TEMP_PENDING_REVIEW_RESEND');

    raise notice 'created foreign table for TEMP_PENDING_REVIEW_RESEND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.TEMP_PENDING_REVIEW_RESEND;

    -- create table if not exists nios.TEMP_PENDING_REVIEW_RESEND as select * from nios_foreign.TEMP_PENDING_REVIEW_RESEND;

    raise notice 'copied table nios.TEMP_PENDING_REVIEW_RESEND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TEMP_QUARANTINE_FW_DOC', 383 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.TEMP_QUARANTINE_FW_DOC;

    create foreign table if not exists nios_foreign.TEMP_QUARANTINE_FW_DOC (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "doc_code" varchar(13),
        "d1_hiv" char(1),
        "d1_hiv_date" timestamp,
        "d1_tb" char(1),
        "d1_tb_date" timestamp,
        "d1_leprosy" char(1),
        "d1_leprosy_date" timestamp,
        "d1_hepatitis" char(1),
        "d1_hepatitis_date" timestamp,
        "d1_psych" char(1),
        "d1_psych_date" timestamp,
        "d1_epilepsy" char(1),
        "d1_epilepsy_date" timestamp,
        "d1_cancer" char(1),
        "d1_cancer_date" timestamp,
        "d1_std" char(1),
        "d1_std_date" timestamp,
        "d1_malaria" char(1),
        "d1_malaria_date" timestamp,
        "d2_hypertension" char(1),
        "d2_hypertension_date" timestamp,
        "d2_heartdisease" char(1),
        "d2_heartdisease_date" timestamp,
        "d2_asthma" char(1),
        "d2_asthma_date" timestamp,
        "d2_diabetes" char(1),
        "d2_diabetes_date" timestamp,
        "d2_ulcer" char(1),
        "d2_ulcer_date" timestamp,
        "d2_kidney" char(1),
        "d2_kidney_date" timestamp,
        "d2_others" char(1),
        "d2_others_date" timestamp,
        "d2_comments" varchar(4000),
        "d3_heartsize" char(1),
        "d3_heartsound" char(1),
        "d3_othercardio" char(1),
        "d3_breathsound" char(1),
        "d3_otherrespiratory" char(1),
        "d3_liver" char(1),
        "d3_spleen" char(1),
        "d3_swelling" char(1),
        "d3_lymphnodes" char(1),
        "d3_rectal" char(1),
        "d4_mental" char(1),
        "d4_speech" char(1),
        "d4_cognitive" char(1),
        "d4_peripheralnerves" char(1),
        "d4_motorpower" char(1),
        "d4_sensory" char(1),
        "d4_reflexes" char(1),
        "d4_kidney" char(1),
        "d4_gendischarge" char(1),
        "d4_gensores" char(1),
        "d4_comments" varchar(4000),
        "d5_height" numeric(10, 2),
        "d5_weight" numeric(10, 2),
        "d5_pulse" numeric(10, 2),
        "d5_systolic" numeric(10, 2),
        "d5_diastolic" numeric(10, 2),
        "d5_skinrash" char(1),
        "d5_skinpatch" char(1),
        "d5_deformities" char(1),
        "d5_anaemia" char(1),
        "d5_jaundice" char(1),
        "d5_enlargement" char(1),
        "d5_vision_unaidedleft" char(1),
        "d5_vision_unaidedright" char(1),
        "d5_vision_aidedleft" char(1),
        "d5_vision_aidedright" char(1),
        "d5_hearingleft" char(1),
        "d5_hearingright" char(1),
        "d5_others" char(1),
        "d5_comments" varchar(4000),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "d7_fw_medstatus" char(1),
        "d7_comments" varchar(4000),
        "d7_unfit_reason" varchar(4000),
        "d8_notifymoh" char(1),
        "d8_notifymoh_date" timestamp,
        "d8_refergh" char(1),
        "d8_refergh_date" timestamp,
        "d8_referph" char(1),
        "d8_referph_date" timestamp,
        "d8_treatpatient" char(1),
        "d8_treatpatient_date" timestamp,
        "d8_ongoingtreatment" char(1),
        "d8_ongoingtreatment_date" timestamp,
        "examination_date" timestamp,
        "certification_date" timestamp,
        "l1_flag" char(1),
        "l1_bloodgroup" char(2),
        "l1_bloodrh" char(1),
        "l1_elisa" char(1),
        "l1_hbsag" char(1),
        "l1_vdrltpha" char(1),
        "l1_malaria" char(1),
        "l1_urineopiates" char(1),
        "l1_urinecannabis" char(1),
        "l1_urinepregnancy" char(1),
        "l1_urinecolor" char(1),
        "l1_urinegravity" char(1),
        "l1_urinesugar" char(1),
        "l1_urinesugar1plus" char(1),
        "l1_urinesugar2plus" char(1),
        "l1_urinesugar3plus" char(1),
        "l1_urinesugar4plus" char(1),
        "l1_sugarmilimoles" varchar(7),
        "l1_urinealbumin" char(1),
        "l1_urinealbumin1plus" char(1),
        "l1_urinealbumin2plus" char(1),
        "l1_urinealbumin3plus" char(1),
        "l1_urinealbumin4plus" char(1),
        "l1_albuminmilimoles" varchar(5),
        "l1_urinemicroexam" char(1),
        "l1_reason" varchar(4000),
        "l1_labresultdate" timestamp,
        "l1_specimendate" timestamp,
        "r1_flag" char(1),
        "r1_thoraciccage" char(1),
        "r1_heartszshape" char(1),
        "r1_lungfields" char(1),
        "r1_xrayresultdate" timestamp,
        "r1_xraydonedate" timestamp,
        "fw_name" varchar(50),
        "fw_dateofbirth" timestamp,
        "fw_sex" char(1),
        "fw_jobtype" varchar(50),
        "fw_passportno" varchar(30),
        "employer_code" varchar(10),
        "fw_countryname" varchar(50),
        "lab_code" varchar(13),
        "rad_code" varchar(13),
        "xray_code" varchar(13),
        "quarantine_reason" varchar(4000),
        "status" varchar(5),
        "inspstatus" char(1),
        "time_inserted" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "last_pms_date" timestamp,
        "d2_taken_drugs" char(1),
        "r1_focallesion" char(1),
        "r1_otherabnormalities" char(1),
        "r1_impression" varchar(4000),
        "r1_mediastinum" char(1),
        "r1_pleura" char(1),
        "r1_thoraciccage_detail" varchar(1000),
        "r1_heartszshape_detail" varchar(1000),
        "r1_lungfields_detail" varchar(1000),
        "r1_mediastinum_detail" varchar(1000),
        "r1_pleura_detail" varchar(1000),
        "r1_focallesion_detail" varchar(1000),
        "r1_otherabnormalities_detail" varchar(1000),
        "l1_tpha" char(1),
        "l1_sgvalue" varchar(20),
        "l1_urinemicroexam_reason" varchar(4000),
        "source" char(1),
        "l1_ibtv2" char(1),
        "l1_batchnum" varchar(10),
        "tcupi_letter_refid" numeric(10),
        "tcupi_xrayletter_refid" numeric(10),
        "qrtn_source" numeric(1),
        "process" char(1),
        "process_date" timestamp,
        "process_xfit_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'TEMP_QUARANTINE_FW_DOC');

    raise notice 'created foreign table for TEMP_QUARANTINE_FW_DOC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.TEMP_QUARANTINE_FW_DOC;

    -- create table if not exists nios.TEMP_QUARANTINE_FW_DOC as select * from nios_foreign.TEMP_QUARANTINE_FW_DOC;

    raise notice 'copied table nios.TEMP_QUARANTINE_FW_DOC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TRANSFER_LOG', 384 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.TRANSFER_LOG;

    create foreign table if not exists nios_foreign.TRANSFER_LOG (
        "table_name" varchar(100),
        "key_value" varchar(100),
        "errmsg" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'TRANSFER_LOG');

    raise notice 'created foreign table for TRANSFER_LOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.TRANSFER_LOG;

    -- create table if not exists nios.TRANSFER_LOG as select * from nios_foreign.TRANSFER_LOG;

    raise notice 'copied table nios.TRANSFER_LOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_AGENT_DISTRICT', 385 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_AGENT_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_AGENT_DISTRICT (
        "agent_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_AGENT_DISTRICT');

    raise notice 'created foreign table for T_CNV_AGENT_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_AGENT_DISTRICT;

    -- create table if not exists nios.T_CNV_AGENT_DISTRICT as select * from nios_foreign.T_CNV_AGENT_DISTRICT;

    raise notice 'copied table nios.T_CNV_AGENT_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_DOCTORH_DISTRICT', 386 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_DOCTORH_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_DOCTORH_DISTRICT (
        "doctor_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_DOCTORH_DISTRICT');

    raise notice 'created foreign table for T_CNV_DOCTORH_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_DOCTORH_DISTRICT;

    -- create table if not exists nios.T_CNV_DOCTORH_DISTRICT as select * from nios_foreign.T_CNV_DOCTORH_DISTRICT;

    raise notice 'copied table nios.T_CNV_DOCTORH_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_DOCTOR_DISTRICT', 387 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_DOCTOR_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_DOCTOR_DISTRICT (
        "doctor_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_DOCTOR_DISTRICT');

    raise notice 'created foreign table for T_CNV_DOCTOR_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_DOCTOR_DISTRICT;

    -- create table if not exists nios.T_CNV_DOCTOR_DISTRICT as select * from nios_foreign.T_CNV_DOCTOR_DISTRICT;

    raise notice 'copied table nios.T_CNV_DOCTOR_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_EMPLOYERH_DISTRICT', 388 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_EMPLOYERH_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_EMPLOYERH_DISTRICT (
        "employer_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_EMPLOYERH_DISTRICT');

    raise notice 'created foreign table for T_CNV_EMPLOYERH_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_EMPLOYERH_DISTRICT;

    -- create table if not exists nios.T_CNV_EMPLOYERH_DISTRICT as select * from nios_foreign.T_CNV_EMPLOYERH_DISTRICT;

    raise notice 'copied table nios.T_CNV_EMPLOYERH_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_EMPLOYER_DISTRICT', 389 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_EMPLOYER_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_EMPLOYER_DISTRICT (
        "employer_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_EMPLOYER_DISTRICT');

    raise notice 'created foreign table for T_CNV_EMPLOYER_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_EMPLOYER_DISTRICT;

    -- create table if not exists nios.T_CNV_EMPLOYER_DISTRICT as select * from nios_foreign.T_CNV_EMPLOYER_DISTRICT;

    raise notice 'copied table nios.T_CNV_EMPLOYER_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_LABORATORYH_DISTRICT', 390 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_LABORATORYH_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_LABORATORYH_DISTRICT (
        "laboratory_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_LABORATORYH_DISTRICT');

    raise notice 'created foreign table for T_CNV_LABORATORYH_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_LABORATORYH_DISTRICT;

    -- create table if not exists nios.T_CNV_LABORATORYH_DISTRICT as select * from nios_foreign.T_CNV_LABORATORYH_DISTRICT;

    raise notice 'copied table nios.T_CNV_LABORATORYH_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_LABORATORY_DISTRICT', 391 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_LABORATORY_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_LABORATORY_DISTRICT (
        "laboratory_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_LABORATORY_DISTRICT');

    raise notice 'created foreign table for T_CNV_LABORATORY_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_LABORATORY_DISTRICT;

    -- create table if not exists nios.T_CNV_LABORATORY_DISTRICT as select * from nios_foreign.T_CNV_LABORATORY_DISTRICT;

    raise notice 'copied table nios.T_CNV_LABORATORY_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_RADIOLOGISTH_DISTRICT', 392 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_RADIOLOGISTH_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_RADIOLOGISTH_DISTRICT (
        "radiologist_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_RADIOLOGISTH_DISTRICT');

    raise notice 'created foreign table for T_CNV_RADIOLOGISTH_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_RADIOLOGISTH_DISTRICT;

    -- create table if not exists nios.T_CNV_RADIOLOGISTH_DISTRICT as select * from nios_foreign.T_CNV_RADIOLOGISTH_DISTRICT;

    raise notice 'copied table nios.T_CNV_RADIOLOGISTH_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_RADIOLOGIST_DISTRICT', 393 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_RADIOLOGIST_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_RADIOLOGIST_DISTRICT (
        "radiologist_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_RADIOLOGIST_DISTRICT');

    raise notice 'created foreign table for T_CNV_RADIOLOGIST_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_RADIOLOGIST_DISTRICT;

    -- create table if not exists nios.T_CNV_RADIOLOGIST_DISTRICT as select * from nios_foreign.T_CNV_RADIOLOGIST_DISTRICT;

    raise notice 'copied table nios.T_CNV_RADIOLOGIST_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_WORKER_DOCTOR', 394 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_WORKER_DOCTOR;

    create foreign table if not exists nios_foreign.T_CNV_WORKER_DOCTOR (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "certify_date" timestamp,
        "allocation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_WORKER_DOCTOR');

    raise notice 'created foreign table for T_CNV_WORKER_DOCTOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_WORKER_DOCTOR;

    -- create table if not exists nios.T_CNV_WORKER_DOCTOR as select * from nios_foreign.T_CNV_WORKER_DOCTOR;

    raise notice 'copied table nios.T_CNV_WORKER_DOCTOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_WORKER_DOCTOR_A', 395 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_WORKER_DOCTOR_A;

    create foreign table if not exists nios_foreign.T_CNV_WORKER_DOCTOR_A (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "certify_date" timestamp,
        "allocation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_WORKER_DOCTOR_A');

    raise notice 'created foreign table for T_CNV_WORKER_DOCTOR_A';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_WORKER_DOCTOR_A;

    -- create table if not exists nios.T_CNV_WORKER_DOCTOR_A as select * from nios_foreign.T_CNV_WORKER_DOCTOR_A;

    raise notice 'copied table nios.T_CNV_WORKER_DOCTOR_A';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_XRAYH_DISTRICT', 396 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_XRAYH_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_XRAYH_DISTRICT (
        "xray_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_XRAYH_DISTRICT');

    raise notice 'created foreign table for T_CNV_XRAYH_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_XRAYH_DISTRICT;

    -- create table if not exists nios.T_CNV_XRAYH_DISTRICT as select * from nios_foreign.T_CNV_XRAYH_DISTRICT;

    raise notice 'copied table nios.T_CNV_XRAYH_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CNV_XRAY_DISTRICT', 397 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CNV_XRAY_DISTRICT;

    create foreign table if not exists nios_foreign.T_CNV_XRAY_DISTRICT (
        "xray_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_XRAY_DISTRICT');

    raise notice 'created foreign table for T_CNV_XRAY_DISTRICT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CNV_XRAY_DISTRICT;

    -- create table if not exists nios.T_CNV_XRAY_DISTRICT as select * from nios_foreign.T_CNV_XRAY_DISTRICT;

    raise notice 'copied table nios.T_CNV_XRAY_DISTRICT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_DOCTOR', 398 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR (
        "nongroup_doctor" varchar(1000),
        "state_ref" varchar(3),
        "doctor_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_DOCTOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_DOCTOR;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_DOCTOR as select * from nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_DOCTOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_DOCTOR_DTL', 399 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_DTL;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_DTL (
        "nongroup_result" varchar(124),
        "state_ref" varchar(3),
        "doctor_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR_DTL');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_DOCTOR_DTL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_DOCTOR_DTL;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_DOCTOR_DTL as select * from nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_DTL;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_DOCTOR_DTL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_DOCTOR_TTL', 400 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_TTL;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_TTL (
        "state_ref" varchar(3),
        "cnt" numeric,
        "total" numeric
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR_TTL');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_DOCTOR_TTL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_DOCTOR_TTL;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_DOCTOR_TTL as select * from nios_foreign.T_CONV_FIN_NONGROUP_DOCTOR_TTL;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_DOCTOR_TTL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_XRAY', 401 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY (
        "nongroup_xray" varchar(1000),
        "state_ref" varchar(3),
        "xray_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_XRAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_XRAY;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_XRAY as select * from nios_foreign.T_CONV_FIN_NONGROUP_XRAY;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_XRAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_XRAY_DTL', 402 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY_DTL;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY_DTL (
        "nongroup_result" varchar(124),
        "state_ref" varchar(3),
        "xray_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY_DTL');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_XRAY_DTL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_XRAY_DTL;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_XRAY_DTL as select * from nios_foreign.T_CONV_FIN_NONGROUP_XRAY_DTL;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_XRAY_DTL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_CONV_FIN_NONGROUP_XRAY_TTL', 403 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY_TTL;

    create foreign table if not exists nios_foreign.T_CONV_FIN_NONGROUP_XRAY_TTL (
        "state_ref" varchar(3),
        "cnt" numeric,
        "total" numeric
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY_TTL');

    raise notice 'created foreign table for T_CONV_FIN_NONGROUP_XRAY_TTL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_CONV_FIN_NONGROUP_XRAY_TTL;

    -- create table if not exists nios.T_CONV_FIN_NONGROUP_XRAY_TTL as select * from nios_foreign.T_CONV_FIN_NONGROUP_XRAY_TTL;

    raise notice 'copied table nios.T_CONV_FIN_NONGROUP_XRAY_TTL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_OBJ_MIGRATED', 404 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_OBJ_MIGRATED;

    create foreign table if not exists nios_foreign.T_OBJ_MIGRATED (
        "object_name" varchar(30),
        "date_migrated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_OBJ_MIGRATED');

    raise notice 'created foreign table for T_OBJ_MIGRATED';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_OBJ_MIGRATED;

    -- create table if not exists nios.T_OBJ_MIGRATED as select * from nios_foreign.T_OBJ_MIGRATED;

    raise notice 'copied table nios.T_OBJ_MIGRATED';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table T_WPC', 405 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.T_WPC;

    create foreign table if not exists nios_foreign.T_WPC (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "country_name" varchar(50),
        "req_id" varchar(16),
        "err_code" varchar(5),
        "old_worker_code" varchar(10),
        "old_worker_name" varchar(50),
        "old_passport_no" varchar(20),
        "old_country_name" varchar(50),
        "employer_code" varchar(10),
        "old_employer_code" varchar(10),
        "emp_req_id" varchar(16),
        "old_emp_req_id" varchar(16)
    ) server nios_server options (schema 'NIOS1', table 'T_WPC');

    raise notice 'created foreign table for T_WPC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.T_WPC;

    -- create table if not exists nios.T_WPC as select * from nios_foreign.T_WPC;

    raise notice 'copied table nios.T_WPC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UM_MODULE_MASTER', 406 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UM_MODULE_MASTER;

    create foreign table if not exists nios_foreign.UM_MODULE_MASTER (
        "mod_id" numeric,
        "parent_mod_id" numeric,
        "mod_desc" varchar(50),
        "description" varchar(250),
        "modified_date" timestamp,
        "created_date" timestamp,
        "sort_order" numeric,
        "isactive" numeric,
        "url" varchar(250)
    ) server nios_server options (schema 'NIOS1', table 'UM_MODULE_MASTER');

    raise notice 'created foreign table for UM_MODULE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UM_MODULE_MASTER;

    -- create table if not exists nios.UM_MODULE_MASTER as select * from nios_foreign.UM_MODULE_MASTER;

    raise notice 'copied table nios.UM_MODULE_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UM_USER_CAPABILITY', 407 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UM_USER_CAPABILITY;

    create foreign table if not exists nios_foreign.UM_USER_CAPABILITY (
        "uuid" numeric(10),
        "mod_id" numeric(38),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'UM_USER_CAPABILITY');

    raise notice 'created foreign table for UM_USER_CAPABILITY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UM_USER_CAPABILITY;

    -- create table if not exists nios.UM_USER_CAPABILITY as select * from nios_foreign.UM_USER_CAPABILITY;

    raise notice 'copied table nios.UM_USER_CAPABILITY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UM_USER_MASTER', 408 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UM_USER_MASTER;

    create foreign table if not exists nios_foreign.UM_USER_MASTER (
        "uuid" numeric(10),
        "passwordcount" numeric,
        "attempdate" timestamp,
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'UM_USER_MASTER');

    raise notice 'created foreign table for UM_USER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UM_USER_MASTER;

    -- create table if not exists nios.UM_USER_MASTER as select * from nios_foreign.UM_USER_MASTER;

    raise notice 'copied table nios.UM_USER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UNDEFINE_DOCTOR', 409 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UNDEFINE_DOCTOR;

    create foreign table if not exists nios_foreign.UNDEFINE_DOCTOR (
        "doctor_code" varchar(10),
        "doctor_name" varchar(50),
        "clinic_name" varchar(50),
        "creation_date" timestamp,
        "doctor_ic_new" varchar(20),
        "doctor_ic_old" varchar(20),
        "annual_practice_certificate" varchar(20),
        "application_number" varchar(7),
        "application_year" varchar(4),
        "kdm_member" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "state_code" varchar(7),
        "district_code" varchar(7),
        "country_code" varchar(3),
        "radiologist_code" varchar(10),
        "xray_code" varchar(10),
        "laboratory_code" varchar(10),
        "email_id" varchar(100),
        "xray_regn_no" varchar(20),
        "version_no" varchar(10),
        "own_xray_clinic" varchar(1),
        "qualification" varchar(50),
        "no_of_solo_clinics" varchar(2),
        "no_of_group_clinics" varchar(2),
        "status_code" varchar(5),
        "comments" varchar(40),
        "numquarantine" numeric(4),
        "district_name" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'UNDEFINE_DOCTOR');

    raise notice 'created foreign table for UNDEFINE_DOCTOR';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UNDEFINE_DOCTOR;

    -- create table if not exists nios.UNDEFINE_DOCTOR as select * from nios_foreign.UNDEFINE_DOCTOR;

    raise notice 'copied table nios.UNDEFINE_DOCTOR';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UNSUITABLE_REASONS', 410 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UNSUITABLE_REASONS;

    create foreign table if not exists nios_foreign.UNSUITABLE_REASONS (
        "unsuitable_id" numeric(10),
        "reason_eng" varchar(100),
        "reason_bm" varchar(100),
        "priority" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'UNSUITABLE_REASONS');

    raise notice 'created foreign table for UNSUITABLE_REASONS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UNSUITABLE_REASONS;

    -- create table if not exists nios.UNSUITABLE_REASONS as select * from nios_foreign.UNSUITABLE_REASONS;

    raise notice 'copied table nios.UNSUITABLE_REASONS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table UNSUITABLE_REASONS_MAP', 411 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.UNSUITABLE_REASONS_MAP;

    create foreign table if not exists nios_foreign.UNSUITABLE_REASONS_MAP (
        "parameter_code" varchar(10),
        "unsuitable_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'UNSUITABLE_REASONS_MAP');

    raise notice 'created foreign table for UNSUITABLE_REASONS_MAP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.UNSUITABLE_REASONS_MAP;

    -- create table if not exists nios.UNSUITABLE_REASONS_MAP as select * from nios_foreign.UNSUITABLE_REASONS_MAP;

    raise notice 'copied table nios.UNSUITABLE_REASONS_MAP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERCAP_DETAIL', 412 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERCAP_DETAIL;

    create foreign table if not exists nios_foreign.USERCAP_DETAIL (
        "cap_id" varchar(10),
        "module_id" varchar(30),
        "allow_action" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'USERCAP_DETAIL');

    raise notice 'created foreign table for USERCAP_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERCAP_DETAIL;

    -- create table if not exists nios.USERCAP_DETAIL as select * from nios_foreign.USERCAP_DETAIL;

    raise notice 'copied table nios.USERCAP_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERCAP_MASTER', 413 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERCAP_MASTER;

    create foreign table if not exists nios_foreign.USERCAP_MASTER (
        "cap_id" varchar(10),
        "description" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USERCAP_MASTER');

    raise notice 'created foreign table for USERCAP_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERCAP_MASTER;

    -- create table if not exists nios.USERCAP_MASTER as select * from nios_foreign.USERCAP_MASTER;

    raise notice 'copied table nios.USERCAP_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERLOG', 414 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERLOG;

    create foreign table if not exists nios_foreign.USERLOG (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(150),
        "ipaddr" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG');

    raise notice 'created foreign table for USERLOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERLOG;

    -- create table if not exists nios.USERLOG as select * from nios_foreign.USERLOG;

    raise notice 'copied table nios.USERLOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERLOG_ARC', 415 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERLOG_ARC;

    create foreign table if not exists nios_foreign.USERLOG_ARC (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(100),
        "ipaddr" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG_ARC');

    raise notice 'created foreign table for USERLOG_ARC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERLOG_ARC;

    -- create table if not exists nios.USERLOG_ARC as select * from nios_foreign.USERLOG_ARC;

    raise notice 'copied table nios.USERLOG_ARC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERLOG_BROWSER', 416 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERLOG_BROWSER;

    create foreign table if not exists nios_foreign.USERLOG_BROWSER (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "header" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG_BROWSER');

    raise notice 'created foreign table for USERLOG_BROWSER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERLOG_BROWSER;

    -- create table if not exists nios.USERLOG_BROWSER as select * from nios_foreign.USERLOG_BROWSER;

    raise notice 'copied table nios.USERLOG_BROWSER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERMASTER', 417 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERMASTER;

    create foreign table if not exists nios_foreign.USERMASTER (
        "userid" varchar(10),
        "fullname" varchar(50),
        "cap_id" varchar(10),
        "password" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'USERMASTER');

    raise notice 'created foreign table for USERMASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERMASTER;

    -- create table if not exists nios.USERMASTER as select * from nios_foreign.USERMASTER;

    raise notice 'copied table nios.USERMASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USEROLDPASS', 418 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USEROLDPASS;

    create foreign table if not exists nios_foreign.USEROLDPASS (
        "usercode" varchar(13),
        "userpass" varchar(50),
        "changedate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USEROLDPASS');

    raise notice 'created foreign table for USEROLDPASS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USEROLDPASS;

    -- create table if not exists nios.USEROLDPASS as select * from nios_foreign.USEROLDPASS;

    raise notice 'copied table nios.USEROLDPASS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERPASSWORD_TRANS', 419 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERPASSWORD_TRANS;

    create foreign table if not exists nios_foreign.USERPASSWORD_TRANS (
        "uuid" varchar(20),
        "password" varchar(100),
        "date_change" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USERPASSWORD_TRANS');

    raise notice 'created foreign table for USERPASSWORD_TRANS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERPASSWORD_TRANS;

    -- create table if not exists nios.USERPASSWORD_TRANS as select * from nios_foreign.USERPASSWORD_TRANS;

    raise notice 'copied table nios.USERPASSWORD_TRANS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USERS', 420 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USERS;

    create foreign table if not exists nios_foreign.USERS (
        "usercode" varchar(13),
        "username" varchar(100),
        "userpass" varchar(100),
        "lastlogindate" timestamp,
        "logoutdate" timestamp,
        "status" varchar(10),
        "inetuser" varchar(2),
        "loginaccess" numeric(10),
        "ismerts" numeric,
        "islogin" numeric,
        "isnewpass" char(1),
        "newpassdate" timestamp,
        "reset_sessid" varchar(100),
        "reset_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USERS');

    raise notice 'created foreign table for USERS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USERS;

    -- create table if not exists nios.USERS as select * from nios_foreign.USERS;

    raise notice 'copied table nios.USERS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_BRANCHES', 421 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USER_BRANCHES;

    create foreign table if not exists nios_foreign.USER_BRANCHES (
        "uuid" numeric(10),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'USER_BRANCHES');

    raise notice 'created foreign table for USER_BRANCHES';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USER_BRANCHES;

    -- create table if not exists nios.USER_BRANCHES as select * from nios_foreign.USER_BRANCHES;

    raise notice 'copied table nios.USER_BRANCHES';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_CAPABILITY', 422 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USER_CAPABILITY;

    create foreign table if not exists nios_foreign.USER_CAPABILITY (
        "uuid" numeric(10),
        "capid" numeric(18),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USER_CAPABILITY');

    raise notice 'created foreign table for USER_CAPABILITY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USER_CAPABILITY;

    -- create table if not exists nios.USER_CAPABILITY as select * from nios_foreign.USER_CAPABILITY;

    raise notice 'copied table nios.USER_CAPABILITY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_COMMENTS', 423 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USER_COMMENTS;

    create foreign table if not exists nios_foreign.USER_COMMENTS (
        "msgno" varchar(10),
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "subject" varchar(100),
        "message" varchar(4000),
        "email" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USER_COMMENTS');

    raise notice 'created foreign table for USER_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USER_COMMENTS;

    -- create table if not exists nios.USER_COMMENTS as select * from nios_foreign.USER_COMMENTS;

    raise notice 'copied table nios.USER_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_SESSION', 425 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USER_SESSION;

    create foreign table if not exists nios_foreign.USER_SESSION (
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "request_uri" varchar(4000),
        "timeout" numeric(10),
        "module" varchar(5),
        "userid" varchar(20),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'USER_SESSION');

    raise notice 'created foreign table for USER_SESSION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USER_SESSION;

    -- create table if not exists nios.USER_SESSION as select * from nios_foreign.USER_SESSION;

    raise notice 'copied table nios.USER_SESSION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_SESSION_HISTORY', 426 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.USER_SESSION_HISTORY;

    create foreign table if not exists nios_foreign.USER_SESSION_HISTORY (
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "request_uri" varchar(4000),
        "timeout" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'USER_SESSION_HISTORY');

    raise notice 'created foreign table for USER_SESSION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.USER_SESSION_HISTORY;

    -- create table if not exists nios.USER_SESSION_HISTORY as select * from nios_foreign.USER_SESSION_HISTORY;

    raise notice 'copied table nios.USER_SESSION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_PLAN_DETAIL', 427 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_PLAN_DETAIL;

    create foreign table if not exists nios_foreign.VISIT_PLAN_DETAIL (
        "plan_id" numeric,
        "provider_id" varchar(10),
        "state_code" varchar(20),
        "district_code" varchar(20),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'VISIT_PLAN_DETAIL');

    raise notice 'created foreign table for VISIT_PLAN_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_PLAN_DETAIL;

    -- create table if not exists nios.VISIT_PLAN_DETAIL as select * from nios_foreign.VISIT_PLAN_DETAIL;

    raise notice 'copied table nios.VISIT_PLAN_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_PLAN_MASTER', 428 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_PLAN_MASTER;

    create foreign table if not exists nios_foreign.VISIT_PLAN_MASTER (
        "plan_id" numeric,
        "plan_status" char(1),
        "category" char(1),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'VISIT_PLAN_MASTER');

    raise notice 'created foreign table for VISIT_PLAN_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_PLAN_MASTER;

    -- create table if not exists nios.VISIT_PLAN_MASTER as select * from nios_foreign.VISIT_PLAN_MASTER;

    raise notice 'copied table nios.VISIT_PLAN_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_DOCXRAY', 429 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_DOCXRAY;

    create foreign table if not exists nios_foreign.VISIT_RPT_DOCXRAY (
        "provider_code" varchar(10),
        "facility_name" varchar(100),
        "visit_date" timestamp,
        "start_time" timestamp,
        "end_time" timestamp,
        "fomema_officer1" varchar(50),
        "fw_present_count" numeric,
        "fw_id_verification" char(2),
        "apc_serial_no" varchar(50),
        "healthact_regno" varchar(50),
        "xray_centre_lic" varchar(50),
        "xray_centre_expirydate" timestamp,
        "fw_written_consent" varchar(2),
        "disease_notification" varchar(2),
        "clinic_facility_adequate" varchar(2),
        "clinic_facility_comment" varchar(4000),
        "fw_medical_record" varchar(2),
        "lab_coc_adequate" varchar(2),
        "lab_coc_comment" varchar(4000),
        "xray_xqcc_doc_adequate" varchar(2),
        "xray_xqcc_doc_comment" varchar(4000),
        "others_comment" varchar(4000),
        "recommendation" varchar(4000),
        "fomema_officer3" varchar(50),
        "fomema_officer2" varchar(50),
        "xray_centre_storage" varchar(2),
        "xray_centre_operate" varchar(2),
        "report_submit_date" timestamp,
        "report_id" numeric,
        "doc_rad_name" varchar(50),
        "cfm_apc_original" varchar(2),
        "healthact_registered" varchar(2),
        "creation_date" timestamp,
        "modify_date" timestamp,
        "creator_id" varchar(20),
        "modify_id" varchar(20),
        "insp_others" varchar(50),
        "moh_representative" varchar(50),
        "apc_year" varchar(4),
        "remarks" varchar(4000),
        "doctor_comment" varchar(4000),
        "type_visit" varchar(50),
        "interactedwith" varchar(50),
        "visit_checklist_num" numeric(19),
        "vacutainer_expirydate" timestamp,
        "vacutainer" varchar(2),
        "radiographer_name" varchar(50),
        "type_visit_others" varchar(50),
        "operation_hrs" varchar(2),
        "mon_hrs" varchar(50),
        "tue_hrs" varchar(50),
        "wed_hrs" varchar(50),
        "thu_hrs" varchar(50),
        "fri_hrs" varchar(50),
        "sat_hrs" varchar(50),
        "sun_hrs" varchar(50),
        "operation_hrs_comment" varchar(4000),
        "verify_fw_comment" varchar(4000),
        "apc_comment" varchar(4000),
        "xray_license_comment" varchar(4000),
        "fw_medical_comment" varchar(4000),
        "healthact_comment" varchar(4000),
        "fw_written_comment" varchar(4000),
        "disease_notification_comment" varchar(4000),
        "vacutainer_comment" varchar(4000),
        "no_disease_notify" varchar(2),
        "prepared_by" varchar(20),
        "prepared_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_DOCXRAY');

    raise notice 'created foreign table for VISIT_RPT_DOCXRAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_DOCXRAY;

    -- create table if not exists nios.VISIT_RPT_DOCXRAY as select * from nios_foreign.VISIT_RPT_DOCXRAY;

    raise notice 'copied table nios.VISIT_RPT_DOCXRAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_FOLLOWUP', 430 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_FOLLOWUP;

    create foreign table if not exists nios_foreign.VISIT_RPT_FOLLOWUP (
        "followup_id" numeric,
        "visit_report_id" numeric,
        "service_provider_code" varchar(10),
        "type" varchar(10),
        "modify_date" timestamp,
        "modify_id" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_FOLLOWUP');

    raise notice 'created foreign table for VISIT_RPT_FOLLOWUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_FOLLOWUP;

    -- create table if not exists nios.VISIT_RPT_FOLLOWUP as select * from nios_foreign.VISIT_RPT_FOLLOWUP;

    raise notice 'copied table nios.VISIT_RPT_FOLLOWUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_FOLLOWUP_COMMENTS', 431 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_FOLLOWUP_COMMENTS;

    create foreign table if not exists nios_foreign.VISIT_RPT_FOLLOWUP_COMMENTS (
        "followup_id" numeric,
        "createdate" timestamp,
        "addedby" numeric,
        "comments" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_FOLLOWUP_COMMENTS');

    raise notice 'created foreign table for VISIT_RPT_FOLLOWUP_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_FOLLOWUP_COMMENTS;

    -- create table if not exists nios.VISIT_RPT_FOLLOWUP_COMMENTS as select * from nios_foreign.VISIT_RPT_FOLLOWUP_COMMENTS;

    raise notice 'copied table nios.VISIT_RPT_FOLLOWUP_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_LABDETAIL', 432 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_LABDETAIL;

    create foreign table if not exists nios_foreign.VISIT_RPT_LABDETAIL (
        "rpt_seq" varchar(20),
        "datavalue" varchar(4000),
        "report_id" numeric
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_LABDETAIL');

    raise notice 'created foreign table for VISIT_RPT_LABDETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_LABDETAIL;

    -- create table if not exists nios.VISIT_RPT_LABDETAIL as select * from nios_foreign.VISIT_RPT_LABDETAIL;

    raise notice 'copied table nios.VISIT_RPT_LABDETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_LABMASTER', 433 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_LABMASTER;

    create foreign table if not exists nios_foreign.VISIT_RPT_LABMASTER (
        "laboratory_code" varchar(10),
        "visit_date" timestamp,
        "visit_type" varchar(30),
        "start_time" timestamp,
        "end_time" timestamp,
        "lab_category" varchar(30),
        "cov_districtcode" varchar(500),
        "attd_lab_personnel" varchar(500),
        "staff_pathologist" varchar(500),
        "staff_degholder_cnt" numeric,
        "staff_dipholder_cnt" numeric,
        "staff_technician_cnt" numeric,
        "staff_despatch_cnt" numeric,
        "staff_others_cnt" numeric,
        "staffing" varchar(1000),
        "report_id" numeric,
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modify_date" timestamp,
        "moh_representative" varchar(50),
        "report_submit_date" timestamp,
        "insp_others" varchar(50),
        "insp_team" varchar(500),
        "nontechnical_degree_cnt" numeric,
        "nontechnical_diploma_cnt" numeric,
        "nontechnical_cert_cnt" numeric,
        "technical_degree_cnt" numeric,
        "technical_diploma_cnt" numeric,
        "technical_cert_cnt" numeric,
        "despatch_degree_cnt" numeric,
        "despatch_diploma_cnt" numeric,
        "despatch_cert_cnt" numeric,
        "others_degree_cnt" numeric,
        "others_diploma_cnt" numeric,
        "others_cert_cnt" numeric,
        "referral_lab" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_LABMASTER');

    raise notice 'created foreign table for VISIT_RPT_LABMASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_LABMASTER;

    -- create table if not exists nios.VISIT_RPT_LABMASTER as select * from nios_foreign.VISIT_RPT_LABMASTER;

    raise notice 'copied table nios.VISIT_RPT_LABMASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_SOP_COMPLIANCE', 434 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_SOP_COMPLIANCE;

    create foreign table if not exists nios_foreign.VISIT_RPT_SOP_COMPLIANCE (
        "report_id" numeric,
        "sopcomp_ind" varchar(2),
        "sopcomp_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_SOP_COMPLIANCE');

    raise notice 'created foreign table for VISIT_RPT_SOP_COMPLIANCE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_SOP_COMPLIANCE;

    -- create table if not exists nios.VISIT_RPT_SOP_COMPLIANCE as select * from nios_foreign.VISIT_RPT_SOP_COMPLIANCE;

    raise notice 'copied table nios.VISIT_RPT_SOP_COMPLIANCE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table VISIT_RPT_XQCC', 435 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.VISIT_RPT_XQCC;

    create foreign table if not exists nios_foreign.VISIT_RPT_XQCC (
        "provider_code" varchar(10),
        "facility_name" varchar(100),
        "visit_date" timestamp,
        "start_time" timestamp,
        "end_time" timestamp,
        "fomema_officer1" varchar(50),
        "fw_present_count" numeric,
        "fw_id_verification" char(2),
        "apc_serial_no" varchar(50),
        "healthact_regno" varchar(50),
        "xray_centre_lic" varchar(50),
        "xray_centre_expirydate" timestamp,
        "fw_written_consent" varchar(2),
        "disease_notification" varchar(2),
        "clinic_facility_adequate" varchar(2),
        "clinic_facility_comment" varchar(4000),
        "fw_medical_record" varchar(2),
        "lab_coc_adequate" varchar(2),
        "lab_coc_comment" varchar(4000),
        "xray_xqcc_doc_adequate" varchar(2),
        "xray_xqcc_doc_comment" varchar(4000),
        "others_comment" varchar(4000),
        "recommendation" varchar(4000),
        "fomema_officer3" varchar(50),
        "fomema_officer2" varchar(50),
        "xray_centre_storage" varchar(2),
        "xray_centre_operate" varchar(2),
        "report_submit_date" timestamp,
        "report_id" numeric,
        "doc_rad_name" varchar(50),
        "cfm_apc_original" varchar(2),
        "healthact_registered" varchar(2),
        "creation_date" timestamp,
        "modify_date" timestamp,
        "creator_id" varchar(20),
        "modify_id" varchar(20),
        "insp_others" varchar(50),
        "moh_representative" varchar(50),
        "apc_year" varchar(4),
        "remarks" varchar(4000),
        "radiographer_name" varchar(100),
        "rad_xray_documentation" varchar(2),
        "image_self_submit" varchar(2),
        "image_assign_radiologist" varchar(2),
        "duration_upload_more24h" varchar(2),
        "duration_upload_less24h" varchar(2),
        "size_of_ip_plate" varchar(20),
        "cr_dr_system" varchar(4000),
        "history_of_facility" varchar(4000),
        "seminar_attendees" varchar(4000),
        "unit_size_ip_plate" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_XQCC');

    raise notice 'created foreign table for VISIT_RPT_XQCC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.VISIT_RPT_XQCC;

    -- create table if not exists nios.VISIT_RPT_XQCC as select * from nios_foreign.VISIT_RPT_XQCC;

    raise notice 'copied table nios.VISIT_RPT_XQCC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_APPEAL_MASTER', 504 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_APPEAL_MASTER;

    create foreign table if not exists nios_foreign.V_APPEAL_MASTER (
        "worker_code" varchar(10),
        "name" varchar(50),
        "passport_nbr" varchar(10),
        "employer_state" varchar(15),
        "certify_date" varchar(19),
        "officer" varchar(20),
        "appeal_ind" varchar(15),
        "comments" varchar(100),
        "create_date" varchar(19),
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'V_APPEAL_MASTER');

    raise notice 'created foreign table for V_APPEAL_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_APPEAL_MASTER;

    -- create table if not exists nios.V_APPEAL_MASTER as select * from nios_foreign.V_APPEAL_MASTER;

    raise notice 'copied table nios.V_APPEAL_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_APPEAL_STATUS', 505 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_APPEAL_STATUS;

    create foreign table if not exists nios_foreign.V_APPEAL_STATUS (
        "worker_code" varchar(10),
        "name" varchar(50),
        "passport_nbr" varchar(10),
        "employer_state" varchar(15),
        "certify_date" varchar(19),
        "successful_date" varchar(19),
        "unsuccessful_date" varchar(19),
        "followup_date" varchar(19),
        "case" varchar(15),
        "followup_ind" varchar(1),
        "appeal_ind" varchar(1),
        "comments" varchar(100),
        "decision_date" varchar(19),
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'V_APPEAL_STATUS');

    raise notice 'created foreign table for V_APPEAL_STATUS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_APPEAL_STATUS;

    -- create table if not exists nios.V_APPEAL_STATUS as select * from nios_foreign.V_APPEAL_STATUS;

    raise notice 'copied table nios.V_APPEAL_STATUS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_FOREIGN_WORKER_HISTORY', 506 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_FOREIGN_WORKER_HISTORY;

    create foreign table if not exists nios_foreign.V_FOREIGN_WORKER_HISTORY (
        "worker_code" varchar(10),
        "version_no" varchar(10),
        "creation_date" timestamp,
        "worker_name" varchar(50),
        "employer_code" varchar(10),
        "fathers_name" varchar(50),
        "country_code" varchar(3),
        "date_of_birth" timestamp,
        "passport_no" varchar(20),
        "visa_no" varchar(20),
        "sex" varchar(1),
        "job_type" varchar(50),
        "arrival_date" timestamp,
        "departure_date" timestamp,
        "agent_code" varchar(10),
        "blood_group" varchar(3),
        "last_examine_date" timestamp,
        "employer_pref_ind" varchar(1),
        "imm_name" varchar(50),
        "fomema_ind" varchar(1),
        "renewal_date" timestamp,
        "modification_date" timestamp,
        "bc_worker_code" varchar(13),
        "bc_agent_code" varchar(13),
        "bc_employer_code" varchar(13),
        "fit_ind" varchar(1),
        "can_renew" varchar(5),
        "ismonitor" varchar(5),
        "isimmblock" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "status_code" varchar(5),
        "ply_count" numeric(10),
        "ply_printed" varchar(5),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "visa_expiry_date" timestamp,
        "rh" varchar(1),
        "classification" varchar(5),
        "action" varchar(10),
        "action_date" timestamp,
        "clinic_code" varchar(10),
        "clinic_examdate" timestamp,
        "created_by" varchar(10),
        "immblocked_by" varchar(3),
        "pati" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'V_FOREIGN_WORKER_HISTORY');

    raise notice 'created foreign table for V_FOREIGN_WORKER_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_FOREIGN_WORKER_HISTORY;

    -- create table if not exists nios.V_FOREIGN_WORKER_HISTORY as select * from nios_foreign.V_FOREIGN_WORKER_HISTORY;

    raise notice 'copied table nios.V_FOREIGN_WORKER_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_FOREIGN_WORKER_MASTER', 507 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_FOREIGN_WORKER_MASTER;

    create foreign table if not exists nios_foreign.V_FOREIGN_WORKER_MASTER (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "creation_date" timestamp,
        "fathers_name" varchar(50),
        "date_of_birth" timestamp,
        "passport_no" varchar(20),
        "visa_no" varchar(20),
        "sex" varchar(1),
        "job_type" varchar(50),
        "arrival_date" timestamp,
        "version_no" varchar(10),
        "blood_group" varchar(3),
        "country_code" varchar(3),
        "departure_date" timestamp,
        "last_examine_date" timestamp,
        "employer_pref_ind" varchar(1),
        "imm_name" varchar(50),
        "agent_code" varchar(10),
        "employer_code" varchar(10),
        "fit_ind" varchar(1),
        "fomema_ind" varchar(1),
        "renewal_date" timestamp,
        "bc_worker_code" varchar(13),
        "bc_agent_code" varchar(13),
        "bc_employer_code" varchar(13),
        "can_renew" varchar(5),
        "ismonitor" varchar(5),
        "isimmblock" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "status_code" varchar(5),
        "ply_count" numeric(10),
        "ply_printed" varchar(5),
        "isblacklisted" varchar(5),
        "blacklisted_date" timestamp,
        "visa_expiry_date" timestamp,
        "rh" varchar(1),
        "classification" varchar(5),
        "clinic_code" varchar(10),
        "clinic_examdate" timestamp,
        "created_by" varchar(10),
        "immblocked_by" varchar(3),
        "pati" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'V_FOREIGN_WORKER_MASTER');

    raise notice 'created foreign table for V_FOREIGN_WORKER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_FOREIGN_WORKER_MASTER;

    -- create table if not exists nios.V_FOREIGN_WORKER_MASTER as select * from nios_foreign.V_FOREIGN_WORKER_MASTER;

    raise notice 'copied table nios.V_FOREIGN_WORKER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_USER_MASTER', 526 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_USER_MASTER;

    create foreign table if not exists nios_foreign.V_USER_MASTER (
        "uuid" numeric(10),
        "userid" varchar(20),
        "empid" varchar(20),
        "password" varchar(100),
        "passwordcount" numeric,
        "attempdate" timestamp,
        "displayname" varchar(100),
        "gender" varchar(1),
        "status" varchar(5),
        "email_id" varchar(100),
        "employmentdate" timestamp,
        "designation" varchar(50),
        "usertype" varchar(5),
        "roleid" numeric(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'V_USER_MASTER');

    raise notice 'created foreign table for V_USER_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_USER_MASTER;

    -- create table if not exists nios.V_USER_MASTER as select * from nios_foreign.V_USER_MASTER;

    raise notice 'copied table nios.V_USER_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_WORKER_CLINIC', 508 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.V_WORKER_CLINIC;

    create foreign table if not exists nios_foreign.V_WORKER_CLINIC (
        "worker_code" varchar(10),
        "country_code" varchar(3),
        "clinic_code" varchar(10),
        "exam_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'V_WORKER_CLINIC');

    raise notice 'created foreign table for V_WORKER_CLINIC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.V_WORKER_CLINIC;

    -- create table if not exists nios.V_WORKER_CLINIC as select * from nios_foreign.V_WORKER_CLINIC;

    raise notice 'copied table nios.V_WORKER_CLINIC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_CANCEL', 436 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_CANCEL;

    create foreign table if not exists nios_foreign.WORKER_CANCEL (
        "fwcancelid" varchar(15),
        "admin_charge" varchar(5),
        "admin_fee" numeric(10, 2),
        "refund_amount" numeric(10, 2),
        "status" varchar(10),
        "version_no" varchar(10),
        "cancelled_by" numeric(10),
        "cancelled_date" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CANCEL');

    raise notice 'created foreign table for WORKER_CANCEL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_CANCEL;

    -- create table if not exists nios.WORKER_CANCEL as select * from nios_foreign.WORKER_CANCEL;

    raise notice 'copied table nios.WORKER_CANCEL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_CANCEL_DETAIL', 437 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_CANCEL_DETAIL;

    create foreign table if not exists nios_foreign.WORKER_CANCEL_DETAIL (
        "fwcancelid" varchar(15),
        "refundid" varchar(15),
        "refund_detailid" varchar(15),
        "trans_id" varchar(14),
        "cancelled_by" numeric(10),
        "cancelled_date" timestamp,
        "status" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CANCEL_DETAIL');

    raise notice 'created foreign table for WORKER_CANCEL_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_CANCEL_DETAIL;

    -- create table if not exists nios.WORKER_CANCEL_DETAIL as select * from nios_foreign.WORKER_CANCEL_DETAIL;

    raise notice 'copied table nios.WORKER_CANCEL_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_CANCEL_HISTORY', 438 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_CANCEL_HISTORY;

    create foreign table if not exists nios_foreign.WORKER_CANCEL_HISTORY (
        "fwcancelid" varchar(15),
        "admin_charge" varchar(5),
        "admin_fee" numeric(10, 2),
        "refund_amount" numeric(10, 2),
        "status" varchar(10),
        "version_no" varchar(10),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "cancelled_by" numeric(10),
        "cancelled_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CANCEL_HISTORY');

    raise notice 'created foreign table for WORKER_CANCEL_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_CANCEL_HISTORY;

    -- create table if not exists nios.WORKER_CANCEL_HISTORY as select * from nios_foreign.WORKER_CANCEL_HISTORY;

    raise notice 'copied table nios.WORKER_CANCEL_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_CERTIFY_FITIND', 439 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_CERTIFY_FITIND;

    create foreign table if not exists nios_foreign.WORKER_CERTIFY_FITIND (
        "logid" numeric,
        "logdate" timestamp,
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "dfit_ind" numeric(1),
        "fit_ind" char(1)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CERTIFY_FITIND');

    raise notice 'created foreign table for WORKER_CERTIFY_FITIND';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_CERTIFY_FITIND;

    -- create table if not exists nios.WORKER_CERTIFY_FITIND as select * from nios_foreign.WORKER_CERTIFY_FITIND;

    raise notice 'copied table nios.WORKER_CERTIFY_FITIND';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_COUNTRY_DIST', 440 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_COUNTRY_DIST;

    create foreign table if not exists nios_foreign.WORKER_COUNTRY_DIST (
        "country_code" varchar(3),
        "fwcount" numeric
    ) server nios_server options (schema 'NIOS1', table 'WORKER_COUNTRY_DIST');

    raise notice 'created foreign table for WORKER_COUNTRY_DIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_COUNTRY_DIST;

    -- create table if not exists nios.WORKER_COUNTRY_DIST as select * from nios_foreign.WORKER_COUNTRY_DIST;

    raise notice 'copied table nios.WORKER_COUNTRY_DIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_DOCTOR_CHANGE', 441 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_DOCTOR_CHANGE;

    create foreign table if not exists nios_foreign.WORKER_DOCTOR_CHANGE (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "bc_new_doctor_code" varchar(13),
        "bc_old_doctor_code" varchar(13),
        "bc_new_laboratory_code" varchar(13),
        "bc_old_laboratory_code" varchar(13),
        "bc_new_xray_code" varchar(13),
        "bc_old_xray_code" varchar(13),
        "bc_new_radiologist_code" varchar(13),
        "bc_old_radiologist_code" varchar(13),
        "modification_id" varchar(30),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_DOCTOR_CHANGE');

    raise notice 'created foreign table for WORKER_DOCTOR_CHANGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_DOCTOR_CHANGE;

    -- create table if not exists nios.WORKER_DOCTOR_CHANGE as select * from nios_foreign.WORKER_DOCTOR_CHANGE;

    raise notice 'copied table nios.WORKER_DOCTOR_CHANGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_DOCTOR_CHANGE_HIST', 442 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_DOCTOR_CHANGE_HIST;

    create foreign table if not exists nios_foreign.WORKER_DOCTOR_CHANGE_HIST (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "bc_new_doctor_code" varchar(13),
        "bc_old_doctor_code" varchar(13),
        "bc_new_laboratory_code" varchar(13),
        "bc_old_laboratory_code" varchar(13),
        "bc_new_xray_code" varchar(13),
        "bc_old_xray_code" varchar(13),
        "bc_new_radiologist_code" varchar(13),
        "bc_old_radiologist_code" varchar(13),
        "modification_id" varchar(30),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_DOCTOR_CHANGE_HIST');

    raise notice 'created foreign table for WORKER_DOCTOR_CHANGE_HIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_DOCTOR_CHANGE_HIST;

    -- create table if not exists nios.WORKER_DOCTOR_CHANGE_HIST as select * from nios_foreign.WORKER_DOCTOR_CHANGE_HIST;

    raise notice 'copied table nios.WORKER_DOCTOR_CHANGE_HIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_FITIND_CHANGE', 443 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_FITIND_CHANGE;

    create foreign table if not exists nios_foreign.WORKER_FITIND_CHANGE (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "change_type" varchar(2),
        "modification_id" varchar(30),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_FITIND_CHANGE');

    raise notice 'created foreign table for WORKER_FITIND_CHANGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_FITIND_CHANGE;

    -- create table if not exists nios.WORKER_FITIND_CHANGE as select * from nios_foreign.WORKER_FITIND_CHANGE;

    raise notice 'copied table nios.WORKER_FITIND_CHANGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_UPD', 444 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WORKER_UPD;

    create foreign table if not exists nios_foreign.WORKER_UPD (
        "old_passport_no" varchar(20),
        "old_worker_name" varchar(50),
        "old_country_name" varchar(25),
        "worker_code" varchar(10),
        "mod_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_UPD');

    raise notice 'created foreign table for WORKER_UPD';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WORKER_UPD;

    -- create table if not exists nios.WORKER_UPD as select * from nios_foreign.WORKER_UPD;

    raise notice 'copied table nios.WORKER_UPD';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WRONG_TRANSMISSION', 445 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WRONG_TRANSMISSION;

    create foreign table if not exists nios_foreign.WRONG_TRANSMISSION (
        "case_id" numeric,
        "provider_code" varchar(10),
        "trans_id" varchar(14),
        "trans_date" timestamp,
        "result_date" timestamp,
        "fwt_version_no" numeric,
        "comments" varchar(255),
        "modify_id" varchar(20),
        "modify_date" timestamp,
        "version_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'WRONG_TRANSMISSION');

    raise notice 'created foreign table for WRONG_TRANSMISSION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WRONG_TRANSMISSION;

    -- create table if not exists nios.WRONG_TRANSMISSION as select * from nios_foreign.WRONG_TRANSMISSION;

    raise notice 'copied table nios.WRONG_TRANSMISSION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WRONG_TRANSMISSION_HISTORY', 446 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WRONG_TRANSMISSION_HISTORY;

    create foreign table if not exists nios_foreign.WRONG_TRANSMISSION_HISTORY (
        "case_id" numeric,
        "provider_code" varchar(10),
        "trans_id" varchar(14),
        "trans_date" timestamp,
        "result_date" timestamp,
        "fwt_version_no" numeric,
        "comments" varchar(4000),
        "modify_id" varchar(20),
        "modify_date" timestamp,
        "version_no" numeric,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WRONG_TRANSMISSION_HISTORY');

    raise notice 'created foreign table for WRONG_TRANSMISSION_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WRONG_TRANSMISSION_HISTORY;

    -- create table if not exists nios.WRONG_TRANSMISSION_HISTORY as select * from nios_foreign.WRONG_TRANSMISSION_HISTORY;

    raise notice 'copied table nios.WRONG_TRANSMISSION_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WS_ACCESS_TOKEN', 447 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.WS_ACCESS_TOKEN;

    create foreign table if not exists nios_foreign.WS_ACCESS_TOKEN (
        "last_access" timestamp,
        "token" varchar(50),
        "created_date" timestamp,
        "usercode" varchar(10),
        "provider_id" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'WS_ACCESS_TOKEN');

    raise notice 'created foreign table for WS_ACCESS_TOKEN';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.WS_ACCESS_TOKEN;

    -- create table if not exists nios.WS_ACCESS_TOKEN as select * from nios_foreign.WS_ACCESS_TOKEN;

    raise notice 'copied table nios.WS_ACCESS_TOKEN';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_CALLLOG', 448 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_CALLLOG;

    create foreign table if not exists nios_foreign.XQCC_CALLLOG (
        "case_id" varchar(20),
        "xray_code" varchar(10),
        "call_date" timestamp,
        "call_time" timestamp,
        "phone_no" varchar(50),
        "discussant_name" varchar(50),
        "fax_no" varchar(50),
        "email_id" varchar(50),
        "issue" varchar(4000),
        "remarks" varchar(4000),
        "status" varchar(20),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "comments" varchar(4000),
        "case_type" numeric
    ) server nios_server options (schema 'NIOS1', table 'XQCC_CALLLOG');

    raise notice 'created foreign table for XQCC_CALLLOG';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_CALLLOG;

    -- create table if not exists nios.XQCC_CALLLOG as select * from nios_foreign.XQCC_CALLLOG;

    raise notice 'copied table nios.XQCC_CALLLOG';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_CERTIFICATE', 449 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_CERTIFICATE;

    create foreign table if not exists nios_foreign.XQCC_CERTIFICATE (
        "bc_xray_code" varchar(13),
        "status" varchar(1),
        "meet_sop" varchar(1),
        "acceptable_quality" varchar(1),
        "correct_report" varchar(1),
        "regular_submission" varchar(1),
        "date_approval" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_CERTIFICATE');

    raise notice 'created foreign table for XQCC_CERTIFICATE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_CERTIFICATE;

    -- create table if not exists nios.XQCC_CERTIFICATE as select * from nios_foreign.XQCC_CERTIFICATE;

    raise notice 'copied table nios.XQCC_CERTIFICATE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_CERTIFICATE_HISTORY', 450 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_CERTIFICATE_HISTORY;

    create foreign table if not exists nios_foreign.XQCC_CERTIFICATE_HISTORY (
        "bc_xray_code" varchar(13),
        "status" varchar(1),
        "meet_sop" varchar(1),
        "acceptable_quality" varchar(1),
        "correct_report" varchar(1),
        "regular_submission" varchar(1),
        "date_approval" timestamp,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_CERTIFICATE_HISTORY');

    raise notice 'created foreign table for XQCC_CERTIFICATE_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_CERTIFICATE_HISTORY;

    -- create table if not exists nios.XQCC_CERTIFICATE_HISTORY as select * from nios_foreign.XQCC_CERTIFICATE_HISTORY;

    raise notice 'copied table nios.XQCC_CERTIFICATE_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_COMMENT', 451 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_COMMENT;

    create foreign table if not exists nios_foreign.XQCC_COMMENT (
        "worker_code" varchar(10),
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_COMMENT');

    raise notice 'created foreign table for XQCC_COMMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_COMMENT;

    -- create table if not exists nios.XQCC_COMMENT as select * from nios_foreign.XQCC_COMMENT;

    raise notice 'copied table nios.XQCC_COMMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_COMMENTS', 452 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_COMMENTS;

    create foreign table if not exists nios_foreign.XQCC_COMMENTS (
        "xqccid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_COMMENTS');

    raise notice 'created foreign table for XQCC_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_COMMENTS;

    -- create table if not exists nios.XQCC_COMMENTS as select * from nios_foreign.XQCC_COMMENTS;

    raise notice 'copied table nios.XQCC_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_FOLLOWUP', 453 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_FOLLOWUP;

    create foreign table if not exists nios_foreign.XQCC_FOLLOWUP (
        "case_id" varchar(20),
        "action_taken" varchar(4000),
        "action_takendate" timestamp,
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "id" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_FOLLOWUP');

    raise notice 'created foreign table for XQCC_FOLLOWUP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_FOLLOWUP;

    -- create table if not exists nios.XQCC_FOLLOWUP as select * from nios_foreign.XQCC_FOLLOWUP;

    raise notice 'copied table nios.XQCC_FOLLOWUP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_FW_EXTRA_COMMENTS', 454 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_FW_EXTRA_COMMENTS;

    create foreign table if not exists nios_foreign.XQCC_FW_EXTRA_COMMENTS (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "source" varchar(1),
        "type" varchar(1),
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_FW_EXTRA_COMMENTS');

    raise notice 'created foreign table for XQCC_FW_EXTRA_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_FW_EXTRA_COMMENTS;

    -- create table if not exists nios.XQCC_FW_EXTRA_COMMENTS as select * from nios_foreign.XQCC_FW_EXTRA_COMMENTS;

    raise notice 'copied table nios.XQCC_FW_EXTRA_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_MLE_RETAKE', 455 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_MLE_RETAKE;

    create foreign table if not exists nios_foreign.XQCC_MLE_RETAKE (
        "reason_id" numeric(10),
        "status" varchar(1),
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "approval_date" timestamp,
        "approval_id" varchar(20),
        "remarks" varchar(1000),
        "shadow_id" varchar(14),
        "id" numeric(19),
        "pool_id" varchar(20),
        "assign_to_pcr" varchar(10),
        "reassign_to_pcr" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_MLE_RETAKE');

    raise notice 'created foreign table for XQCC_MLE_RETAKE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_MLE_RETAKE;

    -- create table if not exists nios.XQCC_MLE_RETAKE as select * from nios_foreign.XQCC_MLE_RETAKE;

    raise notice 'copied table nios.XQCC_MLE_RETAKE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_PERFORMANCE', 456 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_PERFORMANCE;

    create foreign table if not exists nios_foreign.XQCC_PERFORMANCE (
        "letterid" numeric(10),
        "bc_xray_code" varchar(13),
        "letter_type" numeric,
        "date_sent" timestamp,
        "sent_version" numeric,
        "sent_count" numeric,
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_PERFORMANCE');

    raise notice 'created foreign table for XQCC_PERFORMANCE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_PERFORMANCE;

    -- create table if not exists nios.XQCC_PERFORMANCE as select * from nios_foreign.XQCC_PERFORMANCE;

    raise notice 'copied table nios.XQCC_PERFORMANCE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_QUARANTINE_FW_DOC', 457 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_QUARANTINE_FW_DOC;

    create foreign table if not exists nios_foreign.XQCC_QUARANTINE_FW_DOC (
        "trans_id" varchar(14),
        "fw_code" varchar(13),
        "doc_code" varchar(13),
        "d1_hiv" char(1),
        "d1_hiv_date" timestamp,
        "d1_tb" char(1),
        "d1_tb_date" timestamp,
        "d1_leprosy" char(1),
        "d1_leprosy_date" timestamp,
        "d1_hepatitis" char(1),
        "d1_hepatitis_date" timestamp,
        "d1_psych" char(1),
        "d1_psych_date" timestamp,
        "d1_epilepsy" char(1),
        "d1_epilepsy_date" timestamp,
        "d1_cancer" char(1),
        "d1_cancer_date" timestamp,
        "d1_std" char(1),
        "d1_std_date" timestamp,
        "d1_malaria" char(1),
        "d1_malaria_date" timestamp,
        "d2_hypertension" char(1),
        "d2_hypertension_date" timestamp,
        "d2_heartdisease" char(1),
        "d2_heartdisease_date" timestamp,
        "d2_asthma" char(1),
        "d2_asthma_date" timestamp,
        "d2_diabetes" char(1),
        "d2_diabetes_date" timestamp,
        "d2_ulcer" char(1),
        "d2_ulcer_date" timestamp,
        "d2_kidney" char(1),
        "d2_kidney_date" timestamp,
        "d2_others" char(1),
        "d2_others_date" timestamp,
        "d2_comments" varchar(4000),
        "d3_heartsize" char(1),
        "d3_heartsound" char(1),
        "d3_othercardio" char(1),
        "d3_breathsound" char(1),
        "d3_otherrespiratory" char(1),
        "d3_liver" char(1),
        "d3_spleen" char(1),
        "d3_swelling" char(1),
        "d3_lymphnodes" char(1),
        "d3_rectal" char(1),
        "d4_mental" char(1),
        "d4_speech" char(1),
        "d4_cognitive" char(1),
        "d4_peripheralnerves" char(1),
        "d4_motorpower" char(1),
        "d4_sensory" char(1),
        "d4_reflexes" char(1),
        "d4_kidney" char(1),
        "d4_gendischarge" char(1),
        "d4_gensores" char(1),
        "d4_comments" varchar(4000),
        "d5_height" numeric(10, 2),
        "d5_weight" numeric(10, 2),
        "d5_pulse" numeric(10, 2),
        "d5_systolic" numeric(10, 2),
        "d5_diastolic" numeric(10, 2),
        "d5_skinrash" char(1),
        "d5_skinpatch" char(1),
        "d5_deformities" char(1),
        "d5_anaemia" char(1),
        "d5_jaundice" char(1),
        "d5_enlargement" char(1),
        "d5_vision_unaidedleft" char(1),
        "d5_vision_unaidedright" char(1),
        "d5_vision_aidedleft" char(1),
        "d5_vision_aidedright" char(1),
        "d5_hearingleft" char(1),
        "d5_hearingright" char(1),
        "d5_others" char(1),
        "d5_comments" varchar(4000),
        "d6_hiv" char(1),
        "d6_tb" char(1),
        "d6_malaria" char(1),
        "d6_leprosy" char(1),
        "d6_std" char(1),
        "d6_hepatitis" char(1),
        "d6_cancer" char(1),
        "d6_epilepsy" char(1),
        "d6_psych" char(1),
        "d6_others" char(1),
        "d6_pregnant" char(1),
        "d6_opiates" char(1),
        "d6_cannabis" char(1),
        "d7_fw_medstatus" char(1),
        "d7_comments" varchar(4000),
        "d7_unfit_reason" varchar(4000),
        "d8_notifymoh" char(1),
        "d8_notifymoh_date" timestamp,
        "d8_refergh" char(1),
        "d8_refergh_date" timestamp,
        "d8_referph" char(1),
        "d8_referph_date" timestamp,
        "d8_treatpatient" char(1),
        "d8_treatpatient_date" timestamp,
        "d8_ongoingtreatment" char(1),
        "d8_ongoingtreatment_date" timestamp,
        "examination_date" timestamp,
        "certification_date" timestamp,
        "l1_flag" char(1),
        "l1_bloodgroup" char(2),
        "l1_bloodrh" char(1),
        "l1_elisa" char(1),
        "l1_hbsag" char(1),
        "l1_vdrltpha" char(1),
        "l1_malaria" char(1),
        "l1_urineopiates" char(1),
        "l1_urinecannabis" char(1),
        "l1_urinepregnancy" char(1),
        "l1_urinecolor" char(1),
        "l1_urinegravity" char(1),
        "l1_urinesugar" char(1),
        "l1_urinesugar1plus" char(1),
        "l1_urinesugar2plus" char(1),
        "l1_urinesugar3plus" char(1),
        "l1_urinesugar4plus" char(1),
        "l1_sugarmilimoles" varchar(6),
        "l1_urinealbumin" char(1),
        "l1_urinealbumin1plus" char(1),
        "l1_urinealbumin2plus" char(1),
        "l1_urinealbumin3plus" char(1),
        "l1_urinealbumin4plus" char(1),
        "l1_albuminmilimoles" varchar(5),
        "l1_urinemicroexam" char(1),
        "l1_reason" varchar(4000),
        "l1_labresultdate" timestamp,
        "l1_specimendate" timestamp,
        "r1_flag" char(1),
        "r1_thoraciccage" char(1),
        "r1_heartszshape" char(1),
        "r1_lungfields" char(1),
        "r1_xrayresultdate" timestamp,
        "r1_xraydonedate" timestamp,
        "fw_name" varchar(50),
        "fw_dateofbirth" timestamp,
        "fw_sex" char(1),
        "fw_jobtype" varchar(50),
        "fw_passportno" varchar(30),
        "employer_code" varchar(10),
        "fw_countryname" varchar(50),
        "lab_code" varchar(13),
        "rad_code" varchar(13),
        "xray_code" varchar(13),
        "quarantine_reason" varchar(4000),
        "status" varchar(5),
        "inspstatus" char(1),
        "time_inserted" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "last_pms_date" timestamp,
        "d2_taken_drugs" char(1),
        "r1_focallesion" char(1),
        "r1_otherabnormalities" char(1),
        "r1_impression" varchar(4000),
        "r1_mediastinum" char(1),
        "r1_pleura" char(1),
        "r1_thoraciccage_detail" varchar(1000),
        "r1_heartszshape_detail" varchar(1000),
        "r1_lungfields_detail" varchar(1000),
        "r1_mediastinum_detail" varchar(1000),
        "r1_pleura_detail" varchar(1000),
        "r1_focallesion_detail" varchar(1000),
        "r1_otherabnormalities_detail" varchar(1000),
        "l1_tpha" char(1),
        "l1_sgvalue" varchar(20),
        "l1_urinemicroexam_reason" varchar(4000),
        "source" char(1),
        "l1_ibtv2" char(1),
        "l1_batchnum" varchar(10),
        "tcupi_letter_refid" numeric(10),
        "tcupi_xrayletter_refid" numeric(10),
        "qrtn_source" numeric(1),
        "l1_specimentakendate" timestamp,
        "l1_blood_barcodeno" varchar(20),
        "l1_urine_barcodeno" varchar(20),
        "r1_xrayrefno" varchar(20),
        "d3_other" char(1),
        "d4_appearance" char(1),
        "d4_speechquality" char(1),
        "d4_coherent" char(1),
        "d4_relevant" char(1),
        "d4_mood" char(1),
        "d4_depressed" char(1),
        "d4_depressed1" char(1),
        "d4_depressed2" char(1),
        "d4_anxious" char(1),
        "d4_irritable" char(1),
        "d4_affect" char(1),
        "d4_thought" char(1),
        "d4_delusion" char(1),
        "d4_suicidality" char(1),
        "d4_suicidality1" char(1),
        "d4_suicidality2" char(1),
        "d4_perception" char(1),
        "d4_orientation" char(1),
        "d4_time" char(1),
        "d4_place" char(1),
        "d4_person" char(1),
        "d4_other" char(1),
        "d4_discharge" char(1),
        "d4_lump" char(1),
        "d4_axillary" char(1),
        "d4_other6" char(1),
        "l1_bloodgroup_reason" varchar(4000),
        "l1_bfmp" char(1),
        "l1_hcg" char(1),
        "d6_hypertension" char(1),
        "d6_heart_diseases" char(1),
        "d6_asthma" char(1),
        "d6_diabetes" char(1),
        "d6_ulcer" char(1),
        "d6_kidney" char(1),
        "d6_others6" char(1)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_QUARANTINE_FW_DOC');

    raise notice 'created foreign table for XQCC_QUARANTINE_FW_DOC';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_QUARANTINE_FW_DOC;

    -- create table if not exists nios.XQCC_QUARANTINE_FW_DOC as select * from nios_foreign.XQCC_QUARANTINE_FW_DOC;

    raise notice 'copied table nios.XQCC_QUARANTINE_FW_DOC';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_QUARANTINE_FW_REASON', 458 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_QUARANTINE_FW_REASON;

    create foreign table if not exists nios_foreign.XQCC_QUARANTINE_FW_REASON (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_QUARANTINE_FW_REASON');

    raise notice 'created foreign table for XQCC_QUARANTINE_FW_REASON';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_QUARANTINE_FW_REASON;

    -- create table if not exists nios.XQCC_QUARANTINE_FW_REASON as select * from nios_foreign.XQCC_QUARANTINE_FW_REASON;

    raise notice 'copied table nios.XQCC_QUARANTINE_FW_REASON';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_REPORT', 459 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_REPORT;

    create foreign table if not exists nios_foreign.XQCC_REPORT (
        "xqccid" numeric(10),
        "reference_no" varchar(20),
        "trans_id" varchar(14),
        "bc_xray_code" varchar(13),
        "bc_worker_code" varchar(13),
        "radiographer_id" numeric(10),
        "radiographer_comments" varchar(4000),
        "radiographer_indicator" varchar(1),
        "issop" varchar(1),
        "sop_comments" varchar(4000),
        "ismisread" varchar(1),
        "date_received" timestamp,
        "date_reviewed" timestamp,
        "sent_for_audit" varchar(1),
        "date_sent_for_audit" timestamp,
        "date_audit_result_recv" timestamp,
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_REPORT');

    raise notice 'created foreign table for XQCC_REPORT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_REPORT;

    -- create table if not exists nios.XQCC_REPORT as select * from nios_foreign.XQCC_REPORT;

    raise notice 'copied table nios.XQCC_REPORT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_SIGN', 460 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_SIGN;

    create foreign table if not exists nios_foreign.XQCC_SIGN (
        "name" varchar(35),
        "desig" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_SIGN');

    raise notice 'created foreign table for XQCC_SIGN';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_SIGN;

    -- create table if not exists nios.XQCC_SIGN as select * from nios_foreign.XQCC_SIGN;

    raise notice 'copied table nios.XQCC_SIGN';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_STAT_CHANGE_APPROVAL', 461 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_STAT_CHANGE_APPROVAL;

    create foreign table if not exists nios_foreign.XQCC_STAT_CHANGE_APPROVAL (
        "xqccreqid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_STAT_CHANGE_APPROVAL');

    raise notice 'created foreign table for XQCC_STAT_CHANGE_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_STAT_CHANGE_APPROVAL;

    -- create table if not exists nios.XQCC_STAT_CHANGE_APPROVAL as select * from nios_foreign.XQCC_STAT_CHANGE_APPROVAL;

    raise notice 'copied table nios.XQCC_STAT_CHANGE_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_STAT_CHANGE_REASONS', 462 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_STAT_CHANGE_REASONS;

    create foreign table if not exists nios_foreign.XQCC_STAT_CHANGE_REASONS (
        "reasoncode" varchar(5),
        "reason" varchar(255),
        "status" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_STAT_CHANGE_REASONS');

    raise notice 'created foreign table for XQCC_STAT_CHANGE_REASONS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_STAT_CHANGE_REASONS;

    -- create table if not exists nios.XQCC_STAT_CHANGE_REASONS as select * from nios_foreign.XQCC_STAT_CHANGE_REASONS;

    raise notice 'copied table nios.XQCC_STAT_CHANGE_REASONS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_STAT_CHANGE_REQUEST', 463 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_STAT_CHANGE_REQUEST;

    create foreign table if not exists nios_foreign.XQCC_STAT_CHANGE_REQUEST (
        "xqccreqid" numeric(10),
        "xqccid" numeric(10),
        "old_status" varchar(2),
        "new_status" varchar(2),
        "radiologist_name" varchar(50),
        "mo_name" varchar(50),
        "mo_comments" varchar(1000),
        "reasoncode" varchar(5),
        "status" varchar(1),
        "request_by" numeric(10),
        "request_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_STAT_CHANGE_REQUEST');

    raise notice 'created foreign table for XQCC_STAT_CHANGE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_STAT_CHANGE_REQUEST;

    -- create table if not exists nios.XQCC_STAT_CHANGE_REQUEST as select * from nios_foreign.XQCC_STAT_CHANGE_REQUEST;

    raise notice 'copied table nios.XQCC_STAT_CHANGE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_TRANSID', 464 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_TRANSID;

    create foreign table if not exists nios_foreign.XQCC_TRANSID (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_TRANSID');

    raise notice 'created foreign table for XQCC_TRANSID';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_TRANSID;

    -- create table if not exists nios.XQCC_TRANSID as select * from nios_foreign.XQCC_TRANSID;

    raise notice 'copied table nios.XQCC_TRANSID';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_UNFIT', 465 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_UNFIT;

    create foreign table if not exists nios_foreign.XQCC_UNFIT (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_UNFIT');

    raise notice 'created foreign table for XQCC_UNFIT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_UNFIT;

    -- create table if not exists nios.XQCC_UNFIT as select * from nios_foreign.XQCC_UNFIT;

    raise notice 'copied table nios.XQCC_UNFIT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQCC_WAREHOUSE', 466 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQCC_WAREHOUSE;

    create foreign table if not exists nios_foreign.XQCC_WAREHOUSE (
        "warehouse_id" numeric,
        "name" varchar(100),
        "address" varchar(255),
        "status" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_WAREHOUSE');

    raise notice 'created foreign table for XQCC_WAREHOUSE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQCC_WAREHOUSE;

    -- create table if not exists nios.XQCC_WAREHOUSE as select * from nios_foreign.XQCC_WAREHOUSE;

    raise notice 'copied table nios.XQCC_WAREHOUSE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQUARANTINE_RELEASE_APPROVAL', 467 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQUARANTINE_RELEASE_APPROVAL;

    create foreign table if not exists nios_foreign.XQUARANTINE_RELEASE_APPROVAL (
        "xqrreqid" numeric(10),
        "xqrrid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQUARANTINE_RELEASE_APPROVAL');

    raise notice 'created foreign table for XQUARANTINE_RELEASE_APPROVAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQUARANTINE_RELEASE_APPROVAL;

    -- create table if not exists nios.XQUARANTINE_RELEASE_APPROVAL as select * from nios_foreign.XQUARANTINE_RELEASE_APPROVAL;

    raise notice 'copied table nios.XQUARANTINE_RELEASE_APPROVAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQUARANTINE_RELEASE_REQUEST', 468 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQUARANTINE_RELEASE_REQUEST;

    create foreign table if not exists nios_foreign.XQUARANTINE_RELEASE_REQUEST (
        "xqrrid" numeric(18),
        "trans_id" varchar(14),
        "comments" varchar(4000),
        "status" varchar(5),
        "medstatus" char(1),
        "request_by" numeric(10),
        "creation_date" timestamp,
        "ismonitor" char(1),
        "mle" numeric(10),
        "assessment_date" timestamp,
        "release_date" timestamp,
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "remove_mon_comment" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'XQUARANTINE_RELEASE_REQUEST');

    raise notice 'created foreign table for XQUARANTINE_RELEASE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQUARANTINE_RELEASE_REQUEST;

    -- create table if not exists nios.XQUARANTINE_RELEASE_REQUEST as select * from nios_foreign.XQUARANTINE_RELEASE_REQUEST;

    raise notice 'copied table nios.XQUARANTINE_RELEASE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XQUA_RELEASE_REQ_HISTORY', 469 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XQUA_RELEASE_REQ_HISTORY;

    create foreign table if not exists nios_foreign.XQUA_RELEASE_REQ_HISTORY (
        "xqrrid" numeric(18),
        "trans_id" varchar(14),
        "comments" varchar(4000),
        "status" varchar(5),
        "medstatus" char(1),
        "request_by" numeric(10),
        "creation_date" timestamp,
        "ismonitor" char(1),
        "mle" numeric(10),
        "assessment_date" timestamp,
        "release_date" timestamp,
        "modify_id" numeric(10),
        "modify_date" timestamp,
        "action" varchar(10),
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQUA_RELEASE_REQ_HISTORY');

    raise notice 'created foreign table for XQUA_RELEASE_REQ_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XQUA_RELEASE_REQ_HISTORY;

    -- create table if not exists nios.XQUA_RELEASE_REQ_HISTORY as select * from nios_foreign.XQUA_RELEASE_REQ_HISTORY;

    raise notice 'copied table nios.XQUA_RELEASE_REQ_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_ADHOC_SUBMIT_ABNORMAL', 470 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_ADHOC_SUBMIT_ABNORMAL;

    create foreign table if not exists nios_foreign.XRAY_ADHOC_SUBMIT_ABNORMAL (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_ADHOC_SUBMIT_ABNORMAL');

    raise notice 'created foreign table for XRAY_ADHOC_SUBMIT_ABNORMAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_ADHOC_SUBMIT_ABNORMAL;

    -- create table if not exists nios.XRAY_ADHOC_SUBMIT_ABNORMAL as select * from nios_foreign.XRAY_ADHOC_SUBMIT_ABNORMAL;

    raise notice 'copied table nios.XRAY_ADHOC_SUBMIT_ABNORMAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_ADHOC_SUBMIT_DELAY', 471 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_ADHOC_SUBMIT_DELAY;

    create foreign table if not exists nios_foreign.XRAY_ADHOC_SUBMIT_DELAY (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11),
        "filetype" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_ADHOC_SUBMIT_DELAY');

    raise notice 'created foreign table for XRAY_ADHOC_SUBMIT_DELAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_ADHOC_SUBMIT_DELAY;

    -- create table if not exists nios.XRAY_ADHOC_SUBMIT_DELAY as select * from nios_foreign.XRAY_ADHOC_SUBMIT_DELAY;

    raise notice 'copied table nios.XRAY_ADHOC_SUBMIT_DELAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_ADHOC_SUBMIT_HISTORY', 472 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_ADHOC_SUBMIT_HISTORY;

    create foreign table if not exists nios_foreign.XRAY_ADHOC_SUBMIT_HISTORY (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11),
        "filetype" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_ADHOC_SUBMIT_HISTORY');

    raise notice 'created foreign table for XRAY_ADHOC_SUBMIT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_ADHOC_SUBMIT_HISTORY;

    -- create table if not exists nios.XRAY_ADHOC_SUBMIT_HISTORY as select * from nios_foreign.XRAY_ADHOC_SUBMIT_HISTORY;

    raise notice 'copied table nios.XRAY_ADHOC_SUBMIT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_ADHOC_SUBMIT_NORMAL', 473 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_ADHOC_SUBMIT_NORMAL;

    create foreign table if not exists nios_foreign.XRAY_ADHOC_SUBMIT_NORMAL (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_ADHOC_SUBMIT_NORMAL');

    raise notice 'created foreign table for XRAY_ADHOC_SUBMIT_NORMAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_ADHOC_SUBMIT_NORMAL;

    -- create table if not exists nios.XRAY_ADHOC_SUBMIT_NORMAL as select * from nios_foreign.XRAY_ADHOC_SUBMIT_NORMAL;

    raise notice 'copied table nios.XRAY_ADHOC_SUBMIT_NORMAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_CHANGE_REQUEST', 474 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_CHANGE_REQUEST;

    create foreign table if not exists nios_foreign.XRAY_CHANGE_REQUEST (
        "xray_cr_id" numeric(10),
        "xray_code" varchar(10),
        "request_date" timestamp,
        "request_comment" varchar(1000),
        "status" varchar(20),
        "approvedby" numeric(10),
        "approved_date" timestamp,
        "approved_comment" varchar(1000),
        "createby" numeric(10),
        "createdate" timestamp,
        "modifyby" numeric(10),
        "modifydate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_CHANGE_REQUEST');

    raise notice 'created foreign table for XRAY_CHANGE_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_CHANGE_REQUEST;

    -- create table if not exists nios.XRAY_CHANGE_REQUEST as select * from nios_foreign.XRAY_CHANGE_REQUEST;

    raise notice 'copied table nios.XRAY_CHANGE_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_CHANGE_REQUEST_DETAIL', 475 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_CHANGE_REQUEST_DETAIL;

    create foreign table if not exists nios_foreign.XRAY_CHANGE_REQUEST_DETAIL (
        "xray_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_CHANGE_REQUEST_DETAIL');

    raise notice 'created foreign table for XRAY_CHANGE_REQUEST_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_CHANGE_REQUEST_DETAIL;

    -- create table if not exists nios.XRAY_CHANGE_REQUEST_DETAIL as select * from nios_foreign.XRAY_CHANGE_REQUEST_DETAIL;

    raise notice 'copied table nios.XRAY_CHANGE_REQUEST_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_COMPARE', 476 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_COMPARE;

    create foreign table if not exists nios_foreign.XRAY_COMPARE (
        "xray_code" varchar(10),
        "old_xray_name" varchar(50),
        "old_xray_regn_no" varchar(20),
        "new_xray_name" varchar(50),
        "new_xray_regn_no" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_COMPARE');

    raise notice 'created foreign table for XRAY_COMPARE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_COMPARE;

    -- create table if not exists nios.XRAY_COMPARE as select * from nios_foreign.XRAY_COMPARE;

    raise notice 'copied table nios.XRAY_COMPARE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_COUPLING', 477 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_COUPLING;

    create foreign table if not exists nios_foreign.XRAY_COUPLING (
        "bc_xray_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "modify_id" numeric,
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_COUPLING');

    raise notice 'created foreign table for XRAY_COUPLING';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_COUPLING;

    -- create table if not exists nios.XRAY_COUPLING as select * from nios_foreign.XRAY_COUPLING;

    raise notice 'copied table nios.XRAY_COUPLING';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_DISPATCH_LIST', 478 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_DISPATCH_LIST;

    create foreign table if not exists nios_foreign.XRAY_DISPATCH_LIST (
        "dispatch_listid" numeric,
        "bc_xray_code" char(10),
        "films_count" numeric,
        "status" varchar(10),
        "date_sent" timestamp,
        "date_received" timestamp,
        "version_no" numeric,
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "received_count" numeric
    ) server nios_server options (schema 'NIOS1', table 'XRAY_DISPATCH_LIST');

    raise notice 'created foreign table for XRAY_DISPATCH_LIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_DISPATCH_LIST;

    -- create table if not exists nios.XRAY_DISPATCH_LIST as select * from nios_foreign.XRAY_DISPATCH_LIST;

    raise notice 'copied table nios.XRAY_DISPATCH_LIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_DISPATCH_LIST_DETAILS', 479 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_DISPATCH_LIST_DETAILS;

    create foreign table if not exists nios_foreign.XRAY_DISPATCH_LIST_DETAILS (
        "dispatch_listid" numeric,
        "trans_id" varchar(14),
        "status" varchar(10),
        "status_date" timestamp,
        "film_sequence" numeric,
        "xray_testdone_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_DISPATCH_LIST_DETAILS');

    raise notice 'created foreign table for XRAY_DISPATCH_LIST_DETAILS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_DISPATCH_LIST_DETAILS;

    -- create table if not exists nios.XRAY_DISPATCH_LIST_DETAILS as select * from nios_foreign.XRAY_DISPATCH_LIST_DETAILS;

    raise notice 'copied table nios.XRAY_DISPATCH_LIST_DETAILS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FILM_AUDIT', 480 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FILM_AUDIT;

    create foreign table if not exists nios_foreign.XRAY_FILM_AUDIT (
        "film_auditid" numeric,
        "trans_id" varchar(14),
        "ref_transid" varchar(14),
        "bc_worker_code" varchar(10),
        "comments" varchar(1000),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_AUDIT');

    raise notice 'created foreign table for XRAY_FILM_AUDIT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FILM_AUDIT;

    -- create table if not exists nios.XRAY_FILM_AUDIT as select * from nios_foreign.XRAY_FILM_AUDIT;

    raise notice 'copied table nios.XRAY_FILM_AUDIT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FILM_MOVEMENT', 481 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FILM_MOVEMENT;

    create foreign table if not exists nios_foreign.XRAY_FILM_MOVEMENT (
        "movement_id" numeric,
        "trans_id" varchar(14),
        "dispatchlist_id" numeric,
        "status" varchar(10),
        "status_date" timestamp,
        "comments" varchar(1000),
        "user_id" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_MOVEMENT');

    raise notice 'created foreign table for XRAY_FILM_MOVEMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FILM_MOVEMENT;

    -- create table if not exists nios.XRAY_FILM_MOVEMENT as select * from nios_foreign.XRAY_FILM_MOVEMENT;

    raise notice 'copied table nios.XRAY_FILM_MOVEMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FILM_REMINDER', 482 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FILM_REMINDER;

    create foreign table if not exists nios_foreign.XRAY_FILM_REMINDER (
        "film_reminderid" numeric,
        "trans_id" varchar(14),
        "reminder_date" timestamp,
        "dispatch_listid" numeric,
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_REMINDER');

    raise notice 'created foreign table for XRAY_FILM_REMINDER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FILM_REMINDER;

    -- create table if not exists nios.XRAY_FILM_REMINDER as select * from nios_foreign.XRAY_FILM_REMINDER;

    raise notice 'copied table nios.XRAY_FILM_REMINDER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FILM_STORAGE', 483 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FILM_STORAGE;

    create foreign table if not exists nios_foreign.XRAY_FILM_STORAGE (
        "film_storageid" numeric,
        "batch_number" varchar(20),
        "box_number" numeric,
        "type" varchar(20),
        "location" varchar(100),
        "status" varchar(10),
        "disposal_date" timestamp,
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modified_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_STORAGE');

    raise notice 'created foreign table for XRAY_FILM_STORAGE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FILM_STORAGE;

    -- create table if not exists nios.XRAY_FILM_STORAGE as select * from nios_foreign.XRAY_FILM_STORAGE;

    raise notice 'copied table nios.XRAY_FILM_STORAGE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FILM_STORAGE_DETAIL', 484 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FILM_STORAGE_DETAIL;

    create foreign table if not exists nios_foreign.XRAY_FILM_STORAGE_DETAIL (
        "film_storageid" numeric,
        "trans_id" varchar(14),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modified_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_STORAGE_DETAIL');

    raise notice 'created foreign table for XRAY_FILM_STORAGE_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FILM_STORAGE_DETAIL;

    -- create table if not exists nios.XRAY_FILM_STORAGE_DETAIL as select * from nios_foreign.XRAY_FILM_STORAGE_DETAIL;

    raise notice 'copied table nios.XRAY_FILM_STORAGE_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_FOLLOW_UP', 485 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_FOLLOW_UP;

    create foreign table if not exists nios_foreign.XRAY_FOLLOW_UP (
        "follow_upid" numeric,
        "trans_id" varchar(14),
        "decision" varchar(20),
        "can_renew" varchar(1),
        "comments" varchar(4000),
        "status" varchar(10),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "due_to_xray" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FOLLOW_UP');

    raise notice 'created foreign table for XRAY_FOLLOW_UP';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_FOLLOW_UP;

    -- create table if not exists nios.XRAY_FOLLOW_UP as select * from nios_foreign.XRAY_FOLLOW_UP;

    raise notice 'copied table nios.XRAY_FOLLOW_UP';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_HISTORY', 486 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_HISTORY;

    create foreign table if not exists nios_foreign.XRAY_HISTORY (
        "xray_code" varchar(10),
        "creation_date" timestamp,
        "version_no" varchar(10),
        "xray_name" varchar(50),
        "xray_regn_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "qualification" varchar(50),
        "comments" varchar(4000),
        "district_name" varchar(40),
        "modification_date" timestamp,
        "bc_xray_code" varchar(13),
        "status_code" varchar(5),
        "classification" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "grade_point" numeric(3),
        "license" varchar(20),
        "license_year" varchar(4),
        "xray_fac_flag" varchar(5),
        "xregid" numeric(10),
        "nearest_district_office" varchar(7),
        "xray_ic_new" varchar(20),
        "xray_ic_old" varchar(20),
        "mohlicense_status" varchar(5),
        "mohlicense_expirydate" timestamp,
        "action" varchar(10),
        "action_date" timestamp,
        "radiooperated" varchar(1),
        "radiologist_name" varchar(50),
        "apc_year" varchar(4),
        "apc_no" varchar(20),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "digital_image" numeric(1),
        "mystics_ic" numeric(1),
        "bank_code" varchar(8),
        "gst_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_HISTORY');

    raise notice 'created foreign table for XRAY_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_HISTORY;

    -- create table if not exists nios.XRAY_HISTORY as select * from nios_foreign.XRAY_HISTORY;

    raise notice 'copied table nios.XRAY_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_MASTER', 487 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_MASTER;

    create foreign table if not exists nios_foreign.XRAY_MASTER (
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "creation_date" timestamp,
        "xray_regn_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(100),
        "fax" varchar(100),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "version_no" varchar(10),
        "qualification" varchar(50),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "bc_xray_code" varchar(13),
        "classification" varchar(5),
        "creator_id" numeric(10),
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "grade_point" numeric(3),
        "license" varchar(20),
        "license_year" varchar(4),
        "xray_fac_flag" varchar(5),
        "xregid" numeric(10),
        "nearest_district_office" varchar(7),
        "xray_ic_new" varchar(20),
        "xray_ic_old" varchar(20),
        "mohlicense_status" varchar(5),
        "mohlicense_expirydate" timestamp,
        "radiooperated" varchar(1),
        "radiologist_name" varchar(50),
        "apc_year" varchar(4),
        "apc_no" varchar(20),
        "gst_code" varchar(20),
        "gst_tax" numeric(126),
        "male_rate" numeric(126),
        "female_rate" numeric(126),
        "bank_account_no" varchar(20),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "mystics_ic" numeric,
        "digital_image" numeric(1),
        "mobile_no" varchar(20),
        "renewal_date" timestamp,
        "fp_device" numeric(1),
        "seminar_attendees" varchar(1),
        "device_install" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_MASTER');

    raise notice 'created foreign table for XRAY_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_MASTER;

    -- create table if not exists nios.XRAY_MASTER as select * from nios_foreign.XRAY_MASTER;

    raise notice 'copied table nios.XRAY_MASTER';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_NOT_DONE', 488 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_NOT_DONE;

    create foreign table if not exists nios_foreign.XRAY_NOT_DONE (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_NOT_DONE');

    raise notice 'created foreign table for XRAY_NOT_DONE';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_NOT_DONE;

    -- create table if not exists nios.XRAY_NOT_DONE as select * from nios_foreign.XRAY_NOT_DONE;

    raise notice 'copied table nios.XRAY_NOT_DONE';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_PAYIN_LIST', 489 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_PAYIN_LIST;

    create foreign table if not exists nios_foreign.XRAY_PAYIN_LIST (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_PAYIN_LIST');

    raise notice 'created foreign table for XRAY_PAYIN_LIST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_PAYIN_LIST;

    -- create table if not exists nios.XRAY_PAYIN_LIST as select * from nios_foreign.XRAY_PAYIN_LIST;

    raise notice 'copied table nios.XRAY_PAYIN_LIST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_RADIO_ASSIGNMENT', 490 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_RADIO_ASSIGNMENT;

    create foreign table if not exists nios_foreign.XRAY_RADIO_ASSIGNMENT (
        "bc_xray_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "trans_id" varchar(14),
        "status" varchar(1),
        "assignment_date" timestamp,
        "lock_date" timestamp,
        "report_date" timestamp,
        "acknowledge_date" timestamp,
        "create_date" timestamp,
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_RADIO_ASSIGNMENT');

    raise notice 'created foreign table for XRAY_RADIO_ASSIGNMENT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_RADIO_ASSIGNMENT;

    -- create table if not exists nios.XRAY_RADIO_ASSIGNMENT as select * from nios_foreign.XRAY_RADIO_ASSIGNMENT;

    raise notice 'copied table nios.XRAY_RADIO_ASSIGNMENT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REGISTRATION', 491 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REGISTRATION;

    create foreign table if not exists nios_foreign.XRAY_REGISTRATION (
        "xregid" numeric(10),
        "xray_name" varchar(50),
        "xray_regn_no" varchar(20),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "address4" varchar(50),
        "post_code" varchar(10),
        "phone" varchar(25),
        "fax" varchar(25),
        "district_code" varchar(7),
        "state_code" varchar(7),
        "country_code" varchar(3),
        "email_id" varchar(100),
        "primary_contact_person" varchar(50),
        "primary_contact_phone_no" varchar(20),
        "qualification" varchar(50),
        "status_code" varchar(5),
        "comments" varchar(4000),
        "nearest_district_office" varchar(7),
        "tranno" varchar(10),
        "license" varchar(20),
        "license_year" varchar(4),
        "xray_ic_new" varchar(20),
        "xray_ic_old" varchar(20),
        "radiooperated" varchar(1),
        "mohlicense_expirydate" timestamp,
        "radiologist_name" varchar(50),
        "apc_year" varchar(4),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "digital_image" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REGISTRATION');

    raise notice 'created foreign table for XRAY_REGISTRATION';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REGISTRATION;

    -- create table if not exists nios.XRAY_REGISTRATION as select * from nios_foreign.XRAY_REGISTRATION;

    raise notice 'copied table nios.XRAY_REGISTRATION';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REQUEST', 492 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REQUEST;

    create foreign table if not exists nios_foreign.XRAY_REQUEST (
        "xregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REQUEST');

    raise notice 'created foreign table for XRAY_REQUEST';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REQUEST;

    -- create table if not exists nios.XRAY_REQUEST as select * from nios_foreign.XRAY_REQUEST;

    raise notice 'copied table nios.XRAY_REQUEST';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REVIEW_FILM', 493 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REVIEW_FILM;

    create foreign table if not exists nios_foreign.XRAY_REVIEW_FILM (
        "review_filmid" numeric,
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "status" varchar(10),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "date_sent2pcr" timestamp,
        "pcr_trans_id" numeric
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM');

    raise notice 'created foreign table for XRAY_REVIEW_FILM';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REVIEW_FILM;

    -- create table if not exists nios.XRAY_REVIEW_FILM as select * from nios_foreign.XRAY_REVIEW_FILM;

    raise notice 'copied table nios.XRAY_REVIEW_FILM';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REVIEW_FILM_COMMENTS', 494 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REVIEW_FILM_COMMENTS;

    create foreign table if not exists nios_foreign.XRAY_REVIEW_FILM_COMMENTS (
        "trans_id" varchar(14),
        "comments" varchar(1000),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "commentsid" numeric
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_COMMENTS');

    raise notice 'created foreign table for XRAY_REVIEW_FILM_COMMENTS';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REVIEW_FILM_COMMENTS;

    -- create table if not exists nios.XRAY_REVIEW_FILM_COMMENTS as select * from nios_foreign.XRAY_REVIEW_FILM_COMMENTS;

    raise notice 'copied table nios.XRAY_REVIEW_FILM_COMMENTS';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REVIEW_FILM_DETAIL', 495 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REVIEW_FILM_DETAIL;

    create foreign table if not exists nios_foreign.XRAY_REVIEW_FILM_DETAIL (
        "review_filmid" numeric,
        "parameter_code" varchar(20),
        "parameter_value" varchar(20),
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_DETAIL');

    raise notice 'created foreign table for XRAY_REVIEW_FILM_DETAIL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REVIEW_FILM_DETAIL;

    -- create table if not exists nios.XRAY_REVIEW_FILM_DETAIL as select * from nios_foreign.XRAY_REVIEW_FILM_DETAIL;

    raise notice 'copied table nios.XRAY_REVIEW_FILM_DETAIL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_REVIEW_FILM_IDENTICAL', 496 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_REVIEW_FILM_IDENTICAL;

    create foreign table if not exists nios_foreign.XRAY_REVIEW_FILM_IDENTICAL (
        "review_filmid" numeric,
        "trans_id" varchar(14),
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_IDENTICAL');

    raise notice 'created foreign table for XRAY_REVIEW_FILM_IDENTICAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_REVIEW_FILM_IDENTICAL;

    -- create table if not exists nios.XRAY_REVIEW_FILM_IDENTICAL as select * from nios_foreign.XRAY_REVIEW_FILM_IDENTICAL;

    raise notice 'copied table nios.XRAY_REVIEW_FILM_IDENTICAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_SUBMIT_DAILY', 497 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_SUBMIT_DAILY;

    create foreign table if not exists nios_foreign.XRAY_SUBMIT_DAILY (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_SUBMIT_DAILY');

    raise notice 'created foreign table for XRAY_SUBMIT_DAILY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_SUBMIT_DAILY;

    -- create table if not exists nios.XRAY_SUBMIT_DAILY as select * from nios_foreign.XRAY_SUBMIT_DAILY;

    raise notice 'copied table nios.XRAY_SUBMIT_DAILY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_SUBMIT_DAILY_ABNORMAL', 498 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_SUBMIT_DAILY_ABNORMAL;

    create foreign table if not exists nios_foreign.XRAY_SUBMIT_DAILY_ABNORMAL (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_SUBMIT_DAILY_ABNORMAL');

    raise notice 'created foreign table for XRAY_SUBMIT_DAILY_ABNORMAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_SUBMIT_DAILY_ABNORMAL;

    -- create table if not exists nios.XRAY_SUBMIT_DAILY_ABNORMAL as select * from nios_foreign.XRAY_SUBMIT_DAILY_ABNORMAL;

    raise notice 'copied table nios.XRAY_SUBMIT_DAILY_ABNORMAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_SUBMIT_DAILY_NORMAL', 499 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_SUBMIT_DAILY_NORMAL;

    create foreign table if not exists nios_foreign.XRAY_SUBMIT_DAILY_NORMAL (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_SUBMIT_DAILY_NORMAL');

    raise notice 'created foreign table for XRAY_SUBMIT_DAILY_NORMAL';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_SUBMIT_DAILY_NORMAL;

    -- create table if not exists nios.XRAY_SUBMIT_DAILY_NORMAL as select * from nios_foreign.XRAY_SUBMIT_DAILY_NORMAL;

    raise notice 'copied table nios.XRAY_SUBMIT_DAILY_NORMAL';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_SUBMIT_DELAY', 500 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_SUBMIT_DELAY;

    create foreign table if not exists nios_foreign.XRAY_SUBMIT_DELAY (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11),
        "filetype" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_SUBMIT_DELAY');

    raise notice 'created foreign table for XRAY_SUBMIT_DELAY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_SUBMIT_DELAY;

    -- create table if not exists nios.XRAY_SUBMIT_DELAY as select * from nios_foreign.XRAY_SUBMIT_DELAY;

    raise notice 'copied table nios.XRAY_SUBMIT_DELAY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_SUBMIT_HISTORY', 501 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_SUBMIT_HISTORY;

    create foreign table if not exists nios_foreign.XRAY_SUBMIT_HISTORY (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "transdate" timestamp,
        "xray_submit_date" timestamp,
        "send_ind" varchar(5),
        "send_date" timestamp,
        "rownumber" numeric(11),
        "filetype" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_SUBMIT_HISTORY');

    raise notice 'created foreign table for XRAY_SUBMIT_HISTORY';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_SUBMIT_HISTORY;

    -- create table if not exists nios.XRAY_SUBMIT_HISTORY as select * from nios_foreign.XRAY_SUBMIT_HISTORY;

    raise notice 'copied table nios.XRAY_SUBMIT_HISTORY';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table XRAY_WORKER_COUNT', 502 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.XRAY_WORKER_COUNT;

    create foreign table if not exists nios_foreign.XRAY_WORKER_COUNT (
        "bc_xray_code" varchar(10),
        "last_year" numeric,
        "this_year" numeric,
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_WORKER_COUNT');

    raise notice 'created foreign table for XRAY_WORKER_COUNT';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.XRAY_WORKER_COUNT;

    -- create table if not exists nios.XRAY_WORKER_COUNT as select * from nios_foreign.XRAY_WORKER_COUNT;

    raise notice 'copied table nios.XRAY_WORKER_COUNT';
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
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ZONE_MASTER', 503 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists nios_foreign.ZONE_MASTER;

    create foreign table if not exists nios_foreign.ZONE_MASTER (
        "zone_code" varchar(2),
        "zone_name" varchar(30),
        "clearing_days" numeric(3),
        "interest_charge" numeric(10, 2),
        "minimum_charge" numeric(10, 2),
        "group_id" varchar(2),
        "state_code" varchar(7),
        "district_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'ZONE_MASTER');

    raise notice 'created foreign table for ZONE_MASTER';
    -- /foreign table

    -- copy table
    -- drop table if exists nios.ZONE_MASTER;

    -- create table if not exists nios.ZONE_MASTER as select * from nios_foreign.ZONE_MASTER;

    raise notice 'copied table nios.ZONE_MASTER';
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
