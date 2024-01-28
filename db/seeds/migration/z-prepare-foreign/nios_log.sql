
drop foreign table if exists fomema_backup_nios.app_log;

create foreign table if not exists fomema_backup_nios.app_log (
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

\echo 'created foreign table fomema_backup_nios.app_log';

drop foreign table if exists fomema_backup_nios.batchlog;

create foreign table if not exists fomema_backup_nios.batchlog (
    "logdatetime" timestamp,
    "usercode" varchar(15),
    "title" varchar(100),
    "reason" varchar(4000),
    "module" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'batchlog');

\echo 'created foreign table fomema_backup_nios.batchlog';

drop foreign table if exists fomema_backup_nios.doctor_opthour_changelog;

create foreign table if not exists fomema_backup_nios.doctor_opthour_changelog (
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

\echo 'created foreign table fomema_backup_nios.doctor_opthour_changelog';

drop foreign table if exists fomema_backup_nios.fwt_audit_log;

create foreign table if not exists fomema_backup_nios.fwt_audit_log (
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

\echo 'created foreign table fomema_backup_nios.fwt_audit_log';

drop foreign table if exists fomema_backup_nios.fwt_audit_log_history;

create foreign table if not exists fomema_backup_nios.fwt_audit_log_history (
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

\echo 'created foreign table fomema_backup_nios.fwt_audit_log_history';

drop foreign table if exists fomema_backup_nios.job_log;

create foreign table if not exists fomema_backup_nios.job_log (
    "job_id" numeric,
    "start_time" timestamp,
    "end_time" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'job_log');

\echo 'created foreign table fomema_backup_nios.job_log';

drop foreign table if exists fomema_backup_nios.log_master;

create foreign table if not exists fomema_backup_nios.log_master (
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

\echo 'created foreign table fomema_backup_nios.log_master';

drop foreign table if exists fomema_backup_nios.log_master_arc;

create foreign table if not exists fomema_backup_nios.log_master_arc (
    "uuid" numeric(10),
    "ip" varchar(20),
    "moduleid" numeric(10),
    "pageid" numeric(10),
    "action" varchar(4000),
    "action_type" varchar(5),
    "logdate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'log_master_arc');

\echo 'created foreign table fomema_backup_nios.log_master_arc';

drop foreign table if exists fomema_backup_nios.mystics_log;

create foreign table if not exists fomema_backup_nios.mystics_log (
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

\echo 'created foreign table fomema_backup_nios.mystics_log';

drop foreign table if exists fomema_backup_nios.payment_reject_log;

create foreign table if not exists fomema_backup_nios.payment_reject_log (
    "log_id" numeric(19),
    "payment_reject_id" numeric(19),
    "logdate" timestamp,
    "err#" numeric(6),
    "errm" varchar(250),
    "msg" varchar(250),
    "status" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'payment_reject_log');

\echo 'created foreign table fomema_backup_nios.payment_reject_log';

drop foreign table if exists fomema_backup_nios.radiologist_history;

create foreign table if not exists fomema_backup_nios.radiologist_history (
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
) server fomema_backup options (schema_name 'nios', table_name 'radiologist_history');

\echo 'created foreign table fomema_backup_nios.radiologist_history';

drop foreign table if exists fomema_backup_nios.radiologist_registration;

create foreign table if not exists fomema_backup_nios.radiologist_registration (
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
) server fomema_backup options (schema_name 'nios', table_name 'radiologist_registration');

\echo 'created foreign table fomema_backup_nios.radiologist_registration';

drop foreign table if exists fomema_backup_nios.radiologist_request;

create foreign table if not exists fomema_backup_nios.radiologist_request (
    "rdregid" numeric(10),
    "approval_id" numeric(10),
    "status" varchar(5),
    "comments" varchar(4000),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'radiologist_request');

\echo 'created foreign table fomema_backup_nios.radiologist_request';

drop foreign table if exists fomema_backup_nios.rev_sync_log;

create foreign table if not exists fomema_backup_nios.rev_sync_log (
    "sync_id" varchar(16),
    "err_no" varchar(20),
    "err_date" timestamp,
    "remarks" varchar(2000)
) server fomema_backup options (schema_name 'nios', table_name 'rev_sync_log');

\echo 'created foreign table fomema_backup_nios.rev_sync_log';

drop foreign table if exists fomema_backup_nios.sync_log;

create foreign table if not exists fomema_backup_nios.sync_log (
    "sync_id" varchar(16),
    "err_no" varchar(20),
    "err_date" timestamp,
    "remarks" varchar(2000)
) server fomema_backup options (schema_name 'nios', table_name 'sync_log');

\echo 'created foreign table fomema_backup_nios.sync_log';

drop foreign table if exists fomema_backup_nios.transfer_log;

create foreign table if not exists fomema_backup_nios.transfer_log (
    "table_name" varchar(100),
    "key_value" varchar(100),
    "errmsg" varchar(2000)
) server fomema_backup options (schema_name 'nios', table_name 'transfer_log');

\echo 'created foreign table fomema_backup_nios.transfer_log';

drop foreign table if exists fomema_backup_nios.t_cnv_radiologisth_district;

create foreign table if not exists fomema_backup_nios.t_cnv_radiologisth_district (
    "radiologist_code" varchar(10),
    "version_no" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_radiologisth_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_radiologisth_district';

drop foreign table if exists fomema_backup_nios.t_cnv_radiologist_district;

create foreign table if not exists fomema_backup_nios.t_cnv_radiologist_district (
    "radiologist_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_radiologist_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_radiologist_district';

drop foreign table if exists fomema_backup_nios.userlog;

create foreign table if not exists fomema_backup_nios.userlog (
    "logdatetime" timestamp,
    "usercode" varchar(15),
    "title" varchar(50),
    "reason" varchar(4000),
    "module" varchar(150),
    "ipaddr" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'userlog');

\echo 'created foreign table fomema_backup_nios.userlog';

drop foreign table if exists fomema_backup_nios.userlog_arc;

create foreign table if not exists fomema_backup_nios.userlog_arc (
    "logdatetime" timestamp,
    "usercode" varchar(15),
    "title" varchar(50),
    "reason" varchar(4000),
    "module" varchar(100),
    "ipaddr" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'userlog_arc');

\echo 'created foreign table fomema_backup_nios.userlog_arc';

drop foreign table if exists fomema_backup_nios.userlog_browser;

create foreign table if not exists fomema_backup_nios.userlog_browser (
    "logdatetime" timestamp,
    "usercode" varchar(15),
    "header" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'userlog_browser');

\echo 'created foreign table fomema_backup_nios.userlog_browser';
