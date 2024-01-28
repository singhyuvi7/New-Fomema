
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into public.copy_logs (description, start_at) values ('start backup portal process', clock_timestamp()) returning id into v_copy_log_id_process;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table announcement', 509 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.announcement;

    create foreign table if not exists portal_foreign.announcement (
        "id" numeric,
        "creation_date" timestamp,
        "subject" varchar(250),
        "start_date" timestamp,
        "end_date" timestamp,
        "content" text,
        "status" numeric(1)
    ) server portal_server options (schema 'PORTALDB', table 'ANNOUNCEMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.announcement; */

    create table if not exists portal.announcement as select * from portal_foreign.announcement;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_registration', 510 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.employer_registration;

    create foreign table if not exists portal_foreign.employer_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.employer_registration; */

    create table if not exists portal.employer_registration as select * from portal_foreign.employer_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table employer_registration_approval', 511 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.employer_registration_approval;

    create foreign table if not exists portal_foreign.employer_registration_approval (
        "approve_status" numeric(10),
        "comments" varchar(400),
        "creation_date" timestamp,
        "creator_id" numeric(10),
        "modification_date" timestamp,
        "modify_id" numeric(10),
        "nios_uuid" varchar(20),
        "regid" numeric(19)
    ) server portal_server options (schema 'PORTALDB', table 'EMPLOYER_REGISTRATION_APPROVAL');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.employer_registration_approval; */

    create table if not exists portal.employer_registration_approval as select * from portal_foreign.employer_registration_approval;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fpx_bank_master', 512 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.fpx_bank_master;

    create foreign table if not exists portal_foreign.fpx_bank_master (
        "bankid" varchar(30),
        "bankname" varchar(100),
        "fpxtype" varchar(2),
        "banktype" numeric,
        "banklongname" varchar(100)
    ) server portal_server options (schema 'PORTALDB', table 'FPX_BANK_MASTER');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.fpx_bank_master; */

    create table if not exists portal.fpx_bank_master as select * from portal_foreign.fpx_bank_master;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table fw_amendment', 513 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.fw_amendment;

    create foreign table if not exists portal_foreign.fw_amendment (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.fw_amendment; */

    create table if not exists portal.fw_amendment as select * from portal_foreign.fw_amendment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table insurance_purchase', 514 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.insurance_purchase;

    create foreign table if not exists portal_foreign.insurance_purchase (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.insurance_purchase; */

    create table if not exists portal.insurance_purchase as select * from portal_foreign.insurance_purchase;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment', 515 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.payment;

    create foreign table if not exists portal_foreign.payment (
        "id" numeric,
        "empcode" varchar(10),
        "payment_type" numeric,
        "creation_date" timestamp,
        "amount" numeric(20, 2),
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
        "gst_amount" numeric(20, 2),
        "net_amount" numeric(20, 2),
        "nios_deposit_date" timestamp,
        "bank_area" varchar(20),
        "bank_code" varchar(20),
        "date_issue" timestamp,
        "payment_no" varchar(20),
        "zone_code" varchar(20),
        "payment_mode" numeric,
        "other_amount" numeric(20, 2),
        "other_amount_gst" numeric(20, 2),
        "fpx_txnid" varchar(20),
        "fpx_method" varchar(10),
        "buyer_bank" varchar(100),
        "gst_tax" numeric,
        "modification_date" timestamp
    ) server portal_server options (schema 'PORTALDB', table 'PAYMENT');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.payment; */

    create table if not exists portal.payment as select * from portal_foreign.payment;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table payment_log', 516 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.payment_log;

    create foreign table if not exists portal_foreign.payment_log (
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
        "net_amount" numeric(20, 2),
        "gst_amount" numeric(20, 2),
        "other_amount" numeric(20, 2),
        "other_amount_gst" numeric(20, 2),
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.payment_log; */

    create table if not exists portal.payment_log as select * from portal_foreign.payment_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table support_document_path', 518 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.support_document_path;

    create foreign table if not exists portal_foreign.support_document_path (
        "regid" numeric,
        "docdata" varchar(100),
        "doctype" numeric,
        "docid" numeric,
        "imagetype" numeric
    ) server portal_server options (schema 'PORTALDB', table 'SUPPORT_DOCUMENT_PATH');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.support_document_path; */

    create table if not exists portal.support_document_path as select * from portal_foreign.support_document_path;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_log', 519 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.user_log;

    create foreign table if not exists portal_foreign.user_log (
        "userid" varchar(20),
        "log_message" varchar(4000),
        "log_date" timestamp,
        "sessionid" varchar(50)
    ) server portal_server options (schema 'PORTALDB', table 'USER_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.user_log; */

    create table if not exists portal.user_log as select * from portal_foreign.user_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_master', 520 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.user_master;

    create foreign table if not exists portal_foreign.user_master (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.user_master; */

    create table if not exists portal.user_master as select * from portal_foreign.user_master;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table user_session', 521 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.user_session;

    create foreign table if not exists portal_foreign.user_session (
        "sessionid" varchar(50),
        "remote_address" varchar(50),
        "last_access" timestamp,
        "request_uri" varchar(4000),
        "timeout" numeric(10),
        "module" varchar(5),
        "userid" varchar(20),
        "browser_string" varchar(4000)
    ) server portal_server options (schema 'PORTALDB', table 'USER_SESSION');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.user_session; */

    create table if not exists portal.user_session as select * from portal_foreign.user_session;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_list', 522 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.worker_list;

    create foreign table if not exists portal_foreign.worker_list (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.worker_list; */

    create table if not exists portal.worker_list as select * from portal_foreign.worker_list;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_log', 523 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.worker_log;

    create foreign table if not exists portal_foreign.worker_log (
        "invoiceno" varchar(20),
        "workerlist_id" numeric,
        "doctor_code" varchar(10)
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_LOG');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.worker_log; */

    create table if not exists portal.worker_log as select * from portal_foreign.worker_log;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_registration', 524 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.worker_registration;

    create foreign table if not exists portal_foreign.worker_registration (
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
    -- /foreign table

    -- copy table
    /* drop table if exists portal.worker_registration; */

    create table if not exists portal.worker_registration as select * from portal_foreign.worker_registration;
    -- /copy table

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update public.copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;
update public.copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

insert into public.copy_logs (description, oracle_table_id, start_at) values ('start table worker_registration_hdr', 525 , clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists portal_foreign.worker_registration_hdr;

    create foreign table if not exists portal_foreign.worker_registration_hdr (
        "batchid" numeric,
        "employer_code" varchar(10),
        "creation_date" timestamp,
        "batchdesc" varchar(100),
        "modification_date" timestamp,
        "ins_svcprovider" varchar(3)
    ) server portal_server options (schema 'PORTALDB', table 'WORKER_REGISTRATION_HDR');
    -- /foreign table

    -- copy table
    /* drop table if exists portal.worker_registration_hdr; */

    create table if not exists portal.worker_registration_hdr as select * from portal_foreign.worker_registration_hdr;
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
