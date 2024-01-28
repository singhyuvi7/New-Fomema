
drop foreign table if exists fomema_backup_nios.account_concile;

create foreign table if not exists fomema_backup_nios.account_concile (
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
) server fomema_backup options (schema_name 'nios', table_name 'account_concile');

\echo 'created foreign table fomema_backup_nios.account_concile';

drop foreign table if exists fomema_backup_nios.account_reference;

create foreign table if not exists fomema_backup_nios.account_reference (
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
) server fomema_backup options (schema_name 'nios', table_name 'account_reference');

\echo 'created foreign table fomema_backup_nios.account_reference';

drop foreign table if exists fomema_backup_nios.account_setting;

create foreign table if not exists fomema_backup_nios.account_setting (
    "id" numeric(19),
    "version" numeric(19),
    "create_date" timestamp,
    "creator_id" numeric(10),
    "parameter" varchar(120),
    "value" varchar(50),
    "description" varchar(400)
) server fomema_backup options (schema_name 'nios', table_name 'account_setting');

\echo 'created foreign table fomema_backup_nios.account_setting';

drop foreign table if exists fomema_backup_nios.adminusers;

create foreign table if not exists fomema_backup_nios.adminusers (
    "usercode" varchar(13),
    "username" varchar(50),
    "userpass" varchar(100),
    "lastlogindate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'adminusers');

\echo 'created foreign table fomema_backup_nios.adminusers';

drop foreign table if exists fomema_backup_nios.advance_payment;

create foreign table if not exists fomema_backup_nios.advance_payment (
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
) server fomema_backup options (schema_name 'nios', table_name 'advance_payment');

\echo 'created foreign table fomema_backup_nios.advance_payment';

drop foreign table if exists fomema_backup_nios.advance_payment_account;

create foreign table if not exists fomema_backup_nios.advance_payment_account (
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
) server fomema_backup options (schema_name 'nios', table_name 'advance_payment_account');

\echo 'created foreign table fomema_backup_nios.advance_payment_account';

drop foreign table if exists fomema_backup_nios.advance_payment_approval;

create foreign table if not exists fomema_backup_nios.advance_payment_approval (
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
) server fomema_backup options (schema_name 'nios', table_name 'advance_payment_approval');

\echo 'created foreign table fomema_backup_nios.advance_payment_approval';

drop foreign table if exists fomema_backup_nios.advance_payment_group;

create foreign table if not exists fomema_backup_nios.advance_payment_group (
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
) server fomema_backup options (schema_name 'nios', table_name 'advance_payment_group');

\echo 'created foreign table fomema_backup_nios.advance_payment_group';

drop foreign table if exists fomema_backup_nios.announcement;

create foreign table if not exists fomema_backup_nios.announcement (
    "id" numeric,
    "creation_date" timestamp,
    "subject" varchar(200),
    "start_date" timestamp,
    "end_date" timestamp,
    "content" text,
    "status" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'announcement');

\echo 'created foreign table fomema_backup_nios.announcement';

drop foreign table if exists fomema_backup_nios.appeal_fw_appeal;

create foreign table if not exists fomema_backup_nios.appeal_fw_appeal (
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
) server fomema_backup options (schema_name 'nios', table_name 'appeal_fw_appeal');

\echo 'created foreign table fomema_backup_nios.appeal_fw_appeal';

drop foreign table if exists fomema_backup_nios.appeal_fw_appeal_approval;

create foreign table if not exists fomema_backup_nios.appeal_fw_appeal_approval (
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
) server fomema_backup options (schema_name 'nios', table_name 'appeal_fw_appeal_approval');

\echo 'created foreign table fomema_backup_nios.appeal_fw_appeal_approval';

drop foreign table if exists fomema_backup_nios.appeal_fw_appeal_appro_his;

create foreign table if not exists fomema_backup_nios.appeal_fw_appeal_appro_his (
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
) server fomema_backup options (schema_name 'nios', table_name 'appeal_fw_appeal_appro_his');

\echo 'created foreign table fomema_backup_nios.appeal_fw_appeal_appro_his';

drop foreign table if exists fomema_backup_nios.appeal_payment;

create foreign table if not exists fomema_backup_nios.appeal_payment (
    "worker_code" varchar(10),
    "lab_code" varchar(10),
    "lab_amt" numeric(6, 2),
    "lab_inform" char(1),
    "lab_cond" varchar(10),
    "date_reg" timestamp,
    "reg_by" varchar(15)
) server fomema_backup options (schema_name 'nios', table_name 'appeal_payment');

\echo 'created foreign table fomema_backup_nios.appeal_payment';

drop foreign table if exists fomema_backup_nios.appeal_todolist;

create foreign table if not exists fomema_backup_nios.appeal_todolist (
    "todoid" numeric(10),
    "remark" varchar(500),
    "url" varchar(500)
) server fomema_backup options (schema_name 'nios', table_name 'appeal_todolist');

\echo 'created foreign table fomema_backup_nios.appeal_todolist';

drop foreign table if exists fomema_backup_nios.appeal_todolist_map;

create foreign table if not exists fomema_backup_nios.appeal_todolist_map (
    "parameter_code" varchar(10),
    "todoid" numeric(10),
    "can_appeal" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'appeal_todolist_map');

\echo 'created foreign table fomema_backup_nios.appeal_todolist_map';

drop foreign table if exists fomema_backup_nios.app_audit;

create foreign table if not exists fomema_backup_nios.app_audit (
    "audit_date" timestamp,
    "userid" varchar(30),
    "module_id" varchar(30),
    "audit_details" varchar
) server fomema_backup options (schema_name 'nios', table_name 'app_audit');

\echo 'created foreign table fomema_backup_nios.app_audit';

drop foreign table if exists fomema_backup_nios.app_module;

create foreign table if not exists fomema_backup_nios.app_module (
    "module_id" varchar(30),
    "description" varchar(80)
) server fomema_backup options (schema_name 'nios', table_name 'app_module');

\echo 'created foreign table fomema_backup_nios.app_module';

drop foreign table if exists fomema_backup_nios.ap_invoice_generated;

create foreign table if not exists fomema_backup_nios.ap_invoice_generated (
    "creditor_code" varchar(10),
    "trans_id" varchar(14),
    "created_date" timestamp,
    "filename" varchar(100),
    "type" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'ap_invoice_generated');

\echo 'created foreign table fomema_backup_nios.ap_invoice_generated';

drop foreign table if exists fomema_backup_nios.arch_fw_comment;

create foreign table if not exists fomema_backup_nios.arch_fw_comment (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000)
) server fomema_backup options (schema_name 'nios', table_name 'arch_fw_comment');

\echo 'created foreign table fomema_backup_nios.arch_fw_comment';

drop foreign table if exists fomema_backup_nios.arch_fw_detail;

create foreign table if not exists fomema_backup_nios.arch_fw_detail (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "med_history" varchar(5),
    "effected_date" timestamp,
    "parameter_value" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'arch_fw_detail');

\echo 'created foreign table fomema_backup_nios.arch_fw_detail';

drop foreign table if exists fomema_backup_nios.arch_fw_extra_comments;

create foreign table if not exists fomema_backup_nios.arch_fw_extra_comments (
    "trans_id" varchar(14),
    "comment_date" timestamp,
    "comment_time" varchar(8),
    "userid" varchar(30),
    "comments" text
) server fomema_backup options (schema_name 'nios', table_name 'arch_fw_extra_comments');

\echo 'created foreign table fomema_backup_nios.arch_fw_extra_comments';

drop foreign table if exists fomema_backup_nios.arch_fw_quarantine_reason;

create foreign table if not exists fomema_backup_nios.arch_fw_quarantine_reason (
    "trans_id" varchar(14),
    "reason_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'arch_fw_quarantine_reason');

\echo 'created foreign table fomema_backup_nios.arch_fw_quarantine_reason';

drop foreign table if exists fomema_backup_nios.arch_fw_transaction;

create foreign table if not exists fomema_backup_nios.arch_fw_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'arch_fw_transaction');

\echo 'created foreign table fomema_backup_nios.arch_fw_transaction';

drop foreign table if exists fomema_backup_nios.bad_payment;

create foreign table if not exists fomema_backup_nios.bad_payment (
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
) server fomema_backup options (schema_name 'nios', table_name 'bad_payment');

\echo 'created foreign table fomema_backup_nios.bad_payment';

drop foreign table if exists fomema_backup_nios.bad_payment_removal_comments;

create foreign table if not exists fomema_backup_nios.bad_payment_removal_comments (
    "paymentid" numeric(10),
    "removal_comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'bad_payment_removal_comments');

\echo 'created foreign table fomema_backup_nios.bad_payment_removal_comments';

drop foreign table if exists fomema_backup_nios.bank_draft_expiry;

create foreign table if not exists fomema_backup_nios.bank_draft_expiry (
    "bank_code" varchar(8),
    "valid_days" numeric(20)
) server fomema_backup options (schema_name 'nios', table_name 'bank_draft_expiry');

\echo 'created foreign table fomema_backup_nios.bank_draft_expiry';

drop foreign table if exists fomema_backup_nios.barcode_transaction;

create foreign table if not exists fomema_backup_nios.barcode_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'barcode_transaction');

\echo 'created foreign table fomema_backup_nios.barcode_transaction';

drop foreign table if exists fomema_backup_nios.batchlab_group;

create foreign table if not exists fomema_backup_nios.batchlab_group (
    "lab_group" varchar(2),
    "description" varchar(255),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'batchlab_group');

\echo 'created foreign table fomema_backup_nios.batchlab_group';

drop foreign table if exists fomema_backup_nios.batchusers;

create foreign table if not exists fomema_backup_nios.batchusers (
    "usercode" varchar(13),
    "username" varchar(50),
    "userpass" varchar(100),
    "useremail" varchar(50),
    "lastlogindate" timestamp,
    "logoutdate" timestamp,
    "status" varchar(10),
    "ismerts" numeric,
    "usergroup" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'batchusers');

\echo 'created foreign table fomema_backup_nios.batchusers';

drop foreign table if exists fomema_backup_nios.batch_coupling_change;

create foreign table if not exists fomema_backup_nios.batch_coupling_change (
    "batch_transid" varchar(14),
    "bc_doctor_code" varchar(13),
    "bc_laboratory_code" varchar(13),
    "bc_xray_code" varchar(13),
    "status" varchar(2),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'batch_coupling_change');

\echo 'created foreign table fomema_backup_nios.batch_coupling_change';

drop foreign table if exists fomema_backup_nios.branches;

create foreign table if not exists fomema_backup_nios.branches (
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
) server fomema_backup options (schema_name 'nios', table_name 'branches');

\echo 'created foreign table fomema_backup_nios.branches';

drop foreign table if exists fomema_backup_nios.branch_printers;

create foreign table if not exists fomema_backup_nios.branch_printers (
    "branch_printerid" numeric(10),
    "branch_code" varchar(2),
    "printer_name" varchar(100),
    "active" char(1)
) server fomema_backup options (schema_name 'nios', table_name 'branch_printers');

\echo 'created foreign table fomema_backup_nios.branch_printers';

drop foreign table if exists fomema_backup_nios.bulletin_acknowledge;

