
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into copy_logs (description, begin_at) values ('start copy portal-table process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table ANNOUNCEMENT', 509 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.ANNOUNCEMENT;

    create foreign table if not exists portal_foreign.ANNOUNCEMENT (
        "id" numeric,
        "creation_date" timestamp,
        "subject" varchar(250),
        "start_date" timestamp,
        "end_date" timestamp,
        "content" text,
        "status" numeric(1)
    ) server portal_server options (schema 'PORTALDB', table 'ANNOUNCEMENT');

    raise notice 'created foreign table for ANNOUNCEMENT';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.ANNOUNCEMENT; */

    -- create table if not exists portal.ANNOUNCEMENT as select * from portal_foreign.ANNOUNCEMENT;

    raise notice 'copied table portal.ANNOUNCEMENT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_REGISTRATION', 510 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.EMPLOYER_REGISTRATION;

    create foreign table if not exists portal_foreign.EMPLOYER_REGISTRATION (
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
    ) server portal_server options (schema 'PORTALDB', table 'EMPLOYER_REGISTRATION');

    raise notice 'created foreign table for EMPLOYER_REGISTRATION';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.EMPLOYER_REGISTRATION; */

    -- create table if not exists portal.EMPLOYER_REGISTRATION as select * from portal_foreign.EMPLOYER_REGISTRATION;

    raise notice 'copied table portal.EMPLOYER_REGISTRATION';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table EMPLOYER_REGISTRATION_APPROVAL', 511 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.EMPLOYER_REGISTRATION_APPROVAL;

    create foreign table if not exists portal_foreign.EMPLOYER_REGISTRATION_APPROVAL (
        "approve_status" numeric(10),
        "comments" varchar(400),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "nios_uuid" varchar(20),
        "regid" numeric(19)
    ) server portal_server options (schema 'PORTALDB', table 'EMPLOYER_REGISTRATION_APPROVAL');

    raise notice 'created foreign table for EMPLOYER_REGISTRATION_APPROVAL';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.EMPLOYER_REGISTRATION_APPROVAL; */

    -- create table if not exists portal.EMPLOYER_REGISTRATION_APPROVAL as select * from portal_foreign.EMPLOYER_REGISTRATION_APPROVAL;

    raise notice 'copied table portal.EMPLOYER_REGISTRATION_APPROVAL';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FPX_BANK_MASTER', 512 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.FPX_BANK_MASTER;

    create foreign table if not exists portal_foreign.FPX_BANK_MASTER (
        "bankid" varchar(30),
        "bankname" varchar(100),
        "fpxtype" varchar(2),
        "banktype" numeric,
        "banklongname" varchar(100)
    ) server portal_server options (schema 'PORTALDB', table 'FPX_BANK_MASTER');

    raise notice 'created foreign table for FPX_BANK_MASTER';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.FPX_BANK_MASTER; */

    -- create table if not exists portal.FPX_BANK_MASTER as select * from portal_foreign.FPX_BANK_MASTER;

    raise notice 'copied table portal.FPX_BANK_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_AMENDMENT', 513 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.FW_AMENDMENT;

    create foreign table if not exists portal_foreign.FW_AMENDMENT (
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
    ) server portal_server options (schema 'PORTALDB', table 'FW_AMENDMENT');

    raise notice 'created foreign table for FW_AMENDMENT';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.FW_AMENDMENT; */

    -- create table if not exists portal.FW_AMENDMENT as select * from portal_foreign.FW_AMENDMENT;

    raise notice 'copied table portal.FW_AMENDMENT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table INSURANCE_PURCHASE', 514 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.INSURANCE_PURCHASE;

    create foreign table if not exists portal_foreign.INSURANCE_PURCHASE (
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
    ) server portal_server options (schema 'PORTALDB', table 'INSURANCE_PURCHASE');

    raise notice 'created foreign table for INSURANCE_PURCHASE';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.INSURANCE_PURCHASE; */

    -- create table if not exists portal.INSURANCE_PURCHASE as select * from portal_foreign.INSURANCE_PURCHASE;

    raise notice 'copied table portal.INSURANCE_PURCHASE';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT', 515 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.PAYMENT;

    create foreign table if not exists portal_foreign.PAYMENT (
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
    ) server portal_server options (schema 'PORTALDB', table 'PAYMENT');

    raise notice 'created foreign table for PAYMENT';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.PAYMENT; */

    -- create table if not exists portal.PAYMENT as select * from portal_foreign.PAYMENT;

    raise notice 'copied table portal.PAYMENT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PAYMENT_LOG', 516 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.PAYMENT_LOG;

    create foreign table if not exists portal_foreign.PAYMENT_LOG (
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
    ) server portal_server options (schema 'PORTALDB', table 'PAYMENT_LOG');

    raise notice 'created foreign table for PAYMENT_LOG';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.PAYMENT_LOG; */

    -- create table if not exists portal.PAYMENT_LOG as select * from portal_foreign.PAYMENT_LOG;

    raise notice 'copied table portal.PAYMENT_LOG';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SUPPORT_DOCUMENT', 517 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.SUPPORT_DOCUMENT;

    create foreign table if not exists portal_foreign.SUPPORT_DOCUMENT (
        "regid" numeric,
        "docdata" bytea,
        "doctype" numeric,
        "docid" numeric,
        "imagetype" numeric
    ) server portal_server options (schema 'PORTALDB', table 'SUPPORT_DOCUMENT');

    raise notice 'created foreign table for SUPPORT_DOCUMENT';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.SUPPORT_DOCUMENT; */

    -- create table if not exists portal.SUPPORT_DOCUMENT as select * from portal_foreign.SUPPORT_DOCUMENT;

    raise notice 'copied table portal.SUPPORT_DOCUMENT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table SUPPORT_DOCUMENT_PATH', 518 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.SUPPORT_DOCUMENT_PATH;

    create foreign table if not exists portal_foreign.SUPPORT_DOCUMENT_PATH (
        "regid" numeric,
        "docdata" varchar(100),
        "doctype" numeric,
        "docid" numeric,
        "imagetype" numeric
    ) server portal_server options (schema 'PORTALDB', table 'SUPPORT_DOCUMENT_PATH');

    raise notice 'created foreign table for SUPPORT_DOCUMENT_PATH';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.SUPPORT_DOCUMENT_PATH; */

    -- create table if not exists portal.SUPPORT_DOCUMENT_PATH as select * from portal_foreign.SUPPORT_DOCUMENT_PATH;

    raise notice 'copied table portal.SUPPORT_DOCUMENT_PATH';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_LOG', 519 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.USER_LOG;

    create foreign table if not exists portal_foreign.USER_LOG (
        "userid" varchar(20),
        "log_message" varchar(4000),
        "log_date" timestamp,
        "sessionid" varchar(50)
    ) server portal_server options (schema 'PORTALDB', table 'USER_LOG');

    raise notice 'created foreign table for USER_LOG';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.USER_LOG; */

    -- create table if not exists portal.USER_LOG as select * from portal_foreign.USER_LOG;

    raise notice 'copied table portal.USER_LOG';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_MASTER', 520 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.USER_MASTER;

    create foreign table if not exists portal_foreign.USER_MASTER (
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
    ) server portal_server options (schema 'PORTALDB', table 'USER_MASTER');

    raise notice 'created foreign table for USER_MASTER';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.USER_MASTER; */

    -- create table if not exists portal.USER_MASTER as select * from portal_foreign.USER_MASTER;

    raise notice 'copied table portal.USER_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_SESSION', 521 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.USER_SESSION;

    create foreign table if not exists portal_foreign.USER_SESSION (
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "request_uri" varchar(4000),
        "timeout" numeric(10),
        "module" varchar(5),
        "userid" varchar(20),
        "browser_string" varchar(4000)
    ) server portal_server options (schema 'PORTALDB', table 'USER_SESSION');

    raise notice 'created foreign table for USER_SESSION';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.USER_SESSION; */

    -- create table if not exists portal.USER_SESSION as select * from portal_foreign.USER_SESSION;

    raise notice 'copied table portal.USER_SESSION';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_LIST', 522 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.WORKER_LIST;

    create foreign table if not exists portal_foreign.WORKER_LIST (
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
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_LIST');

    raise notice 'created foreign table for WORKER_LIST';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.WORKER_LIST; */

    -- create table if not exists portal.WORKER_LIST as select * from portal_foreign.WORKER_LIST;

    raise notice 'copied table portal.WORKER_LIST';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_LOG', 523 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.WORKER_LOG;

    create foreign table if not exists portal_foreign.WORKER_LOG (
        "invoiceno" varchar(20),
        "workerlist_id" numeric,
        "doctor_code" varchar(10)
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_LOG');

    raise notice 'created foreign table for WORKER_LOG';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.WORKER_LOG; */

    -- create table if not exists portal.WORKER_LOG as select * from portal_foreign.WORKER_LOG;

    raise notice 'copied table portal.WORKER_LOG';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_REGISTRATION', 524 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.WORKER_REGISTRATION;

    create foreign table if not exists portal_foreign.WORKER_REGISTRATION (
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
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_REGISTRATION');

    raise notice 'created foreign table for WORKER_REGISTRATION';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.WORKER_REGISTRATION; */

    -- create table if not exists portal.WORKER_REGISTRATION as select * from portal_foreign.WORKER_REGISTRATION;

    raise notice 'copied table portal.WORKER_REGISTRATION';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table WORKER_REGISTRATION_HDR', 525 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists portal_foreign.WORKER_REGISTRATION_HDR;

    create foreign table if not exists portal_foreign.WORKER_REGISTRATION_HDR (
        "batchid" numeric,
        "employer_code" varchar(10),
        "creation_date" timestamp,
        "batchdesc" varchar(100),
        "modification_date" timestamp,
        "ins_svcprovider" varchar(3)
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_REGISTRATION_HDR');

    raise notice 'created foreign table for WORKER_REGISTRATION_HDR';
    -- /foreign table

    -- copy table
    /* drop table if exists portal.WORKER_REGISTRATION_HDR; */

    -- create table if not exists portal.WORKER_REGISTRATION_HDR as select * from portal_foreign.WORKER_REGISTRATION_HDR;

    raise notice 'copied table portal.WORKER_REGISTRATION_HDR';
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