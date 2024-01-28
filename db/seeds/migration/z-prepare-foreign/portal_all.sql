
drop foreign table if exists fomema_backup_portal.announcement;

create foreign table if not exists fomema_backup_portal.announcement (
    "id" numeric,
    "creation_date" timestamp,
    "subject" varchar(250),
    "start_date" timestamp,
    "end_date" timestamp,
    "content" text,
    "status" numeric(1)
) server fomema_backup options (schema_name 'portal', table_name 'announcement');

\echo 'created foreign table fomema_backup_portal.announcement';

drop foreign table if exists fomema_backup_portal.employer_registration;

create foreign table if not exists fomema_backup_portal.employer_registration (
    "id" numeric,
    "employer_name" varchar(150),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "state_code" varchar(7),
    "post_code" varchar(10),
    "country_code" varchar(3),
    "telephone" varchar(20),
    "fax" varchar(20),
    "email" varchar(100),
    "employer_type" numeric,
    "company_number" varchar(20),
    "ic_passport_no" varchar(20),
    "fomema_remarks" varchar(4000),
    "creation_date" timestamp,
    "modification_date" timestamp,
    "reg_status" numeric,
    "previous_employer_code" varchar(10),
    "employer_code" varchar(10),
    "contact_person" varchar(100),
    "password" varchar(100),
    "assign_to" varchar(20),
    "assign_date" timestamp,
    "use_employer_reginfo" numeric,
    "district_code" varchar(7),
    "reg_sessid" varchar(100)
) server fomema_backup options (schema_name 'portal', table_name 'employer_registration');

\echo 'created foreign table fomema_backup_portal.employer_registration';

drop foreign table if exists fomema_backup_portal.employer_registration_approval;

create foreign table if not exists fomema_backup_portal.employer_registration_approval (
    "approve_status" numeric(10),
    "comments" varchar(400),
    "creation_date" timestamp,
    "creator_id" numeric(10),
    "modification_date" timestamp,
    "modify_id" numeric(10),
    "nios_uuid" varchar(20),
    "regid" numeric(19)
) server fomema_backup options (schema_name 'portal', table_name 'employer_registration_approval');

\echo 'created foreign table fomema_backup_portal.employer_registration_approval';

drop foreign table if exists fomema_backup_portal.fpx_bank_master;

create foreign table if not exists fomema_backup_portal.fpx_bank_master (
    "bankid" varchar(30),
    "bankname" varchar(100),
    "fpxtype" varchar(2),
    "banktype" numeric,
    "banklongname" varchar(100)
) server fomema_backup options (schema_name 'portal', table_name 'fpx_bank_master');

\echo 'created foreign table fomema_backup_portal.fpx_bank_master';

drop foreign table if exists fomema_backup_portal.fw_amendment;

create foreign table if not exists fomema_backup_portal.fw_amendment (
    "id" numeric,
    "batch_id" numeric,
    "reg_id" numeric,
    "approval_status" varchar(20),
    "worker_name" varchar(50),
    "worker_name_new" varchar(50),
    "passport_no" varchar(20),
    "passport_no_new" varchar(20),
    "dob" timestamp,
    "dob_new" timestamp,
    "country_code" varchar(3),
    "country_code_new" varchar(3),
    "gender" varchar(1),
    "gender_new" varchar(1),
    "approval_comments" varchar(2000),
    "created_date" timestamp,
    "created_by" varchar(20),
    "modified_date" timestamp,
    "modified_by" varchar(20),
    "trans_id" varchar(14),
    "worker_code" varchar(10),
    "doc_type" varchar(1),
    "doc_path" varchar(500)
) server fomema_backup options (schema_name 'portal', table_name 'fw_amendment');

\echo 'created foreign table fomema_backup_portal.fw_amendment';

drop foreign table if exists fomema_backup_portal.insurance_purchase;

create foreign table if not exists fomema_backup_portal.insurance_purchase (
    "id" numeric,
    "batchid" numeric,
    "employer_code" varchar(10),
    "worker_regid" numeric,
    "worker_name" varchar(50),
    "product_name" varchar(100),
    "start_date" timestamp,
    "end_date" timestamp,
    "ins_svcprovider" varchar(3),
    "creation_date" timestamp
) server fomema_backup options (schema_name 'portal', table_name 'insurance_purchase');

\echo 'created foreign table fomema_backup_portal.insurance_purchase';

drop foreign table if exists fomema_backup_portal.payment;

create foreign table if not exists fomema_backup_portal.payment (
    "id" numeric,
    "empcode" varchar(10),
    "payment_type" numeric,
    "creation_date" timestamp,
    "amount" numeric(126),
    "fpx_sellerexorderno" varchar(20),
    "fpx_sellertxntime" varchar(20),
    "fpx_sellerorderno" varchar(20),
    "fpx_buyeremail" varchar(50),
    "wr_batchid" numeric,
    "isposted" numeric,
    "posted_date" timestamp,
    "status" numeric,
    "cancel_date" timestamp,
    "cancel_reason" varchar(1000),
    "gst_amount" numeric(126),
    "net_amount" numeric(126),
    "nios_deposit_date" timestamp,
    "bank_area" varchar(20),
    "bank_code" varchar(20),
    "date_issue" timestamp,
    "payment_no" varchar(20),
    "zone_code" varchar(20),
    "payment_mode" numeric,
    "other_amount" numeric(126),
    "other_amount_gst" numeric(126),
    "fpx_txnid" varchar(20),
    "fpx_method" varchar(10),
    "buyer_bank" varchar(100),
    "gst_tax" numeric,
    "modification_date" timestamp
) server fomema_backup options (schema_name 'portal', table_name 'payment');