create foreign table if not exists fomema_backup_nios.bulletin_acknowledge (
    "bulletinid" numeric(10),
    "usercode" varchar(10),
    "ackdate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'bulletin_acknowledge');

\echo 'created foreign table fomema_backup_nios.bulletin_acknowledge';

drop foreign table if exists fomema_backup_nios.bulletin_target;

create foreign table if not exists fomema_backup_nios.bulletin_target (
    "bulletinid" numeric(10),
    "usercode" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'bulletin_target');

\echo 'created foreign table fomema_backup_nios.bulletin_target';

drop foreign table if exists fomema_backup_nios.bypass_error;

create foreign table if not exists fomema_backup_nios.bypass_error (
    "error_desc" varchar(30),
    "error_ind" numeric(2)
) server fomema_backup options (schema_name 'nios', table_name 'bypass_error');

\echo 'created foreign table fomema_backup_nios.bypass_error';

drop foreign table if exists fomema_backup_nios.cng_worker_clinic;

create foreign table if not exists fomema_backup_nios.cng_worker_clinic (
    "worker_code" varchar(10),
    "country_code" varchar(3),
    "clinic_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'cng_worker_clinic');

\echo 'created foreign table fomema_backup_nios.cng_worker_clinic';

drop foreign table if exists fomema_backup_nios.code_m;

create foreign table if not exists fomema_backup_nios.code_m (
    "req_type" varchar(2),
    "type_ind" varchar(1),
    "state_code" varchar(1),
    "name_first" varchar(1),
    "last_issue_no" numeric
) server fomema_backup options (schema_name 'nios', table_name 'code_m');

\echo 'created foreign table fomema_backup_nios.code_m';

drop foreign table if exists fomema_backup_nios.condition_map;

create foreign table if not exists fomema_backup_nios.condition_map (
    "parameter_code" varchar(10),
    "old_parameter_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'condition_map');

\echo 'created foreign table fomema_backup_nios.condition_map';

drop foreign table if exists fomema_backup_nios.coupling_trans;

create foreign table if not exists fomema_backup_nios.coupling_trans (
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
) server fomema_backup options (schema_name 'nios', table_name 'coupling_trans');

\echo 'created foreign table fomema_backup_nios.coupling_trans';

drop foreign table if exists fomema_backup_nios.customer_complaint;

create foreign table if not exists fomema_backup_nios.customer_complaint (
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
) server fomema_backup options (schema_name 'nios', table_name 'customer_complaint');

\echo 'created foreign table fomema_backup_nios.customer_complaint';

drop foreign table if exists fomema_backup_nios.delay_trans;

create foreign table if not exists fomema_backup_nios.delay_trans (
    "doctor_code" varchar(10),
    "worker_code" varchar(10),
    "exam_date" timestamp,
    "lab_submit_date" timestamp,
    "xray_submit_date" timestamp,
    "action_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'delay_trans');

\echo 'created foreign table fomema_backup_nios.delay_trans';

drop foreign table if exists fomema_backup_nios.diff_rh;

create foreign table if not exists fomema_backup_nios.diff_rh (
    "tranno" varchar(10),
    "oldtranno" varchar(10),
    "branch_code" varchar(2),
    "service_type" varchar(2),
    "trandate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'diff_rh');

\echo 'created foreign table fomema_backup_nios.diff_rh';

drop foreign table if exists fomema_backup_nios.discrp_tab;

create foreign table if not exists fomema_backup_nios.discrp_tab (
    "ftype" varchar(1),
    "scandir" varchar(2),
    "fcode" varchar(10),
    "ecode" varchar(2),
    "a_loc" varchar(1),
    "a_fcode" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'discrp_tab');

\echo 'created foreign table fomema_backup_nios.discrp_tab';

drop foreign table if exists fomema_backup_nios.district_map;

create foreign table if not exists fomema_backup_nios.district_map (
    "district_map_code" varchar(7),
    "district_map_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'district_map');

\echo 'created foreign table fomema_backup_nios.district_map';

drop foreign table if exists fomema_backup_nios.district_office;

create foreign table if not exists fomema_backup_nios.district_office (
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
) server fomema_backup options (schema_name 'nios', table_name 'district_office');

\echo 'created foreign table fomema_backup_nios.district_office';

drop foreign table if exists fomema_backup_nios.doctor_change_request;

create foreign table if not exists fomema_backup_nios.doctor_change_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'doctor_change_request');

\echo 'created foreign table fomema_backup_nios.doctor_change_request';

drop foreign table if exists fomema_backup_nios.doctor_change_request_detail;

create foreign table if not exists fomema_backup_nios.doctor_change_request_detail (
    "dm_cr_id" numeric(10),
    "cr_column" varchar(100),
    "cr_old" varchar(100),
    "cr_new" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'doctor_change_request_detail');

\echo 'created foreign table fomema_backup_nios.doctor_change_request_detail';

drop foreign table if exists fomema_backup_nios.doctor_load_6p;

create foreign table if not exists fomema_backup_nios.doctor_load_6p (
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
) server fomema_backup options (schema_name 'nios', table_name 'doctor_load_6p');

\echo 'created foreign table fomema_backup_nios.doctor_load_6p';

drop foreign table if exists fomema_backup_nios.doctor_opthour;

create foreign table if not exists fomema_backup_nios.doctor_opthour (
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
) server fomema_backup options (schema_name 'nios', table_name 'doctor_opthour');

\echo 'created foreign table fomema_backup_nios.doctor_opthour';

drop foreign table if exists fomema_backup_nios.doctor_quota_trans;

create foreign table if not exists fomema_backup_nios.doctor_quota_trans (
    "trans_date" timestamp,
    "doctor_code" varchar(10),
    "old_quota" numeric,
    "new_quota" numeric,
    "decision_date" timestamp,
    "userid" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'doctor_quota_trans');

\echo 'created foreign table fomema_backup_nios.doctor_quota_trans';

drop foreign table if exists fomema_backup_nios.doctor_registration;

create foreign table if not exists fomema_backup_nios.doctor_registration (
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
) server fomema_backup options (schema_name 'nios', table_name 'doctor_registration');

\echo 'created foreign table fomema_backup_nios.doctor_registration';

drop foreign table if exists fomema_backup_nios.doctor_request;

create foreign table if not exists fomema_backup_nios.doctor_request (
    "dregid" numeric(10),
    "approval_id" numeric(10),
    "status" varchar(5),
    "comments" varchar(4000),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'doctor_request');

\echo 'created foreign table fomema_backup_nios.doctor_request';

drop foreign table if exists fomema_backup_nios.doctor_status_enquiry;

create foreign table if not exists fomema_backup_nios.doctor_status_enquiry (
    "bc_doctor_code" varchar(10),
    "reserved_quota" numeric(10),
    "pend_exam_less_5" numeric(10),
    "pend_exam_greater_5" numeric(10),
    "pend_cert_less_4" numeric(10),
    "pend_cert_greater_4" numeric(10),
    "pend_xray_less_5" numeric(10),
    "pend_xray_greater_5" numeric(10),
    "last_updated" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'doctor_status_enquiry');

\echo 'created foreign table fomema_backup_nios.doctor_status_enquiry';

drop foreign table if exists fomema_backup_nios.doc_compare;

create foreign table if not exists fomema_backup_nios.doc_compare (
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
) server fomema_backup options (schema_name 'nios', table_name 'doc_compare');

\echo 'created foreign table fomema_backup_nios.doc_compare';

drop foreign table if exists fomema_backup_nios.doc_lab_allocation;

create foreign table if not exists fomema_backup_nios.doc_lab_allocation (
    "doctor_code" varchar(10),
    "old_lab" varchar(10),
    "new_lab" varchar(10),
    "mod_date" timestamp,
    "modify_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'doc_lab_allocation');

\echo 'created foreign table fomema_backup_nios.doc_lab_allocation';

drop foreign table if exists fomema_backup_nios.doc_quota_allocation;

create foreign table if not exists fomema_backup_nios.doc_quota_allocation (
    "doctor_code" varchar(10),
    "old_quota" numeric(10),
    "new_quota" numeric(10),
    "mod_date" timestamp,
    "modify_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'doc_quota_allocation');

\echo 'created foreign table fomema_backup_nios.doc_quota_allocation';

drop foreign table if exists fomema_backup_nios.doc_status;

create foreign table if not exists fomema_backup_nios.doc_status (
    "action_date" timestamp,
    "doctor_code" varchar(10),
    "status" varchar(3),
    "reason" varchar(200),
    "date_susp" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'doc_status');

\echo 'created foreign table fomema_backup_nios.doc_status';

drop foreign table if exists fomema_backup_nios.doc_xray_allocation;

create foreign table if not exists fomema_backup_nios.doc_xray_allocation (
    "doctor_code" varchar(10),
    "old_xray" varchar(10),
    "new_xray" varchar(10),
    "mod_date" timestamp,
    "modify_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'doc_xray_allocation');

\echo 'created foreign table fomema_backup_nios.doc_xray_allocation';

drop foreign table if exists fomema_backup_nios.draft_allocation;

create foreign table if not exists fomema_backup_nios.draft_allocation (
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
) server fomema_backup options (schema_name 'nios', table_name 'draft_allocation');

\echo 'created foreign table fomema_backup_nios.draft_allocation';

drop foreign table if exists fomema_backup_nios.draft_usage;

create foreign table if not exists fomema_backup_nios.draft_usage (
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
) server fomema_backup options (schema_name 'nios', table_name 'draft_usage');

\echo 'created foreign table fomema_backup_nios.draft_usage';

drop foreign table if exists fomema_backup_nios.dup_rec;

create foreign table if not exists fomema_backup_nios.dup_rec (
    "payment_no" varchar(10),
    "count" numeric
) server fomema_backup options (schema_name 'nios', table_name 'dup_rec');

\echo 'created foreign table fomema_backup_nios.dup_rec';

drop foreign table if exists fomema_backup_nios.dxbasket;

create foreign table if not exists fomema_backup_nios.dxbasket (
    "id" numeric(19),
    "version" numeric(19),
    "status" varchar(40),
    "submit_date" timestamp,
    "trans_id" varchar(56),
    "xray_code" varchar(40),
    "pickup_date" timestamp,
    "batch_id" numeric(10),
    "source_ref" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'dxbasket');

\echo 'created foreign table fomema_backup_nios.dxbasket';

drop foreign table if exists fomema_backup_nios.dxfilm_audit;

create foreign table if not exists fomema_backup_nios.dxfilm_audit (
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
) server fomema_backup options (schema_name 'nios', table_name 'dxfilm_audit');

\echo 'created foreign table fomema_backup_nios.dxfilm_audit';

drop foreign table if exists fomema_backup_nios.dxfilm_movement;

create foreign table if not exists fomema_backup_nios.dxfilm_movement (
    "id" numeric(19),
    "version" numeric(19),
    "comments" varchar(500),
    "status" varchar(20),
    "status_date" timestamp,
    "trans_id" varchar(14),
    "uuid" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'dxfilm_movement');

\echo 'created foreign table fomema_backup_nios.dxfilm_movement';

drop foreign table if exists fomema_backup_nios.dxpcr_audit_comment;

create foreign table if not exists fomema_backup_nios.dxpcr_audit_comment (
    "id" numeric(19),
    "version" numeric(19),
    "comments" varchar(2000),
    "parameter_code" varchar(20),
    "pcr_audit_film_id" numeric(19)
) server fomema_backup options (schema_name 'nios', table_name 'dxpcr_audit_comment');

\echo 'created foreign table fomema_backup_nios.dxpcr_audit_comment';

drop foreign table if exists fomema_backup_nios.dxpcr_audit_detail;

create foreign table if not exists fomema_backup_nios.dxpcr_audit_detail (
    "id" numeric(19),
    "version" numeric(19),
    "parameter_code" varchar(20),
    "parameter_value" varchar(8),
    "pcr_audit_film_id" numeric(19)
) server fomema_backup options (schema_name 'nios', table_name 'dxpcr_audit_detail');

\echo 'created foreign table fomema_backup_nios.dxpcr_audit_detail';

drop foreign table if exists fomema_backup_nios.dxpcr_audit_film;

create foreign table if not exists fomema_backup_nios.dxpcr_audit_film (
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
) server fomema_backup options (schema_name 'nios', table_name 'dxpcr_audit_film');

\echo 'created foreign table fomema_backup_nios.dxpcr_audit_film';

drop foreign table if exists fomema_backup_nios.dxpcr_pool;

create foreign table if not exists fomema_backup_nios.dxpcr_pool (
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
) server fomema_backup options (schema_name 'nios', table_name 'dxpcr_pool');

\echo 'created foreign table fomema_backup_nios.dxpcr_pool';

drop foreign table if exists fomema_backup_nios.dxpcr_retake_reasons;

create foreign table if not exists fomema_backup_nios.dxpcr_retake_reasons (
    "id" varchar(20),
    "description" varchar(1000)
) server fomema_backup options (schema_name 'nios', table_name 'dxpcr_retake_reasons');

\echo 'created foreign table fomema_backup_nios.dxpcr_retake_reasons';

drop foreign table if exists fomema_backup_nios.dxreview_film;

create foreign table if not exists fomema_backup_nios.dxreview_film (
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
) server fomema_backup options (schema_name 'nios', table_name 'dxreview_film');

\echo 'created foreign table fomema_backup_nios.dxreview_film';

drop foreign table if exists fomema_backup_nios.dxreview_film_comment;

create foreign table if not exists fomema_backup_nios.dxreview_film_comment (
    "id" numeric(19),
    "version" numeric(19),
    "comments" varchar(2000),
    "create_date" timestamp,
    "creator_id" numeric(10),
    "dxry_id" numeric(19),
    "modify_date" timestamp,
    "modify_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'dxreview_film_comment');

\echo 'created foreign table fomema_backup_nios.dxreview_film_comment';

drop foreign table if exists fomema_backup_nios.dxreview_film_detail;

create foreign table if not exists fomema_backup_nios.dxreview_film_detail (
    "id" numeric(19),
    "version" numeric(19),
    "dxry_id" numeric(19),
    "parameter_code" varchar(20),
    "parameter_value" varchar(8)
) server fomema_backup options (schema_name 'nios', table_name 'dxreview_film_detail');

\echo 'created foreign table fomema_backup_nios.dxreview_film_detail';

drop foreign table if exists fomema_backup_nios.dxreview_film_identical;

create foreign table if not exists fomema_backup_nios.dxreview_film_identical (
    "id" numeric(19),
    "version" numeric(19),
    "dxry_id" numeric(19),
    "trans_id" varchar(56),
    "worker_code" varchar(40)
) server fomema_backup options (schema_name 'nios', table_name 'dxreview_film_identical');

\echo 'created foreign table fomema_backup_nios.dxreview_film_identical';

drop foreign table if exists fomema_backup_nios.dxxray_audit;

create foreign table if not exists fomema_backup_nios.dxxray_audit (
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
) server fomema_backup options (schema_name 'nios', table_name 'dxxray_audit');

\echo 'created foreign table fomema_backup_nios.dxxray_audit';

drop foreign table if exists fomema_backup_nios.dx_payblock;

create foreign table if not exists fomema_backup_nios.dx_payblock (
    "doc_xray_code" varchar(10),
    "doc_xray_ind" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'dx_payblock');

\echo 'created foreign table fomema_backup_nios.dx_payblock';

drop foreign table if exists fomema_backup_nios.employer_account;

create foreign table if not exists fomema_backup_nios.employer_account (
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
) server fomema_backup options (schema_name 'nios', table_name 'employer_account');

\echo 'created foreign table fomema_backup_nios.employer_account';

drop foreign table if exists fomema_backup_nios.employer_alloc_detail;

create foreign table if not exists fomema_backup_nios.employer_alloc_detail (
    "id" numeric(19),
    "version" numeric(19),
    "allocation_amount" numeric(126),
    "creation_date" timestamp,
    "creator_id" numeric(10),
    "employer_alloc_master_id" numeric(19),
    "employer_code" varchar(40),
    "gst_amount" numeric(126),
    "invoice_no" varchar(40)
) server fomema_backup options (schema_name 'nios', table_name 'employer_alloc_detail');

\echo 'created foreign table fomema_backup_nios.employer_alloc_detail';

drop foreign table if exists fomema_backup_nios.employer_cn;

create foreign table if not exists fomema_backup_nios.employer_cn (
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
) server fomema_backup options (schema_name 'nios', table_name 'employer_cn');

\echo 'created foreign table fomema_backup_nios.employer_cn';

drop foreign table if exists fomema_backup_nios.employer_notification;

create foreign table if not exists fomema_backup_nios.employer_notification (
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
) server fomema_backup options (schema_name 'nios', table_name 'employer_notification');

\echo 'created foreign table fomema_backup_nios.employer_notification';

drop foreign table if exists fomema_backup_nios.employer_notification_count;

create foreign table if not exists fomema_backup_nios.employer_notification_count (
    "employer_code" varchar(10),
    "total" numeric(5)
) server fomema_backup options (schema_name 'nios', table_name 'employer_notification_count');

\echo 'created foreign table fomema_backup_nios.employer_notification_count';

drop foreign table if exists fomema_backup_nios.errormsg_from_kk;

create foreign table if not exists fomema_backup_nios.errormsg_from_kk (
    "msgtime" timestamp,
    "msgtext" varchar(1000),
    "msgid" numeric
) server fomema_backup options (schema_name 'nios', table_name 'errormsg_from_kk');

\echo 'created foreign table fomema_backup_nios.errormsg_from_kk';

drop foreign table if exists fomema_backup_nios.finance_payment;

create foreign table if not exists fomema_backup_nios.finance_payment (
    "worker_code" varchar(10),
    "trans_id" varchar(14),
    "certify_date" timestamp,
    "report_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'finance_payment');

\echo 'created foreign table fomema_backup_nios.finance_payment';

drop foreign table if exists fomema_backup_nios.fin_batch_trans;

create foreign table if not exists fomema_backup_nios.fin_batch_trans (
    "batch_number" numeric,
    "trans_id" varchar(14),
    "certify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fin_batch_trans');

\echo 'created foreign table fomema_backup_nios.fin_batch_trans';

drop foreign table if exists fomema_backup_nios.fom_doctor_quota_bkp;

create foreign table if not exists fomema_backup_nios.fom_doctor_quota_bkp (
    "doctor_code" varchar(10),
    "laboratory_code" varchar(10),
    "xray_code" varchar(10),
    "quota" numeric,
    "quota_use" numeric,
    "creation_date" timestamp,
    "status_code" varchar(5)
) server fomema_backup options (schema_name 'nios', table_name 'fom_doctor_quota_bkp');

\echo 'created foreign table fomema_backup_nios.fom_doctor_quota_bkp';

drop foreign table if exists fomema_backup_nios.fom_lab_payment_missed;

create foreign table if not exists fomema_backup_nios.fom_lab_payment_missed (
    "trans_id" varchar(14),
    "lab_code" varchar(10),
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "sex" varchar(1),
    "transdate" timestamp,
    "certify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fom_lab_payment_missed');

\echo 'created foreign table fomema_backup_nios.fom_lab_payment_missed';

drop foreign table if exists fomema_backup_nios.fom_lab_unpaid;

create foreign table if not exists fomema_backup_nios.fom_lab_unpaid (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_lab_unpaid');

\echo 'created foreign table fomema_backup_nios.fom_lab_unpaid';

drop foreign table if exists fomema_backup_nios.fom_params;

create foreign table if not exists fomema_backup_nios.fom_params (
    "param_code" varchar(100),
    "param_value" varchar(1000),
    "isactive" numeric,
    "created_date" timestamp,
    "remark" varchar(1000),
    "refid" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'fom_params');

\echo 'created foreign table fomema_backup_nios.fom_params';

drop foreign table if exists fomema_backup_nios.fom_payment_status_missed;

create foreign table if not exists fomema_backup_nios.fom_payment_status_missed (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_payment_status_missed');

\echo 'created foreign table fomema_backup_nios.fom_payment_status_missed';

drop foreign table if exists fomema_backup_nios.fom_pay_transaction;

create foreign table if not exists fomema_backup_nios.fom_pay_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_pay_transaction');

\echo 'created foreign table fomema_backup_nios.fom_pay_transaction';

drop foreign table if exists fomema_backup_nios.fom_pay_transaction_missed;

create foreign table if not exists fomema_backup_nios.fom_pay_transaction_missed (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_pay_transaction_missed');

\echo 'created foreign table fomema_backup_nios.fom_pay_transaction_missed';

drop foreign table if exists fomema_backup_nios.fom_special_payment;

create foreign table if not exists fomema_backup_nios.fom_special_payment (
    "trans_id" varchar(14),
    "sp_type" varchar(1),
    "payment_date" timestamp,
    "payment_amount" numeric,
    "created_by" varchar(20),
    "created_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fom_special_payment');

\echo 'created foreign table fomema_backup_nios.fom_special_payment';

drop foreign table if exists fomema_backup_nios.fom_tempmyeg;

create foreign table if not exists fomema_backup_nios.fom_tempmyeg (
    "worker_name" varchar(50),
    "passport_no" varchar(25),
    "country" varchar(50),
    "old_passport_no" varchar(25)
) server fomema_backup options (schema_name 'nios', table_name 'fom_tempmyeg');

\echo 'created foreign table fomema_backup_nios.fom_tempmyeg';

drop foreign table if exists fomema_backup_nios.fom_tmp_jim;

create foreign table if not exists fomema_backup_nios.fom_tmp_jim (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_tmp_jim');

\echo 'created foreign table fomema_backup_nios.fom_tmp_jim';

drop foreign table if exists fomema_backup_nios.fom_user_capability;

create foreign table if not exists fomema_backup_nios.fom_user_capability (
    "uuid" numeric(10),
    "mod_id" numeric(38),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fom_user_capability');

\echo 'created foreign table fomema_backup_nios.fom_user_capability';

drop foreign table if exists fomema_backup_nios.fom_xray_not_done_missed;

create foreign table if not exists fomema_backup_nios.fom_xray_not_done_missed (
    "trans_id" varchar(14),
    "xray_code" varchar(10),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "certify_date" timestamp,
    "xray_submit_date" timestamp,
    "release_date" timestamp,
    "xray_ded" numeric(3)
) server fomema_backup options (schema_name 'nios', table_name 'fom_xray_not_done_missed');

\echo 'created foreign table fomema_backup_nios.fom_xray_not_done_missed';

drop foreign table if exists fomema_backup_nios.fom_xray_not_receive;

create foreign table if not exists fomema_backup_nios.fom_xray_not_receive (
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
) server fomema_backup options (schema_name 'nios', table_name 'fom_xray_not_receive');

\echo 'created foreign table fomema_backup_nios.fom_xray_not_receive';

drop foreign table if exists fomema_backup_nios.fom_xray_use_swast;

create foreign table if not exists fomema_backup_nios.fom_xray_use_swast (
    "xray_code" varchar(10),
    "install_date" timestamp,
    "created_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fom_xray_use_swast');

\echo 'created foreign table fomema_backup_nios.fom_xray_use_swast';

drop foreign table if exists fomema_backup_nios.foreign_worker_biodata;

create foreign table if not exists fomema_backup_nios.foreign_worker_biodata (
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
) server fomema_backup options (schema_name 'nios', table_name 'foreign_worker_biodata');

\echo 'created foreign table fomema_backup_nios.foreign_worker_biodata';

drop foreign table if exists fomema_backup_nios.fwm_change_trans;

create foreign table if not exists fomema_backup_nios.fwm_change_trans (
    "bc_worker_code" varchar(13),
    "trans_id" varchar(14),
    "old_value" varchar(100),
    "new_value" varchar(100),
    "reason_code" varchar(5),
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fwm_change_trans');

\echo 'created foreign table fomema_backup_nios.fwm_change_trans';

drop foreign table if exists fomema_backup_nios.fwm_change_trans_org;

create foreign table if not exists fomema_backup_nios.fwm_change_trans_org (
    "bc_worker_code" varchar(13),
    "trans_id" varchar(14),
    "old_value" varchar(100),
    "new_value" varchar(100),
    "reason_code" varchar(5),
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fwm_change_trans_org');

\echo 'created foreign table fomema_backup_nios.fwm_change_trans_org';

drop foreign table if exists fomema_backup_nios.fwm_modulecode;

create foreign table if not exists fomema_backup_nios.fwm_modulecode (
    "module_code" numeric(5),
    "description" varchar(255),
    "status" numeric(1),
    "creator_id" varchar(20),
    "create_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fwm_modulecode');

\echo 'created foreign table fomema_backup_nios.fwm_modulecode';

drop foreign table if exists fomema_backup_nios.fwm_mon;

create foreign table if not exists fomema_backup_nios.fwm_mon (
    "worker_code" varchar(10),
    "ismonitor" varchar(5),
    "passport_no" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'fwm_mon');

\echo 'created foreign table fomema_backup_nios.fwm_mon';

drop foreign table if exists fomema_backup_nios.fwt_change_clinic_approval;

create foreign table if not exists fomema_backup_nios.fwt_change_clinic_approval (
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
) server fomema_backup options (schema_name 'nios', table_name 'fwt_change_clinic_approval');

\echo 'created foreign table fomema_backup_nios.fwt_change_clinic_approval';

drop foreign table if exists fomema_backup_nios.fwt_change_journal;

create foreign table if not exists fomema_backup_nios.fwt_change_journal (
    "chgjl_id" varchar(14),
    "chgjl_date" timestamp,
    "trans_id" varchar(14),
    "userid" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'fwt_change_journal');

\echo 'created foreign table fomema_backup_nios.fwt_change_journal';

drop foreign table if exists fomema_backup_nios.fwt_change_journal_detail;

create foreign table if not exists fomema_backup_nios.fwt_change_journal_detail (
    "chgjl_id" varchar(14),
    "chgtype" varchar(1),
    "old_code" varchar(10),
    "new_code" varchar(10),
    "reason" varchar(240)
) server fomema_backup options (schema_name 'nios', table_name 'fwt_change_journal_detail');

\echo 'created foreign table fomema_backup_nios.fwt_change_journal_detail';

drop foreign table if exists fomema_backup_nios.fwt_deferred;

create foreign table if not exists fomema_backup_nios.fwt_deferred (
    "trans_id" varchar(14),
    "creation_date" timestamp,
    "created_by" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'fwt_deferred');

\echo 'created foreign table fomema_backup_nios.fwt_deferred';

drop foreign table if exists fomema_backup_nios.fwt_examdate_change_trans;

create foreign table if not exists fomema_backup_nios.fwt_examdate_change_trans (
    "change_id" numeric(9),
    "trans_id" varchar(14),
    "old_exam_date" timestamp,
    "new_exam_date" timestamp,
    "initiated_by" varchar(20),
    "date_initiated" timestamp,
    "status" char(1),
    "concur_by" varchar(20),
    "concur_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fwt_examdate_change_trans');

\echo 'created foreign table fomema_backup_nios.fwt_examdate_change_trans';

drop foreign table if exists fomema_backup_nios.fwt_regmed;

create foreign table if not exists fomema_backup_nios.fwt_regmed (
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "certify_date" timestamp,
    "med_ind" numeric,
    "reg_ind" numeric
) server fomema_backup options (schema_name 'nios', table_name 'fwt_regmed');

\echo 'created foreign table fomema_backup_nios.fwt_regmed';

drop foreign table if exists fomema_backup_nios.fwt_regmed_delta;

create foreign table if not exists fomema_backup_nios.fwt_regmed_delta (
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "certify_date" timestamp,
    "med_ind" numeric,
    "reg_ind" numeric
) server fomema_backup options (schema_name 'nios', table_name 'fwt_regmed_delta');

\echo 'created foreign table fomema_backup_nios.fwt_regmed_delta';

drop foreign table if exists fomema_backup_nios.fwt_shadow;

create foreign table if not exists fomema_backup_nios.fwt_shadow (
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
) server fomema_backup options (schema_name 'nios', table_name 'fwt_shadow');

\echo 'created foreign table fomema_backup_nios.fwt_shadow';

drop foreign table if exists fomema_backup_nios.fwt_update_tcupi;

create foreign table if not exists fomema_backup_nios.fwt_update_tcupi (
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "old_fit_ind" varchar(1),
    "new_fit_ind" varchar(1),
    "old_tcupi_ind" varchar(1),
    "new_tcupi_ind" varchar(1),
    "mod_date" timestamp,
    "status" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'fwt_update_tcupi');

\echo 'created foreign table fomema_backup_nios.fwt_update_tcupi';

drop foreign table if exists fomema_backup_nios.fwt_xray_unmatch;

create foreign table if not exists fomema_backup_nios.fwt_xray_unmatch (
    "trans_id" varchar(14),
    "bc_worker_code" varchar(14),
    "bc_xray_code" varchar(14),
    "xray_code" varchar(14),
    "modify_id" numeric,
    "modification_date" timestamp,
    "version_no" numeric
) server fomema_backup options (schema_name 'nios', table_name 'fwt_xray_unmatch');

\echo 'created foreign table fomema_backup_nios.fwt_xray_unmatch';

drop foreign table if exists fomema_backup_nios.fw_appeal;

create foreign table if not exists fomema_backup_nios.fw_appeal (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal');

\echo 'created foreign table fomema_backup_nios.fw_appeal';

drop foreign table if exists fomema_backup_nios.fw_appeal_approval;

create foreign table if not exists fomema_backup_nios.fw_appeal_approval (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_approval');

\echo 'created foreign table fomema_backup_nios.fw_appeal_approval';

drop foreign table if exists fomema_backup_nios.fw_appeal_comment;

create foreign table if not exists fomema_backup_nios.fw_appeal_comment (
    "appeal_commentid" numeric(10),
    "appealid" numeric(10),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_comment');

\echo 'created foreign table fomema_backup_nios.fw_appeal_comment';

drop foreign table if exists fomema_backup_nios.fw_appeal_doc_change;

create foreign table if not exists fomema_backup_nios.fw_appeal_doc_change (
    "appealid" numeric(10),
    "comments" varchar(4000),
    "old_doctor_code" varchar(13),
    "new_doctor_code" varchar(13),
    "creator_id" numeric(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_doc_change');

\echo 'created foreign table fomema_backup_nios.fw_appeal_doc_change';

drop foreign table if exists fomema_backup_nios.fw_appeal_follow_up;

create foreign table if not exists fomema_backup_nios.fw_appeal_follow_up (
    "followupid" numeric(10),
    "appealid" numeric(10),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_follow_up');

\echo 'created foreign table fomema_backup_nios.fw_appeal_follow_up';

drop foreign table if exists fomema_backup_nios.fw_appeal_follow_up_detail;

create foreign table if not exists fomema_backup_nios.fw_appeal_follow_up_detail (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_follow_up_detail');

\echo 'created foreign table fomema_backup_nios.fw_appeal_follow_up_detail';

drop foreign table if exists fomema_backup_nios.fw_appeal_passfail_reason;

create foreign table if not exists fomema_backup_nios.fw_appeal_passfail_reason (
    "reasonid" numeric(10),
    "appeal_param_code" varchar(10),
    "reason_code" varchar(10),
    "reason_description" varchar(250),
    "passfail" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_passfail_reason');

\echo 'created foreign table fomema_backup_nios.fw_appeal_passfail_reason';

drop foreign table if exists fomema_backup_nios.fw_appeal_todolist;

create foreign table if not exists fomema_backup_nios.fw_appeal_todolist (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_todolist');

\echo 'created foreign table fomema_backup_nios.fw_appeal_todolist';

drop foreign table if exists fomema_backup_nios.fw_appeal_unfit_details;

create foreign table if not exists fomema_backup_nios.fw_appeal_unfit_details (
    "appealid" numeric(10),
    "merts_param_code" varchar(10),
    "appeal_param_code" varchar(10),
    "reason_code" varchar(10),
    "passfail" varchar(1),
    "remarks" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'fw_appeal_unfit_details');

\echo 'created foreign table fomema_backup_nios.fw_appeal_unfit_details';

drop foreign table if exists fomema_backup_nios.fw_biodata_reenrolment;

create foreign table if not exists fomema_backup_nios.fw_biodata_reenrolment (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_biodata_reenrolment');

\echo 'created foreign table fomema_backup_nios.fw_biodata_reenrolment';

drop foreign table if exists fomema_backup_nios.fw_block;

create foreign table if not exists fomema_backup_nios.fw_block (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_block');

\echo 'created foreign table fomema_backup_nios.fw_block';

drop foreign table if exists fomema_backup_nios.fw_change_trans;

create foreign table if not exists fomema_backup_nios.fw_change_trans (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_change_trans');

\echo 'created foreign table fomema_backup_nios.fw_change_trans';

drop foreign table if exists fomema_backup_nios.fw_comment;

create foreign table if not exists fomema_backup_nios.fw_comment (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_comment');

\echo 'created foreign table fomema_backup_nios.fw_comment';

drop foreign table if exists fomema_backup_nios.fw_critical_info;

create foreign table if not exists fomema_backup_nios.fw_critical_info (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_critical_info');

\echo 'created foreign table fomema_backup_nios.fw_critical_info';

drop foreign table if exists fomema_backup_nios.fw_critical_info_detail;

create foreign table if not exists fomema_backup_nios.fw_critical_info_detail (
    "fw_critical_id" numeric(10),
    "critical_column" varchar(100),
    "critical_old" varchar(50),
    "critical_new" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'fw_critical_info_detail');

\echo 'created foreign table fomema_backup_nios.fw_critical_info_detail';

drop foreign table if exists fomema_backup_nios.fw_detail;

create foreign table if not exists fomema_backup_nios.fw_detail (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "med_history" varchar(5),
    "effected_date" timestamp,
    "parameter_value" varchar(20),
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_detail');

\echo 'created foreign table fomema_backup_nios.fw_detail';

drop foreign table if exists fomema_backup_nios.fw_extra_comments;

create foreign table if not exists fomema_backup_nios.fw_extra_comments (
    "trans_id" varchar(14),
    "comment_date" timestamp,
    "comment_time" varchar(8),
    "userid" varchar(30),
    "comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'fw_extra_comments');

\echo 'created foreign table fomema_backup_nios.fw_extra_comments';

drop foreign table if exists fomema_backup_nios.fw_medblocked;

create foreign table if not exists fomema_backup_nios.fw_medblocked (
    "blk_tranno" varchar(10),
    "receipt_tranno" varchar(10),
    "isblock" varchar(1),
    "creator_id" numeric(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'fw_medblocked');

\echo 'created foreign table fomema_backup_nios.fw_medblocked';

drop foreign table if exists fomema_backup_nios.fw_monitor;

create foreign table if not exists fomema_backup_nios.fw_monitor (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_monitor');

\echo 'created foreign table fomema_backup_nios.fw_monitor';

drop foreign table if exists fomema_backup_nios.fw_monitor_reason;

create foreign table if not exists fomema_backup_nios.fw_monitor_reason (
    "reason_code" varchar(5),
    "description" varchar(100),
    "capid" numeric(10),
    "shortdesc" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'fw_monitor_reason');

\echo 'created foreign table fomema_backup_nios.fw_monitor_reason';

drop foreign table if exists fomema_backup_nios.fw_movement;

create foreign table if not exists fomema_backup_nios.fw_movement (
    "id" numeric(19),
    "branch_code" varchar(8),
    "log_date" timestamp,
    "module_code" numeric(10),
    "remarks" varchar(4000),
    "trans_id" varchar(56),
    "userid" varchar(80),
    "worker_code" varchar(1020)
) server fomema_backup options (schema_name 'nios', table_name 'fw_movement');

\echo 'created foreign table fomema_backup_nios.fw_movement';

drop foreign table if exists fomema_backup_nios.fw_quarantine_reason;

create foreign table if not exists fomema_backup_nios.fw_quarantine_reason (
    "trans_id" varchar(14),
    "reason_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'fw_quarantine_reason');

\echo 'created foreign table fomema_backup_nios.fw_quarantine_reason';

drop foreign table if exists fomema_backup_nios.fw_transaction;

create foreign table if not exists fomema_backup_nios.fw_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_transaction');

\echo 'created foreign table fomema_backup_nios.fw_transaction';

drop foreign table if exists fomema_backup_nios.fw_transaction_cancel;

create foreign table if not exists fomema_backup_nios.fw_transaction_cancel (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_transaction_cancel');

\echo 'created foreign table fomema_backup_nios.fw_transaction_cancel';

drop foreign table if exists fomema_backup_nios.fw_transaction_delete;

create foreign table if not exists fomema_backup_nios.fw_transaction_delete (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_transaction_delete');

\echo 'created foreign table fomema_backup_nios.fw_transaction_delete';

drop foreign table if exists fomema_backup_nios.fw_transaction_update;

create foreign table if not exists fomema_backup_nios.fw_transaction_update (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_transaction_update');

\echo 'created foreign table fomema_backup_nios.fw_transaction_update';

drop foreign table if exists fomema_backup_nios.fw_unsuitable_reasons;

create foreign table if not exists fomema_backup_nios.fw_unsuitable_reasons (
    "trans_id" varchar(14),
    "unsuitable_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'fw_unsuitable_reasons');

\echo 'created foreign table fomema_backup_nios.fw_unsuitable_reasons';

drop foreign table if exists fomema_backup_nios.fw_worker_replacement;

create foreign table if not exists fomema_backup_nios.fw_worker_replacement (
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
) server fomema_backup options (schema_name 'nios', table_name 'fw_worker_replacement');

\echo 'created foreign table fomema_backup_nios.fw_worker_replacement';

drop foreign table if exists fomema_backup_nios.group_details;

create foreign table if not exists fomema_backup_nios.group_details (
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
) server fomema_backup options (schema_name 'nios', table_name 'group_details');

\echo 'created foreign table fomema_backup_nios.group_details';

drop foreign table if exists fomema_backup_nios.group_doctor_pay;

create foreign table if not exists fomema_backup_nios.group_doctor_pay (
    "group_code" varchar(6),
    "pay_ind" varchar(1),
    "doctor_code" varchar(10),
    "group_status" varchar(1),
    "create_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'group_doctor_pay');

\echo 'created foreign table fomema_backup_nios.group_doctor_pay';

drop foreign table if exists fomema_backup_nios.group_worker;

create foreign table if not exists fomema_backup_nios.group_worker (
    "passport" varchar(20),
    "country" varchar(3),
    "creation_date" timestamp,
    "name" varchar(60),
    "sex" varchar(1),
    "modify_date" timestamp,
    "status" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'group_worker');

\echo 'created foreign table fomema_backup_nios.group_worker';

drop foreign table if exists fomema_backup_nios.group_xray_pay;

create foreign table if not exists fomema_backup_nios.group_xray_pay (
    "group_code" varchar(6),
    "pay_ind" varchar(1),
    "xray_code" varchar(10),
    "group_status" varchar(1),
    "create_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'group_xray_pay');

\echo 'created foreign table fomema_backup_nios.group_xray_pay';

drop foreign table if exists fomema_backup_nios.imm_block_workers;

create foreign table if not exists fomema_backup_nios.imm_block_workers (
    "worker_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'imm_block_workers');

\echo 'created foreign table fomema_backup_nios.imm_block_workers';

drop foreign table if exists fomema_backup_nios.imm_med_receive;

create foreign table if not exists fomema_backup_nios.imm_med_receive (
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
) server fomema_backup options (schema_name 'nios', table_name 'imm_med_receive');

\echo 'created foreign table fomema_backup_nios.imm_med_receive';

drop foreign table if exists fomema_backup_nios.imm_med_send;

create foreign table if not exists fomema_backup_nios.imm_med_send (
    "imm_doc_no" varchar(15),
    "imm_nat" varchar(3),
    "imm_dob" timestamp,
    "imm_name" varchar(60),
    "imm_sex" varchar(1),
    "imm_medsts" varchar(1),
    "imm_meddt" timestamp,
    "imm_moddt" timestamp,
    "imm_send" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'imm_med_send');

\echo 'created foreign table fomema_backup_nios.imm_med_send';

drop foreign table if exists fomema_backup_nios.inactive_doctors;

create foreign table if not exists fomema_backup_nios.inactive_doctors (
    "doctor_code" varchar(10),
    "date_of_inactive" timestamp,
    "reason" varchar(500)
) server fomema_backup options (schema_name 'nios', table_name 'inactive_doctors');

\echo 'created foreign table fomema_backup_nios.inactive_doctors';

drop foreign table if exists fomema_backup_nios.invoice_detail;

create foreign table if not exists fomema_backup_nios.invoice_detail (
    "invoice_no" varchar(20),
    "service_provider_code" varchar(10),
    "trans_id" varchar(14),
    "member_code" varchar(10),
    "sex" varchar(1),
    "creator_id" varchar(20),
    "creation_date" timestamp,
    "modify_id" varchar(20),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'invoice_detail');

\echo 'created foreign table fomema_backup_nios.invoice_detail';

drop foreign table if exists fomema_backup_nios.laboratory_group;

create foreign table if not exists fomema_backup_nios.laboratory_group (
    "lab_group" varchar(2),
    "description" varchar(255),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'laboratory_group');

\echo 'created foreign table fomema_backup_nios.laboratory_group';

drop foreign table if exists fomema_backup_nios.laboratory_registration;

create foreign table if not exists fomema_backup_nios.laboratory_registration (
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
) server fomema_backup options (schema_name 'nios', table_name 'laboratory_registration');

\echo 'created foreign table fomema_backup_nios.laboratory_registration';

drop foreign table if exists fomema_backup_nios.laboratory_request;

create foreign table if not exists fomema_backup_nios.laboratory_request (
    "lregid" numeric(10),
    "approval_id" numeric(10),
    "status" varchar(5),
    "comments" varchar(4000),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'laboratory_request');

\echo 'created foreign table fomema_backup_nios.laboratory_request';

drop foreign table if exists fomema_backup_nios.labuan_g_workers;

create foreign table if not exists fomema_backup_nios.labuan_g_workers (
    "worker_code" varchar(10),
    "created_by" varchar(30),
    "transdate" timestamp,
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'labuan_g_workers');

\echo 'created foreign table fomema_backup_nios.labuan_g_workers';

drop foreign table if exists fomema_backup_nios.labws_applicationid;

create foreign table if not exists fomema_backup_nios.labws_applicationid (
    "appid" varchar(3),
    "active" char(1),
    "description" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'labws_applicationid');

\echo 'created foreign table fomema_backup_nios.labws_applicationid';

drop foreign table if exists fomema_backup_nios.lab_change_request;

create foreign table if not exists fomema_backup_nios.lab_change_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'lab_change_request');

\echo 'created foreign table fomema_backup_nios.lab_change_request';

drop foreign table if exists fomema_backup_nios.lab_change_request_detail;

create foreign table if not exists fomema_backup_nios.lab_change_request_detail (
    "lab_cr_id" numeric(10),
    "cr_column" varchar(100),
    "cr_old" varchar(100),
    "cr_new" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'lab_change_request_detail');

\echo 'created foreign table fomema_backup_nios.lab_change_request_detail';

drop foreign table if exists fomema_backup_nios.lab_payment;

create foreign table if not exists fomema_backup_nios.lab_payment (
    "trans_id" varchar(14),
    "lab_code" varchar(10),
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "sex" varchar(1),
    "transdate" timestamp,
    "certify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'lab_payment');

\echo 'created foreign table fomema_backup_nios.lab_payment';

drop foreign table if exists fomema_backup_nios.last_monitor;

create foreign table if not exists fomema_backup_nios.last_monitor (
    "monitor_type" varchar(50),
    "last_run" timestamp,
    "last_start" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'last_monitor');

\echo 'created foreign table fomema_backup_nios.last_monitor';

drop foreign table if exists fomema_backup_nios.last_rev_sync;

create foreign table if not exists fomema_backup_nios.last_rev_sync (
    "table_name" varchar(100),
    "sync_start" timestamp,
    "sync_end" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'last_rev_sync');

\echo 'created foreign table fomema_backup_nios.last_rev_sync';

drop foreign table if exists fomema_backup_nios.last_sync;

create foreign table if not exists fomema_backup_nios.last_sync (
    "table_name" varchar(100),
    "sync_start" timestamp,
    "sync_end" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'last_sync');

\echo 'created foreign table fomema_backup_nios.last_sync';

drop foreign table if exists fomema_backup_nios.letter_monitor;

create foreign table if not exists fomema_backup_nios.letter_monitor (
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
) server fomema_backup options (schema_name 'nios', table_name 'letter_monitor');

\echo 'created foreign table fomema_backup_nios.letter_monitor';

drop foreign table if exists fomema_backup_nios.letter_monitor_detail;

create foreign table if not exists fomema_backup_nios.letter_monitor_detail (
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
) server fomema_backup options (schema_name 'nios', table_name 'letter_monitor_detail');

\echo 'created foreign table fomema_backup_nios.letter_monitor_detail';

drop foreign table if exists fomema_backup_nios.load_info;

create foreign table if not exists fomema_backup_nios.load_info (
    "last_exam_date" timestamp,
    "passport_no" varchar(20),
    "fit_ind" varchar(1),
    "arrival_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'load_info');

\echo 'created foreign table fomema_backup_nios.load_info';

drop foreign table if exists fomema_backup_nios.lqcc_comments;

create foreign table if not exists fomema_backup_nios.lqcc_comments (
    "lq_commentid" numeric(10),
    "lqccid" numeric(10),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'lqcc_comments');

\echo 'created foreign table fomema_backup_nios.lqcc_comments';

drop foreign table if exists fomema_backup_nios.lqcc_report;

create foreign table if not exists fomema_backup_nios.lqcc_report (
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
) server fomema_backup options (schema_name 'nios', table_name 'lqcc_report');

\echo 'created foreign table fomema_backup_nios.lqcc_report';

drop foreign table if exists fomema_backup_nios.maxigrid;

create foreign table if not exists fomema_backup_nios.maxigrid (
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
) server fomema_backup options (schema_name 'nios', table_name 'maxigrid');

\echo 'created foreign table fomema_backup_nios.maxigrid';

drop foreign table if exists fomema_backup_nios.merts_doc_startpage_stats;

create foreign table if not exists fomema_backup_nios.merts_doc_startpage_stats (
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
) server fomema_backup options (schema_name 'nios', table_name 'merts_doc_startpage_stats');

\echo 'created foreign table fomema_backup_nios.merts_doc_startpage_stats';

drop foreign table if exists fomema_backup_nios.merts_lab_startpage_stats;

create foreign table if not exists fomema_backup_nios.merts_lab_startpage_stats (
    "lab_code" varchar(10),
    "delayed_transmission" numeric,
    "last_updated" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'merts_lab_startpage_stats');

\echo 'created foreign table fomema_backup_nios.merts_lab_startpage_stats';

drop foreign table if exists fomema_backup_nios.merts_xray_startpage_stats;

create foreign table if not exists fomema_backup_nios.merts_xray_startpage_stats (
    "xray_code" varchar(10),
    "delayed_transmission" numeric,
    "film_notyet_send" numeric,
    "last_updated" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'merts_xray_startpage_stats');

\echo 'created foreign table fomema_backup_nios.merts_xray_startpage_stats';

drop foreign table if exists fomema_backup_nios.missing_payment;

create foreign table if not exists fomema_backup_nios.missing_payment (
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
) server fomema_backup options (schema_name 'nios', table_name 'missing_payment');

\echo 'created foreign table fomema_backup_nios.missing_payment';

drop foreign table if exists fomema_backup_nios.module_page;

create foreign table if not exists fomema_backup_nios.module_page (
    "pageid" numeric(10),
    "moduleid" numeric(10),
    "filename" varchar(50),
    "description" varchar(255),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'module_page');

\echo 'created foreign table fomema_backup_nios.module_page';

drop foreign table if exists fomema_backup_nios.moh_doc_report;

create foreign table if not exists fomema_backup_nios.moh_doc_report (
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
) server fomema_backup options (schema_name 'nios', table_name 'moh_doc_report');

\echo 'created foreign table fomema_backup_nios.moh_doc_report';

drop foreign table if exists fomema_backup_nios.moh_doc_stat;

create foreign table if not exists fomema_backup_nios.moh_doc_stat (
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
) server fomema_backup options (schema_name 'nios', table_name 'moh_doc_stat');

\echo 'created foreign table fomema_backup_nios.moh_doc_stat';

drop foreign table if exists fomema_backup_nios.monitoring;

create foreign table if not exists fomema_backup_nios.monitoring (
    "worker_code" varchar(10),
    "worker_name" varchar(30),
    "passport_no" varchar(10),
    "renewal_date" timestamp,
    "certify_date" timestamp,
    "status" varchar(5),
    "remarks" varchar(200)
) server fomema_backup options (schema_name 'nios', table_name 'monitoring');

\echo 'created foreign table fomema_backup_nios.monitoring';

drop foreign table if exists fomema_backup_nios.monitor_exam;

create foreign table if not exists fomema_backup_nios.monitor_exam (
    "worker_code" varchar(10),
    "trans_id" varchar(14),
    "issue_letter_ind" varchar(1),
    "issue_date" timestamp,
    "ins_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'monitor_exam');

\echo 'created foreign table fomema_backup_nios.monitor_exam';

drop foreign table if exists fomema_backup_nios.myimms_mon_tcupi;

create foreign table if not exists fomema_backup_nios.myimms_mon_tcupi (
    "trans_id" varchar(14),
    "passport_no" varchar(15)
) server fomema_backup options (schema_name 'nios', table_name 'myimms_mon_tcupi');

\echo 'created foreign table fomema_backup_nios.myimms_mon_tcupi';

drop foreign table if exists fomema_backup_nios.myimms_queue;

create foreign table if not exists fomema_backup_nios.myimms_queue (
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
) server fomema_backup options (schema_name 'nios', table_name 'myimms_queue');

\echo 'created foreign table fomema_backup_nios.myimms_queue';

drop foreign table if exists fomema_backup_nios.myimms_queue_hist;

create foreign table if not exists fomema_backup_nios.myimms_queue_hist (
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
) server fomema_backup options (schema_name 'nios', table_name 'myimms_queue_hist');

\echo 'created foreign table fomema_backup_nios.myimms_queue_hist';

drop foreign table if exists fomema_backup_nios.new_arri;

create foreign table if not exists fomema_backup_nios.new_arri (
    "regn_date" timestamp,
    "old_clinic" varchar(70),
    "new_clinic" varchar(50),
    "doctor_code" varchar(10),
    "worker_code" varchar(10),
    "country_name" varchar(50),
    "fitness" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'new_arri');

\echo 'created foreign table fomema_backup_nios.new_arri';

drop foreign table if exists fomema_backup_nios.nios_lab_payment;

create foreign table if not exists fomema_backup_nios.nios_lab_payment (
    "laboratory_code" varchar(10),
    "worker_code" varchar(10),
    "worker_name" varchar(50),
    "sex" varchar(1),
    "transdate" timestamp,
    "certify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'nios_lab_payment');

\echo 'created foreign table fomema_backup_nios.nios_lab_payment';

drop foreign table if exists fomema_backup_nios.nios_setting;

create foreign table if not exists fomema_backup_nios.nios_setting (
    "id" numeric(19),
    "version" numeric(19),
    "create_date" timestamp,
    "creator_id" numeric(10),
    "description" varchar(400),
    "parameter" varchar(120),
    "value" varchar(200)
) server fomema_backup options (schema_name 'nios', table_name 'nios_setting');

\echo 'created foreign table fomema_backup_nios.nios_setting';

drop foreign table if exists fomema_backup_nios.non_transmission;

create foreign table if not exists fomema_backup_nios.non_transmission (
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
) server fomema_backup options (schema_name 'nios', table_name 'non_transmission');

\echo 'created foreign table fomema_backup_nios.non_transmission';

drop foreign table if exists fomema_backup_nios.notification;

create foreign table if not exists fomema_backup_nios.notification (
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
) server fomema_backup options (schema_name 'nios', table_name 'notification');

\echo 'created foreign table fomema_backup_nios.notification';

drop foreign table if exists fomema_backup_nios.operation_comments;

create foreign table if not exists fomema_backup_nios.operation_comments (
    "commentid" numeric(10),
    "bc_user_code" varchar(13),
    "category" varchar(5),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'operation_comments');

\echo 'created foreign table fomema_backup_nios.operation_comments';

drop foreign table if exists fomema_backup_nios.pati_renew;

create foreign table if not exists fomema_backup_nios.pati_renew (
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "reg_ind" numeric
) server fomema_backup options (schema_name 'nios', table_name 'pati_renew');

\echo 'created foreign table fomema_backup_nios.pati_renew';

drop foreign table if exists fomema_backup_nios.payment;

create foreign table if not exists fomema_backup_nios.payment (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment');

\echo 'created foreign table fomema_backup_nios.payment';

drop foreign table if exists fomema_backup_nios.payment_method;

create foreign table if not exists fomema_backup_nios.payment_method (
    "payment_type" numeric(4),
    "description" varchar(255),
    "service_type" varchar(2),
    "status" numeric(1),
    "isfoc" numeric,
    "surcharge" numeric(126)
) server fomema_backup options (schema_name 'nios', table_name 'payment_method');

\echo 'created foreign table fomema_backup_nios.payment_method';

drop foreign table if exists fomema_backup_nios.payment_refund;

create foreign table if not exists fomema_backup_nios.payment_refund (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment_refund');

\echo 'created foreign table fomema_backup_nios.payment_refund';

drop foreign table if exists fomema_backup_nios.payment_refund_approval;

create foreign table if not exists fomema_backup_nios.payment_refund_approval (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment_refund_approval');

\echo 'created foreign table fomema_backup_nios.payment_refund_approval';

drop foreign table if exists fomema_backup_nios.payment_reject;

create foreign table if not exists fomema_backup_nios.payment_reject (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment_reject');

\echo 'created foreign table fomema_backup_nios.payment_reject';

drop foreign table if exists fomema_backup_nios.payment_req;

create foreign table if not exists fomema_backup_nios.payment_req (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment_req');

\echo 'created foreign table fomema_backup_nios.payment_req';

drop foreign table if exists fomema_backup_nios.payment_status;

create foreign table if not exists fomema_backup_nios.payment_status (
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
) server fomema_backup options (schema_name 'nios', table_name 'payment_status');

\echo 'created foreign table fomema_backup_nios.payment_status';

drop foreign table if exists fomema_backup_nios.pay_transaction;

create foreign table if not exists fomema_backup_nios.pay_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'pay_transaction');

\echo 'created foreign table fomema_backup_nios.pay_transaction';

drop foreign table if exists fomema_backup_nios.pay_trans_manual;

create foreign table if not exists fomema_backup_nios.pay_trans_manual (
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
) server fomema_backup options (schema_name 'nios', table_name 'pay_trans_manual');

\echo 'created foreign table fomema_backup_nios.pay_trans_manual';

drop foreign table if exists fomema_backup_nios.pbcatcol;

create foreign table if not exists fomema_backup_nios.pbcatcol (
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
) server fomema_backup options (schema_name 'nios', table_name 'pbcatcol');

\echo 'created foreign table fomema_backup_nios.pbcatcol';

drop foreign table if exists fomema_backup_nios.pbcatedt;

create foreign table if not exists fomema_backup_nios.pbcatedt (
    "pbe_name" varchar(30),
    "pbe_edit" varchar(254),
    "pbe_type" numeric,
    "pbe_cntr" numeric,
    "pbe_seqn" numeric,
    "pbe_flag" numeric,
    "pbe_work" varchar(32)
) server fomema_backup options (schema_name 'nios', table_name 'pbcatedt');

\echo 'created foreign table fomema_backup_nios.pbcatedt';

drop foreign table if exists fomema_backup_nios.pbcatfmt;

create foreign table if not exists fomema_backup_nios.pbcatfmt (
    "pbf_name" varchar(30),
    "pbf_frmt" varchar(254),
    "pbf_type" numeric,
    "pbf_cntr" numeric
) server fomema_backup options (schema_name 'nios', table_name 'pbcatfmt');

\echo 'created foreign table fomema_backup_nios.pbcatfmt';

drop foreign table if exists fomema_backup_nios.pbcattbl;

create foreign table if not exists fomema_backup_nios.pbcattbl (
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
) server fomema_backup options (schema_name 'nios', table_name 'pbcattbl');

\echo 'created foreign table fomema_backup_nios.pbcattbl';

drop foreign table if exists fomema_backup_nios.pbcatvld;

create foreign table if not exists fomema_backup_nios.pbcatvld (
    "pbv_name" varchar(30),
    "pbv_vald" varchar(254),
    "pbv_type" numeric,
    "pbv_cntr" numeric,
    "pbv_msg" varchar(254)
) server fomema_backup options (schema_name 'nios', table_name 'pbcatvld');

\echo 'created foreign table fomema_backup_nios.pbcatvld';

drop foreign table if exists fomema_backup_nios.pcr_transaction;

create foreign table if not exists fomema_backup_nios.pcr_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'pcr_transaction');

\echo 'created foreign table fomema_backup_nios.pcr_transaction';

drop foreign table if exists fomema_backup_nios.pcr_trans_comments;

create foreign table if not exists fomema_backup_nios.pcr_trans_comments (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000)
) server fomema_backup options (schema_name 'nios', table_name 'pcr_trans_comments');

\echo 'created foreign table fomema_backup_nios.pcr_trans_comments';

drop foreign table if exists fomema_backup_nios.pcr_trans_detail;

create foreign table if not exists fomema_backup_nios.pcr_trans_detail (
    "trans_id" varchar(14),
    "parameter_code" varchar(10),
    "parameter_value" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'pcr_trans_detail');

\echo 'created foreign table fomema_backup_nios.pcr_trans_detail';

drop foreign table if exists fomema_backup_nios.pincode_req;

create foreign table if not exists fomema_backup_nios.pincode_req (
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
) server fomema_backup options (schema_name 'nios', table_name 'pincode_req');

\echo 'created foreign table fomema_backup_nios.pincode_req';

drop foreign table if exists fomema_backup_nios.ply_transaction;

create foreign table if not exists fomema_backup_nios.ply_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'ply_transaction');

\echo 'created foreign table fomema_backup_nios.ply_transaction';

drop foreign table if exists fomema_backup_nios.ply_transaction_hist;

create foreign table if not exists fomema_backup_nios.ply_transaction_hist (
    "plyid" numeric(10),
    "tranno" varchar(10),
    "bc_worker_code" varchar(13),
    "trans_id" varchar(14),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "status" varchar(5)
) server fomema_backup options (schema_name 'nios', table_name 'ply_transaction_hist');

\echo 'created foreign table fomema_backup_nios.ply_transaction_hist';

drop foreign table if exists fomema_backup_nios.quarantine_fw_doc;

create foreign table if not exists fomema_backup_nios.quarantine_fw_doc (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_fw_doc');

\echo 'created foreign table fomema_backup_nios.quarantine_fw_doc';

drop foreign table if exists fomema_backup_nios.quarantine_fw_doc_hist;

create foreign table if not exists fomema_backup_nios.quarantine_fw_doc_hist (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_fw_doc_hist');

\echo 'created foreign table fomema_backup_nios.quarantine_fw_doc_hist';

drop foreign table if exists fomema_backup_nios.quarantine_fw_reason;

create foreign table if not exists fomema_backup_nios.quarantine_fw_reason (
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "reason_code" varchar(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_fw_reason');

\echo 'created foreign table fomema_backup_nios.quarantine_fw_reason';

drop foreign table if exists fomema_backup_nios.quarantine_fw_reason_hist;

create foreign table if not exists fomema_backup_nios.quarantine_fw_reason_hist (
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "reason_code" varchar(10),
    "creation_date" timestamp,
    "delete_date" timestamp,
    "delete_by" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_fw_reason_hist');

\echo 'created foreign table fomema_backup_nios.quarantine_fw_reason_hist';

drop foreign table if exists fomema_backup_nios.quarantine_insp_findings;

create foreign table if not exists fomema_backup_nios.quarantine_insp_findings (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_insp_findings');

\echo 'created foreign table fomema_backup_nios.quarantine_insp_findings';

drop foreign table if exists fomema_backup_nios.quarantine_insp_findings_hist;

create foreign table if not exists fomema_backup_nios.quarantine_insp_findings_hist (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_insp_findings_hist');

\echo 'created foreign table fomema_backup_nios.quarantine_insp_findings_hist';

drop foreign table if exists fomema_backup_nios.quarantine_reason;

create foreign table if not exists fomema_backup_nios.quarantine_reason (
    "reason_code" varchar(10),
    "reason" varchar(1000),
    "active" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_reason');

\echo 'created foreign table fomema_backup_nios.quarantine_reason';

drop foreign table if exists fomema_backup_nios.quarantine_reason_group;

create foreign table if not exists fomema_backup_nios.quarantine_reason_group (
    "capid" numeric(18),
    "reason_code" varchar(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_reason_group');

\echo 'created foreign table fomema_backup_nios.quarantine_reason_group';

drop foreign table if exists fomema_backup_nios.quarantine_release_approval;

create foreign table if not exists fomema_backup_nios.quarantine_release_approval (
    "qrreqid" numeric(10),
    "qrrid" numeric(10),
    "status" varchar(1),
    "comments" varchar(4000),
    "approval_id" numeric(10),
    "approval_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_release_approval');

\echo 'created foreign table fomema_backup_nios.quarantine_release_approval';

drop foreign table if exists fomema_backup_nios.quarantine_release_request;

create foreign table if not exists fomema_backup_nios.quarantine_release_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_release_request');

\echo 'created foreign table fomema_backup_nios.quarantine_release_request';

drop foreign table if exists fomema_backup_nios.quarantine_status_pending;

create foreign table if not exists fomema_backup_nios.quarantine_status_pending (
    "bc_worker_code" varchar(13),
    "old_status" varchar(1),
    "new_status" varchar(1),
    "userid" numeric(10),
    "mod_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_status_pending');

\echo 'created foreign table fomema_backup_nios.quarantine_status_pending';

drop foreign table if exists fomema_backup_nios.quarantine_tcupi_todolist;

create foreign table if not exists fomema_backup_nios.quarantine_tcupi_todolist (
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
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_tcupi_todolist');

\echo 'created foreign table fomema_backup_nios.quarantine_tcupi_todolist';

drop foreign table if exists fomema_backup_nios.quarantine_transfer;

create foreign table if not exists fomema_backup_nios.quarantine_transfer (
    "trans_id" varchar(14),
    "worker_code" varchar(13),
    "transfer_mode" numeric(1),
    "comments" varchar(1000),
    "creator_id" varchar(50),
    "create_date" timestamp,
    "modifier_id" varchar(50),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'quarantine_transfer');

\echo 'created foreign table fomema_backup_nios.quarantine_transfer';

drop foreign table if exists fomema_backup_nios.quest_com_products;

create foreign table if not exists fomema_backup_nios.quest_com_products (
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
) server fomema_backup options (schema_name 'nios', table_name 'quest_com_products');

\echo 'created foreign table fomema_backup_nios.quest_com_products';

drop foreign table if exists fomema_backup_nios.quest_com_products_used_by;

create foreign table if not exists fomema_backup_nios.quest_com_products_used_by (
    "product_id" numeric,
    "used_by_product_id" numeric,
    "product_version" varchar(20),
    "install_user" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'quest_com_products_used_by');

\echo 'created foreign table fomema_backup_nios.quest_com_products_used_by';

drop foreign table if exists fomema_backup_nios.quest_com_product_privs;

create foreign table if not exists fomema_backup_nios.quest_com_product_privs (
    "product_id" numeric,
    "privilege_id" varchar(60),
    "privilege_description" varchar(256),
    "validation_routine" varchar(2000),
    "privilege_level" varchar(256),
    "install_user" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'quest_com_product_privs');

\echo 'created foreign table fomema_backup_nios.quest_com_product_privs';

drop foreign table if exists fomema_backup_nios.quest_com_users;

create foreign table if not exists fomema_backup_nios.quest_com_users (
    "user_id" numeric,
    "product_id" numeric,
    "authorization_level" varchar(60),
    "install_user" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'quest_com_users');

\echo 'created foreign table fomema_backup_nios.quest_com_users';

drop foreign table if exists fomema_backup_nios.quest_com_user_privileges;

create foreign table if not exists fomema_backup_nios.quest_com_user_privileges (
    "product_id" numeric,
    "user_id" numeric,
    "privilege_id" varchar(60),
    "privilege_level" varchar(2000),
    "install_user" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'quest_com_user_privileges');

\echo 'created foreign table fomema_backup_nios.quest_com_user_privileges';

drop foreign table if exists fomema_backup_nios.receipt;

create foreign table if not exists fomema_backup_nios.receipt (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt');

\echo 'created foreign table fomema_backup_nios.receipt';

drop foreign table if exists fomema_backup_nios.receipt_change_reason;

create foreign table if not exists fomema_backup_nios.receipt_change_reason (
    "rregid" numeric(10),
    "tranno" varchar(10),
    "reason_type" varchar(5),
    "reason" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_change_reason');

\echo 'created foreign table fomema_backup_nios.receipt_change_reason';

drop foreign table if exists fomema_backup_nios.receipt_change_type;

create foreign table if not exists fomema_backup_nios.receipt_change_type (
    "reason_type" numeric(10),
    "description" varchar(255),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_change_type');

\echo 'created foreign table fomema_backup_nios.receipt_change_type';

drop foreign table if exists fomema_backup_nios.receipt_detail;

create foreign table if not exists fomema_backup_nios.receipt_detail (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_detail');

\echo 'created foreign table fomema_backup_nios.receipt_detail';

drop foreign table if exists fomema_backup_nios.receipt_detail_sabah;

create foreign table if not exists fomema_backup_nios.receipt_detail_sabah (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_detail_sabah');

\echo 'created foreign table fomema_backup_nios.receipt_detail_sabah';

drop foreign table if exists fomema_backup_nios.receipt_gender_change;

create foreign table if not exists fomema_backup_nios.receipt_gender_change (
    "receipt_gender_id" numeric(10),
    "tranno" varchar(10),
    "male_diff" numeric(5),
    "female_diff" numeric(5),
    "amount_diff" numeric(10),
    "create_by" numeric(10),
    "create_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'receipt_gender_change');

\echo 'created foreign table fomema_backup_nios.receipt_gender_change';

drop foreign table if exists fomema_backup_nios.receipt_kiv_request;

create foreign table if not exists fomema_backup_nios.receipt_kiv_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_kiv_request');

\echo 'created foreign table fomema_backup_nios.receipt_kiv_request';

drop foreign table if exists fomema_backup_nios.receipt_medcon;

create foreign table if not exists fomema_backup_nios.receipt_medcon (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_medcon');

\echo 'created foreign table fomema_backup_nios.receipt_medcon';

drop foreign table if exists fomema_backup_nios.receipt_prefer_doctor;

create foreign table if not exists fomema_backup_nios.receipt_prefer_doctor (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_prefer_doctor');

\echo 'created foreign table fomema_backup_nios.receipt_prefer_doctor';

drop foreign table if exists fomema_backup_nios.receipt_sabah;

create foreign table if not exists fomema_backup_nios.receipt_sabah (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_sabah');

\echo 'created foreign table fomema_backup_nios.receipt_sabah';

drop foreign table if exists fomema_backup_nios.receipt_service;

create foreign table if not exists fomema_backup_nios.receipt_service (
    "service_type" varchar(2),
    "description" varchar(255),
    "status" varchar(5),
    "service_charge" numeric,
    "use_by" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'receipt_service');

\echo 'created foreign table fomema_backup_nios.receipt_service';

drop foreign table if exists fomema_backup_nios.receipt_usage;

create foreign table if not exists fomema_backup_nios.receipt_usage (
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
) server fomema_backup options (schema_name 'nios', table_name 'receipt_usage');

\echo 'created foreign table fomema_backup_nios.receipt_usage';

drop foreign table if exists fomema_backup_nios.refund;

create foreign table if not exists fomema_backup_nios.refund (
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
) server fomema_backup options (schema_name 'nios', table_name 'refund');

\echo 'created foreign table fomema_backup_nios.refund';

drop foreign table if exists fomema_backup_nios.refund_detail;

create foreign table if not exists fomema_backup_nios.refund_detail (
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
) server fomema_backup options (schema_name 'nios', table_name 'refund_detail');

\echo 'created foreign table fomema_backup_nios.refund_detail';

drop foreign table if exists fomema_backup_nios.refund_fomic;

create foreign table if not exists fomema_backup_nios.refund_fomic (
    "worker_code" varchar(10),
    "trans_id" varchar(14),
    "transdate" timestamp,
    "invalidate_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'refund_fomic');

\echo 'created foreign table fomema_backup_nios.refund_fomic';

drop foreign table if exists fomema_backup_nios.refund_fomic_final;

create foreign table if not exists fomema_backup_nios.refund_fomic_final (
    "worker_code" varchar(10),
    "trans_id" varchar(14),
    "transdate" timestamp,
    "invalidate_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'refund_fomic_final');

\echo 'created foreign table fomema_backup_nios.refund_fomic_final';

drop foreign table if exists fomema_backup_nios.ref_double;

create foreign table if not exists fomema_backup_nios.ref_double (
    "worker_code" varchar(10),
    "count" numeric
) server fomema_backup options (schema_name 'nios', table_name 'ref_double');

\echo 'created foreign table fomema_backup_nios.ref_double';

drop foreign table if exists fomema_backup_nios.rel_qrtn;

create foreign table if not exists fomema_backup_nios.rel_qrtn (
    "worker_code" varchar(10),
    "release_date" timestamp,
    "transdate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rel_qrtn');

\echo 'created foreign table fomema_backup_nios.rel_qrtn';

drop foreign table if exists fomema_backup_nios.renewal_comments;

create foreign table if not exists fomema_backup_nios.renewal_comments (
    "bc_worker_code" varchar(13),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp,
    "renew_type" numeric,
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'renewal_comments');

\echo 'created foreign table fomema_backup_nios.renewal_comments';

drop foreign table if exists fomema_backup_nios.renewal_worker;

create foreign table if not exists fomema_backup_nios.renewal_worker (
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
) server fomema_backup options (schema_name 'nios', table_name 'renewal_worker');

\echo 'created foreign table fomema_backup_nios.renewal_worker';

drop foreign table if exists fomema_backup_nios.replace_table;

create foreign table if not exists fomema_backup_nios.replace_table (
    "worker_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'replace_table');

\echo 'created foreign table fomema_backup_nios.replace_table';

drop foreign table if exists fomema_backup_nios.reply_table;

create foreign table if not exists fomema_backup_nios.reply_table (
    "req_id" varchar(16),
    "error_code" varchar(5),
    "response_to_query" varchar(2000),
    "reply_read" varchar(1),
    "reply_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'reply_table');

\echo 'created foreign table fomema_backup_nios.reply_table';

drop foreign table if exists fomema_backup_nios.reply_table_arc;

create foreign table if not exists fomema_backup_nios.reply_table_arc (
    "req_id" varchar(16),
    "error_code" varchar(5),
    "response_to_query" varchar(2000),
    "reply_read" varchar(1),
    "reply_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'reply_table_arc');

\echo 'created foreign table fomema_backup_nios.reply_table_arc';

drop foreign table if exists fomema_backup_nios.reply_table_old;

create foreign table if not exists fomema_backup_nios.reply_table_old (
    "req_id" varchar(16),
    "error_code" varchar(5),
    "response_to_query" varchar(2000),
    "reply_read" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'reply_table_old');

\echo 'created foreign table fomema_backup_nios.reply_table_old';

drop foreign table if exists fomema_backup_nios.report_diff_bloodgroup;

create foreign table if not exists fomema_backup_nios.report_diff_bloodgroup (
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
) server fomema_backup options (schema_name 'nios', table_name 'report_diff_bloodgroup');

\echo 'created foreign table fomema_backup_nios.report_diff_bloodgroup';

drop foreign table if exists fomema_backup_nios.report_group;

create foreign table if not exists fomema_backup_nios.report_group (
    "groupid" numeric(10),
    "capid" numeric(10),
    "seq" numeric(10),
    "reportname" varchar(255),
    "contextname" varchar(50),
    "indexpage" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'report_group');

\echo 'created foreign table fomema_backup_nios.report_group';

drop foreign table if exists fomema_backup_nios.report_receive;

create foreign table if not exists fomema_backup_nios.report_receive (
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
) server fomema_backup options (schema_name 'nios', table_name 'report_receive');

\echo 'created foreign table fomema_backup_nios.report_receive';

drop foreign table if exists fomema_backup_nios.report_session;

create foreign table if not exists fomema_backup_nios.report_session (
    "reportid" numeric(10),
    "sessionid" varchar(50),
    "remote_address" varchar(50),
    "last_access" timestamp,
    "timeout" numeric(10),
    "xmldom" varchar
) server fomema_backup options (schema_name 'nios', table_name 'report_session');

\echo 'created foreign table fomema_backup_nios.report_session';

drop foreign table if exists fomema_backup_nios.request_table;

create foreign table if not exists fomema_backup_nios.request_table (
    "req_id" varchar(16),
    "req_type" varchar(2),
    "participants_details" varchar(2000),
    "request_read" varchar(1),
    "request_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'request_table');

\echo 'created foreign table fomema_backup_nios.request_table';

drop foreign table if exists fomema_backup_nios.request_table_arc;

create foreign table if not exists fomema_backup_nios.request_table_arc (
    "req_id" varchar(16),
    "req_type" varchar(2),
    "participants_details" varchar(2000),
    "request_read" varchar(1),
    "request_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'request_table_arc');

\echo 'created foreign table fomema_backup_nios.request_table_arc';

drop foreign table if exists fomema_backup_nios.request_table_old;

create foreign table if not exists fomema_backup_nios.request_table_old (
    "req_id" varchar(16),
    "req_type" varchar(2),
    "participants_details" varchar(2000),
    "request_read" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'request_table_old');

\echo 'created foreign table fomema_backup_nios.request_table_old';

drop foreign table if exists fomema_backup_nios.rev_sync_table;

create foreign table if not exists fomema_backup_nios.rev_sync_table (
    "table_name" varchar(100),
    "sequence" numeric
) server fomema_backup options (schema_name 'nios', table_name 'rev_sync_table');

\echo 'created foreign table fomema_backup_nios.rev_sync_table';

drop foreign table if exists fomema_backup_nios.rfw_batch_transaction;

create foreign table if not exists fomema_backup_nios.rfw_batch_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'rfw_batch_transaction');

\echo 'created foreign table fomema_backup_nios.rfw_batch_transaction';

drop foreign table if exists fomema_backup_nios.rfw_case_transaction;

create foreign table if not exists fomema_backup_nios.rfw_case_transaction (
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
) server fomema_backup options (schema_name 'nios', table_name 'rfw_case_transaction');

\echo 'created foreign table fomema_backup_nios.rfw_case_transaction';

drop foreign table if exists fomema_backup_nios.rfw_comment;

create foreign table if not exists fomema_backup_nios.rfw_comment (
    "rfwtrans_id" varchar(14),
    "parameter_code" varchar(10),
    "comments" varchar(1000)
) server fomema_backup options (schema_name 'nios', table_name 'rfw_comment');

\echo 'created foreign table fomema_backup_nios.rfw_comment';

drop foreign table if exists fomema_backup_nios.rfw_detail;

create foreign table if not exists fomema_backup_nios.rfw_detail (
    "rfwtrans_id" varchar(14),
    "parameter_code" varchar(10),
    "parameter_value" varchar(20),
    "med_history" varchar(1),
    "effected_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rfw_detail');

\echo 'created foreign table fomema_backup_nios.rfw_detail';

drop foreign table if exists fomema_backup_nios.rfw_fw_transaction;

create foreign table if not exists fomema_backup_nios.rfw_fw_transaction (
    "rfwtrans_id" varchar(14),
    "rtrans_id" varchar(14),
    "laboratory_code" varchar(10),
    "bc_laboratory_code" varchar(13),
    "lab_submit_date" timestamp,
    "lab_specimen_date" timestamp,
    "bld_grp" varchar(2),
    "rh" varchar(1),
    "version_no" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'rfw_fw_transaction');

\echo 'created foreign table fomema_backup_nios.rfw_fw_transaction';

drop foreign table if exists fomema_backup_nios.rfw_labchange_trans;

create foreign table if not exists fomema_backup_nios.rfw_labchange_trans (
    "rfwtrans_id" varchar(14),
    "bc_laboratory_code" varchar(13),
    "bc_old_laboratory_code" varchar(13),
    "comments" varchar(4000),
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'rfw_labchange_trans');

\echo 'created foreign table fomema_backup_nios.rfw_labchange_trans';

drop foreign table if exists fomema_backup_nios.role_capability;

create foreign table if not exists fomema_backup_nios.role_capability (
    "roleid" numeric(10),
    "capid" numeric(10),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'role_capability');

\echo 'created foreign table fomema_backup_nios.role_capability';

drop foreign table if exists fomema_backup_nios.rp;

create foreign table if not exists fomema_backup_nios.rp (
    "capid" numeric(10),
    "description" varchar(100),
    "category" numeric(10),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp,
    "longdesc" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'rp');

\echo 'created foreign table fomema_backup_nios.rp';

drop foreign table if exists fomema_backup_nios.r_del_dup;

create foreign table if not exists fomema_backup_nios.r_del_dup (
    "worker_code" varchar(10),
    "tot" numeric
) server fomema_backup options (schema_name 'nios', table_name 'r_del_dup');

\echo 'created foreign table fomema_backup_nios.r_del_dup';

drop foreign table if exists fomema_backup_nios.sabah_doc_post;

create foreign table if not exists fomema_backup_nios.sabah_doc_post (
    "doctor_code" varchar(10),
    "doctor_name" varchar(50),
    "clinic_name" varchar(50),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "state_code" varchar(7),
    "district_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'sabah_doc_post');

\echo 'created foreign table fomema_backup_nios.sabah_doc_post';

drop foreign table if exists fomema_backup_nios.sabah_transid;

create foreign table if not exists fomema_backup_nios.sabah_transid (
    "trans_id" varchar(14),
    "new_trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'sabah_transid');

\echo 'created foreign table fomema_backup_nios.sabah_transid';

drop foreign table if exists fomema_backup_nios.scb_hp_dx;

create foreign table if not exists fomema_backup_nios.scb_hp_dx (
    "doc_xray_code" varchar(10),
    "doc_xray_ind" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'scb_hp_dx');

\echo 'created foreign table fomema_backup_nios.scb_hp_dx';

drop foreign table if exists fomema_backup_nios.scb_pay_xray_nameandadd;

create foreign table if not exists fomema_backup_nios.scb_pay_xray_nameandadd (
    "xray_code" varchar(10),
    "xray_payee_name" varchar(50),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "district_code" varchar(7),
    "state_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'scb_pay_xray_nameandadd');

\echo 'created foreign table fomema_backup_nios.scb_pay_xray_nameandadd';

drop foreign table if exists fomema_backup_nios.scb_sabah_doc_post;

create foreign table if not exists fomema_backup_nios.scb_sabah_doc_post (
    "doctor_code" varchar(10),
    "doctor_name" varchar(50),
    "clinic_name" varchar(50),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "state_code" varchar(7),
    "district_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'scb_sabah_doc_post');

\echo 'created foreign table fomema_backup_nios.scb_sabah_doc_post';

drop foreign table if exists fomema_backup_nios.scb_xray_not_done;

create foreign table if not exists fomema_backup_nios.scb_xray_not_done (
    "xray_code" varchar(10),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "certify_date" timestamp,
    "xray_submit_date" timestamp,
    "release_date" timestamp,
    "xray_ded" numeric(3)
) server fomema_backup options (schema_name 'nios', table_name 'scb_xray_not_done');

\echo 'created foreign table fomema_backup_nios.scb_xray_not_done';

drop foreign table if exists fomema_backup_nios.scb_xray_payin_list;

create foreign table if not exists fomema_backup_nios.scb_xray_payin_list (
    "xray_code" varchar(10),
    "xray_payee_name" varchar(50),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "district_code" varchar(7),
    "state_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'scb_xray_payin_list');

\echo 'created foreign table fomema_backup_nios.scb_xray_payin_list';

drop foreign table if exists fomema_backup_nios.scb_xray_pay_new_address;

create foreign table if not exists fomema_backup_nios.scb_xray_pay_new_address (
    "xray_code" varchar(10),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "district_code" varchar(7),
    "state_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'scb_xray_pay_new_address');

\echo 'created foreign table fomema_backup_nios.scb_xray_pay_new_address';

drop foreign table if exists fomema_backup_nios.seminar;

create foreign table if not exists fomema_backup_nios.seminar (
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
) server fomema_backup options (schema_name 'nios', table_name 'seminar');

\echo 'created foreign table fomema_backup_nios.seminar';

drop foreign table if exists fomema_backup_nios.seminar_detail;

create foreign table if not exists fomema_backup_nios.seminar_detail (
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
) server fomema_backup options (schema_name 'nios', table_name 'seminar_detail');

\echo 'created foreign table fomema_backup_nios.seminar_detail';

drop foreign table if exists fomema_backup_nios.send_mail_ind;

create foreign table if not exists fomema_backup_nios.send_mail_ind (
    "trans_id" varchar(14),
    "send_date" timestamp,
    "status" varchar(20),
    "email_type" numeric(1)
) server fomema_backup options (schema_name 'nios', table_name 'send_mail_ind');

\echo 'created foreign table fomema_backup_nios.send_mail_ind';

drop foreign table if exists fomema_backup_nios.service_providers_group;

create foreign table if not exists fomema_backup_nios.service_providers_group (
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
) server fomema_backup options (schema_name 'nios', table_name 'service_providers_group');

\echo 'created foreign table fomema_backup_nios.service_providers_group';

drop foreign table if exists fomema_backup_nios.service_providers_group_member;

create foreign table if not exists fomema_backup_nios.service_providers_group_member (
    "id" numeric(19),
    "version" numeric(19),
    "creation_date" timestamp,
    "creator_id" numeric(10),
    "modification_date" timestamp,
    "modify_id" numeric(10),
    "service_member" varchar(40),
    "service_providers_group_id" numeric(19)
) server fomema_backup options (schema_name 'nios', table_name 'service_providers_group_member');

\echo 'created foreign table fomema_backup_nios.service_providers_group_member';

drop foreign table if exists fomema_backup_nios.service_provide_pay_rate;

create foreign table if not exists fomema_backup_nios.service_provide_pay_rate (
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
) server fomema_backup options (schema_name 'nios', table_name 'service_provide_pay_rate');

\echo 'created foreign table fomema_backup_nios.service_provide_pay_rate';

drop foreign table if exists fomema_backup_nios.shadow_xray_radio_assignment;

create foreign table if not exists fomema_backup_nios.shadow_xray_radio_assignment (
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
) server fomema_backup options (schema_name 'nios', table_name 'shadow_xray_radio_assignment');

\echo 'created foreign table fomema_backup_nios.shadow_xray_radio_assignment';

drop foreign table if exists fomema_backup_nios.special_renewal_request;

create foreign table if not exists fomema_backup_nios.special_renewal_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'special_renewal_request');

\echo 'created foreign table fomema_backup_nios.special_renewal_request';

drop foreign table if exists fomema_backup_nios.sppayment_reference;

create foreign table if not exists fomema_backup_nios.sppayment_reference (
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
) server fomema_backup options (schema_name 'nios', table_name 'sppayment_reference');

\echo 'created foreign table fomema_backup_nios.sppayment_reference';

drop foreign table if exists fomema_backup_nios.status_change_pending;

create foreign table if not exists fomema_backup_nios.status_change_pending (
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
) server fomema_backup options (schema_name 'nios', table_name 'status_change_pending');

\echo 'created foreign table fomema_backup_nios.status_change_pending';

drop foreign table if exists fomema_backup_nios.suspension_comments;

create foreign table if not exists fomema_backup_nios.suspension_comments (
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
) server fomema_backup options (schema_name 'nios', table_name 'suspension_comments');

\echo 'created foreign table fomema_backup_nios.suspension_comments';

drop foreign table if exists fomema_backup_nios.sync_table;

create foreign table if not exists fomema_backup_nios.sync_table (
    "table_name" varchar(100),
    "sequence" numeric
) server fomema_backup options (schema_name 'nios', table_name 'sync_table');

\echo 'created foreign table fomema_backup_nios.sync_table';

drop foreign table if exists fomema_backup_nios.tcupi_todolist;

create foreign table if not exists fomema_backup_nios.tcupi_todolist (
    "tcupi_todolist_id" numeric,
    "tcupi_todolist_desc" varchar(1000)
) server fomema_backup options (schema_name 'nios', table_name 'tcupi_todolist');

\echo 'created foreign table fomema_backup_nios.tcupi_todolist';

drop foreign table if exists fomema_backup_nios.temp_pending_review_resend;

create foreign table if not exists fomema_backup_nios.temp_pending_review_resend (
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'temp_pending_review_resend');

\echo 'created foreign table fomema_backup_nios.temp_pending_review_resend';

drop foreign table if exists fomema_backup_nios.temp_quarantine_fw_doc;

create foreign table if not exists fomema_backup_nios.temp_quarantine_fw_doc (
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
) server fomema_backup options (schema_name 'nios', table_name 'temp_quarantine_fw_doc');

\echo 'created foreign table fomema_backup_nios.temp_quarantine_fw_doc';

drop foreign table if exists fomema_backup_nios.t_cnv_agent_district;

create foreign table if not exists fomema_backup_nios.t_cnv_agent_district (
    "agent_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_agent_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_agent_district';

drop foreign table if exists fomema_backup_nios.t_cnv_doctorh_district;

create foreign table if not exists fomema_backup_nios.t_cnv_doctorh_district (
    "doctor_code" varchar(10),
    "version_no" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_doctorh_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_doctorh_district';

drop foreign table if exists fomema_backup_nios.t_cnv_doctor_district;

create foreign table if not exists fomema_backup_nios.t_cnv_doctor_district (
    "doctor_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_doctor_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_doctor_district';

drop foreign table if exists fomema_backup_nios.t_cnv_employerh_district;

create foreign table if not exists fomema_backup_nios.t_cnv_employerh_district (
    "employer_code" varchar(10),
    "version_no" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_employerh_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_employerh_district';

drop foreign table if exists fomema_backup_nios.t_cnv_employer_district;

create foreign table if not exists fomema_backup_nios.t_cnv_employer_district (
    "employer_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_employer_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_employer_district';

drop foreign table if exists fomema_backup_nios.t_cnv_laboratoryh_district;

create foreign table if not exists fomema_backup_nios.t_cnv_laboratoryh_district (
    "laboratory_code" varchar(10),
    "version_no" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_laboratoryh_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_laboratoryh_district';

drop foreign table if exists fomema_backup_nios.t_cnv_laboratory_district;

create foreign table if not exists fomema_backup_nios.t_cnv_laboratory_district (
    "laboratory_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_laboratory_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_laboratory_district';

drop foreign table if exists fomema_backup_nios.t_cnv_worker_doctor;

create foreign table if not exists fomema_backup_nios.t_cnv_worker_doctor (
    "worker_code" varchar(10),
    "doctor_code" varchar(10),
    "certify_date" timestamp,
    "allocation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_worker_doctor');

\echo 'created foreign table fomema_backup_nios.t_cnv_worker_doctor';

drop foreign table if exists fomema_backup_nios.t_cnv_worker_doctor_a;

create foreign table if not exists fomema_backup_nios.t_cnv_worker_doctor_a (
    "worker_code" varchar(10),
    "doctor_code" varchar(10),
    "certify_date" timestamp,
    "allocation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_worker_doctor_a');

\echo 'created foreign table fomema_backup_nios.t_cnv_worker_doctor_a';

drop foreign table if exists fomema_backup_nios.t_cnv_xrayh_district;

create foreign table if not exists fomema_backup_nios.t_cnv_xrayh_district (
    "xray_code" varchar(10),
    "version_no" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_xrayh_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_xrayh_district';

drop foreign table if exists fomema_backup_nios.t_cnv_xray_district;

create foreign table if not exists fomema_backup_nios.t_cnv_xray_district (
    "xray_code" varchar(10),
    "district_name" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 't_cnv_xray_district');

\echo 'created foreign table fomema_backup_nios.t_cnv_xray_district';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_doctor;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_doctor (
    "nongroup_doctor" varchar(1000),
    "state_ref" varchar(3),
    "doctor_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_doctor');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_doctor';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_doctor_dtl;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_doctor_dtl (
    "nongroup_result" varchar(124),
    "state_ref" varchar(3),
    "doctor_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_doctor_dtl');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_doctor_dtl';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_doctor_ttl;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_doctor_ttl (
    "state_ref" varchar(3),
    "cnt" numeric,
    "total" numeric
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_doctor_ttl');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_doctor_ttl';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_xray;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_xray (
    "nongroup_xray" varchar(1000),
    "state_ref" varchar(3),
    "xray_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_xray');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_xray';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_xray_dtl;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_xray_dtl (
    "nongroup_result" varchar(124),
    "state_ref" varchar(3),
    "xray_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_xray_dtl');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_xray_dtl';

drop foreign table if exists fomema_backup_nios.t_conv_fin_nongroup_xray_ttl;

create foreign table if not exists fomema_backup_nios.t_conv_fin_nongroup_xray_ttl (
    "state_ref" varchar(3),
    "cnt" numeric,
    "total" numeric
) server fomema_backup options (schema_name 'nios', table_name 't_conv_fin_nongroup_xray_ttl');

\echo 'created foreign table fomema_backup_nios.t_conv_fin_nongroup_xray_ttl';

drop foreign table if exists fomema_backup_nios.t_obj_migrated;

create foreign table if not exists fomema_backup_nios.t_obj_migrated (
    "object_name" varchar(30),
    "date_migrated" timestamp
) server fomema_backup options (schema_name 'nios', table_name 't_obj_migrated');

\echo 'created foreign table fomema_backup_nios.t_obj_migrated';

drop foreign table if exists fomema_backup_nios.t_wpc;

create foreign table if not exists fomema_backup_nios.t_wpc (
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
) server fomema_backup options (schema_name 'nios', table_name 't_wpc');

\echo 'created foreign table fomema_backup_nios.t_wpc';

drop foreign table if exists fomema_backup_nios.um_user_capability;

create foreign table if not exists fomema_backup_nios.um_user_capability (
    "uuid" numeric(10),
    "mod_id" numeric(38),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'um_user_capability');

\echo 'created foreign table fomema_backup_nios.um_user_capability';

drop foreign table if exists fomema_backup_nios.undefine_doctor;

create foreign table if not exists fomema_backup_nios.undefine_doctor (
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
) server fomema_backup options (schema_name 'nios', table_name 'undefine_doctor');

\echo 'created foreign table fomema_backup_nios.undefine_doctor';

drop foreign table if exists fomema_backup_nios.unsuitable_reasons;

create foreign table if not exists fomema_backup_nios.unsuitable_reasons (
    "unsuitable_id" numeric(10),
    "reason_eng" varchar(100),
    "reason_bm" varchar(100),
    "priority" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'unsuitable_reasons');

\echo 'created foreign table fomema_backup_nios.unsuitable_reasons';

drop foreign table if exists fomema_backup_nios.unsuitable_reasons_map;

create foreign table if not exists fomema_backup_nios.unsuitable_reasons_map (
    "parameter_code" varchar(10),
    "unsuitable_id" numeric(10)
) server fomema_backup options (schema_name 'nios', table_name 'unsuitable_reasons_map');

\echo 'created foreign table fomema_backup_nios.unsuitable_reasons_map';

drop foreign table if exists fomema_backup_nios.usercap_detail;

create foreign table if not exists fomema_backup_nios.usercap_detail (
    "cap_id" varchar(10),
    "module_id" varchar(30),
    "allow_action" varchar(15)
) server fomema_backup options (schema_name 'nios', table_name 'usercap_detail');

\echo 'created foreign table fomema_backup_nios.usercap_detail';

drop foreign table if exists fomema_backup_nios.useroldpass;

create foreign table if not exists fomema_backup_nios.useroldpass (
    "usercode" varchar(13),
    "userpass" varchar(50),
    "changedate" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'useroldpass');

\echo 'created foreign table fomema_backup_nios.useroldpass';

drop foreign table if exists fomema_backup_nios.userpassword_trans;

create foreign table if not exists fomema_backup_nios.userpassword_trans (
    "uuid" varchar(20),
    "password" varchar(100),
    "date_change" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'userpassword_trans');

\echo 'created foreign table fomema_backup_nios.userpassword_trans';

drop foreign table if exists fomema_backup_nios.users;

create foreign table if not exists fomema_backup_nios.users (
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
) server fomema_backup options (schema_name 'nios', table_name 'users');

\echo 'created foreign table fomema_backup_nios.users';

drop foreign table if exists fomema_backup_nios.user_branches;

create foreign table if not exists fomema_backup_nios.user_branches (
    "uuid" numeric(10),
    "branch_code" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'user_branches');

\echo 'created foreign table fomema_backup_nios.user_branches';

drop foreign table if exists fomema_backup_nios.user_capability;

create foreign table if not exists fomema_backup_nios.user_capability (
    "uuid" numeric(10),
    "capid" numeric(18),
    "status" varchar(5),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modify_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'user_capability');

\echo 'created foreign table fomema_backup_nios.user_capability';

drop foreign table if exists fomema_backup_nios.user_comments;

create foreign table if not exists fomema_backup_nios.user_comments (
    "msgno" varchar(10),
    "logdatetime" timestamp,
    "usercode" varchar(15),
    "subject" varchar(100),
    "message" varchar(4000),
    "email" varchar(50)
) server fomema_backup options (schema_name 'nios', table_name 'user_comments');

\echo 'created foreign table fomema_backup_nios.user_comments';

drop foreign table if exists fomema_backup_nios.user_session;

create foreign table if not exists fomema_backup_nios.user_session (
    "sessionid" varchar(50),
    "remote_address" varchar(50),
    "last_access" timestamp,
    "request_uri" varchar(4000),
    "timeout" numeric(10),
    "module" varchar(5),
    "userid" varchar(20),
    "branch_code" varchar(2)
) server fomema_backup options (schema_name 'nios', table_name 'user_session');

\echo 'created foreign table fomema_backup_nios.user_session';

drop foreign table if exists fomema_backup_nios.visit_plan_detail;

create foreign table if not exists fomema_backup_nios.visit_plan_detail (
    "plan_id" numeric,
    "provider_id" varchar(10),
    "state_code" varchar(20),
    "district_code" varchar(20),
    "creator_id" varchar(20),
    "creation_date" timestamp,
    "modify_id" varchar(20),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'visit_plan_detail');

\echo 'created foreign table fomema_backup_nios.visit_plan_detail';

drop foreign table if exists fomema_backup_nios.visit_rpt_docxray;

create foreign table if not exists fomema_backup_nios.visit_rpt_docxray (
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
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_docxray');

\echo 'created foreign table fomema_backup_nios.visit_rpt_docxray';

drop foreign table if exists fomema_backup_nios.visit_rpt_followup;

create foreign table if not exists fomema_backup_nios.visit_rpt_followup (
    "followup_id" numeric,
    "visit_report_id" numeric,
    "service_provider_code" varchar(10),
    "type" varchar(10),
    "modify_date" timestamp,
    "modify_id" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_followup');

\echo 'created foreign table fomema_backup_nios.visit_rpt_followup';

drop foreign table if exists fomema_backup_nios.visit_rpt_followup_comments;

create foreign table if not exists fomema_backup_nios.visit_rpt_followup_comments (
    "followup_id" numeric,
    "createdate" timestamp,
    "addedby" numeric,
    "comments" varchar(255)
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_followup_comments');

\echo 'created foreign table fomema_backup_nios.visit_rpt_followup_comments';

drop foreign table if exists fomema_backup_nios.visit_rpt_labdetail;

create foreign table if not exists fomema_backup_nios.visit_rpt_labdetail (
    "rpt_seq" varchar(20),
    "datavalue" varchar(4000),
    "report_id" numeric
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_labdetail');

\echo 'created foreign table fomema_backup_nios.visit_rpt_labdetail';

drop foreign table if exists fomema_backup_nios.visit_rpt_sop_compliance;

create foreign table if not exists fomema_backup_nios.visit_rpt_sop_compliance (
    "report_id" numeric,
    "sopcomp_ind" varchar(2),
    "sopcomp_comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_sop_compliance');

\echo 'created foreign table fomema_backup_nios.visit_rpt_sop_compliance';

drop foreign table if exists fomema_backup_nios.visit_rpt_xqcc;

create foreign table if not exists fomema_backup_nios.visit_rpt_xqcc (
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
) server fomema_backup options (schema_name 'nios', table_name 'visit_rpt_xqcc');

\echo 'created foreign table fomema_backup_nios.visit_rpt_xqcc';

drop foreign table if exists fomema_backup_nios.v_appeal_status;

create foreign table if not exists fomema_backup_nios.v_appeal_status (
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
) server fomema_backup options (schema_name 'nios', table_name 'v_appeal_status');

\echo 'created foreign table fomema_backup_nios.v_appeal_status';

drop foreign table if exists fomema_backup_nios.v_worker_clinic;

create foreign table if not exists fomema_backup_nios.v_worker_clinic (
    "worker_code" varchar(10),
    "country_code" varchar(3),
    "clinic_code" varchar(10),
    "exam_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'v_worker_clinic');

\echo 'created foreign table fomema_backup_nios.v_worker_clinic';

drop foreign table if exists fomema_backup_nios.worker_cancel;

create foreign table if not exists fomema_backup_nios.worker_cancel (
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
) server fomema_backup options (schema_name 'nios', table_name 'worker_cancel');

\echo 'created foreign table fomema_backup_nios.worker_cancel';

drop foreign table if exists fomema_backup_nios.worker_cancel_detail;

create foreign table if not exists fomema_backup_nios.worker_cancel_detail (
    "fwcancelid" varchar(15),
    "refundid" varchar(15),
    "refund_detailid" varchar(15),
    "trans_id" varchar(14),
    "cancelled_by" numeric(10),
    "cancelled_date" timestamp,
    "status" varchar(5)
) server fomema_backup options (schema_name 'nios', table_name 'worker_cancel_detail');

\echo 'created foreign table fomema_backup_nios.worker_cancel_detail';

drop foreign table if exists fomema_backup_nios.worker_certify_fitind;

create foreign table if not exists fomema_backup_nios.worker_certify_fitind (
    "logid" numeric,
    "logdate" timestamp,
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "dfit_ind" numeric(1),
    "fit_ind" char(1)
) server fomema_backup options (schema_name 'nios', table_name 'worker_certify_fitind');

\echo 'created foreign table fomema_backup_nios.worker_certify_fitind';

drop foreign table if exists fomema_backup_nios.worker_country_dist;

create foreign table if not exists fomema_backup_nios.worker_country_dist (
    "country_code" varchar(3),
    "fwcount" numeric
) server fomema_backup options (schema_name 'nios', table_name 'worker_country_dist');

\echo 'created foreign table fomema_backup_nios.worker_country_dist';

drop foreign table if exists fomema_backup_nios.worker_doctor_change;

create foreign table if not exists fomema_backup_nios.worker_doctor_change (
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
) server fomema_backup options (schema_name 'nios', table_name 'worker_doctor_change');

\echo 'created foreign table fomema_backup_nios.worker_doctor_change';

drop foreign table if exists fomema_backup_nios.worker_doctor_change_hist;

create foreign table if not exists fomema_backup_nios.worker_doctor_change_hist (
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
) server fomema_backup options (schema_name 'nios', table_name 'worker_doctor_change_hist');

\echo 'created foreign table fomema_backup_nios.worker_doctor_change_hist';

drop foreign table if exists fomema_backup_nios.worker_fitind_change;

create foreign table if not exists fomema_backup_nios.worker_fitind_change (
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "change_type" varchar(2),
    "modification_id" varchar(30),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'worker_fitind_change');

\echo 'created foreign table fomema_backup_nios.worker_fitind_change';

drop foreign table if exists fomema_backup_nios.worker_upd;

create foreign table if not exists fomema_backup_nios.worker_upd (
    "old_passport_no" varchar(20),
    "old_worker_name" varchar(50),
    "old_country_name" varchar(25),
    "worker_code" varchar(10),
    "mod_date" timestamp,
    "status" varchar(1)
) server fomema_backup options (schema_name 'nios', table_name 'worker_upd');

\echo 'created foreign table fomema_backup_nios.worker_upd';

drop foreign table if exists fomema_backup_nios.wrong_transmission;

create foreign table if not exists fomema_backup_nios.wrong_transmission (
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
) server fomema_backup options (schema_name 'nios', table_name 'wrong_transmission');

\echo 'created foreign table fomema_backup_nios.wrong_transmission';

drop foreign table if exists fomema_backup_nios.ws_access_token;

create foreign table if not exists fomema_backup_nios.ws_access_token (
    "last_access" timestamp,
    "token" varchar(50),
    "created_date" timestamp,
    "usercode" varchar(10),
    "provider_id" varchar(3)
) server fomema_backup options (schema_name 'nios', table_name 'ws_access_token');

\echo 'created foreign table fomema_backup_nios.ws_access_token';

drop foreign table if exists fomema_backup_nios.xqcc_calllog;

create foreign table if not exists fomema_backup_nios.xqcc_calllog (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_calllog');

\echo 'created foreign table fomema_backup_nios.xqcc_calllog';

drop foreign table if exists fomema_backup_nios.xqcc_certificate;

create foreign table if not exists fomema_backup_nios.xqcc_certificate (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_certificate');

\echo 'created foreign table fomema_backup_nios.xqcc_certificate';

drop foreign table if exists fomema_backup_nios.xqcc_comment;

create foreign table if not exists fomema_backup_nios.xqcc_comment (
    "worker_code" varchar(10),
    "certify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_comment');

\echo 'created foreign table fomema_backup_nios.xqcc_comment';

drop foreign table if exists fomema_backup_nios.xqcc_comments;

create foreign table if not exists fomema_backup_nios.xqcc_comments (
    "xqccid" numeric(10),
    "comments" varchar(4000),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_comments');

\echo 'created foreign table fomema_backup_nios.xqcc_comments';

drop foreign table if exists fomema_backup_nios.xqcc_followup;

create foreign table if not exists fomema_backup_nios.xqcc_followup (
    "case_id" varchar(20),
    "action_taken" varchar(4000),
    "action_takendate" timestamp,
    "creation_date" timestamp,
    "creator_id" varchar(20),
    "modify_date" timestamp,
    "modify_id" varchar(20),
    "id" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_followup');

\echo 'created foreign table fomema_backup_nios.xqcc_followup';

drop foreign table if exists fomema_backup_nios.xqcc_fw_extra_comments;

create foreign table if not exists fomema_backup_nios.xqcc_fw_extra_comments (
    "trans_id" varchar(14),
    "comment_date" timestamp,
    "comment_time" varchar(8),
    "userid" varchar(30),
    "source" varchar(1),
    "type" varchar(1),
    "comments" varchar(4000)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_fw_extra_comments');

\echo 'created foreign table fomema_backup_nios.xqcc_fw_extra_comments';

drop foreign table if exists fomema_backup_nios.xqcc_mle_retake;

create foreign table if not exists fomema_backup_nios.xqcc_mle_retake (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_mle_retake');

\echo 'created foreign table fomema_backup_nios.xqcc_mle_retake';

drop foreign table if exists fomema_backup_nios.xqcc_performance;

create foreign table if not exists fomema_backup_nios.xqcc_performance (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_performance');

\echo 'created foreign table fomema_backup_nios.xqcc_performance';

drop foreign table if exists fomema_backup_nios.xqcc_quarantine_fw_doc;

create foreign table if not exists fomema_backup_nios.xqcc_quarantine_fw_doc (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_quarantine_fw_doc');

\echo 'created foreign table fomema_backup_nios.xqcc_quarantine_fw_doc';

drop foreign table if exists fomema_backup_nios.xqcc_quarantine_fw_reason;

create foreign table if not exists fomema_backup_nios.xqcc_quarantine_fw_reason (
    "trans_id" varchar(14),
    "bc_worker_code" varchar(13),
    "reason_code" varchar(10),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_quarantine_fw_reason');

\echo 'created foreign table fomema_backup_nios.xqcc_quarantine_fw_reason';

drop foreign table if exists fomema_backup_nios.xqcc_report;

create foreign table if not exists fomema_backup_nios.xqcc_report (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_report');

\echo 'created foreign table fomema_backup_nios.xqcc_report';

drop foreign table if exists fomema_backup_nios.xqcc_sign;

create foreign table if not exists fomema_backup_nios.xqcc_sign (
    "name" varchar(35),
    "desig" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_sign');

\echo 'created foreign table fomema_backup_nios.xqcc_sign';

drop foreign table if exists fomema_backup_nios.xqcc_stat_change_approval;

create foreign table if not exists fomema_backup_nios.xqcc_stat_change_approval (
    "xqccreqid" numeric(10),
    "status" varchar(1),
    "comments" varchar(4000),
    "approval_id" numeric(10),
    "approval_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_stat_change_approval');

\echo 'created foreign table fomema_backup_nios.xqcc_stat_change_approval';

drop foreign table if exists fomema_backup_nios.xqcc_stat_change_reasons;

create foreign table if not exists fomema_backup_nios.xqcc_stat_change_reasons (
    "reasoncode" varchar(5),
    "reason" varchar(255),
    "status" varchar(1),
    "creator_id" numeric(10),
    "creation_date" timestamp,
    "modification_id" numeric(10),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_stat_change_reasons');

\echo 'created foreign table fomema_backup_nios.xqcc_stat_change_reasons';

drop foreign table if exists fomema_backup_nios.xqcc_stat_change_request;

create foreign table if not exists fomema_backup_nios.xqcc_stat_change_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_stat_change_request');

\echo 'created foreign table fomema_backup_nios.xqcc_stat_change_request';

drop foreign table if exists fomema_backup_nios.xqcc_transid;

create foreign table if not exists fomema_backup_nios.xqcc_transid (
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_transid');

\echo 'created foreign table fomema_backup_nios.xqcc_transid';

drop foreign table if exists fomema_backup_nios.xqcc_unfit;

create foreign table if not exists fomema_backup_nios.xqcc_unfit (
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_unfit');

\echo 'created foreign table fomema_backup_nios.xqcc_unfit';

drop foreign table if exists fomema_backup_nios.xqcc_warehouse;

create foreign table if not exists fomema_backup_nios.xqcc_warehouse (
    "warehouse_id" numeric,
    "name" varchar(100),
    "address" varchar(255),
    "status" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'xqcc_warehouse');

\echo 'created foreign table fomema_backup_nios.xqcc_warehouse';

drop foreign table if exists fomema_backup_nios.xquarantine_release_approval;

create foreign table if not exists fomema_backup_nios.xquarantine_release_approval (
    "xqrreqid" numeric(10),
    "xqrrid" numeric(10),
    "status" varchar(1),
    "comments" varchar(4000),
    "approval_id" numeric(10),
    "approval_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xquarantine_release_approval');

\echo 'created foreign table fomema_backup_nios.xquarantine_release_approval';

drop foreign table if exists fomema_backup_nios.xquarantine_release_request;

create foreign table if not exists fomema_backup_nios.xquarantine_release_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'xquarantine_release_request');

\echo 'created foreign table fomema_backup_nios.xquarantine_release_request';

drop foreign table if exists fomema_backup_nios.xray_adhoc_submit_abnormal;

create foreign table if not exists fomema_backup_nios.xray_adhoc_submit_abnormal (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_adhoc_submit_abnormal');

\echo 'created foreign table fomema_backup_nios.xray_adhoc_submit_abnormal';

drop foreign table if exists fomema_backup_nios.xray_adhoc_submit_delay;

create foreign table if not exists fomema_backup_nios.xray_adhoc_submit_delay (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_adhoc_submit_delay');

\echo 'created foreign table fomema_backup_nios.xray_adhoc_submit_delay';

drop foreign table if exists fomema_backup_nios.xray_adhoc_submit_normal;

create foreign table if not exists fomema_backup_nios.xray_adhoc_submit_normal (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_adhoc_submit_normal');

\echo 'created foreign table fomema_backup_nios.xray_adhoc_submit_normal';

drop foreign table if exists fomema_backup_nios.xray_change_request;

create foreign table if not exists fomema_backup_nios.xray_change_request (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_change_request');

\echo 'created foreign table fomema_backup_nios.xray_change_request';

drop foreign table if exists fomema_backup_nios.xray_change_request_detail;

create foreign table if not exists fomema_backup_nios.xray_change_request_detail (
    "xray_cr_id" numeric(10),
    "cr_column" varchar(100),
    "cr_old" varchar(100),
    "cr_new" varchar(100)
) server fomema_backup options (schema_name 'nios', table_name 'xray_change_request_detail');

\echo 'created foreign table fomema_backup_nios.xray_change_request_detail';

drop foreign table if exists fomema_backup_nios.xray_compare;

create foreign table if not exists fomema_backup_nios.xray_compare (
    "xray_code" varchar(10),
    "old_xray_name" varchar(50),
    "old_xray_regn_no" varchar(20),
    "new_xray_name" varchar(50),
    "new_xray_regn_no" varchar(20)
) server fomema_backup options (schema_name 'nios', table_name 'xray_compare');

\echo 'created foreign table fomema_backup_nios.xray_compare';

drop foreign table if exists fomema_backup_nios.xray_coupling;

create foreign table if not exists fomema_backup_nios.xray_coupling (
    "bc_xray_code" varchar(13),
    "bc_radiologist_code" varchar(13),
    "modify_id" numeric,
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_coupling');

\echo 'created foreign table fomema_backup_nios.xray_coupling';

drop foreign table if exists fomema_backup_nios.xray_dispatch_list;

create foreign table if not exists fomema_backup_nios.xray_dispatch_list (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_dispatch_list');

\echo 'created foreign table fomema_backup_nios.xray_dispatch_list';

drop foreign table if exists fomema_backup_nios.xray_dispatch_list_details;

create foreign table if not exists fomema_backup_nios.xray_dispatch_list_details (
    "dispatch_listid" numeric,
    "trans_id" varchar(14),
    "status" varchar(10),
    "status_date" timestamp,
    "film_sequence" numeric,
    "xray_testdone_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_dispatch_list_details');

\echo 'created foreign table fomema_backup_nios.xray_dispatch_list_details';

drop foreign table if exists fomema_backup_nios.xray_film_audit;

create foreign table if not exists fomema_backup_nios.xray_film_audit (
    "film_auditid" numeric,
    "trans_id" varchar(14),
    "ref_transid" varchar(14),
    "bc_worker_code" varchar(10),
    "comments" varchar(1000),
    "creator_id" varchar(50),
    "create_date" timestamp,
    "modifier_id" varchar(50),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_film_audit');

\echo 'created foreign table fomema_backup_nios.xray_film_audit';

drop foreign table if exists fomema_backup_nios.xray_film_movement;

create foreign table if not exists fomema_backup_nios.xray_film_movement (
    "movement_id" numeric,
    "trans_id" varchar(14),
    "dispatchlist_id" numeric,
    "status" varchar(10),
    "status_date" timestamp,
    "comments" varchar(1000),
    "user_id" varchar(30)
) server fomema_backup options (schema_name 'nios', table_name 'xray_film_movement');

\echo 'created foreign table fomema_backup_nios.xray_film_movement';

drop foreign table if exists fomema_backup_nios.xray_film_reminder;

create foreign table if not exists fomema_backup_nios.xray_film_reminder (
    "film_reminderid" numeric,
    "trans_id" varchar(14),
    "reminder_date" timestamp,
    "dispatch_listid" numeric,
    "creator_id" varchar(50),
    "create_date" timestamp,
    "modifier_id" varchar(50),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_film_reminder');

\echo 'created foreign table fomema_backup_nios.xray_film_reminder';

drop foreign table if exists fomema_backup_nios.xray_film_storage;

create foreign table if not exists fomema_backup_nios.xray_film_storage (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_film_storage');

\echo 'created foreign table fomema_backup_nios.xray_film_storage';

drop foreign table if exists fomema_backup_nios.xray_film_storage_detail;

create foreign table if not exists fomema_backup_nios.xray_film_storage_detail (
    "film_storageid" numeric,
    "trans_id" varchar(14),
    "creator_id" varchar(50),
    "create_date" timestamp,
    "modified_id" varchar(50),
    "modify_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_film_storage_detail');

\echo 'created foreign table fomema_backup_nios.xray_film_storage_detail';

drop foreign table if exists fomema_backup_nios.xray_follow_up;

create foreign table if not exists fomema_backup_nios.xray_follow_up (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_follow_up');

\echo 'created foreign table fomema_backup_nios.xray_follow_up';

drop foreign table if exists fomema_backup_nios.xray_not_done;

create foreign table if not exists fomema_backup_nios.xray_not_done (
    "trans_id" varchar(14),
    "xray_code" varchar(10),
    "worker_code" varchar(10),
    "transdate" timestamp,
    "certify_date" timestamp,
    "xray_submit_date" timestamp,
    "release_date" timestamp,
    "xray_ded" numeric(3)
) server fomema_backup options (schema_name 'nios', table_name 'xray_not_done');

\echo 'created foreign table fomema_backup_nios.xray_not_done';

drop foreign table if exists fomema_backup_nios.xray_payin_list;

create foreign table if not exists fomema_backup_nios.xray_payin_list (
    "xray_code" varchar(10),
    "xray_payee_name" varchar(50),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "post_code" varchar(10),
    "district_code" varchar(7),
    "state_code" varchar(7)
) server fomema_backup options (schema_name 'nios', table_name 'xray_payin_list');

\echo 'created foreign table fomema_backup_nios.xray_payin_list';

drop foreign table if exists fomema_backup_nios.xray_radio_assignment;

create foreign table if not exists fomema_backup_nios.xray_radio_assignment (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_radio_assignment');

\echo 'created foreign table fomema_backup_nios.xray_radio_assignment';

drop foreign table if exists fomema_backup_nios.xray_registration;

create foreign table if not exists fomema_backup_nios.xray_registration (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_registration');

\echo 'created foreign table fomema_backup_nios.xray_registration';

drop foreign table if exists fomema_backup_nios.xray_request;

create foreign table if not exists fomema_backup_nios.xray_request (
    "xregid" numeric(10),
    "approval_id" numeric(10),
    "status" varchar(5),
    "comments" varchar(4000),
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_request');

\echo 'created foreign table fomema_backup_nios.xray_request';

drop foreign table if exists fomema_backup_nios.xray_review_film;

create foreign table if not exists fomema_backup_nios.xray_review_film (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_review_film');

\echo 'created foreign table fomema_backup_nios.xray_review_film';

drop foreign table if exists fomema_backup_nios.xray_review_film_comments;

create foreign table if not exists fomema_backup_nios.xray_review_film_comments (
    "trans_id" varchar(14),
    "comments" varchar(1000),
    "creator_id" varchar(50),
    "create_date" timestamp,
    "modifier_id" varchar(50),
    "modify_date" timestamp,
    "commentsid" numeric
) server fomema_backup options (schema_name 'nios', table_name 'xray_review_film_comments');

\echo 'created foreign table fomema_backup_nios.xray_review_film_comments';

drop foreign table if exists fomema_backup_nios.xray_review_film_detail;

create foreign table if not exists fomema_backup_nios.xray_review_film_detail (
    "review_filmid" numeric,
    "parameter_code" varchar(20),
    "parameter_value" varchar(20),
    "trans_id" varchar(14)
) server fomema_backup options (schema_name 'nios', table_name 'xray_review_film_detail');

\echo 'created foreign table fomema_backup_nios.xray_review_film_detail';

drop foreign table if exists fomema_backup_nios.xray_review_film_identical;

create foreign table if not exists fomema_backup_nios.xray_review_film_identical (
    "review_filmid" numeric,
    "trans_id" varchar(14),
    "worker_code" varchar(10)
) server fomema_backup options (schema_name 'nios', table_name 'xray_review_film_identical');

\echo 'created foreign table fomema_backup_nios.xray_review_film_identical';

drop foreign table if exists fomema_backup_nios.xray_submit_daily;

create foreign table if not exists fomema_backup_nios.xray_submit_daily (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_submit_daily');

\echo 'created foreign table fomema_backup_nios.xray_submit_daily';

drop foreign table if exists fomema_backup_nios.xray_submit_daily_abnormal;

create foreign table if not exists fomema_backup_nios.xray_submit_daily_abnormal (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_submit_daily_abnormal');

\echo 'created foreign table fomema_backup_nios.xray_submit_daily_abnormal';

drop foreign table if exists fomema_backup_nios.xray_submit_daily_normal;

create foreign table if not exists fomema_backup_nios.xray_submit_daily_normal (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_submit_daily_normal');

\echo 'created foreign table fomema_backup_nios.xray_submit_daily_normal';

drop foreign table if exists fomema_backup_nios.xray_submit_delay;

create foreign table if not exists fomema_backup_nios.xray_submit_delay (
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
) server fomema_backup options (schema_name 'nios', table_name 'xray_submit_delay');

\echo 'created foreign table fomema_backup_nios.xray_submit_delay';

drop foreign table if exists fomema_backup_nios.xray_worker_count;

create foreign table if not exists fomema_backup_nios.xray_worker_count (
    "bc_xray_code" varchar(10),
    "last_year" numeric,
    "this_year" numeric,
    "modification_date" timestamp
) server fomema_backup options (schema_name 'nios', table_name 'xray_worker_count');

\echo 'created foreign table fomema_backup_nios.xray_worker_count';
