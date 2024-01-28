
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into public.copy_logs (description, start_at) values ('start backup nios transaction process', clock_timestamp()) returning id into v_copy_log_id_process;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table account_concile', 1 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.account_concile;

    create foreign table if not exists nios_foreign.account_concile (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.account_concile; */

    create table if not exists nios.account_concile as select * from nios_foreign.account_concile;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table account_reference', 2 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.account_reference;

    create foreign table if not exists nios_foreign.account_reference (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.account_reference; */

    create table if not exists nios.account_reference as select * from nios_foreign.account_reference;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table account_setting', 3 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.account_setting;

    create foreign table if not exists nios_foreign.account_setting (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "parameter" varchar(120),
        "value" varchar(50),
        "description" varchar(400)
    ) server nios_server options (schema 'NIOS1', table 'ACCOUNT_SETTING');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.account_setting; */

    create table if not exists nios.account_setting as select * from nios_foreign.account_setting;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table adminusers', 4 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.adminusers;

    create foreign table if not exists nios_foreign.adminusers (
        "usercode" varchar(13),
        "username" varchar(50),
        "userpass" varchar(100),
        "lastlogindate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ADMINUSERS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.adminusers; */

    create table if not exists nios.adminusers as select * from nios_foreign.adminusers;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table advance_payment', 5 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.advance_payment;

    create foreign table if not exists nios_foreign.advance_payment (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.advance_payment; */

    create table if not exists nios.advance_payment as select * from nios_foreign.advance_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table advance_payment_account', 6 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.advance_payment_account;

    create foreign table if not exists nios_foreign.advance_payment_account (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
        "ap_id" numeric(19),
        "ap_group_id" numeric(19),
        "branch_code" varchar(8),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "description" varchar(4000),
        "draft_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(20, 2),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "type" numeric(10),
        "refund_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'ADVANCE_PAYMENT_ACCOUNT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.advance_payment_account; */

    create table if not exists nios.advance_payment_account as select * from nios_foreign.advance_payment_account;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table advance_payment_approval', 7 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.advance_payment_approval;

    create foreign table if not exists nios_foreign.advance_payment_approval (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.advance_payment_approval; */

    create table if not exists nios.advance_payment_approval as select * from nios_foreign.advance_payment_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table advance_payment_group', 8 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.advance_payment_group;

    create foreign table if not exists nios_foreign.advance_payment_group (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.advance_payment_group; */

    create table if not exists nios.advance_payment_group as select * from nios_foreign.advance_payment_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table announcement', 11 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.announcement;

    create foreign table if not exists nios_foreign.announcement (
        "id" numeric,
        "creation_date" timestamp,
        "subject" varchar(200),
        "start_date" timestamp,
        "end_date" timestamp,
        "content" text,
        "status" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'ANNOUNCEMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.announcement; */

    create table if not exists nios.announcement as select * from nios_foreign.announcement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table ap_invoice_generated', 23 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.ap_invoice_generated;

    create foreign table if not exists nios_foreign.ap_invoice_generated (
        "creditor_code" varchar(10),
        "trans_id" varchar(14),
        "created_date" timestamp,
        "filename" varchar(100),
        "type" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'AP_INVOICE_GENERATED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.ap_invoice_generated; */

    create table if not exists nios.ap_invoice_generated as select * from nios_foreign.ap_invoice_generated;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table app_audit', 20 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.app_audit;

    create foreign table if not exists nios_foreign.app_audit (
        "audit_date" timestamp,
        "userid" varchar(30),
        "module_id" varchar(30),
        "audit_details" varchar
    ) server nios_server options (schema 'NIOS1', table 'APP_AUDIT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.app_audit; */

    create table if not exists nios.app_audit as select * from nios_foreign.app_audit;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_fw_appeal', 12 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_fw_appeal;

    create foreign table if not exists nios_foreign.appeal_fw_appeal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_fw_appeal; */

    create table if not exists nios.appeal_fw_appeal as select * from nios_foreign.appeal_fw_appeal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_fw_appeal_appro_his', 14 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_fw_appeal_appro_his;

    create foreign table if not exists nios_foreign.appeal_fw_appeal_appro_his (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_fw_appeal_appro_his; */

    create table if not exists nios.appeal_fw_appeal_appro_his as select * from nios_foreign.appeal_fw_appeal_appro_his;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_fw_appeal_approval', 13 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_fw_appeal_approval;

    create foreign table if not exists nios_foreign.appeal_fw_appeal_approval (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_fw_appeal_approval; */

    create table if not exists nios.appeal_fw_appeal_approval as select * from nios_foreign.appeal_fw_appeal_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_payment', 16 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_payment;

    create foreign table if not exists nios_foreign.appeal_payment (
        "worker_code" varchar(10),
        "lab_code" varchar(10),
        "lab_amt" numeric(6, 2),
        "lab_inform" char(1),
        "lab_cond" varchar(10),
        "date_reg" timestamp,
        "reg_by" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_payment; */

    create table if not exists nios.appeal_payment as select * from nios_foreign.appeal_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_todolist', 18 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_todolist;

    create foreign table if not exists nios_foreign.appeal_todolist (
        "todoid" numeric(10),
        "remark" varchar(500),
        "url" varchar(500)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_TODOLIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_todolist; */

    create table if not exists nios.appeal_todolist as select * from nios_foreign.appeal_todolist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table appeal_todolist_map', 19 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.appeal_todolist_map;

    create foreign table if not exists nios_foreign.appeal_todolist_map (
        "parameter_code" varchar(10),
        "todoid" numeric(10),
        "can_appeal" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'APPEAL_TODOLIST_MAP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.appeal_todolist_map; */

    create table if not exists nios.appeal_todolist_map as select * from nios_foreign.appeal_todolist_map;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table app_module', 22 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.app_module;

    create foreign table if not exists nios_foreign.app_module (
        "module_id" varchar(30),
        "description" varchar(80)
    ) server nios_server options (schema 'NIOS1', table 'APP_MODULE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.app_module; */

    create table if not exists nios.app_module as select * from nios_foreign.app_module;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table arch_fw_comment', 24 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.arch_fw_comment;

    create foreign table if not exists nios_foreign.arch_fw_comment (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.arch_fw_comment; */

    create table if not exists nios.arch_fw_comment as select * from nios_foreign.arch_fw_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table arch_fw_detail', 25 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.arch_fw_detail;

    create foreign table if not exists nios_foreign.arch_fw_detail (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.arch_fw_detail; */

    create table if not exists nios.arch_fw_detail as select * from nios_foreign.arch_fw_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table arch_fw_extra_comments', 26 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.arch_fw_extra_comments;

    create foreign table if not exists nios_foreign.arch_fw_extra_comments (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "comments" text
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_EXTRA_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.arch_fw_extra_comments; */

    create table if not exists nios.arch_fw_extra_comments as select * from nios_foreign.arch_fw_extra_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table arch_fw_quarantine_reason', 27 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.arch_fw_quarantine_reason;

    create foreign table if not exists nios_foreign.arch_fw_quarantine_reason (
        "trans_id" varchar(14),
        "reason_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'ARCH_FW_QUARANTINE_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.arch_fw_quarantine_reason; */

    create table if not exists nios.arch_fw_quarantine_reason as select * from nios_foreign.arch_fw_quarantine_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table arch_fw_transaction', 28 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.arch_fw_transaction;

    create foreign table if not exists nios_foreign.arch_fw_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.arch_fw_transaction; */

    create table if not exists nios.arch_fw_transaction as select * from nios_foreign.arch_fw_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bad_payment', 29 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bad_payment;

    create foreign table if not exists nios_foreign.bad_payment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bad_payment; */

    create table if not exists nios.bad_payment as select * from nios_foreign.bad_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bad_payment_removal_comments', 31 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bad_payment_removal_comments;

    create foreign table if not exists nios_foreign.bad_payment_removal_comments (
        "paymentid" numeric(10),
        "removal_comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BAD_PAYMENT_REMOVAL_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bad_payment_removal_comments; */

    create table if not exists nios.bad_payment_removal_comments as select * from nios_foreign.bad_payment_removal_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bank_draft_expiry', 32 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bank_draft_expiry;

    create foreign table if not exists nios_foreign.bank_draft_expiry (
        "bank_code" varchar(8),
        "valid_days" numeric(20)
    ) server nios_server options (schema 'NIOS1', table 'BANK_DRAFT_EXPIRY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bank_draft_expiry; */

    create table if not exists nios.bank_draft_expiry as select * from nios_foreign.bank_draft_expiry;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table barcode_transaction', 34 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.barcode_transaction;

    create foreign table if not exists nios_foreign.barcode_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.barcode_transaction; */

    create table if not exists nios.barcode_transaction as select * from nios_foreign.barcode_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table batch_coupling_change', 38 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.batch_coupling_change;

    create foreign table if not exists nios_foreign.batch_coupling_change (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.batch_coupling_change; */

    create table if not exists nios.batch_coupling_change as select * from nios_foreign.batch_coupling_change;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table batch_coupling_change_history', 39 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.batch_coupling_change_history;

    create foreign table if not exists nios_foreign.batch_coupling_change_history (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.batch_coupling_change_history; */

    create table if not exists nios.batch_coupling_change_history as select * from nios_foreign.batch_coupling_change_history;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table batchlab_group', 35 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.batchlab_group;

    create foreign table if not exists nios_foreign.batchlab_group (
        "lab_group" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BATCHLAB_GROUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.batchlab_group; */

    create table if not exists nios.batchlab_group as select * from nios_foreign.batchlab_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table batchusers', 37 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.batchusers;

    create foreign table if not exists nios_foreign.batchusers (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.batchusers; */

    create table if not exists nios.batchusers as select * from nios_foreign.batchusers;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table branches', 40 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.branches;

    create foreign table if not exists nios_foreign.branches (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.branches; */

    create table if not exists nios.branches as select * from nios_foreign.branches;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table branch_printers', 41 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.branch_printers;

    create foreign table if not exists nios_foreign.branch_printers (
        "branch_printerid" numeric(10),
        "branch_code" varchar(2),
        "printer_name" varchar(100),
        "active" char(1)
    ) server nios_server options (schema 'NIOS1', table 'BRANCH_PRINTERS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.branch_printers; */

    create table if not exists nios.branch_printers as select * from nios_foreign.branch_printers;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bulletin_acknowledge', 42 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bulletin_acknowledge;

    create foreign table if not exists nios_foreign.bulletin_acknowledge (
        "bulletinid" numeric(10),
        "usercode" varchar(10),
        "ackdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'BULLETIN_ACKNOWLEDGE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bulletin_acknowledge; */

    create table if not exists nios.bulletin_acknowledge as select * from nios_foreign.bulletin_acknowledge;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bulletin_target', 44 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bulletin_target;

    create foreign table if not exists nios_foreign.bulletin_target (
        "bulletinid" numeric(10),
        "usercode" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'BULLETIN_TARGET');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bulletin_target; */

    create table if not exists nios.bulletin_target as select * from nios_foreign.bulletin_target;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table bypass_error', 45 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.bypass_error;

    create foreign table if not exists nios_foreign.bypass_error (
        "error_desc" varchar(30),
        "error_ind" numeric(2)
    ) server nios_server options (schema 'NIOS1', table 'BYPASS_ERROR');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.bypass_error; */

    create table if not exists nios.bypass_error as select * from nios_foreign.bypass_error;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table cng_worker_clinic', 47 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.cng_worker_clinic;

    create foreign table if not exists nios_foreign.cng_worker_clinic (
        "worker_code" varchar(10),
        "country_code" varchar(3),
        "clinic_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'CNG_WORKER_CLINIC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.cng_worker_clinic; */

    create table if not exists nios.cng_worker_clinic as select * from nios_foreign.cng_worker_clinic;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table code_m', 48 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.code_m;

    create foreign table if not exists nios_foreign.code_m (
        "req_type" varchar(2),
        "type_ind" varchar(1),
        "state_code" varchar(1),
        "name_first" varchar(1),
        "last_issue_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'CODE_M');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.code_m; */

    create table if not exists nios.code_m as select * from nios_foreign.code_m;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table condition_map', 51 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.condition_map;

    create foreign table if not exists nios_foreign.condition_map (
        "parameter_code" varchar(10),
        "old_parameter_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'CONDITION_MAP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.condition_map; */

    create table if not exists nios.condition_map as select * from nios_foreign.condition_map;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table coupling_trans', 54 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.coupling_trans;

    create foreign table if not exists nios_foreign.coupling_trans (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.coupling_trans; */

    create table if not exists nios.coupling_trans as select * from nios_foreign.coupling_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table customer_complaint', 55 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.customer_complaint;

    create foreign table if not exists nios_foreign.customer_complaint (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.customer_complaint; */

    create table if not exists nios.customer_complaint as select * from nios_foreign.customer_complaint;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table delay_trans', 56 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.delay_trans;

    create foreign table if not exists nios_foreign.delay_trans (
        "doctor_code" varchar(10),
        "worker_code" varchar(10),
        "exam_date" timestamp,
        "lab_submit_date" timestamp,
        "xray_submit_date" timestamp,
        "action_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DELAY_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.delay_trans; */

    create table if not exists nios.delay_trans as select * from nios_foreign.delay_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table diff_rh', 57 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.diff_rh;

    create foreign table if not exists nios_foreign.diff_rh (
        "tranno" varchar(10),
        "oldtranno" varchar(10),
        "branch_code" varchar(2),
        "service_type" varchar(2),
        "trandate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DIFF_RH');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.diff_rh; */

    create table if not exists nios.diff_rh as select * from nios_foreign.diff_rh;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table discrp_tab', 58 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.discrp_tab;

    create foreign table if not exists nios_foreign.discrp_tab (
        "ftype" varchar(1),
        "scandir" varchar(2),
        "fcode" varchar(10),
        "ecode" varchar(2),
        "a_loc" varchar(1),
        "a_fcode" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'DISCRP_TAB');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.discrp_tab; */

    create table if not exists nios.discrp_tab as select * from nios_foreign.discrp_tab;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table district_map', 59 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.district_map;

    create foreign table if not exists nios_foreign.district_map (
        "district_map_code" varchar(7),
        "district_map_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'DISTRICT_MAP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.district_map; */

    create table if not exists nios.district_map as select * from nios_foreign.district_map;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table district_office', 61 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.district_office;

    create foreign table if not exists nios_foreign.district_office (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.district_office; */

    create table if not exists nios.district_office as select * from nios_foreign.district_office;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doc_compare', 75 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doc_compare;

    create foreign table if not exists nios_foreign.doc_compare (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doc_compare; */

    create table if not exists nios.doc_compare as select * from nios_foreign.doc_compare;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doc_lab_allocation', 76 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doc_lab_allocation;

    create foreign table if not exists nios_foreign.doc_lab_allocation (
        "doctor_code" varchar(10),
        "old_lab" varchar(10),
        "new_lab" varchar(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_LAB_ALLOCATION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doc_lab_allocation; */

    create table if not exists nios.doc_lab_allocation as select * from nios_foreign.doc_lab_allocation;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doc_quota_allocation', 77 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doc_quota_allocation;

    create foreign table if not exists nios_foreign.doc_quota_allocation (
        "doctor_code" varchar(10),
        "old_quota" numeric(10),
        "new_quota" numeric(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_QUOTA_ALLOCATION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doc_quota_allocation; */

    create table if not exists nios.doc_quota_allocation as select * from nios_foreign.doc_quota_allocation;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doc_status', 78 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doc_status;

    create foreign table if not exists nios_foreign.doc_status (
        "action_date" timestamp,
        "doctor_code" varchar(10),
        "status" varchar(3),
        "reason" varchar(200),
        "date_susp" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOC_STATUS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doc_status; */

    create table if not exists nios.doc_status as select * from nios_foreign.doc_status;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_change_request', 63 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_change_request;

    create foreign table if not exists nios_foreign.doctor_change_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_change_request; */

    create table if not exists nios.doctor_change_request as select * from nios_foreign.doctor_change_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_change_request_detail', 64 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_change_request_detail;

    create foreign table if not exists nios_foreign.doctor_change_request_detail (
        "dm_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_CHANGE_REQUEST_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_change_request_detail; */

    create table if not exists nios.doctor_change_request_detail as select * from nios_foreign.doctor_change_request_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_load_6p', 66 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_load_6p;

    create foreign table if not exists nios_foreign.doctor_load_6p (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_load_6p; */

    create table if not exists nios.doctor_load_6p as select * from nios_foreign.doctor_load_6p;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_opthour', 68 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_opthour;

    create foreign table if not exists nios_foreign.doctor_opthour (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_opthour; */

    create table if not exists nios.doctor_opthour as select * from nios_foreign.doctor_opthour;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_quota_trans', 71 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_quota_trans;

    create foreign table if not exists nios_foreign.doctor_quota_trans (
        "trans_date" timestamp,
        "doctor_code" varchar(10),
        "old_quota" numeric,
        "new_quota" numeric,
        "decision_date" timestamp,
        "userid" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_QUOTA_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_quota_trans; */

    create table if not exists nios.doctor_quota_trans as select * from nios_foreign.doctor_quota_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_registration', 72 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_registration;

    create foreign table if not exists nios_foreign.doctor_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_registration; */

    create table if not exists nios.doctor_registration as select * from nios_foreign.doctor_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_request', 73 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_request;

    create foreign table if not exists nios_foreign.doctor_request (
        "dregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'DOCTOR_REQUEST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_request; */

    create table if not exists nios.doctor_request as select * from nios_foreign.doctor_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_status_enquiry', 74 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_status_enquiry;

    create foreign table if not exists nios_foreign.doctor_status_enquiry (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_status_enquiry; */

    create table if not exists nios.doctor_status_enquiry as select * from nios_foreign.doctor_status_enquiry;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doc_xray_allocation', 79 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doc_xray_allocation;

    create foreign table if not exists nios_foreign.doc_xray_allocation (
        "doctor_code" varchar(10),
        "old_xray" varchar(10),
        "new_xray" varchar(10),
        "mod_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DOC_XRAY_ALLOCATION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doc_xray_allocation; */

    create table if not exists nios.doc_xray_allocation as select * from nios_foreign.doc_xray_allocation;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table draft_allocation', 80 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.draft_allocation;

    create foreign table if not exists nios_foreign.draft_allocation (
        "id" numeric(19),
        "version" numeric(19),
        "allocation_amount" numeric(20, 2),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_master_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(20, 2),
        "invoice_no" varchar(40),
        "process_fee" numeric(20, 2)
    ) server nios_server options (schema 'NIOS1', table 'DRAFT_ALLOCATION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.draft_allocation; */

    create table if not exists nios.draft_allocation as select * from nios_foreign.draft_allocation;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table draft_usage', 82 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.draft_usage;

    create foreign table if not exists nios_foreign.draft_usage (
        "id" numeric(19),
        "version" numeric(19),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_master_id" numeric(19),
        "employer_code" varchar(40),
        "status" numeric(10),
        "trans_id" varchar(56),
        "utilise_amount" numeric(20, 2),
        "worker_code" varchar(40),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'DRAFT_USAGE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.draft_usage; */

    create table if not exists nios.draft_usage as select * from nios_foreign.draft_usage;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dup_rec', 83 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dup_rec;

    create foreign table if not exists nios_foreign.dup_rec (
        "payment_no" varchar(10),
        "count" numeric
    ) server nios_server options (schema 'NIOS1', table 'DUP_REC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dup_rec; */

    create table if not exists nios.dup_rec as select * from nios_foreign.dup_rec;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxbasket', 84 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxbasket;

    create foreign table if not exists nios_foreign.dxbasket (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxbasket; */

    create table if not exists nios.dxbasket as select * from nios_foreign.dxbasket;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxfilm_audit', 85 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxfilm_audit;

    create foreign table if not exists nios_foreign.dxfilm_audit (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxfilm_audit; */

    create table if not exists nios.dxfilm_audit as select * from nios_foreign.dxfilm_audit;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxfilm_movement', 86 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxfilm_movement;

    create foreign table if not exists nios_foreign.dxfilm_movement (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(500),
        "status" varchar(20),
        "status_date" timestamp,
        "trans_id" varchar(14),
        "uuid" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'DXFILM_MOVEMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxfilm_movement; */

    create table if not exists nios.dxfilm_movement as select * from nios_foreign.dxfilm_movement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dx_payblock', 98 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dx_payblock;

    create foreign table if not exists nios_foreign.dx_payblock (
        "doc_xray_code" varchar(10),
        "doc_xray_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'DX_PAYBLOCK');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dx_payblock; */

    create table if not exists nios.dx_payblock as select * from nios_foreign.dx_payblock;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxpcr_audit_comment', 87 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxpcr_audit_comment;

    create foreign table if not exists nios_foreign.dxpcr_audit_comment (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(2000),
        "parameter_code" varchar(20),
        "pcr_audit_film_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_AUDIT_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxpcr_audit_comment; */

    create table if not exists nios.dxpcr_audit_comment as select * from nios_foreign.dxpcr_audit_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxpcr_audit_detail', 88 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxpcr_audit_detail;

    create foreign table if not exists nios_foreign.dxpcr_audit_detail (
        "id" numeric(19),
        "version" numeric(19),
        "parameter_code" varchar(20),
        "parameter_value" varchar(8),
        "pcr_audit_film_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_AUDIT_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxpcr_audit_detail; */

    create table if not exists nios.dxpcr_audit_detail as select * from nios_foreign.dxpcr_audit_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxpcr_audit_film', 89 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxpcr_audit_film;

    create foreign table if not exists nios_foreign.dxpcr_audit_film (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxpcr_audit_film; */

    create table if not exists nios.dxpcr_audit_film as select * from nios_foreign.dxpcr_audit_film;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxpcr_pool', 90 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxpcr_pool;

    create foreign table if not exists nios_foreign.dxpcr_pool (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxpcr_pool; */

    create table if not exists nios.dxpcr_pool as select * from nios_foreign.dxpcr_pool;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxpcr_retake_reasons', 91 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxpcr_retake_reasons;

    create foreign table if not exists nios_foreign.dxpcr_retake_reasons (
        "id" varchar(20),
        "description" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'DXPCR_RETAKE_REASONS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxpcr_retake_reasons; */

    create table if not exists nios.dxpcr_retake_reasons as select * from nios_foreign.dxpcr_retake_reasons;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxreview_film', 93 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxreview_film;

    create foreign table if not exists nios_foreign.dxreview_film (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxreview_film; */

    create table if not exists nios.dxreview_film as select * from nios_foreign.dxreview_film;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxreview_film_comment', 94 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxreview_film_comment;

    create foreign table if not exists nios_foreign.dxreview_film_comment (
        "id" numeric(19),
        "version" numeric(19),
        "comments" varchar(2000),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "dxry_id" numeric(19),
        "modify_date" timestamp,
        "modify_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxreview_film_comment; */

    create table if not exists nios.dxreview_film_comment as select * from nios_foreign.dxreview_film_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxreview_film_detail', 95 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxreview_film_detail;

    create foreign table if not exists nios_foreign.dxreview_film_detail (
        "id" numeric(19),
        "version" numeric(19),
        "dxry_id" numeric(19),
        "parameter_code" varchar(20),
        "parameter_value" varchar(8)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxreview_film_detail; */

    create table if not exists nios.dxreview_film_detail as select * from nios_foreign.dxreview_film_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxreview_film_identical', 96 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxreview_film_identical;

    create foreign table if not exists nios_foreign.dxreview_film_identical (
        "id" numeric(19),
        "version" numeric(19),
        "dxry_id" numeric(19),
        "trans_id" varchar(56),
        "worker_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'DXREVIEW_FILM_IDENTICAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxreview_film_identical; */

    create table if not exists nios.dxreview_film_identical as select * from nios_foreign.dxreview_film_identical;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table dxxray_audit', 97 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.dxxray_audit;

    create foreign table if not exists nios_foreign.dxxray_audit (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.dxxray_audit; */

    create table if not exists nios.dxxray_audit as select * from nios_foreign.dxxray_audit;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_account', 99 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.employer_account;

    create foreign table if not exists nios_foreign.employer_account (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "draft_id" numeric(19),
        "draft_allocation_id" numeric(19),
        "draft_usage_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(20, 2),
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
        "other_amount" numeric(20, 2),
        "other_amount_gst" numeric(20, 2),
        "gst_tax" numeric,
        "process_fee" numeric(20, 2)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_ACCOUNT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.employer_account; */

    create table if not exists nios.employer_account as select * from nios_foreign.employer_account;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_alloc_detail', 100 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.employer_alloc_detail;

    create foreign table if not exists nios_foreign.employer_alloc_detail (
        "id" numeric(19),
        "version" numeric(19),
        "allocation_amount" numeric(20, 2),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "employer_alloc_master_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(20, 2),
        "invoice_no" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_ALLOC_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.employer_alloc_detail; */

    create table if not exists nios.employer_alloc_detail as select * from nios_foreign.employer_alloc_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_cn', 102 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.employer_cn;

    create foreign table if not exists nios_foreign.employer_cn (
        "id" numeric(19),
        "version" numeric(19),
        "account_concile_id" numeric(19),
        "allocation_amount" numeric(20, 2),
        "branch_code" varchar(1020),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "credit_note_no" varchar(40),
        "draft_allocation_id" numeric(19),
        "employer_code" varchar(40),
        "gst_amount" numeric(20, 2),
        "is_posted" numeric(10),
        "gst_percentage" numeric(20, 2),
        "nios_reference_no" numeric(19),
        "mystics_reference_no" numeric(19),
        "type" numeric(10),
        "posted_date" timestamp,
        "ap_group_id" numeric(19),
        "payment_refund_id" numeric(19),
        "other_amount" numeric(20, 2),
        "other_amount_gst" numeric(20, 2)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_CN');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.employer_cn; */

    create table if not exists nios.employer_cn as select * from nios_foreign.employer_cn;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_notification', 105 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.employer_notification;

    create foreign table if not exists nios_foreign.employer_notification (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.employer_notification; */

    create table if not exists nios.employer_notification as select * from nios_foreign.employer_notification;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_notification_count', 106 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.employer_notification_count;

    create foreign table if not exists nios_foreign.employer_notification_count (
        "employer_code" varchar(10),
        "total" numeric(5)
    ) server nios_server options (schema 'NIOS1', table 'EMPLOYER_NOTIFICATION_COUNT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.employer_notification_count; */

    create table if not exists nios.employer_notification_count as select * from nios_foreign.employer_notification_count;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table errormsg_from_kk', 107 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.errormsg_from_kk;

    create foreign table if not exists nios_foreign.errormsg_from_kk (
        "msgtime" timestamp,
        "msgtext" varchar(1000),
        "msgid" numeric
    ) server nios_server options (schema 'NIOS1', table 'ERRORMSG_FROM_KK');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.errormsg_from_kk; */

    create table if not exists nios.errormsg_from_kk as select * from nios_foreign.errormsg_from_kk;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table finance_payment', 108 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.finance_payment;

    create foreign table if not exists nios_foreign.finance_payment (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "certify_date" timestamp,
        "report_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FINANCE_PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.finance_payment; */

    create table if not exists nios.finance_payment as select * from nios_foreign.finance_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fin_batch_trans', 110 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fin_batch_trans;

    create foreign table if not exists nios_foreign.fin_batch_trans (
        "batch_number" numeric,
        "trans_id" varchar(14),
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FIN_BATCH_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fin_batch_trans; */

    create table if not exists nios.fin_batch_trans as select * from nios_foreign.fin_batch_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_doctor_quota_bkp', 111 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_doctor_quota_bkp;

    create foreign table if not exists nios_foreign.fom_doctor_quota_bkp (
        "doctor_code" varchar(10),
        "laboratory_code" varchar(10),
        "xray_code" varchar(10),
        "quota" numeric,
        "quota_use" numeric,
        "creation_date" timestamp,
        "status_code" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'FOM_DOCTOR_QUOTA_BKP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_doctor_quota_bkp; */

    create table if not exists nios.fom_doctor_quota_bkp as select * from nios_foreign.fom_doctor_quota_bkp;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_lab_payment_missed', 112 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_lab_payment_missed;

    create foreign table if not exists nios_foreign.fom_lab_payment_missed (
        "trans_id" varchar(14),
        "lab_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_LAB_PAYMENT_MISSED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_lab_payment_missed; */

    create table if not exists nios.fom_lab_payment_missed as select * from nios_foreign.fom_lab_payment_missed;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_lab_unpaid', 113 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_lab_unpaid;

    create foreign table if not exists nios_foreign.fom_lab_unpaid (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_lab_unpaid; */

    create table if not exists nios.fom_lab_unpaid as select * from nios_foreign.fom_lab_unpaid;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_params', 115 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_params;

    create foreign table if not exists nios_foreign.fom_params (
        "param_code" varchar(100),
        "param_value" varchar(1000),
        "isactive" numeric,
        "created_date" timestamp,
        "remark" varchar(1000),
        "refid" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'FOM_PARAMS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_params; */

    create table if not exists nios.fom_params as select * from nios_foreign.fom_params;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_payment_status_missed', 116 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_payment_status_missed;

    create foreign table if not exists nios_foreign.fom_payment_status_missed (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_payment_status_missed; */

    create table if not exists nios.fom_payment_status_missed as select * from nios_foreign.fom_payment_status_missed;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_pay_transaction', 117 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_pay_transaction;

    create foreign table if not exists nios_foreign.fom_pay_transaction (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "sex" varchar(1),
        "branch_code" varchar(2),
        "certify_date" timestamp,
        "sp_type" varchar(1),
        "sp_code" varchar(10),
        "sp_group_id" numeric,
        "sp_state_code" varchar(20),
        "amount" numeric(20, 2),
        "xray_notdone_ind" varchar(120),
        "created_date" timestamp,
        "gst_code" varchar(20),
        "gst_tax" numeric(20, 2),
        "gst_type" numeric(10),
        "gstamount" numeric(20, 2)
    ) server nios_server options (schema 'NIOS1', table 'FOM_PAY_TRANSACTION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_pay_transaction; */

    create table if not exists nios.fom_pay_transaction as select * from nios_foreign.fom_pay_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_pay_transaction_missed', 118 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_pay_transaction_missed;

    create foreign table if not exists nios_foreign.fom_pay_transaction_missed (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_pay_transaction_missed; */

    create table if not exists nios.fom_pay_transaction_missed as select * from nios_foreign.fom_pay_transaction_missed;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_special_payment', 119 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_special_payment;

    create foreign table if not exists nios_foreign.fom_special_payment (
        "trans_id" varchar(14),
        "sp_type" varchar(1),
        "payment_date" timestamp,
        "payment_amount" numeric,
        "created_by" varchar(20),
        "created_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_SPECIAL_PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_special_payment; */

    create table if not exists nios.fom_special_payment as select * from nios_foreign.fom_special_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_tempmyeg', 120 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_tempmyeg;

    create foreign table if not exists nios_foreign.fom_tempmyeg (
        "worker_name" varchar(50),
        "passport_no" varchar(25),
        "country" varchar(50),
        "old_passport_no" varchar(25)
    ) server nios_server options (schema 'NIOS1', table 'FOM_TEMPMYEG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_tempmyeg; */

    create table if not exists nios.fom_tempmyeg as select * from nios_foreign.fom_tempmyeg;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_tmp_jim', 121 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_tmp_jim;

    create foreign table if not exists nios_foreign.fom_tmp_jim (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_tmp_jim; */

    create table if not exists nios.fom_tmp_jim as select * from nios_foreign.fom_tmp_jim;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_user_capability', 122 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_user_capability;

    create foreign table if not exists nios_foreign.fom_user_capability (
        "uuid" numeric(10),
        "mod_id" numeric(38),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_USER_CAPABILITY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_user_capability; */

    create table if not exists nios.fom_user_capability as select * from nios_foreign.fom_user_capability;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_xray_not_done_missed', 124 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_xray_not_done_missed;

    create foreign table if not exists nios_foreign.fom_xray_not_done_missed (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'FOM_XRAY_NOT_DONE_MISSED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_xray_not_done_missed; */

    create table if not exists nios.fom_xray_not_done_missed as select * from nios_foreign.fom_xray_not_done_missed;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_xray_not_receive', 125 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_xray_not_receive;

    create foreign table if not exists nios_foreign.fom_xray_not_receive (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_xray_not_receive; */

    create table if not exists nios.fom_xray_not_receive as select * from nios_foreign.fom_xray_not_receive;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fom_xray_use_swast', 126 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fom_xray_use_swast;

    create foreign table if not exists nios_foreign.fom_xray_use_swast (
        "xray_code" varchar(10),
        "install_date" timestamp,
        "created_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FOM_XRAY_USE_SWAST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fom_xray_use_swast; */

    create table if not exists nios.fom_xray_use_swast as select * from nios_foreign.fom_xray_use_swast;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table foreign_worker_biodata', 128 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.foreign_worker_biodata;

    create foreign table if not exists nios_foreign.foreign_worker_biodata (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.foreign_worker_biodata; */

    create table if not exists nios.foreign_worker_biodata as select * from nios_foreign.foreign_worker_biodata;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal', 149 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal;

    create foreign table if not exists nios_foreign.fw_appeal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal; */

    create table if not exists nios.fw_appeal as select * from nios_foreign.fw_appeal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_approval', 150 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_approval;

    create foreign table if not exists nios_foreign.fw_appeal_approval (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_approval; */

    create table if not exists nios.fw_appeal_approval as select * from nios_foreign.fw_appeal_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_comment', 152 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_comment;

    create foreign table if not exists nios_foreign.fw_appeal_comment (
        "appeal_commentid" numeric(10),
        "appealid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_comment; */

    create table if not exists nios.fw_appeal_comment as select * from nios_foreign.fw_appeal_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_doc_change', 153 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_doc_change;

    create foreign table if not exists nios_foreign.fw_appeal_doc_change (
        "appealid" numeric(10),
        "comments" varchar(4000),
        "old_doctor_code" varchar(13),
        "new_doctor_code" varchar(13),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_DOC_CHANGE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_doc_change; */

    create table if not exists nios.fw_appeal_doc_change as select * from nios_foreign.fw_appeal_doc_change;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_follow_up', 154 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_follow_up;

    create foreign table if not exists nios_foreign.fw_appeal_follow_up (
        "followupid" numeric(10),
        "appealid" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_FOLLOW_UP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_follow_up; */

    create table if not exists nios.fw_appeal_follow_up as select * from nios_foreign.fw_appeal_follow_up;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_follow_up_detail', 155 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_follow_up_detail;

    create foreign table if not exists nios_foreign.fw_appeal_follow_up_detail (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_follow_up_detail; */

    create table if not exists nios.fw_appeal_follow_up_detail as select * from nios_foreign.fw_appeal_follow_up_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_passfail_reason', 157 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_passfail_reason;

    create foreign table if not exists nios_foreign.fw_appeal_passfail_reason (
        "reasonid" numeric(10),
        "appeal_param_code" varchar(10),
        "reason_code" varchar(10),
        "reason_description" varchar(250),
        "passfail" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_PASSFAIL_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_passfail_reason; */

    create table if not exists nios.fw_appeal_passfail_reason as select * from nios_foreign.fw_appeal_passfail_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_todolist', 158 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_todolist;

    create foreign table if not exists nios_foreign.fw_appeal_todolist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_todolist; */

    create table if not exists nios.fw_appeal_todolist as select * from nios_foreign.fw_appeal_todolist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_appeal_unfit_details', 159 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_appeal_unfit_details;

    create foreign table if not exists nios_foreign.fw_appeal_unfit_details (
        "appealid" numeric(10),
        "merts_param_code" varchar(10),
        "appeal_param_code" varchar(10),
        "reason_code" varchar(10),
        "passfail" varchar(1),
        "remarks" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_APPEAL_UNFIT_DETAILS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_appeal_unfit_details; */

    create table if not exists nios.fw_appeal_unfit_details as select * from nios_foreign.fw_appeal_unfit_details;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_biodata_reenrolment', 160 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_biodata_reenrolment;

    create foreign table if not exists nios_foreign.fw_biodata_reenrolment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_biodata_reenrolment; */

    create table if not exists nios.fw_biodata_reenrolment as select * from nios_foreign.fw_biodata_reenrolment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_block', 161 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_block;

    create foreign table if not exists nios_foreign.fw_block (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_block; */

    create table if not exists nios.fw_block as select * from nios_foreign.fw_block;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_change_trans', 162 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_change_trans;

    create foreign table if not exists nios_foreign.fw_change_trans (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_change_trans; */

    create table if not exists nios.fw_change_trans as select * from nios_foreign.fw_change_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_comment', 163 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_comment;

    create foreign table if not exists nios_foreign.fw_comment (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_comment; */

    create table if not exists nios.fw_comment as select * from nios_foreign.fw_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_critical_info', 165 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_critical_info;

    create foreign table if not exists nios_foreign.fw_critical_info (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_critical_info; */

    create table if not exists nios.fw_critical_info as select * from nios_foreign.fw_critical_info;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_critical_info_detail', 166 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_critical_info_detail;

    create foreign table if not exists nios_foreign.fw_critical_info_detail (
        "fw_critical_id" numeric(10),
        "critical_column" varchar(100),
        "critical_old" varchar(50),
        "critical_new" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'FW_CRITICAL_INFO_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_critical_info_detail; */

    create table if not exists nios.fw_critical_info_detail as select * from nios_foreign.fw_critical_info_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_detail', 167 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_detail;

    create foreign table if not exists nios_foreign.fw_detail (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_detail; */

    create table if not exists nios.fw_detail as select * from nios_foreign.fw_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_extra_comments', 169 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_extra_comments;

    create foreign table if not exists nios_foreign.fw_extra_comments (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'FW_EXTRA_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_extra_comments; */

    create table if not exists nios.fw_extra_comments as select * from nios_foreign.fw_extra_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwm_change_trans', 133 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwm_change_trans;

    create foreign table if not exists nios_foreign.fwm_change_trans (
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "old_value" varchar(100),
        "new_value" varchar(100),
        "reason_code" varchar(5),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_CHANGE_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwm_change_trans; */

    create table if not exists nios.fwm_change_trans as select * from nios_foreign.fwm_change_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwm_change_trans_org', 134 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwm_change_trans_org;

    create foreign table if not exists nios_foreign.fwm_change_trans_org (
        "bc_worker_code" varchar(13),
        "trans_id" varchar(14),
        "old_value" varchar(100),
        "new_value" varchar(100),
        "reason_code" varchar(5),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_CHANGE_TRANS_ORG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwm_change_trans_org; */

    create table if not exists nios.fwm_change_trans_org as select * from nios_foreign.fwm_change_trans_org;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_medblocked', 171 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_medblocked;

    create foreign table if not exists nios_foreign.fw_medblocked (
        "blk_tranno" varchar(10),
        "receipt_tranno" varchar(10),
        "isblock" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FW_MEDBLOCKED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_medblocked; */

    create table if not exists nios.fw_medblocked as select * from nios_foreign.fw_medblocked;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwm_modulecode', 135 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwm_modulecode;

    create foreign table if not exists nios_foreign.fwm_modulecode (
        "module_code" numeric(5),
        "description" varchar(255),
        "status" numeric(1),
        "creator_id" varchar(20),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'FWM_MODULECODE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwm_modulecode; */

    create table if not exists nios.fwm_modulecode as select * from nios_foreign.fwm_modulecode;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwm_mon', 136 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwm_mon;

    create foreign table if not exists nios_foreign.fwm_mon (
        "worker_code" varchar(10),
        "ismonitor" varchar(5),
        "passport_no" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'FWM_MON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwm_mon; */

    create table if not exists nios.fwm_mon as select * from nios_foreign.fwm_mon;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_monitor', 172 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_monitor;

    create foreign table if not exists nios_foreign.fw_monitor (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_monitor; */

    create table if not exists nios.fw_monitor as select * from nios_foreign.fw_monitor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_monitor_reason', 173 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_monitor_reason;

    create foreign table if not exists nios_foreign.fw_monitor_reason (
        "reason_code" varchar(5),
        "description" varchar(100),
        "capid" numeric(10),
        "shortdesc" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_MONITOR_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_monitor_reason; */

    create table if not exists nios.fw_monitor_reason as select * from nios_foreign.fw_monitor_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_movement', 174 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_movement;

    create foreign table if not exists nios_foreign.fw_movement (
        "id" numeric(19),
        "branch_code" varchar(8),
        "log_date" timestamp,
        "module_code" numeric(10),
        "remarks" varchar(4000),
        "trans_id" varchar(56),
        "userid" varchar(80),
        "worker_code" varchar(1020)
    ) server nios_server options (schema 'NIOS1', table 'FW_MOVEMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_movement; */

    create table if not exists nios.fw_movement as select * from nios_foreign.fw_movement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_quarantine_reason', 175 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_quarantine_reason;

    create foreign table if not exists nios_foreign.fw_quarantine_reason (
        "trans_id" varchar(14),
        "reason_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_QUARANTINE_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_quarantine_reason; */

    create table if not exists nios.fw_quarantine_reason as select * from nios_foreign.fw_quarantine_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_change_clinic_approval', 139 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_change_clinic_approval;

    create foreign table if not exists nios_foreign.fwt_change_clinic_approval (
        "req_id" numeric(10),
        "trans_id" varchar(16),
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "payment_mode" varchar(20),
        "payment_amount" numeric(20, 2),
        "foc_reason" varchar(2000),
        "approval_status" numeric,
        "creation_date" timestamp,
        "created_by" numeric(10),
        "modification_date" timestamp,
        "modified_by" numeric(10),
        "branch_code" varchar(2),
        "approval_comment" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_CLINIC_APPROVAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_change_clinic_approval; */

    create table if not exists nios.fwt_change_clinic_approval as select * from nios_foreign.fwt_change_clinic_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_change_journal', 140 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_change_journal;

    create foreign table if not exists nios_foreign.fwt_change_journal (
        "chgjl_id" varchar(14),
        "chgjl_date" timestamp,
        "trans_id" varchar(14),
        "userid" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_JOURNAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_change_journal; */

    create table if not exists nios.fwt_change_journal as select * from nios_foreign.fwt_change_journal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_change_journal_detail', 141 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_change_journal_detail;

    create foreign table if not exists nios_foreign.fwt_change_journal_detail (
        "chgjl_id" varchar(14),
        "chgtype" varchar(1),
        "old_code" varchar(10),
        "new_code" varchar(10),
        "reason" varchar(240)
    ) server nios_server options (schema 'NIOS1', table 'FWT_CHANGE_JOURNAL_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_change_journal_detail; */

    create table if not exists nios.fwt_change_journal_detail as select * from nios_foreign.fwt_change_journal_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_deferred', 142 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_deferred;

    create foreign table if not exists nios_foreign.fwt_deferred (
        "trans_id" varchar(14),
        "creation_date" timestamp,
        "created_by" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'FWT_DEFERRED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_deferred; */

    create table if not exists nios.fwt_deferred as select * from nios_foreign.fwt_deferred;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_examdate_change_trans', 143 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_examdate_change_trans;

    create foreign table if not exists nios_foreign.fwt_examdate_change_trans (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_examdate_change_trans; */

    create table if not exists nios.fwt_examdate_change_trans as select * from nios_foreign.fwt_examdate_change_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_transaction', 177 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_transaction;

    create foreign table if not exists nios_foreign.fw_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_transaction; */

    create table if not exists nios.fw_transaction as select * from nios_foreign.fw_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_transaction_cancel', 178 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_transaction_cancel;

    create foreign table if not exists nios_foreign.fw_transaction_cancel (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_transaction_cancel; */

    create table if not exists nios.fw_transaction_cancel as select * from nios_foreign.fw_transaction_cancel;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_transaction_delete', 179 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_transaction_delete;

    create foreign table if not exists nios_foreign.fw_transaction_delete (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_transaction_delete; */

    create table if not exists nios.fw_transaction_delete as select * from nios_foreign.fw_transaction_delete;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_transaction_update', 181 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_transaction_update;

    create foreign table if not exists nios_foreign.fw_transaction_update (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_transaction_update; */

    create table if not exists nios.fw_transaction_update as select * from nios_foreign.fw_transaction_update;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_regmed', 144 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_regmed;

    create foreign table if not exists nios_foreign.fwt_regmed (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "med_ind" numeric,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_REGMED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_regmed; */

    create table if not exists nios.fwt_regmed as select * from nios_foreign.fwt_regmed;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_regmed_delta', 145 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_regmed_delta;

    create foreign table if not exists nios_foreign.fwt_regmed_delta (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "med_ind" numeric,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_REGMED_DELTA');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_regmed_delta; */

    create table if not exists nios.fwt_regmed_delta as select * from nios_foreign.fwt_regmed_delta;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_shadow', 146 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_shadow;

    create foreign table if not exists nios_foreign.fwt_shadow (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_shadow; */

    create table if not exists nios.fwt_shadow as select * from nios_foreign.fwt_shadow;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_update_tcupi', 147 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_update_tcupi;

    create foreign table if not exists nios_foreign.fwt_update_tcupi (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "old_fit_ind" varchar(1),
        "new_fit_ind" varchar(1),
        "old_tcupi_ind" varchar(1),
        "new_tcupi_ind" varchar(1),
        "mod_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'FWT_UPDATE_TCUPI');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_update_tcupi; */

    create table if not exists nios.fwt_update_tcupi as select * from nios_foreign.fwt_update_tcupi;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_xray_unmatch', 148 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_xray_unmatch;

    create foreign table if not exists nios_foreign.fwt_xray_unmatch (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(14),
        "bc_xray_code" varchar(14),
        "xray_code" varchar(14),
        "modify_id" numeric,
        "modification_date" timestamp,
        "version_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'FWT_XRAY_UNMATCH');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_xray_unmatch; */

    create table if not exists nios.fwt_xray_unmatch as select * from nios_foreign.fwt_xray_unmatch;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_unsuitable_reasons', 182 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_unsuitable_reasons;

    create foreign table if not exists nios_foreign.fw_unsuitable_reasons (
        "trans_id" varchar(14),
        "unsuitable_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'FW_UNSUITABLE_REASONS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_unsuitable_reasons; */

    create table if not exists nios.fw_unsuitable_reasons as select * from nios_foreign.fw_unsuitable_reasons;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_worker_replacement', 183 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fw_worker_replacement;

    create foreign table if not exists nios_foreign.fw_worker_replacement (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fw_worker_replacement; */

    create table if not exists nios.fw_worker_replacement as select * from nios_foreign.fw_worker_replacement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table group_details', 184 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.group_details;

    create foreign table if not exists nios_foreign.group_details (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.group_details; */

    create table if not exists nios.group_details as select * from nios_foreign.group_details;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table group_doctor_pay', 185 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.group_doctor_pay;

    create foreign table if not exists nios_foreign.group_doctor_pay (
        "group_code" varchar(6),
        "pay_ind" varchar(1),
        "doctor_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_DOCTOR_PAY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.group_doctor_pay; */

    create table if not exists nios.group_doctor_pay as select * from nios_foreign.group_doctor_pay;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table group_worker', 187 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.group_worker;

    create foreign table if not exists nios_foreign.group_worker (
        "passport" varchar(20),
        "country" varchar(3),
        "creation_date" timestamp,
        "name" varchar(60),
        "sex" varchar(1),
        "modify_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'GROUP_WORKER');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.group_worker; */

    create table if not exists nios.group_worker as select * from nios_foreign.group_worker;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table group_xray_pay', 188 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.group_xray_pay;

    create foreign table if not exists nios_foreign.group_xray_pay (
        "group_code" varchar(6),
        "pay_ind" varchar(1),
        "xray_code" varchar(10),
        "group_status" varchar(1),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'GROUP_XRAY_PAY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.group_xray_pay; */

    create table if not exists nios.group_xray_pay as select * from nios_foreign.group_xray_pay;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table imm_block_workers', 191 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.imm_block_workers;

    create foreign table if not exists nios_foreign.imm_block_workers (
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'IMM_BLOCK_WORKERS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.imm_block_workers; */

    create table if not exists nios.imm_block_workers as select * from nios_foreign.imm_block_workers;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table imm_med_receive', 192 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.imm_med_receive;

    create foreign table if not exists nios_foreign.imm_med_receive (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.imm_med_receive; */

    create table if not exists nios.imm_med_receive as select * from nios_foreign.imm_med_receive;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table imm_med_send', 193 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.imm_med_send;

    create foreign table if not exists nios_foreign.imm_med_send (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.imm_med_send; */

    create table if not exists nios.imm_med_send as select * from nios_foreign.imm_med_send;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table inactive_doctors', 194 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.inactive_doctors;

    create foreign table if not exists nios_foreign.inactive_doctors (
        "doctor_code" varchar(10),
        "date_of_inactive" timestamp,
        "reason" varchar(500)
    ) server nios_server options (schema 'NIOS1', table 'INACTIVE_DOCTORS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.inactive_doctors; */

    create table if not exists nios.inactive_doctors as select * from nios_foreign.inactive_doctors;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table invoice_detail', 196 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.invoice_detail;

    create foreign table if not exists nios_foreign.invoice_detail (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.invoice_detail; */

    create table if not exists nios.invoice_detail as select * from nios_foreign.invoice_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table lab_change_request', 207 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.lab_change_request;

    create foreign table if not exists nios_foreign.lab_change_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.lab_change_request; */

    create table if not exists nios.lab_change_request as select * from nios_foreign.lab_change_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table lab_change_request_detail', 208 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.lab_change_request_detail;

    create foreign table if not exists nios_foreign.lab_change_request_detail (
        "lab_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'LAB_CHANGE_REQUEST_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.lab_change_request_detail; */

    create table if not exists nios.lab_change_request_detail as select * from nios_foreign.lab_change_request_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table laboratory_group', 200 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.laboratory_group;

    create foreign table if not exists nios_foreign.laboratory_group (
        "lab_group" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_GROUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.laboratory_group; */

    create table if not exists nios.laboratory_group as select * from nios_foreign.laboratory_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table laboratory_registration', 203 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.laboratory_registration;

    create foreign table if not exists nios_foreign.laboratory_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.laboratory_registration; */

    create table if not exists nios.laboratory_registration as select * from nios_foreign.laboratory_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table laboratory_request', 204 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.laboratory_request;

    create foreign table if not exists nios_foreign.laboratory_request (
        "lregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LABORATORY_REQUEST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.laboratory_request; */

    create table if not exists nios.laboratory_request as select * from nios_foreign.laboratory_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table lab_payment', 209 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.lab_payment;

    create foreign table if not exists nios_foreign.lab_payment (
        "trans_id" varchar(14),
        "lab_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAB_PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.lab_payment; */

    create table if not exists nios.lab_payment as select * from nios_foreign.lab_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table labuan_g_workers', 205 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.labuan_g_workers;

    create foreign table if not exists nios_foreign.labuan_g_workers (
        "worker_code" varchar(10),
        "created_by" varchar(30),
        "transdate" timestamp,
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'LABUAN_G_WORKERS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.labuan_g_workers; */

    create table if not exists nios.labuan_g_workers as select * from nios_foreign.labuan_g_workers;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table labws_applicationid', 206 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.labws_applicationid;

    create foreign table if not exists nios_foreign.labws_applicationid (
        "appid" varchar(3),
        "active" char(1),
        "description" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'LABWS_APPLICATIONID');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.labws_applicationid; */

    create table if not exists nios.labws_applicationid as select * from nios_foreign.labws_applicationid;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table last_monitor', 211 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.last_monitor;

    create foreign table if not exists nios_foreign.last_monitor (
        "monitor_type" varchar(50),
        "last_run" timestamp,
        "last_start" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_MONITOR');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.last_monitor; */

    create table if not exists nios.last_monitor as select * from nios_foreign.last_monitor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table last_rev_sync', 212 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.last_rev_sync;

    create foreign table if not exists nios_foreign.last_rev_sync (
        "table_name" varchar(100),
        "sync_start" timestamp,
        "sync_end" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_REV_SYNC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.last_rev_sync; */

    create table if not exists nios.last_rev_sync as select * from nios_foreign.last_rev_sync;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table last_sync', 213 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.last_sync;

    create foreign table if not exists nios_foreign.last_sync (
        "table_name" varchar(100),
        "sync_start" timestamp,
        "sync_end" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LAST_SYNC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.last_sync; */

    create table if not exists nios.last_sync as select * from nios_foreign.last_sync;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table letter_monitor', 214 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.letter_monitor;

    create foreign table if not exists nios_foreign.letter_monitor (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.letter_monitor; */

    create table if not exists nios.letter_monitor as select * from nios_foreign.letter_monitor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table letter_monitor_detail', 215 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.letter_monitor_detail;

    create foreign table if not exists nios_foreign.letter_monitor_detail (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.letter_monitor_detail; */

    create table if not exists nios.letter_monitor_detail as select * from nios_foreign.letter_monitor_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table load_info', 216 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.load_info;

    create foreign table if not exists nios_foreign.load_info (
        "last_exam_date" timestamp,
        "passport_no" varchar(20),
        "fit_ind" varchar(1),
        "arrival_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LOAD_INFO');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.load_info; */

    create table if not exists nios.load_info as select * from nios_foreign.load_info;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table lqcc_comments', 219 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.lqcc_comments;

    create foreign table if not exists nios_foreign.lqcc_comments (
        "lq_commentid" numeric(10),
        "lqccid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LQCC_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.lqcc_comments; */

    create table if not exists nios.lqcc_comments as select * from nios_foreign.lqcc_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table lqcc_report', 220 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.lqcc_report;

    create foreign table if not exists nios_foreign.lqcc_report (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.lqcc_report; */

    create table if not exists nios.lqcc_report as select * from nios_foreign.lqcc_report;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table maxigrid', 221 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.maxigrid;

    create foreign table if not exists nios_foreign.maxigrid (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.maxigrid; */

    create table if not exists nios.maxigrid as select * from nios_foreign.maxigrid;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table merts_doc_startpage_stats', 222 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.merts_doc_startpage_stats;

    create foreign table if not exists nios_foreign.merts_doc_startpage_stats (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.merts_doc_startpage_stats; */

    create table if not exists nios.merts_doc_startpage_stats as select * from nios_foreign.merts_doc_startpage_stats;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table merts_lab_startpage_stats', 223 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.merts_lab_startpage_stats;

    create foreign table if not exists nios_foreign.merts_lab_startpage_stats (
        "lab_code" varchar(10),
        "delayed_transmission" numeric,
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MERTS_LAB_STARTPAGE_STATS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.merts_lab_startpage_stats; */

    create table if not exists nios.merts_lab_startpage_stats as select * from nios_foreign.merts_lab_startpage_stats;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table merts_xray_startpage_stats', 224 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.merts_xray_startpage_stats;

    create foreign table if not exists nios_foreign.merts_xray_startpage_stats (
        "xray_code" varchar(10),
        "delayed_transmission" numeric,
        "film_notyet_send" numeric,
        "last_updated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MERTS_XRAY_STARTPAGE_STATS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.merts_xray_startpage_stats; */

    create table if not exists nios.merts_xray_startpage_stats as select * from nios_foreign.merts_xray_startpage_stats;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table missing_payment', 225 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.missing_payment;

    create foreign table if not exists nios_foreign.missing_payment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.missing_payment; */

    create table if not exists nios.missing_payment as select * from nios_foreign.missing_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table module_page', 227 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.module_page;

    create foreign table if not exists nios_foreign.module_page (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.module_page; */

    create table if not exists nios.module_page as select * from nios_foreign.module_page;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table moh_doc_report', 228 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.moh_doc_report;

    create foreign table if not exists nios_foreign.moh_doc_report (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.moh_doc_report; */

    create table if not exists nios.moh_doc_report as select * from nios_foreign.moh_doc_report;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table moh_doc_stat', 229 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.moh_doc_stat;

    create foreign table if not exists nios_foreign.moh_doc_stat (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.moh_doc_stat; */

    create table if not exists nios.moh_doc_stat as select * from nios_foreign.moh_doc_stat;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table monitor_exam', 232 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.monitor_exam;

    create foreign table if not exists nios_foreign.monitor_exam (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "issue_letter_ind" varchar(1),
        "issue_date" timestamp,
        "ins_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'MONITOR_EXAM');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.monitor_exam; */

    create table if not exists nios.monitor_exam as select * from nios_foreign.monitor_exam;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table monitoring', 231 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.monitoring;

    create foreign table if not exists nios_foreign.monitoring (
        "worker_code" varchar(10),
        "worker_name" varchar(30),
        "passport_no" varchar(10),
        "renewal_date" timestamp,
        "certify_date" timestamp,
        "status" varchar(5),
        "remarks" varchar(200)
    ) server nios_server options (schema 'NIOS1', table 'MONITORING');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.monitoring; */

    create table if not exists nios.monitoring as select * from nios_foreign.monitoring;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table myimms_mon_tcupi', 234 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.myimms_mon_tcupi;

    create foreign table if not exists nios_foreign.myimms_mon_tcupi (
        "trans_id" varchar(14),
        "passport_no" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'MYIMMS_MON_TCUPI');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.myimms_mon_tcupi; */

    create table if not exists nios.myimms_mon_tcupi as select * from nios_foreign.myimms_mon_tcupi;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table myimms_queue', 235 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.myimms_queue;

    create foreign table if not exists nios_foreign.myimms_queue (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.myimms_queue; */

    create table if not exists nios.myimms_queue as select * from nios_foreign.myimms_queue;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table myimms_queue_hist', 236 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.myimms_queue_hist;

    create foreign table if not exists nios_foreign.myimms_queue_hist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.myimms_queue_hist; */

    create table if not exists nios.myimms_queue_hist as select * from nios_foreign.myimms_queue_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table new_arri', 238 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.new_arri;

    create foreign table if not exists nios_foreign.new_arri (
        "regn_date" timestamp,
        "old_clinic" varchar(70),
        "new_clinic" varchar(50),
        "doctor_code" varchar(10),
        "worker_code" varchar(10),
        "country_name" varchar(50),
        "fitness" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'NEW_ARRI');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.new_arri; */

    create table if not exists nios.new_arri as select * from nios_foreign.new_arri;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table nios_lab_payment', 239 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.nios_lab_payment;

    create foreign table if not exists nios_foreign.nios_lab_payment (
        "laboratory_code" varchar(10),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "transdate" timestamp,
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'NIOS_LAB_PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.nios_lab_payment; */

    create table if not exists nios.nios_lab_payment as select * from nios_foreign.nios_lab_payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table nios_setting', 240 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.nios_setting;

    create foreign table if not exists nios_foreign.nios_setting (
        "id" numeric(19),
        "version" numeric(19),
        "create_date" timestamp,
        "creator_id" numeric(10),
        "description" varchar(400),
        "parameter" varchar(120),
        "value" varchar(200)
    ) server nios_server options (schema 'NIOS1', table 'NIOS_SETTING');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.nios_setting; */

    create table if not exists nios.nios_setting as select * from nios_foreign.nios_setting;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table non_transmission', 241 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.non_transmission;

    create foreign table if not exists nios_foreign.non_transmission (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.non_transmission; */

    create table if not exists nios.non_transmission as select * from nios_foreign.non_transmission;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table notification', 242 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.notification;

    create foreign table if not exists nios_foreign.notification (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.notification; */

    create table if not exists nios.notification as select * from nios_foreign.notification;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table operation_comments', 243 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.operation_comments;

    create foreign table if not exists nios_foreign.operation_comments (
        "commentid" numeric(10),
        "bc_user_code" varchar(13),
        "category" varchar(5),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'OPERATION_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.operation_comments; */

    create table if not exists nios.operation_comments as select * from nios_foreign.operation_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pati_renew', 244 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pati_renew;

    create foreign table if not exists nios_foreign.pati_renew (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "reg_ind" numeric
    ) server nios_server options (schema 'NIOS1', table 'PATI_RENEW');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pati_renew; */

    create table if not exists nios.pati_renew as select * from nios_foreign.pati_renew;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment', 245 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment;

    create foreign table if not exists nios_foreign.payment (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
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
        "gst_tax" numeric(20, 2),
        "invoice_date" timestamp,
        "invoice_no" varchar(120),
        "gst_type" numeric(1),
        "service_provider_group_id" varchar(30),
        "gstamount" numeric(20, 2),
        "fin_batch_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment; */

    create table if not exists nios.payment as select * from nios_foreign.payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_method', 246 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_method;

    create foreign table if not exists nios_foreign.payment_method (
        "payment_type" numeric(4),
        "description" varchar(255),
        "service_type" varchar(2),
        "status" numeric(1),
        "isfoc" numeric,
        "surcharge" numeric(20, 2)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_METHOD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_method; */

    create table if not exists nios.payment_method as select * from nios_foreign.payment_method;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_refund', 247 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_refund;

    create foreign table if not exists nios_foreign.payment_refund (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
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
        "gst_amount" numeric(20, 2),
        "old_bank_account_holder_name" varchar(50),
        "refund_fee" numeric(20, 2),
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_refund; */

    create table if not exists nios.payment_refund as select * from nios_foreign.payment_refund;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_refund_approval', 248 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_refund_approval;

    create foreign table if not exists nios_foreign.payment_refund_approval (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_refund_approval; */

    create table if not exists nios.payment_refund_approval as select * from nios_foreign.payment_refund_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_reject', 249 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_reject;

    create foreign table if not exists nios_foreign.payment_reject (
        "id" numeric(19),
        "reject_code" varchar(5),
        "reference_id" varchar(20),
        "service_provider" varchar(1500),
        "group_pay" varchar(1),
        "payable_amount" numeric(20, 2),
        "gst_amount" numeric(20, 2),
        "isread" numeric,
        "read_date" timestamp,
        "creator_id" varchar(7),
        "create_date" timestamp,
        "modify_id" varchar(7),
        "modification_date" timestamp,
        "type" numeric(19),
        "employer_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REJECT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_reject; */

    create table if not exists nios.payment_reject as select * from nios_foreign.payment_reject;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_req', 251 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_req;

    create foreign table if not exists nios_foreign.payment_req (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
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
        "gstamount" numeric(20, 2),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "sex" varchar(1),
        "fin_batch_no" numeric
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REQ');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_req; */

    create table if not exists nios.payment_req as select * from nios_foreign.payment_req;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_status', 253 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_status;

    create foreign table if not exists nios_foreign.payment_status (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_status; */

    create table if not exists nios.payment_status as select * from nios_foreign.payment_status;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pay_transaction', 254 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pay_transaction;

    create foreign table if not exists nios_foreign.pay_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pay_transaction; */

    create table if not exists nios.pay_transaction as select * from nios_foreign.pay_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pay_trans_manual', 255 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pay_trans_manual;

    create foreign table if not exists nios_foreign.pay_trans_manual (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pay_trans_manual; */

    create table if not exists nios.pay_trans_manual as select * from nios_foreign.pay_trans_manual;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pbcatcol', 256 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pbcatcol;

    create foreign table if not exists nios_foreign.pbcatcol (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pbcatcol; */

    create table if not exists nios.pbcatcol as select * from nios_foreign.pbcatcol;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pbcatedt', 257 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pbcatedt;

    create foreign table if not exists nios_foreign.pbcatedt (
        "pbe_name" varchar(30),
        "pbe_edit" varchar(254),
        "pbe_type" numeric,
        "pbe_cntr" numeric,
        "pbe_seqn" numeric,
        "pbe_flag" numeric,
        "pbe_work" varchar(32)
    ) server nios_server options (schema 'NIOS1', table 'PBCATEDT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pbcatedt; */

    create table if not exists nios.pbcatedt as select * from nios_foreign.pbcatedt;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pbcatfmt', 258 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pbcatfmt;

    create foreign table if not exists nios_foreign.pbcatfmt (
        "pbf_name" varchar(30),
        "pbf_frmt" varchar(254),
        "pbf_type" numeric,
        "pbf_cntr" numeric
    ) server nios_server options (schema 'NIOS1', table 'PBCATFMT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pbcatfmt; */

    create table if not exists nios.pbcatfmt as select * from nios_foreign.pbcatfmt;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pbcattbl', 259 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pbcattbl;

    create foreign table if not exists nios_foreign.pbcattbl (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pbcattbl; */

    create table if not exists nios.pbcattbl as select * from nios_foreign.pbcattbl;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pbcatvld', 260 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pbcatvld;

    create foreign table if not exists nios_foreign.pbcatvld (
        "pbv_name" varchar(30),
        "pbv_vald" varchar(254),
        "pbv_type" numeric,
        "pbv_cntr" numeric,
        "pbv_msg" varchar(254)
    ) server nios_server options (schema 'NIOS1', table 'PBCATVLD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pbcatvld; */

    create table if not exists nios.pbcatvld as select * from nios_foreign.pbcatvld;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pcr_transaction', 261 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pcr_transaction;

    create foreign table if not exists nios_foreign.pcr_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pcr_transaction; */

    create table if not exists nios.pcr_transaction as select * from nios_foreign.pcr_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pcr_trans_comments', 262 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pcr_trans_comments;

    create foreign table if not exists nios_foreign.pcr_trans_comments (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'PCR_TRANS_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pcr_trans_comments; */

    create table if not exists nios.pcr_trans_comments as select * from nios_foreign.pcr_trans_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pcr_trans_detail', 263 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pcr_trans_detail;

    create foreign table if not exists nios_foreign.pcr_trans_detail (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "parameter_value" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'PCR_TRANS_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pcr_trans_detail; */

    create table if not exists nios.pcr_trans_detail as select * from nios_foreign.pcr_trans_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table pincode_req', 264 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.pincode_req;

    create foreign table if not exists nios_foreign.pincode_req (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.pincode_req; */

    create table if not exists nios.pincode_req as select * from nios_foreign.pincode_req;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table ply_transaction', 265 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.ply_transaction;

    create foreign table if not exists nios_foreign.ply_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.ply_transaction; */

    create table if not exists nios.ply_transaction as select * from nios_foreign.ply_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table ply_transaction_hist', 266 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.ply_transaction_hist;

    create foreign table if not exists nios_foreign.ply_transaction_hist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.ply_transaction_hist; */

    create table if not exists nios.ply_transaction_hist as select * from nios_foreign.ply_transaction_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_fw_doc', 269 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_fw_doc;

    create foreign table if not exists nios_foreign.quarantine_fw_doc (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_fw_doc; */

    create table if not exists nios.quarantine_fw_doc as select * from nios_foreign.quarantine_fw_doc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_fw_doc_hist', 270 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_fw_doc_hist;

    create foreign table if not exists nios_foreign.quarantine_fw_doc_hist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_fw_doc_hist; */

    create table if not exists nios.quarantine_fw_doc_hist as select * from nios_foreign.quarantine_fw_doc_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_fw_reason', 271 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_fw_reason;

    create foreign table if not exists nios_foreign.quarantine_fw_reason (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_fw_reason; */

    create table if not exists nios.quarantine_fw_reason as select * from nios_foreign.quarantine_fw_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_fw_reason_hist', 272 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_fw_reason_hist;

    create foreign table if not exists nios_foreign.quarantine_fw_reason_hist (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp,
        "delete_date" timestamp,
        "delete_by" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_FW_REASON_HIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_fw_reason_hist; */

    create table if not exists nios.quarantine_fw_reason_hist as select * from nios_foreign.quarantine_fw_reason_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_insp_findings', 273 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_insp_findings;

    create foreign table if not exists nios_foreign.quarantine_insp_findings (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_insp_findings; */

    create table if not exists nios.quarantine_insp_findings as select * from nios_foreign.quarantine_insp_findings;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_insp_findings_hist', 274 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_insp_findings_hist;

    create foreign table if not exists nios_foreign.quarantine_insp_findings_hist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_insp_findings_hist; */

    create table if not exists nios.quarantine_insp_findings_hist as select * from nios_foreign.quarantine_insp_findings_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_reason', 275 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_reason;

    create foreign table if not exists nios_foreign.quarantine_reason (
        "reason_code" varchar(10),
        "reason" varchar(1000),
        "active" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_reason; */

    create table if not exists nios.quarantine_reason as select * from nios_foreign.quarantine_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_reason_group', 276 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_reason_group;

    create foreign table if not exists nios_foreign.quarantine_reason_group (
        "capid" numeric(18),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_REASON_GROUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_reason_group; */

    create table if not exists nios.quarantine_reason_group as select * from nios_foreign.quarantine_reason_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_release_approval', 277 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_release_approval;

    create foreign table if not exists nios_foreign.quarantine_release_approval (
        "qrreqid" numeric(10),
        "qrrid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_RELEASE_APPROVAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_release_approval; */

    create table if not exists nios.quarantine_release_approval as select * from nios_foreign.quarantine_release_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_release_request', 278 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_release_request;

    create foreign table if not exists nios_foreign.quarantine_release_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_release_request; */

    create table if not exists nios.quarantine_release_request as select * from nios_foreign.quarantine_release_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_status_pending', 281 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_status_pending;

    create foreign table if not exists nios_foreign.quarantine_status_pending (
        "bc_worker_code" varchar(13),
        "old_status" varchar(1),
        "new_status" varchar(1),
        "userid" numeric(10),
        "mod_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_STATUS_PENDING');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_status_pending; */

    create table if not exists nios.quarantine_status_pending as select * from nios_foreign.quarantine_status_pending;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_tcupi_todolist', 282 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_tcupi_todolist;

    create foreign table if not exists nios_foreign.quarantine_tcupi_todolist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_tcupi_todolist; */

    create table if not exists nios.quarantine_tcupi_todolist as select * from nios_foreign.quarantine_tcupi_todolist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quarantine_transfer', 283 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quarantine_transfer;

    create foreign table if not exists nios_foreign.quarantine_transfer (
        "trans_id" varchar(14),
        "worker_code" varchar(13),
        "transfer_mode" numeric(1),
        "comments" varchar(1000),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'QUARANTINE_TRANSFER');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quarantine_transfer; */

    create table if not exists nios.quarantine_transfer as select * from nios_foreign.quarantine_transfer;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quest_com_product_privs', 286 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quest_com_product_privs;

    create foreign table if not exists nios_foreign.quest_com_product_privs (
        "product_id" numeric,
        "privilege_id" varchar(60),
        "privilege_description" varchar(256),
        "validation_routine" varchar(2000),
        "privilege_level" varchar(256),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_PRODUCT_PRIVS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quest_com_product_privs; */

    create table if not exists nios.quest_com_product_privs as select * from nios_foreign.quest_com_product_privs;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quest_com_products', 284 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quest_com_products;

    create foreign table if not exists nios_foreign.quest_com_products (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quest_com_products; */

    create table if not exists nios.quest_com_products as select * from nios_foreign.quest_com_products;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quest_com_products_used_by', 285 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quest_com_products_used_by;

    create foreign table if not exists nios_foreign.quest_com_products_used_by (
        "product_id" numeric,
        "used_by_product_id" numeric,
        "product_version" varchar(20),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_PRODUCTS_USED_BY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quest_com_products_used_by; */

    create table if not exists nios.quest_com_products_used_by as select * from nios_foreign.quest_com_products_used_by;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quest_com_user_privileges', 288 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quest_com_user_privileges;

    create foreign table if not exists nios_foreign.quest_com_user_privileges (
        "product_id" numeric,
        "user_id" numeric,
        "privilege_id" varchar(60),
        "privilege_level" varchar(2000),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_USER_PRIVILEGES');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quest_com_user_privileges; */

    create table if not exists nios.quest_com_user_privileges as select * from nios_foreign.quest_com_user_privileges;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table quest_com_users', 287 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.quest_com_users;

    create foreign table if not exists nios_foreign.quest_com_users (
        "user_id" numeric,
        "product_id" numeric,
        "authorization_level" varchar(60),
        "install_user" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'QUEST_COM_USERS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.quest_com_users; */

    create table if not exists nios.quest_com_users as select * from nios_foreign.quest_com_users;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table radiologist_registration', 292 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.radiologist_registration;

    create foreign table if not exists nios_foreign.radiologist_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.radiologist_registration; */

    create table if not exists nios.radiologist_registration as select * from nios_foreign.radiologist_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table r_del_dup', 350 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.r_del_dup;

    create foreign table if not exists nios_foreign.r_del_dup (
        "worker_code" varchar(10),
        "tot" numeric
    ) server nios_server options (schema 'NIOS1', table 'R_DEL_DUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.r_del_dup; */

    create table if not exists nios.r_del_dup as select * from nios_foreign.r_del_dup;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt', 294 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt;

    create foreign table if not exists nios_foreign.receipt (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt; */

    create table if not exists nios.receipt as select * from nios_foreign.receipt;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_change_reason', 295 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_change_reason;

    create foreign table if not exists nios_foreign.receipt_change_reason (
        "rregid" numeric(10),
        "tranno" varchar(10),
        "reason_type" varchar(5),
        "reason" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_CHANGE_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_change_reason; */

    create table if not exists nios.receipt_change_reason as select * from nios_foreign.receipt_change_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_change_type', 296 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_change_type;

    create foreign table if not exists nios_foreign.receipt_change_type (
        "reason_type" numeric(10),
        "description" varchar(255),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_CHANGE_TYPE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_change_type; */

    create table if not exists nios.receipt_change_type as select * from nios_foreign.receipt_change_type;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_detail', 297 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_detail;

    create foreign table if not exists nios_foreign.receipt_detail (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_detail; */

    create table if not exists nios.receipt_detail as select * from nios_foreign.receipt_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_detail_sabah', 299 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_detail_sabah;

    create foreign table if not exists nios_foreign.receipt_detail_sabah (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_detail_sabah; */

    create table if not exists nios.receipt_detail_sabah as select * from nios_foreign.receipt_detail_sabah;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_gender_change', 300 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_gender_change;

    create foreign table if not exists nios_foreign.receipt_gender_change (
        "receipt_gender_id" numeric(10),
        "tranno" varchar(10),
        "male_diff" numeric(5),
        "female_diff" numeric(5),
        "amount_diff" numeric(10),
        "create_by" numeric(10),
        "create_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_GENDER_CHANGE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_gender_change; */

    create table if not exists nios.receipt_gender_change as select * from nios_foreign.receipt_gender_change;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_kiv_request', 303 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_kiv_request;

    create foreign table if not exists nios_foreign.receipt_kiv_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_kiv_request; */

    create table if not exists nios.receipt_kiv_request as select * from nios_foreign.receipt_kiv_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_medcon', 304 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_medcon;

    create foreign table if not exists nios_foreign.receipt_medcon (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_medcon; */

    create table if not exists nios.receipt_medcon as select * from nios_foreign.receipt_medcon;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_prefer_doctor', 305 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_prefer_doctor;

    create foreign table if not exists nios_foreign.receipt_prefer_doctor (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_prefer_doctor; */

    create table if not exists nios.receipt_prefer_doctor as select * from nios_foreign.receipt_prefer_doctor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_sabah', 307 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_sabah;

    create foreign table if not exists nios_foreign.receipt_sabah (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_sabah; */

    create table if not exists nios.receipt_sabah as select * from nios_foreign.receipt_sabah;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_service', 308 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_service;

    create foreign table if not exists nios_foreign.receipt_service (
        "service_type" varchar(2),
        "description" varchar(255),
        "status" varchar(5),
        "service_charge" numeric,
        "use_by" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'RECEIPT_SERVICE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_service; */

    create table if not exists nios.receipt_service as select * from nios_foreign.receipt_service;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table receipt_usage', 309 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.receipt_usage;

    create foreign table if not exists nios_foreign.receipt_usage (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.receipt_usage; */

    create table if not exists nios.receipt_usage as select * from nios_foreign.receipt_usage;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table ref_double', 317 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.ref_double;

    create foreign table if not exists nios_foreign.ref_double (
        "worker_code" varchar(10),
        "count" numeric
    ) server nios_server options (schema 'NIOS1', table 'REF_DOUBLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.ref_double; */

    create table if not exists nios.ref_double as select * from nios_foreign.ref_double;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table refund', 311 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.refund;

    create foreign table if not exists nios_foreign.refund (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.refund; */

    create table if not exists nios.refund as select * from nios_foreign.refund;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table refund_detail', 312 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.refund_detail;

    create foreign table if not exists nios_foreign.refund_detail (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.refund_detail; */

    create table if not exists nios.refund_detail as select * from nios_foreign.refund_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table refund_fomic', 314 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.refund_fomic;

    create foreign table if not exists nios_foreign.refund_fomic (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "transdate" timestamp,
        "invalidate_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REFUND_FOMIC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.refund_fomic; */

    create table if not exists nios.refund_fomic as select * from nios_foreign.refund_fomic;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table refund_fomic_final', 315 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.refund_fomic_final;

    create foreign table if not exists nios_foreign.refund_fomic_final (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "transdate" timestamp,
        "invalidate_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REFUND_FOMIC_FINAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.refund_fomic_final; */

    create table if not exists nios.refund_fomic_final as select * from nios_foreign.refund_fomic_final;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rel_qrtn', 318 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rel_qrtn;

    create foreign table if not exists nios_foreign.rel_qrtn (
        "worker_code" varchar(10),
        "release_date" timestamp,
        "transdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REL_QRTN');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rel_qrtn; */

    create table if not exists nios.rel_qrtn as select * from nios_foreign.rel_qrtn;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table renewal_comments', 319 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.renewal_comments;

    create foreign table if not exists nios_foreign.renewal_comments (
        "bc_worker_code" varchar(13),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp,
        "renew_type" numeric,
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'RENEWAL_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.renewal_comments; */

    create table if not exists nios.renewal_comments as select * from nios_foreign.renewal_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table renewal_worker', 320 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.renewal_worker;

    create foreign table if not exists nios_foreign.renewal_worker (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.renewal_worker; */

    create table if not exists nios.renewal_worker as select * from nios_foreign.renewal_worker;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table replace_table', 321 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.replace_table;

    create foreign table if not exists nios_foreign.replace_table (
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'REPLACE_TABLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.replace_table; */

    create table if not exists nios.replace_table as select * from nios_foreign.replace_table;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table reply_table', 322 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.reply_table;

    create foreign table if not exists nios_foreign.reply_table (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1),
        "reply_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.reply_table; */

    create table if not exists nios.reply_table as select * from nios_foreign.reply_table;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table reply_table_arc', 323 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.reply_table_arc;

    create foreign table if not exists nios_foreign.reply_table_arc (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1),
        "reply_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE_ARC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.reply_table_arc; */

    create table if not exists nios.reply_table_arc as select * from nios_foreign.reply_table_arc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table reply_table_old', 324 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.reply_table_old;

    create foreign table if not exists nios_foreign.reply_table_old (
        "req_id" varchar(16),
        "error_code" varchar(5),
        "response_to_query" varchar(2000),
        "reply_read" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REPLY_TABLE_OLD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.reply_table_old; */

    create table if not exists nios.reply_table_old as select * from nios_foreign.reply_table_old;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table report_diff_bloodgroup', 325 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.report_diff_bloodgroup;

    create foreign table if not exists nios_foreign.report_diff_bloodgroup (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.report_diff_bloodgroup; */

    create table if not exists nios.report_diff_bloodgroup as select * from nios_foreign.report_diff_bloodgroup;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table report_group', 326 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.report_group;

    create foreign table if not exists nios_foreign.report_group (
        "groupid" numeric(10),
        "capid" numeric(10),
        "seq" numeric(10),
        "reportname" varchar(255),
        "contextname" varchar(50),
        "indexpage" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'REPORT_GROUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.report_group; */

    create table if not exists nios.report_group as select * from nios_foreign.report_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table report_receive', 328 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.report_receive;

    create foreign table if not exists nios_foreign.report_receive (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.report_receive; */

    create table if not exists nios.report_receive as select * from nios_foreign.report_receive;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table request_table', 330 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.request_table;

    create foreign table if not exists nios_foreign.request_table (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1),
        "request_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.request_table; */

    create table if not exists nios.request_table as select * from nios_foreign.request_table;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table request_table_arc', 331 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.request_table_arc;

    create foreign table if not exists nios_foreign.request_table_arc (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1),
        "request_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE_ARC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.request_table_arc; */

    create table if not exists nios.request_table_arc as select * from nios_foreign.request_table_arc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table request_table_old', 333 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.request_table_old;

    create foreign table if not exists nios_foreign.request_table_old (
        "req_id" varchar(16),
        "req_type" varchar(2),
        "participants_details" varchar(2000),
        "request_read" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'REQUEST_TABLE_OLD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.request_table_old; */

    create table if not exists nios.request_table_old as select * from nios_foreign.request_table_old;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rev_sync_table', 335 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rev_sync_table;

    create foreign table if not exists nios_foreign.rev_sync_table (
        "table_name" varchar(100),
        "sequence" numeric
    ) server nios_server options (schema 'NIOS1', table 'REV_SYNC_TABLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rev_sync_table; */

    create table if not exists nios.rev_sync_table as select * from nios_foreign.rev_sync_table;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_batch_transaction', 336 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_batch_transaction;

    create foreign table if not exists nios_foreign.rfw_batch_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_batch_transaction; */

    create table if not exists nios.rfw_batch_transaction as select * from nios_foreign.rfw_batch_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_case_transaction', 338 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_case_transaction;

    create foreign table if not exists nios_foreign.rfw_case_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_case_transaction; */

    create table if not exists nios.rfw_case_transaction as select * from nios_foreign.rfw_case_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_comment', 340 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_comment;

    create foreign table if not exists nios_foreign.rfw_comment (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "comments" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'RFW_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_comment; */

    create table if not exists nios.rfw_comment as select * from nios_foreign.rfw_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_detail', 342 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_detail;

    create foreign table if not exists nios_foreign.rfw_detail (
        "rfwtrans_id" varchar(14),
        "parameter_code" varchar(10),
        "parameter_value" varchar(20),
        "med_history" varchar(1),
        "effected_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_detail; */

    create table if not exists nios.rfw_detail as select * from nios_foreign.rfw_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_fw_transaction', 344 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_fw_transaction;

    create foreign table if not exists nios_foreign.rfw_fw_transaction (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_fw_transaction; */

    create table if not exists nios.rfw_fw_transaction as select * from nios_foreign.rfw_fw_transaction;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rfw_labchange_trans', 346 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rfw_labchange_trans;

    create foreign table if not exists nios_foreign.rfw_labchange_trans (
        "rfwtrans_id" varchar(14),
        "bc_laboratory_code" varchar(13),
        "bc_old_laboratory_code" varchar(13),
        "comments" varchar(4000),
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RFW_LABCHANGE_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rfw_labchange_trans; */

    create table if not exists nios.rfw_labchange_trans as select * from nios_foreign.rfw_labchange_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table role_capability', 347 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.role_capability;

    create foreign table if not exists nios_foreign.role_capability (
        "roleid" numeric(10),
        "capid" numeric(10),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'ROLE_CAPABILITY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.role_capability; */

    create table if not exists nios.role_capability as select * from nios_foreign.role_capability;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rp', 349 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rp;

    create foreign table if not exists nios_foreign.rp (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rp; */

    create table if not exists nios.rp as select * from nios_foreign.rp;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table sabah_doc_post', 351 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.sabah_doc_post;

    create foreign table if not exists nios_foreign.sabah_doc_post (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.sabah_doc_post; */

    create table if not exists nios.sabah_doc_post as select * from nios_foreign.sabah_doc_post;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table sabah_transid', 352 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.sabah_transid;

    create foreign table if not exists nios_foreign.sabah_transid (
        "trans_id" varchar(14),
        "new_trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'SABAH_TRANSID');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.sabah_transid; */

    create table if not exists nios.sabah_transid as select * from nios_foreign.sabah_transid;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_hp_dx', 353 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_hp_dx;

    create foreign table if not exists nios_foreign.scb_hp_dx (
        "doc_xray_code" varchar(10),
        "doc_xray_ind" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'SCB_HP_DX');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_hp_dx; */

    create table if not exists nios.scb_hp_dx as select * from nios_foreign.scb_hp_dx;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_pay_xray_nameandadd', 356 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_pay_xray_nameandadd;

    create foreign table if not exists nios_foreign.scb_pay_xray_nameandadd (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_PAY_XRAY_NAMEANDADD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_pay_xray_nameandadd; */

    create table if not exists nios.scb_pay_xray_nameandadd as select * from nios_foreign.scb_pay_xray_nameandadd;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_sabah_doc_post', 357 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_sabah_doc_post;

    create foreign table if not exists nios_foreign.scb_sabah_doc_post (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_sabah_doc_post; */

    create table if not exists nios.scb_sabah_doc_post as select * from nios_foreign.scb_sabah_doc_post;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_xray_not_done', 358 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_xray_not_done;

    create foreign table if not exists nios_foreign.scb_xray_not_done (
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_NOT_DONE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_xray_not_done; */

    create table if not exists nios.scb_xray_not_done as select * from nios_foreign.scb_xray_not_done;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_xray_payin_list', 359 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_xray_payin_list;

    create foreign table if not exists nios_foreign.scb_xray_payin_list (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_PAYIN_LIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_xray_payin_list; */

    create table if not exists nios.scb_xray_payin_list as select * from nios_foreign.scb_xray_payin_list;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table scb_xray_pay_new_address', 360 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.scb_xray_pay_new_address;

    create foreign table if not exists nios_foreign.scb_xray_pay_new_address (
        "xray_code" varchar(10),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'SCB_XRAY_PAY_NEW_ADDRESS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.scb_xray_pay_new_address; */

    create table if not exists nios.scb_xray_pay_new_address as select * from nios_foreign.scb_xray_pay_new_address;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table seminar', 361 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.seminar;

    create foreign table if not exists nios_foreign.seminar (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.seminar; */

    create table if not exists nios.seminar as select * from nios_foreign.seminar;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table seminar_detail', 362 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.seminar_detail;

    create foreign table if not exists nios_foreign.seminar_detail (
        "seminar_id" varchar(20),
        "sp_code" varchar(10),
        "phone_no" varchar(20),
        "payment_date" timestamp,
        "amount" numeric(20, 2),
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.seminar_detail; */

    create table if not exists nios.seminar_detail as select * from nios_foreign.seminar_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table send_mail_ind', 363 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.send_mail_ind;

    create foreign table if not exists nios_foreign.send_mail_ind (
        "trans_id" varchar(14),
        "send_date" timestamp,
        "status" varchar(20),
        "email_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'SEND_MAIL_IND');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.send_mail_ind; */

    create table if not exists nios.send_mail_ind as select * from nios_foreign.send_mail_ind;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table service_provide_pay_rate', 369 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.service_provide_pay_rate;

    create foreign table if not exists nios_foreign.service_provide_pay_rate (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.service_provide_pay_rate; */

    create table if not exists nios.service_provide_pay_rate as select * from nios_foreign.service_provide_pay_rate;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table service_providers_group', 366 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.service_providers_group;

    create foreign table if not exists nios_foreign.service_providers_group (
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
        "female_rate" numeric(20, 2),
        "male_rate" numeric(20, 2),
        "business_reg_no" varchar(80),
        "email_address" varchar(100),
        "gst_code" varchar(20),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp,
        "gst_tax" numeric(20, 2),
        "gst_type" numeric(10),
        "bank_code" varchar(8),
        "group_logo" varchar(50),
        "service_provider_master_code" varchar(10),
        "web_taxinvoice" numeric(1),
        "gst_effective_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDERS_GROUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.service_providers_group; */

    create table if not exists nios.service_providers_group as select * from nios_foreign.service_providers_group;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table service_providers_group_member', 367 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.service_providers_group_member;

    create foreign table if not exists nios_foreign.service_providers_group_member (
        "id" numeric(19),
        "version" numeric(19),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "service_member" varchar(40),
        "service_providers_group_id" numeric(19)
    ) server nios_server options (schema 'NIOS1', table 'SERVICE_PROVIDERS_GROUP_MEMBER');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.service_providers_group_member; */

    create table if not exists nios.service_providers_group_member as select * from nios_foreign.service_providers_group_member;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table shadow_xray_radio_assignment', 370 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.shadow_xray_radio_assignment;

    create foreign table if not exists nios_foreign.shadow_xray_radio_assignment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.shadow_xray_radio_assignment; */

    create table if not exists nios.shadow_xray_radio_assignment as select * from nios_foreign.shadow_xray_radio_assignment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table special_renewal_request', 371 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.special_renewal_request;

    create foreign table if not exists nios_foreign.special_renewal_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.special_renewal_request; */

    create table if not exists nios.special_renewal_request as select * from nios_foreign.special_renewal_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table sppayment_reference', 372 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.sppayment_reference;

    create foreign table if not exists nios_foreign.sppayment_reference (
        "id" numeric(19),
        "version" numeric(19),
        "amount" numeric(20, 2),
        "batchid" numeric(10),
        "certify_date" timestamp,
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "payment_req_id" numeric(10),
        "transid" varchar(56),
        "branch_code" varchar(2),
        "service_provider_code" varchar(40)
    ) server nios_server options (schema 'NIOS1', table 'SPPAYMENT_REFERENCE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.sppayment_reference; */

    create table if not exists nios.sppayment_reference as select * from nios_foreign.sppayment_reference;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table status_change_history', 376 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.status_change_history;

    create foreign table if not exists nios_foreign.status_change_history (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.status_change_history; */

    create table if not exists nios.status_change_history as select * from nios_foreign.status_change_history;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table status_change_pending', 377 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.status_change_pending;

    create foreign table if not exists nios_foreign.status_change_pending (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.status_change_pending; */

    create table if not exists nios.status_change_pending as select * from nios_foreign.status_change_pending;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table suspension_comments', 378 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.suspension_comments;

    create foreign table if not exists nios_foreign.suspension_comments (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.suspension_comments; */

    create table if not exists nios.suspension_comments as select * from nios_foreign.suspension_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table sync_table', 380 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.sync_table;

    create foreign table if not exists nios_foreign.sync_table (
        "table_name" varchar(100),
        "sequence" numeric
    ) server nios_server options (schema 'NIOS1', table 'SYNC_TABLE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.sync_table; */

    create table if not exists nios.sync_table as select * from nios_foreign.sync_table;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_agent_district', 385 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_agent_district;

    create foreign table if not exists nios_foreign.t_cnv_agent_district (
        "agent_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_AGENT_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_agent_district; */

    create table if not exists nios.t_cnv_agent_district as select * from nios_foreign.t_cnv_agent_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_doctor_district', 387 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_doctor_district;

    create foreign table if not exists nios_foreign.t_cnv_doctor_district (
        "doctor_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_DOCTOR_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_doctor_district; */

    create table if not exists nios.t_cnv_doctor_district as select * from nios_foreign.t_cnv_doctor_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_doctorh_district', 386 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_doctorh_district;

    create foreign table if not exists nios_foreign.t_cnv_doctorh_district (
        "doctor_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_DOCTORH_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_doctorh_district; */

    create table if not exists nios.t_cnv_doctorh_district as select * from nios_foreign.t_cnv_doctorh_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_employer_district', 389 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_employer_district;

    create foreign table if not exists nios_foreign.t_cnv_employer_district (
        "employer_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_EMPLOYER_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_employer_district; */

    create table if not exists nios.t_cnv_employer_district as select * from nios_foreign.t_cnv_employer_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_employerh_district', 388 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_employerh_district;

    create foreign table if not exists nios_foreign.t_cnv_employerh_district (
        "employer_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_EMPLOYERH_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_employerh_district; */

    create table if not exists nios.t_cnv_employerh_district as select * from nios_foreign.t_cnv_employerh_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_laboratory_district', 391 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_laboratory_district;

    create foreign table if not exists nios_foreign.t_cnv_laboratory_district (
        "laboratory_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_LABORATORY_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_laboratory_district; */

    create table if not exists nios.t_cnv_laboratory_district as select * from nios_foreign.t_cnv_laboratory_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_laboratoryh_district', 390 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_laboratoryh_district;

    create foreign table if not exists nios_foreign.t_cnv_laboratoryh_district (
        "laboratory_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_LABORATORYH_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_laboratoryh_district; */

    create table if not exists nios.t_cnv_laboratoryh_district as select * from nios_foreign.t_cnv_laboratoryh_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_worker_doctor', 394 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_worker_doctor;

    create foreign table if not exists nios_foreign.t_cnv_worker_doctor (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "certify_date" timestamp,
        "allocation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_WORKER_DOCTOR');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_worker_doctor; */

    create table if not exists nios.t_cnv_worker_doctor as select * from nios_foreign.t_cnv_worker_doctor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_worker_doctor_a', 395 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_worker_doctor_a;

    create foreign table if not exists nios_foreign.t_cnv_worker_doctor_a (
        "worker_code" varchar(10),
        "doctor_code" varchar(10),
        "certify_date" timestamp,
        "allocation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_WORKER_DOCTOR_A');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_worker_doctor_a; */

    create table if not exists nios.t_cnv_worker_doctor_a as select * from nios_foreign.t_cnv_worker_doctor_a;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_xray_district', 397 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_xray_district;

    create foreign table if not exists nios_foreign.t_cnv_xray_district (
        "xray_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_XRAY_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_xray_district; */

    create table if not exists nios.t_cnv_xray_district as select * from nios_foreign.t_cnv_xray_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_xrayh_district', 396 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_xrayh_district;

    create foreign table if not exists nios_foreign.t_cnv_xrayh_district (
        "xray_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_XRAYH_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_xrayh_district; */

    create table if not exists nios.t_cnv_xrayh_district as select * from nios_foreign.t_cnv_xrayh_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_doctor', 398 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_doctor;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_doctor (
        "nongroup_doctor" varchar(1000),
        "state_ref" varchar(3),
        "doctor_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_doctor; */

    create table if not exists nios.t_conv_fin_nongroup_doctor as select * from nios_foreign.t_conv_fin_nongroup_doctor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_doctor_dtl', 399 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_doctor_dtl;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_doctor_dtl (
        "nongroup_result" varchar(124),
        "state_ref" varchar(3),
        "doctor_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR_DTL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_doctor_dtl; */

    create table if not exists nios.t_conv_fin_nongroup_doctor_dtl as select * from nios_foreign.t_conv_fin_nongroup_doctor_dtl;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_doctor_ttl', 400 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_doctor_ttl;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_doctor_ttl (
        "state_ref" varchar(3),
        "cnt" numeric,
        "total" numeric
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_DOCTOR_TTL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_doctor_ttl; */

    create table if not exists nios.t_conv_fin_nongroup_doctor_ttl as select * from nios_foreign.t_conv_fin_nongroup_doctor_ttl;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_xray', 401 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_xray;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_xray (
        "nongroup_xray" varchar(1000),
        "state_ref" varchar(3),
        "xray_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_xray; */

    create table if not exists nios.t_conv_fin_nongroup_xray as select * from nios_foreign.t_conv_fin_nongroup_xray;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_xray_dtl', 402 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_xray_dtl;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_xray_dtl (
        "nongroup_result" varchar(124),
        "state_ref" varchar(3),
        "xray_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY_DTL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_xray_dtl; */

    create table if not exists nios.t_conv_fin_nongroup_xray_dtl as select * from nios_foreign.t_conv_fin_nongroup_xray_dtl;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_conv_fin_nongroup_xray_ttl', 403 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_conv_fin_nongroup_xray_ttl;

    create foreign table if not exists nios_foreign.t_conv_fin_nongroup_xray_ttl (
        "state_ref" varchar(3),
        "cnt" numeric,
        "total" numeric
    ) server nios_server options (schema 'NIOS1', table 'T_CONV_FIN_NONGROUP_XRAY_TTL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_conv_fin_nongroup_xray_ttl; */

    create table if not exists nios.t_conv_fin_nongroup_xray_ttl as select * from nios_foreign.t_conv_fin_nongroup_xray_ttl;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table tcupi_todolist', 381 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.tcupi_todolist;

    create foreign table if not exists nios_foreign.tcupi_todolist (
        "tcupi_todolist_id" numeric,
        "tcupi_todolist_desc" varchar(1000)
    ) server nios_server options (schema 'NIOS1', table 'TCUPI_TODOLIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.tcupi_todolist; */

    create table if not exists nios.tcupi_todolist as select * from nios_foreign.tcupi_todolist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table temp_pending_review_resend', 382 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.temp_pending_review_resend;

    create foreign table if not exists nios_foreign.temp_pending_review_resend (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'TEMP_PENDING_REVIEW_RESEND');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.temp_pending_review_resend; */

    create table if not exists nios.temp_pending_review_resend as select * from nios_foreign.temp_pending_review_resend;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table temp_quarantine_fw_doc', 383 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.temp_quarantine_fw_doc;

    create foreign table if not exists nios_foreign.temp_quarantine_fw_doc (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.temp_quarantine_fw_doc; */

    create table if not exists nios.temp_quarantine_fw_doc as select * from nios_foreign.temp_quarantine_fw_doc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_obj_migrated', 404 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_obj_migrated;

    create foreign table if not exists nios_foreign.t_obj_migrated (
        "object_name" varchar(30),
        "date_migrated" timestamp
    ) server nios_server options (schema 'NIOS1', table 'T_OBJ_MIGRATED');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_obj_migrated; */

    create table if not exists nios.t_obj_migrated as select * from nios_foreign.t_obj_migrated;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_wpc', 405 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_wpc;

    create foreign table if not exists nios_foreign.t_wpc (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_wpc; */

    create table if not exists nios.t_wpc as select * from nios_foreign.t_wpc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table um_user_capability', 407 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.um_user_capability;

    create foreign table if not exists nios_foreign.um_user_capability (
        "uuid" numeric(10),
        "mod_id" numeric(38),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'UM_USER_CAPABILITY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.um_user_capability; */

    create table if not exists nios.um_user_capability as select * from nios_foreign.um_user_capability;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table undefine_doctor', 409 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.undefine_doctor;

    create foreign table if not exists nios_foreign.undefine_doctor (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.undefine_doctor; */

    create table if not exists nios.undefine_doctor as select * from nios_foreign.undefine_doctor;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table unsuitable_reasons', 410 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.unsuitable_reasons;

    create foreign table if not exists nios_foreign.unsuitable_reasons (
        "unsuitable_id" numeric(10),
        "reason_eng" varchar(100),
        "reason_bm" varchar(100),
        "priority" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'UNSUITABLE_REASONS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.unsuitable_reasons; */

    create table if not exists nios.unsuitable_reasons as select * from nios_foreign.unsuitable_reasons;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table unsuitable_reasons_map', 411 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.unsuitable_reasons_map;

    create foreign table if not exists nios_foreign.unsuitable_reasons_map (
        "parameter_code" varchar(10),
        "unsuitable_id" numeric(10)
    ) server nios_server options (schema 'NIOS1', table 'UNSUITABLE_REASONS_MAP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.unsuitable_reasons_map; */

    create table if not exists nios.unsuitable_reasons_map as select * from nios_foreign.unsuitable_reasons_map;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_branches', 421 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.user_branches;

    create foreign table if not exists nios_foreign.user_branches (
        "uuid" numeric(10),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'USER_BRANCHES');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.user_branches; */

    create table if not exists nios.user_branches as select * from nios_foreign.user_branches;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_capability', 422 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.user_capability;

    create foreign table if not exists nios_foreign.user_capability (
        "uuid" numeric(10),
        "capid" numeric(18),
        "status" varchar(5),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modify_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USER_CAPABILITY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.user_capability; */

    create table if not exists nios.user_capability as select * from nios_foreign.user_capability;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table usercap_detail', 412 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.usercap_detail;

    create foreign table if not exists nios_foreign.usercap_detail (
        "cap_id" varchar(10),
        "module_id" varchar(30),
        "allow_action" varchar(15)
    ) server nios_server options (schema 'NIOS1', table 'USERCAP_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.usercap_detail; */

    create table if not exists nios.usercap_detail as select * from nios_foreign.usercap_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_comments', 423 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.user_comments;

    create foreign table if not exists nios_foreign.user_comments (
        "msgno" varchar(10),
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "subject" varchar(100),
        "message" varchar(4000),
        "email" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USER_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.user_comments; */

    create table if not exists nios.user_comments as select * from nios_foreign.user_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table useroldpass', 418 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.useroldpass;

    create foreign table if not exists nios_foreign.useroldpass (
        "usercode" varchar(13),
        "userpass" varchar(50),
        "changedate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USEROLDPASS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.useroldpass; */

    create table if not exists nios.useroldpass as select * from nios_foreign.useroldpass;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table userpassword_trans', 419 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.userpassword_trans;

    create foreign table if not exists nios_foreign.userpassword_trans (
        "uuid" varchar(20),
        "password" varchar(100),
        "date_change" timestamp
    ) server nios_server options (schema 'NIOS1', table 'USERPASSWORD_TRANS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.userpassword_trans; */

    create table if not exists nios.userpassword_trans as select * from nios_foreign.userpassword_trans;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table users', 420 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.users;

    create foreign table if not exists nios_foreign.users (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.users; */

    create table if not exists nios.users as select * from nios_foreign.users;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_session', 425 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.user_session;

    create foreign table if not exists nios_foreign.user_session (
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "request_uri" varchar(4000),
        "timeout" numeric(10),
        "module" varchar(5),
        "userid" varchar(20),
        "branch_code" varchar(2)
    ) server nios_server options (schema 'NIOS1', table 'USER_SESSION');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.user_session; */

    create table if not exists nios.user_session as select * from nios_foreign.user_session;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table v_appeal_status', 505 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.v_appeal_status;

    create foreign table if not exists nios_foreign.v_appeal_status (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.v_appeal_status; */

    create table if not exists nios.v_appeal_status as select * from nios_foreign.v_appeal_status;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_plan_detail', 427 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_plan_detail;

    create foreign table if not exists nios_foreign.visit_plan_detail (
        "plan_id" numeric,
        "provider_id" varchar(10),
        "state_code" varchar(20),
        "district_code" varchar(20),
        "creator_id" varchar(20),
        "creation_date" timestamp,
        "modify_id" varchar(20),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'VISIT_PLAN_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_plan_detail; */

    create table if not exists nios.visit_plan_detail as select * from nios_foreign.visit_plan_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_docxray', 429 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_docxray;

    create foreign table if not exists nios_foreign.visit_rpt_docxray (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_docxray; */

    create table if not exists nios.visit_rpt_docxray as select * from nios_foreign.visit_rpt_docxray;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_followup', 430 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_followup;

    create foreign table if not exists nios_foreign.visit_rpt_followup (
        "followup_id" numeric,
        "visit_report_id" numeric,
        "service_provider_code" varchar(10),
        "type" varchar(10),
        "modify_date" timestamp,
        "modify_id" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_FOLLOWUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_followup; */

    create table if not exists nios.visit_rpt_followup as select * from nios_foreign.visit_rpt_followup;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_followup_comments', 431 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_followup_comments;

    create foreign table if not exists nios_foreign.visit_rpt_followup_comments (
        "followup_id" numeric,
        "createdate" timestamp,
        "addedby" numeric,
        "comments" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_FOLLOWUP_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_followup_comments; */

    create table if not exists nios.visit_rpt_followup_comments as select * from nios_foreign.visit_rpt_followup_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_labdetail', 432 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_labdetail;

    create foreign table if not exists nios_foreign.visit_rpt_labdetail (
        "rpt_seq" varchar(20),
        "datavalue" varchar(4000),
        "report_id" numeric
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_LABDETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_labdetail; */

    create table if not exists nios.visit_rpt_labdetail as select * from nios_foreign.visit_rpt_labdetail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_sop_compliance', 434 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_sop_compliance;

    create foreign table if not exists nios_foreign.visit_rpt_sop_compliance (
        "report_id" numeric,
        "sopcomp_ind" varchar(2),
        "sopcomp_comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'VISIT_RPT_SOP_COMPLIANCE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_sop_compliance; */

    create table if not exists nios.visit_rpt_sop_compliance as select * from nios_foreign.visit_rpt_sop_compliance;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table visit_rpt_xqcc', 435 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.visit_rpt_xqcc;

    create foreign table if not exists nios_foreign.visit_rpt_xqcc (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.visit_rpt_xqcc; */

    create table if not exists nios.visit_rpt_xqcc as select * from nios_foreign.visit_rpt_xqcc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table v_worker_clinic', 508 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.v_worker_clinic;

    create foreign table if not exists nios_foreign.v_worker_clinic (
        "worker_code" varchar(10),
        "country_code" varchar(3),
        "clinic_code" varchar(10),
        "exam_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'V_WORKER_CLINIC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.v_worker_clinic; */

    create table if not exists nios.v_worker_clinic as select * from nios_foreign.v_worker_clinic;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_cancel', 436 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_cancel;

    create foreign table if not exists nios_foreign.worker_cancel (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_cancel; */

    create table if not exists nios.worker_cancel as select * from nios_foreign.worker_cancel;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_cancel_detail', 437 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_cancel_detail;

    create foreign table if not exists nios_foreign.worker_cancel_detail (
        "fwcancelid" varchar(15),
        "refundid" varchar(15),
        "refund_detailid" varchar(15),
        "trans_id" varchar(14),
        "cancelled_by" numeric(10),
        "cancelled_date" timestamp,
        "status" varchar(5)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CANCEL_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_cancel_detail; */

    create table if not exists nios.worker_cancel_detail as select * from nios_foreign.worker_cancel_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_certify_fitind', 439 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_certify_fitind;

    create foreign table if not exists nios_foreign.worker_certify_fitind (
        "logid" numeric,
        "logdate" timestamp,
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "dfit_ind" numeric(1),
        "fit_ind" char(1)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_CERTIFY_FITIND');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_certify_fitind; */

    create table if not exists nios.worker_certify_fitind as select * from nios_foreign.worker_certify_fitind;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_country_dist', 440 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_country_dist;

    create foreign table if not exists nios_foreign.worker_country_dist (
        "country_code" varchar(3),
        "fwcount" numeric
    ) server nios_server options (schema 'NIOS1', table 'WORKER_COUNTRY_DIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_country_dist; */

    create table if not exists nios.worker_country_dist as select * from nios_foreign.worker_country_dist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_doctor_change', 441 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_doctor_change;

    create foreign table if not exists nios_foreign.worker_doctor_change (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_doctor_change; */

    create table if not exists nios.worker_doctor_change as select * from nios_foreign.worker_doctor_change;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_doctor_change_hist', 442 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_doctor_change_hist;

    create foreign table if not exists nios_foreign.worker_doctor_change_hist (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_doctor_change_hist; */

    create table if not exists nios.worker_doctor_change_hist as select * from nios_foreign.worker_doctor_change_hist;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_fitind_change', 443 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_fitind_change;

    create foreign table if not exists nios_foreign.worker_fitind_change (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "change_type" varchar(2),
        "modification_id" varchar(30),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'WORKER_FITIND_CHANGE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_fitind_change; */

    create table if not exists nios.worker_fitind_change as select * from nios_foreign.worker_fitind_change;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_upd', 444 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.worker_upd;

    create foreign table if not exists nios_foreign.worker_upd (
        "old_passport_no" varchar(20),
        "old_worker_name" varchar(50),
        "old_country_name" varchar(25),
        "worker_code" varchar(10),
        "mod_date" timestamp,
        "status" varchar(1)
    ) server nios_server options (schema 'NIOS1', table 'WORKER_UPD');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.worker_upd; */

    create table if not exists nios.worker_upd as select * from nios_foreign.worker_upd;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table wrong_transmission', 445 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.wrong_transmission;

    create foreign table if not exists nios_foreign.wrong_transmission (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.wrong_transmission; */

    create table if not exists nios.wrong_transmission as select * from nios_foreign.wrong_transmission;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table ws_access_token', 447 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.ws_access_token;

    create foreign table if not exists nios_foreign.ws_access_token (
        "last_access" timestamp,
        "token" varchar(50),
        "created_date" timestamp,
        "usercode" varchar(10),
        "provider_id" varchar(3)
    ) server nios_server options (schema 'NIOS1', table 'WS_ACCESS_TOKEN');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.ws_access_token; */

    create table if not exists nios.ws_access_token as select * from nios_foreign.ws_access_token;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_calllog', 448 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_calllog;

    create foreign table if not exists nios_foreign.xqcc_calllog (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_calllog; */

    create table if not exists nios.xqcc_calllog as select * from nios_foreign.xqcc_calllog;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_certificate', 449 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_certificate;

    create foreign table if not exists nios_foreign.xqcc_certificate (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_certificate; */

    create table if not exists nios.xqcc_certificate as select * from nios_foreign.xqcc_certificate;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_comment', 451 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_comment;

    create foreign table if not exists nios_foreign.xqcc_comment (
        "worker_code" varchar(10),
        "certify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_COMMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_comment; */

    create table if not exists nios.xqcc_comment as select * from nios_foreign.xqcc_comment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_comments', 452 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_comments;

    create foreign table if not exists nios_foreign.xqcc_comments (
        "xqccid" numeric(10),
        "comments" varchar(4000),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_comments; */

    create table if not exists nios.xqcc_comments as select * from nios_foreign.xqcc_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_followup', 453 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_followup;

    create foreign table if not exists nios_foreign.xqcc_followup (
        "case_id" varchar(20),
        "action_taken" varchar(4000),
        "action_takendate" timestamp,
        "creation_date" timestamp,
        "creator_id" varchar(20),
        "modify_date" timestamp,
        "modify_id" varchar(20),
        "id" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_FOLLOWUP');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_followup; */

    create table if not exists nios.xqcc_followup as select * from nios_foreign.xqcc_followup;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_fw_extra_comments', 454 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_fw_extra_comments;

    create foreign table if not exists nios_foreign.xqcc_fw_extra_comments (
        "trans_id" varchar(14),
        "comment_date" timestamp,
        "comment_time" varchar(8),
        "userid" varchar(30),
        "source" varchar(1),
        "type" varchar(1),
        "comments" varchar(4000)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_FW_EXTRA_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_fw_extra_comments; */

    create table if not exists nios.xqcc_fw_extra_comments as select * from nios_foreign.xqcc_fw_extra_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_mle_retake', 455 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_mle_retake;

    create foreign table if not exists nios_foreign.xqcc_mle_retake (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_mle_retake; */

    create table if not exists nios.xqcc_mle_retake as select * from nios_foreign.xqcc_mle_retake;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_performance', 456 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_performance;

    create foreign table if not exists nios_foreign.xqcc_performance (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_performance; */

    create table if not exists nios.xqcc_performance as select * from nios_foreign.xqcc_performance;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_quarantine_fw_doc', 457 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_quarantine_fw_doc;

    create foreign table if not exists nios_foreign.xqcc_quarantine_fw_doc (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_quarantine_fw_doc; */

    create table if not exists nios.xqcc_quarantine_fw_doc as select * from nios_foreign.xqcc_quarantine_fw_doc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_quarantine_fw_reason', 458 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_quarantine_fw_reason;

    create foreign table if not exists nios_foreign.xqcc_quarantine_fw_reason (
        "trans_id" varchar(14),
        "bc_worker_code" varchar(13),
        "reason_code" varchar(10),
        "creation_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_QUARANTINE_FW_REASON');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_quarantine_fw_reason; */

    create table if not exists nios.xqcc_quarantine_fw_reason as select * from nios_foreign.xqcc_quarantine_fw_reason;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_report', 459 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_report;

    create foreign table if not exists nios_foreign.xqcc_report (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_report; */

    create table if not exists nios.xqcc_report as select * from nios_foreign.xqcc_report;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_sign', 460 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_sign;

    create foreign table if not exists nios_foreign.xqcc_sign (
        "name" varchar(35),
        "desig" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_SIGN');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_sign; */

    create table if not exists nios.xqcc_sign as select * from nios_foreign.xqcc_sign;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_stat_change_approval', 461 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_stat_change_approval;

    create foreign table if not exists nios_foreign.xqcc_stat_change_approval (
        "xqccreqid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_STAT_CHANGE_APPROVAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_stat_change_approval; */

    create table if not exists nios.xqcc_stat_change_approval as select * from nios_foreign.xqcc_stat_change_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_stat_change_reasons', 462 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_stat_change_reasons;

    create foreign table if not exists nios_foreign.xqcc_stat_change_reasons (
        "reasoncode" varchar(5),
        "reason" varchar(255),
        "status" varchar(1),
        "creator_id" numeric(10),
        "creation_date" timestamp,
        "modification_id" numeric(10),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQCC_STAT_CHANGE_REASONS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_stat_change_reasons; */

    create table if not exists nios.xqcc_stat_change_reasons as select * from nios_foreign.xqcc_stat_change_reasons;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_stat_change_request', 463 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_stat_change_request;

    create foreign table if not exists nios_foreign.xqcc_stat_change_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_stat_change_request; */

    create table if not exists nios.xqcc_stat_change_request as select * from nios_foreign.xqcc_stat_change_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_transid', 464 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_transid;

    create foreign table if not exists nios_foreign.xqcc_transid (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_TRANSID');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_transid; */

    create table if not exists nios.xqcc_transid as select * from nios_foreign.xqcc_transid;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_unfit', 465 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_unfit;

    create foreign table if not exists nios_foreign.xqcc_unfit (
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_UNFIT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_unfit; */

    create table if not exists nios.xqcc_unfit as select * from nios_foreign.xqcc_unfit;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xqcc_warehouse', 466 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xqcc_warehouse;

    create foreign table if not exists nios_foreign.xqcc_warehouse (
        "warehouse_id" numeric,
        "name" varchar(100),
        "address" varchar(255),
        "status" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XQCC_WAREHOUSE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xqcc_warehouse; */

    create table if not exists nios.xqcc_warehouse as select * from nios_foreign.xqcc_warehouse;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xquarantine_release_approval', 467 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xquarantine_release_approval;

    create foreign table if not exists nios_foreign.xquarantine_release_approval (
        "xqrreqid" numeric(10),
        "xqrrid" numeric(10),
        "status" varchar(1),
        "comments" varchar(4000),
        "approval_id" numeric(10),
        "approval_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XQUARANTINE_RELEASE_APPROVAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xquarantine_release_approval; */

    create table if not exists nios.xquarantine_release_approval as select * from nios_foreign.xquarantine_release_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xquarantine_release_request', 468 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xquarantine_release_request;

    create foreign table if not exists nios_foreign.xquarantine_release_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xquarantine_release_request; */

    create table if not exists nios.xquarantine_release_request as select * from nios_foreign.xquarantine_release_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_adhoc_submit_abnormal', 470 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_adhoc_submit_abnormal;

    create foreign table if not exists nios_foreign.xray_adhoc_submit_abnormal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_adhoc_submit_abnormal; */

    create table if not exists nios.xray_adhoc_submit_abnormal as select * from nios_foreign.xray_adhoc_submit_abnormal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_adhoc_submit_delay', 471 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_adhoc_submit_delay;

    create foreign table if not exists nios_foreign.xray_adhoc_submit_delay (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_adhoc_submit_delay; */

    create table if not exists nios.xray_adhoc_submit_delay as select * from nios_foreign.xray_adhoc_submit_delay;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_adhoc_submit_normal', 473 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_adhoc_submit_normal;

    create foreign table if not exists nios_foreign.xray_adhoc_submit_normal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_adhoc_submit_normal; */

    create table if not exists nios.xray_adhoc_submit_normal as select * from nios_foreign.xray_adhoc_submit_normal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_change_request', 474 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_change_request;

    create foreign table if not exists nios_foreign.xray_change_request (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_change_request; */

    create table if not exists nios.xray_change_request as select * from nios_foreign.xray_change_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_change_request_detail', 475 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_change_request_detail;

    create foreign table if not exists nios_foreign.xray_change_request_detail (
        "xray_cr_id" numeric(10),
        "cr_column" varchar(100),
        "cr_old" varchar(100),
        "cr_new" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_CHANGE_REQUEST_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_change_request_detail; */

    create table if not exists nios.xray_change_request_detail as select * from nios_foreign.xray_change_request_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_compare', 476 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_compare;

    create foreign table if not exists nios_foreign.xray_compare (
        "xray_code" varchar(10),
        "old_xray_name" varchar(50),
        "old_xray_regn_no" varchar(20),
        "new_xray_name" varchar(50),
        "new_xray_regn_no" varchar(20)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_COMPARE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_compare; */

    create table if not exists nios.xray_compare as select * from nios_foreign.xray_compare;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_coupling', 477 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_coupling;

    create foreign table if not exists nios_foreign.xray_coupling (
        "bc_xray_code" varchar(13),
        "bc_radiologist_code" varchar(13),
        "modify_id" numeric,
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_COUPLING');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_coupling; */

    create table if not exists nios.xray_coupling as select * from nios_foreign.xray_coupling;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_dispatch_list', 478 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_dispatch_list;

    create foreign table if not exists nios_foreign.xray_dispatch_list (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_dispatch_list; */

    create table if not exists nios.xray_dispatch_list as select * from nios_foreign.xray_dispatch_list;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_dispatch_list_details', 479 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_dispatch_list_details;

    create foreign table if not exists nios_foreign.xray_dispatch_list_details (
        "dispatch_listid" numeric,
        "trans_id" varchar(14),
        "status" varchar(10),
        "status_date" timestamp,
        "film_sequence" numeric,
        "xray_testdone_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_DISPATCH_LIST_DETAILS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_dispatch_list_details; */

    create table if not exists nios.xray_dispatch_list_details as select * from nios_foreign.xray_dispatch_list_details;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_film_audit', 480 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_film_audit;

    create foreign table if not exists nios_foreign.xray_film_audit (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_film_audit; */

    create table if not exists nios.xray_film_audit as select * from nios_foreign.xray_film_audit;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_film_movement', 481 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_film_movement;

    create foreign table if not exists nios_foreign.xray_film_movement (
        "movement_id" numeric,
        "trans_id" varchar(14),
        "dispatchlist_id" numeric,
        "status" varchar(10),
        "status_date" timestamp,
        "comments" varchar(1000),
        "user_id" varchar(30)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_MOVEMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_film_movement; */

    create table if not exists nios.xray_film_movement as select * from nios_foreign.xray_film_movement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_film_reminder', 482 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_film_reminder;

    create foreign table if not exists nios_foreign.xray_film_reminder (
        "film_reminderid" numeric,
        "trans_id" varchar(14),
        "reminder_date" timestamp,
        "dispatch_listid" numeric,
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_REMINDER');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_film_reminder; */

    create table if not exists nios.xray_film_reminder as select * from nios_foreign.xray_film_reminder;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_film_storage', 483 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_film_storage;

    create foreign table if not exists nios_foreign.xray_film_storage (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_film_storage; */

    create table if not exists nios.xray_film_storage as select * from nios_foreign.xray_film_storage;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_film_storage_detail', 484 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_film_storage_detail;

    create foreign table if not exists nios_foreign.xray_film_storage_detail (
        "film_storageid" numeric,
        "trans_id" varchar(14),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modified_id" varchar(50),
        "modify_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_FILM_STORAGE_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_film_storage_detail; */

    create table if not exists nios.xray_film_storage_detail as select * from nios_foreign.xray_film_storage_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_follow_up', 485 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_follow_up;

    create foreign table if not exists nios_foreign.xray_follow_up (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_follow_up; */

    create table if not exists nios.xray_follow_up as select * from nios_foreign.xray_follow_up;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_not_done', 488 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_not_done;

    create foreign table if not exists nios_foreign.xray_not_done (
        "trans_id" varchar(14),
        "xray_code" varchar(10),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "xray_submit_date" timestamp,
        "release_date" timestamp,
        "xray_ded" numeric(3)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_NOT_DONE');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_not_done; */

    create table if not exists nios.xray_not_done as select * from nios_foreign.xray_not_done;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_payin_list', 489 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_payin_list;

    create foreign table if not exists nios_foreign.xray_payin_list (
        "xray_code" varchar(10),
        "xray_payee_name" varchar(50),
        "address1" varchar(50),
        "address2" varchar(50),
        "address3" varchar(50),
        "post_code" varchar(10),
        "district_code" varchar(7),
        "state_code" varchar(7)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_PAYIN_LIST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_payin_list; */

    create table if not exists nios.xray_payin_list as select * from nios_foreign.xray_payin_list;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_radio_assignment', 490 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_radio_assignment;

    create foreign table if not exists nios_foreign.xray_radio_assignment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_radio_assignment; */

    create table if not exists nios.xray_radio_assignment as select * from nios_foreign.xray_radio_assignment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_registration', 491 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_registration;

    create foreign table if not exists nios_foreign.xray_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_registration; */

    create table if not exists nios.xray_registration as select * from nios_foreign.xray_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_request', 492 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_request;

    create foreign table if not exists nios_foreign.xray_request (
        "xregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REQUEST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_request; */

    create table if not exists nios.xray_request as select * from nios_foreign.xray_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_review_film', 493 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_review_film;

    create foreign table if not exists nios_foreign.xray_review_film (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_review_film; */

    create table if not exists nios.xray_review_film as select * from nios_foreign.xray_review_film;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_review_film_comments', 494 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_review_film_comments;

    create foreign table if not exists nios_foreign.xray_review_film_comments (
        "trans_id" varchar(14),
        "comments" varchar(1000),
        "creator_id" varchar(50),
        "create_date" timestamp,
        "modifier_id" varchar(50),
        "modify_date" timestamp,
        "commentsid" numeric
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_COMMENTS');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_review_film_comments; */

    create table if not exists nios.xray_review_film_comments as select * from nios_foreign.xray_review_film_comments;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_review_film_detail', 495 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_review_film_detail;

    create foreign table if not exists nios_foreign.xray_review_film_detail (
        "review_filmid" numeric,
        "parameter_code" varchar(20),
        "parameter_value" varchar(20),
        "trans_id" varchar(14)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_DETAIL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_review_film_detail; */

    create table if not exists nios.xray_review_film_detail as select * from nios_foreign.xray_review_film_detail;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_review_film_identical', 496 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_review_film_identical;

    create foreign table if not exists nios_foreign.xray_review_film_identical (
        "review_filmid" numeric,
        "trans_id" varchar(14),
        "worker_code" varchar(10)
    ) server nios_server options (schema 'NIOS1', table 'XRAY_REVIEW_FILM_IDENTICAL');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_review_film_identical; */

    create table if not exists nios.xray_review_film_identical as select * from nios_foreign.xray_review_film_identical;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_submit_daily', 497 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_submit_daily;

    create foreign table if not exists nios_foreign.xray_submit_daily (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_submit_daily; */

    create table if not exists nios.xray_submit_daily as select * from nios_foreign.xray_submit_daily;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_submit_daily_abnormal', 498 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_submit_daily_abnormal;

    create foreign table if not exists nios_foreign.xray_submit_daily_abnormal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_submit_daily_abnormal; */

    create table if not exists nios.xray_submit_daily_abnormal as select * from nios_foreign.xray_submit_daily_abnormal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_submit_daily_normal', 499 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_submit_daily_normal;

    create foreign table if not exists nios_foreign.xray_submit_daily_normal (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_submit_daily_normal; */

    create table if not exists nios.xray_submit_daily_normal as select * from nios_foreign.xray_submit_daily_normal;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_submit_delay', 500 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_submit_delay;

    create foreign table if not exists nios_foreign.xray_submit_delay (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_submit_delay; */

    create table if not exists nios.xray_submit_delay as select * from nios_foreign.xray_submit_delay;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table xray_worker_count', 502 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.xray_worker_count;

    create foreign table if not exists nios_foreign.xray_worker_count (
        "bc_xray_code" varchar(10),
        "last_year" numeric,
        "this_year" numeric,
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'XRAY_WORKER_COUNT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.xray_worker_count; */

    create table if not exists nios.xray_worker_count as select * from nios_foreign.xray_worker_count;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;


update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