\echo 'created foreign table fomema_backup_portal.payment';

drop foreign table if exists fomema_backup_portal.payment_log;

create foreign table if not exists fomema_backup_portal.payment_log (
    "id" numeric,
    "creation_date" timestamp,
    "empcode" varchar(10),
    "amount" numeric,
    "fpx_sellerexorderno" varchar(20),
    "fpx_sellertxntime" varchar(20),
    "fpx_sellerorderno" varchar(20),
    "fpx_buyeremail" varchar(50),
    "payment_posted" numeric,
    "post_date" timestamp,
    "fpx_return_status" varchar(20),
    "net_amount" numeric(126),
    "gst_amount" numeric(126),
    "other_amount" numeric(126),
    "other_amount_gst" numeric(126),
    "fpx_txnid" varchar(20),
    "payment_type" numeric,
    "batchdesc" varchar(100),
    "status" numeric,
    "batch_id" numeric,
    "fpx_method" varchar(10),
    "buyer_bankid" varchar(30),
    "buyer_bankname" varchar(100),
    "gst_tax" numeric
) server fomema_backup options (schema_name 'portal', table_name 'payment_log');

\echo 'created foreign table fomema_backup_portal.payment_log';

drop foreign table if exists fomema_backup_portal.support_document;

create foreign table if not exists fomema_backup_portal.support_document (
    "regid" numeric,
    "docdata" bytea,
    "doctype" numeric,
    "docid" numeric,
    "imagetype" numeric
) server fomema_backup options (schema_name 'portal', table_name 'support_document');

\echo 'created foreign table fomema_backup_portal.support_document';

drop foreign table if exists fomema_backup_portal.support_document_path;

create foreign table if not exists fomema_backup_portal.support_document_path (
    "regid" numeric,
    "docdata" varchar(100),
    "doctype" numeric,
    "docid" numeric,
    "imagetype" numeric
) server fomema_backup options (schema_name 'portal', table_name 'support_document_path');

\echo 'created foreign table fomema_backup_portal.support_document_path';

drop foreign table if exists fomema_backup_portal.user_log;

create foreign table if not exists fomema_backup_portal.user_log (
    "userid" varchar(20),
    "log_message" varchar(4000),
    "log_date" timestamp,
    "sessionid" varchar(50)
) server fomema_backup options (schema_name 'portal', table_name 'user_log');

\echo 'created foreign table fomema_backup_portal.user_log';

drop foreign table if exists fomema_backup_portal.user_master;

create foreign table if not exists fomema_backup_portal.user_master (
    "regid" numeric,
    "username" varchar(100),
    "email" varchar(100),
    "type" numeric,
    "password" varchar(100),
    "usercode" varchar(10),
    "status" numeric,
    "creation_date" timestamp,
    "modification_date" timestamp,
    "islogin" numeric,
    "logindate" timestamp,
    "password_reset" varchar(1),
    "address1" varchar(50),
    "address2" varchar(50),
    "address3" varchar(50),
    "address4" varchar(50),
    "state_code" varchar(7),
    "post_code" varchar(10),
    "country_code" varchar(3),
    "telephone" varchar(50),
    "fax" varchar(50),
    "company_number" varchar(20),
    "ic_passport_no" varchar(20),
    "contact_person" varchar(100),
    "reset_sessid" varchar(100),
    "reset_date" timestamp,
    "district_code" varchar(7)
) server fomema_backup options (schema_name 'portal', table_name 'user_master');

\echo 'created foreign table fomema_backup_portal.user_master';

drop foreign table if exists fomema_backup_portal.user_session;

create foreign table if not exists fomema_backup_portal.user_session (
    "sessionid" varchar(50),
    "remote_address" varchar(50),
    "last_access" timestamp,
    "request_uri" varchar(4000),
    "timeout" numeric(10),
    "module" varchar(5),
    "userid" varchar(20),
    "browser_string" varchar(4000)
) server fomema_backup options (schema_name 'portal', table_name 'user_session');

\echo 'created foreign table fomema_backup_portal.user_session';

drop foreign table if exists fomema_backup_portal.worker_list;

