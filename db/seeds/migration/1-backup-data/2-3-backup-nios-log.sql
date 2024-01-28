
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into public.copy_logs (description, start_at) values ('start backup nios log process', clock_timestamp()) returning id into v_copy_log_id_process;
    raise notice 'now: %', clock_timestamp();

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table app_log', 21 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.app_log;

    create foreign table if not exists nios_foreign.app_log (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.app_log; */

    create table if not exists nios.app_log as select * from nios_foreign.app_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table batchlog', 36 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.batchlog;

    create foreign table if not exists nios_foreign.batchlog (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(100),
        "reason" varchar(4000),
        "module" varchar(100)
    ) server nios_server options (schema 'NIOS1', table 'BATCHLOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.batchlog; */

    create table if not exists nios.batchlog as select * from nios_foreign.batchlog;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table doctor_opthour_changelog', 69 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.doctor_opthour_changelog;

    create foreign table if not exists nios_foreign.doctor_opthour_changelog (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.doctor_opthour_changelog; */

    create table if not exists nios.doctor_opthour_changelog as select * from nios_foreign.doctor_opthour_changelog;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_audit_log', 137 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_audit_log;

    create foreign table if not exists nios_foreign.fwt_audit_log (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_audit_log; */

    create table if not exists nios.fwt_audit_log as select * from nios_foreign.fwt_audit_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fwt_audit_log_history', 138 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.fwt_audit_log_history;

    create foreign table if not exists nios_foreign.fwt_audit_log_history (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.fwt_audit_log_history; */

    create table if not exists nios.fwt_audit_log_history as select * from nios_foreign.fwt_audit_log_history;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table job_log', 199 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.job_log;

    create foreign table if not exists nios_foreign.job_log (
        "job_id" numeric,
        "start_time" timestamp,
        "end_time" timestamp
    ) server nios_server options (schema 'NIOS1', table 'JOB_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.job_log; */

    create table if not exists nios.job_log as select * from nios_foreign.job_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table log_master', 217 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.log_master;

    create foreign table if not exists nios_foreign.log_master (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.log_master; */

    create table if not exists nios.log_master as select * from nios_foreign.log_master;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table log_master_arc', 218 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.log_master_arc;

    create foreign table if not exists nios_foreign.log_master_arc (
        "uuid" numeric(10),
        "ip" varchar(20),
        "moduleid" numeric(10),
        "pageid" numeric(10),
        "action" varchar(4000),
        "action_type" varchar(5),
        "logdate" timestamp
    ) server nios_server options (schema 'NIOS1', table 'LOG_MASTER_ARC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.log_master_arc; */

    create table if not exists nios.log_master_arc as select * from nios_foreign.log_master_arc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table mystics_log', 237 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.mystics_log;

    create foreign table if not exists nios_foreign.mystics_log (
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
    -- /foreign table

    -- copy table
    /* drop table if exists nios.mystics_log; */

    create table if not exists nios.mystics_log as select * from nios_foreign.mystics_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_reject_log', 250 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.payment_reject_log;

    create foreign table if not exists nios_foreign.payment_reject_log (
        "log_id" numeric(19),
        "payment_reject_id" numeric(19),
        "logdate" timestamp,
        "err#" numeric(6),
        "errm" varchar(250),
        "msg" varchar(250),
        "status" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'PAYMENT_REJECT_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.payment_reject_log; */

    create table if not exists nios.payment_reject_log as select * from nios_foreign.payment_reject_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table radiologist_history', 290 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.radiologist_history;

    create foreign table if not exists nios_foreign.radiologist_history (
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
        "gst_tax" numeric(20, 2),
        "male_rate" numeric(20, 2),
        "female_rate" numeric(20, 2),
        "bank_account_no" varchar(20),
        "bank_code" varchar(8),
        "gst_type" numeric(1)
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_HISTORY');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.radiologist_history; */

    create table if not exists nios.radiologist_history as select * from nios_foreign.radiologist_history;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table radiologist_request', 293 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.radiologist_request;

    create foreign table if not exists nios_foreign.radiologist_request (
        "rdregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server nios_server options (schema 'NIOS1', table 'RADIOLOGIST_REQUEST');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.radiologist_request; */

    create table if not exists nios.radiologist_request as select * from nios_foreign.radiologist_request;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table rev_sync_log', 334 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.rev_sync_log;

    create foreign table if not exists nios_foreign.rev_sync_log (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'REV_SYNC_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.rev_sync_log; */

    create table if not exists nios.rev_sync_log as select * from nios_foreign.rev_sync_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table sync_log', 379 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.sync_log;

    create foreign table if not exists nios_foreign.sync_log (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'SYNC_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.sync_log; */

    create table if not exists nios.sync_log as select * from nios_foreign.sync_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_radiologist_district', 393 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_radiologist_district;

    create foreign table if not exists nios_foreign.t_cnv_radiologist_district (
        "radiologist_code" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_RADIOLOGIST_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_radiologist_district; */

    create table if not exists nios.t_cnv_radiologist_district as select * from nios_foreign.t_cnv_radiologist_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table t_cnv_radiologisth_district', 392 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.t_cnv_radiologisth_district;

    create foreign table if not exists nios_foreign.t_cnv_radiologisth_district (
        "radiologist_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'T_CNV_RADIOLOGISTH_DISTRICT');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.t_cnv_radiologisth_district; */

    create table if not exists nios.t_cnv_radiologisth_district as select * from nios_foreign.t_cnv_radiologisth_district;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table transfer_log', 384 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.transfer_log;

    create foreign table if not exists nios_foreign.transfer_log (
        "table_name" varchar(100),
        "key_value" varchar(100),
        "errmsg" varchar(2000)
    ) server nios_server options (schema 'NIOS1', table 'TRANSFER_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.transfer_log; */

    create table if not exists nios.transfer_log as select * from nios_foreign.transfer_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table userlog', 414 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.userlog;

    create foreign table if not exists nios_foreign.userlog (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(150),
        "ipaddr" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.userlog; */

    create table if not exists nios.userlog as select * from nios_foreign.userlog;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table userlog_arc', 415 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.userlog_arc;

    create foreign table if not exists nios_foreign.userlog_arc (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(100),
        "ipaddr" varchar(50)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG_ARC');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.userlog_arc; */

    create table if not exists nios.userlog_arc as select * from nios_foreign.userlog_arc;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table userlog_browser', 416 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios_foreign.userlog_browser;

    create foreign table if not exists nios_foreign.userlog_browser (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "header" varchar(255)
    ) server nios_server options (schema 'NIOS1', table 'USERLOG_BROWSER');
    -- /foreign table

    -- copy table
    /* drop table if exists nios.userlog_browser; */

    create table if not exists nios.userlog_browser as select * from nios_foreign.userlog_browser;
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
