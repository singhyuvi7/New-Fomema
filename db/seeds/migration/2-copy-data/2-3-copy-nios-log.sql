
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start copy nios log process', clock_timestamp()) returning id into v_copy_log_id_process;
        
insert into public.migration_logs (description, start_at) values ('start copy table app_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.app_log;

    create foreign table if not exists nios.app_log (
        "log_id" numeric(10),
        "log_date" timestamp,
        "module" varchar(60),
        "action" varchar(300),
        "err#" numeric(6),
        "errm" varchar(250),
        "more1" varchar(1000),
        "more2" varchar(2000),
        "req_id" varchar(16)
    ) server fomema_backup options (schema_name 'nios', table_name 'app_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.app_log; */

    create table if not exists fomema_backup_nios.app_log as select * from nios.app_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table batchlog', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.batchlog;

    create foreign table if not exists nios.batchlog (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(100),
        "reason" varchar(4000),
        "module" varchar(100)
    ) server fomema_backup options (schema_name 'nios', table_name 'batchlog');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.batchlog; */

    create table if not exists fomema_backup_nios.batchlog as select * from nios.batchlog;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table doctor_opthour_changelog', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.doctor_opthour_changelog;

    create foreign table if not exists nios.doctor_opthour_changelog (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'doctor_opthour_changelog');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.doctor_opthour_changelog; */

    create table if not exists fomema_backup_nios.doctor_opthour_changelog as select * from nios.doctor_opthour_changelog;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table fwt_audit_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.fwt_audit_log;

    create foreign table if not exists nios.fwt_audit_log (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'fwt_audit_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.fwt_audit_log; */

    create table if not exists fomema_backup_nios.fwt_audit_log as select * from nios.fwt_audit_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table fwt_audit_log_history', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.fwt_audit_log_history;

    create foreign table if not exists nios.fwt_audit_log_history (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'fwt_audit_log_history');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.fwt_audit_log_history; */

    create table if not exists fomema_backup_nios.fwt_audit_log_history as select * from nios.fwt_audit_log_history;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table job_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.job_log;

    create foreign table if not exists nios.job_log (
        "job_id" numeric,
        "start_time" timestamp,
        "end_time" timestamp
    ) server fomema_backup options (schema_name 'nios', table_name 'job_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.job_log; */

    create table if not exists fomema_backup_nios.job_log as select * from nios.job_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table log_master', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.log_master;

    create foreign table if not exists nios.log_master (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'log_master');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.log_master; */

    create table if not exists fomema_backup_nios.log_master as select * from nios.log_master;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table log_master_arc', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.log_master_arc;

    create foreign table if not exists nios.log_master_arc (
        "uuid" numeric(10),
        "ip" varchar(20),
        "moduleid" numeric(10),
        "pageid" numeric(10),
        "action" varchar(4000),
        "action_type" varchar(5),
        "logdate" timestamp
    ) server fomema_backup options (schema_name 'nios', table_name 'log_master_arc');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.log_master_arc; */

    create table if not exists fomema_backup_nios.log_master_arc as select * from nios.log_master_arc;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table mystics_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.mystics_log;

    create foreign table if not exists nios.mystics_log (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'mystics_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.mystics_log; */

    create table if not exists fomema_backup_nios.mystics_log as select * from nios.mystics_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table payment_reject_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.payment_reject_log;

    create foreign table if not exists nios.payment_reject_log (
        "log_id" numeric(19),
        "payment_reject_id" numeric(19),
        "logdate" timestamp,
        "err#" numeric(6),
        "errm" varchar(250),
        "msg" varchar(250),
        "status" numeric(1)
    ) server fomema_backup options (schema_name 'nios', table_name 'payment_reject_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.payment_reject_log; */

    create table if not exists fomema_backup_nios.payment_reject_log as select * from nios.payment_reject_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table radiologist_history', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.radiologist_history;

    create foreign table if not exists nios.radiologist_history (
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
    ) server fomema_backup options (schema_name 'nios', table_name 'radiologist_history');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.radiologist_history; */

    create table if not exists fomema_backup_nios.radiologist_history as select * from nios.radiologist_history;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table radiologist_request', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.radiologist_request;

    create foreign table if not exists nios.radiologist_request (
        "rdregid" numeric(10),
        "approval_id" numeric(10),
        "status" varchar(5),
        "comments" varchar(4000),
        "modification_date" timestamp
    ) server fomema_backup options (schema_name 'nios', table_name 'radiologist_request');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.radiologist_request; */

    create table if not exists fomema_backup_nios.radiologist_request as select * from nios.radiologist_request;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table rev_sync_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.rev_sync_log;

    create foreign table if not exists nios.rev_sync_log (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server fomema_backup options (schema_name 'nios', table_name 'rev_sync_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.rev_sync_log; */

    create table if not exists fomema_backup_nios.rev_sync_log as select * from nios.rev_sync_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table sync_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.sync_log;

    create foreign table if not exists nios.sync_log (
        "sync_id" varchar(16),
        "err_no" varchar(20),
        "err_date" timestamp,
        "remarks" varchar(2000)
    ) server fomema_backup options (schema_name 'nios', table_name 'sync_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.sync_log; */

    create table if not exists fomema_backup_nios.sync_log as select * from nios.sync_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table t_cnv_radiologist_district', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.t_cnv_radiologist_district;

    create foreign table if not exists nios.t_cnv_radiologist_district (
        "radiologist_code" varchar(10),
        "district_name" varchar(50)
    ) server fomema_backup options (schema_name 'nios', table_name 't_cnv_radiologist_district');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.t_cnv_radiologist_district; */

    create table if not exists fomema_backup_nios.t_cnv_radiologist_district as select * from nios.t_cnv_radiologist_district;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table t_cnv_radiologisth_district', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.t_cnv_radiologisth_district;

    create foreign table if not exists nios.t_cnv_radiologisth_district (
        "radiologist_code" varchar(10),
        "version_no" varchar(10),
        "district_name" varchar(50)
    ) server fomema_backup options (schema_name 'nios', table_name 't_cnv_radiologisth_district');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.t_cnv_radiologisth_district; */

    create table if not exists fomema_backup_nios.t_cnv_radiologisth_district as select * from nios.t_cnv_radiologisth_district;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table transfer_log', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.transfer_log;

    create foreign table if not exists nios.transfer_log (
        "table_name" varchar(100),
        "key_value" varchar(100),
        "errmsg" varchar(2000)
    ) server fomema_backup options (schema_name 'nios', table_name 'transfer_log');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.transfer_log; */

    create table if not exists fomema_backup_nios.transfer_log as select * from nios.transfer_log;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table userlog', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.userlog;

    create foreign table if not exists nios.userlog (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(150),
        "ipaddr" varchar(50)
    ) server fomema_backup options (schema_name 'nios', table_name 'userlog');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.userlog; */

    create table if not exists fomema_backup_nios.userlog as select * from nios.userlog;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table userlog_arc', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.userlog_arc;

    create foreign table if not exists nios.userlog_arc (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "title" varchar(50),
        "reason" varchar(4000),
        "module" varchar(100),
        "ipaddr" varchar(50)
    ) server fomema_backup options (schema_name 'nios', table_name 'userlog_arc');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.userlog_arc; */

    create table if not exists fomema_backup_nios.userlog_arc as select * from nios.userlog_arc;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table userlog_browser', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists nios.userlog_browser;

    create foreign table if not exists nios.userlog_browser (
        "logdatetime" timestamp,
        "usercode" varchar(15),
        "header" varchar(255)
    ) server fomema_backup options (schema_name 'nios', table_name 'userlog_browser');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_nios.userlog_browser; */

    create table if not exists fomema_backup_nios.userlog_browser as select * from nios.userlog_browser;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

    
    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