create foreign table if not exists fomema_backup_portal.worker_list (
    "id" numeric,
    "worker_name" varchar(50),
    "sex" varchar(1),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "country_code" varchar(3),
    "job_type" varchar(50),
    "employer_code" varchar(10),
    "creation_date" timestamp,
    "modification_date" timestamp,
    "arrival_date" timestamp,
    "status" numeric,
    "worker_code" varchar(10),
    "ispati" numeric,
    "pending_reg" numeric,
    "invoiceno" varchar(20),
    "imm_date_of_birth" varchar(8),
    "imm_gender" varchar(1),
    "imm_passportno" varchar(20),
    "imm_nationality" varchar(3),
    "imm_date_of_arrival" varchar(8),
    "imm_doc_expiry_date" varchar(8),
    "imm_doc_issue_authority" varchar(3),
    "imm_application_number" varchar(45),
    "imm_afis_id" varchar(15),
    "imm_ners_reason_code" varchar(5),
    "imm_employer_name" varchar(150),
    "imm_employer_id" varchar(20),
    "imm_employer_type" varchar(3),
    "imm_employer_address1" varchar(40),
    "imm_employer_address2" varchar(40),
    "imm_employer_address3" varchar(40),
    "imm_employer_address4" varchar(40),
    "imm_employer_city" varchar(6),
    "imm_employer_state" varchar(3),
    "imm_employer_email" varchar(60),
    "imm_employer_phone_no" varchar(25),
    "imm_employer_postcode" varchar(15),
    "imm_ners_status" varchar(3),
    "imm_ners_message" varchar(100),
    "imm_transaction_id" varchar(30),
    "ispra" numeric(1),
    "plks_no" numeric(3),
    "imm_fp_biosl" varchar(2),
    "imm_fp_availability_status" varchar(3),
    "imm_renew_count_year" varchar(2),
    "imm_pra_create_id" varchar(30),
    "imm_fp_avail" varchar(30),
    "imm_worker_name" varchar(150),
    "error_desc" varchar(100),
    "error_ind" varchar(10)
) server fomema_backup options (schema_name 'portal', table_name 'worker_list');

\echo 'created foreign table fomema_backup_portal.worker_list';

drop foreign table if exists fomema_backup_portal.worker_log;

create foreign table if not exists fomema_backup_portal.worker_log (
    "invoiceno" varchar(20),
    "workerlist_id" numeric,
    "doctor_code" varchar(10)
) server fomema_backup options (schema_name 'portal', table_name 'worker_log');

\echo 'created foreign table fomema_backup_portal.worker_log';

drop foreign table if exists fomema_backup_portal.worker_registration;

create foreign table if not exists fomema_backup_portal.worker_registration (
    "id" numeric,
    "worker_name" varchar(50),
    "sex" varchar(1),
    "date_of_birth" timestamp,
    "passport_no" varchar(20),
    "country_code" varchar(3),
    "job_type" varchar(50),
    "employer_code" varchar(10),
    "arrival_date" timestamp,
    "worker_code" varchar(10),
    "reg_status" numeric,
    "doctor_code" varchar(10),
    "payment_method" numeric,
    "transdate" timestamp,
    "submission_date" timestamp,
    "reg_remarks" varchar(4000),
    "batchid" numeric,
    "previous_worker_code" varchar(10),
    "trans_id" varchar(14),
    "ispati" numeric,
    "imm_date_of_birth" varchar(8),
    "imm_gender" varchar(1),
    "imm_passportno" varchar(20),
    "imm_nationality" varchar(3),
    "imm_date_of_arrival" varchar(8),
    "imm_doc_expiry_date" varchar(8),
    "imm_doc_issue_authority" varchar(3),
    "imm_application_number" varchar(45),
    "imm_afis_id" varchar(15),
    "imm_ners_reason_code" varchar(5),
    "imm_employer_name" varchar(150),
    "imm_employer_id" varchar(20),
    "imm_employer_type" varchar(3),
    "imm_employer_address1" varchar(40),
    "imm_employer_address2" varchar(40),
    "imm_employer_address3" varchar(40),
    "imm_employer_address4" varchar(40),
    "imm_employer_city" varchar(6),
    "imm_employer_state" varchar(3),
    "imm_employer_email" varchar(60),
    "imm_employer_phone_no" varchar(25),
    "imm_employer_postcode" varchar(15),
    "imm_ners_status" varchar(3),
    "imm_ners_message" varchar(100),
    "imm_transaction_id" varchar(30),
    "ispra" numeric(1),
    "plks_no" numeric(3),
    "imm_fp_biosl" varchar(2),
    "imm_fp_availability_status" varchar(3),
    "imm_renew_count_year" varchar(2),
    "imm_pra_create_id" varchar(30),
    "imm_fp_avail" varchar(30),
    "imm_worker_name" varchar(150),
    "error_desc" varchar(100),
    "error_ind" varchar(10)
) server fomema_backup options (schema_name 'portal', table_name 'worker_registration');

\echo 'created foreign table fomema_backup_portal.worker_registration';

drop foreign table if exists fomema_backup_portal.worker_registration_hdr;

create foreign table if not exists fomema_backup_portal.worker_registration_hdr (
    "batchid" numeric,
    "employer_code" varchar(10),
    "creation_date" timestamp,
    "batchdesc" varchar(100),
    "modification_date" timestamp,
    "ins_svcprovider" varchar(3)
) server fomema_backup options (schema_name 'portal', table_name 'worker_registration_hdr');

\echo 'created foreign table fomema_backup_portal.worker_registration_hdr';
