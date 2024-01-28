
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into copy_logs (description, begin_at) values ('start copy moh-table process', clock_timestamp()) returning id into v_copy_log_id_process;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_DETAIL_STATIC', 527 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.FW_DETAIL_STATIC;

    create foreign table if not exists moh_foreign.FW_DETAIL_STATIC (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "creation_date" timestamp
    ) server moh_server options (schema 'MOH', table 'FW_DETAIL_STATIC');

    raise notice 'created foreign table for FW_DETAIL_STATIC';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.FW_DETAIL_STATIC; */

    -- create table if not exists moh.FW_DETAIL_STATIC as select * from moh_foreign.FW_DETAIL_STATIC;

    raise notice 'copied table moh.FW_DETAIL_STATIC';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_DX', 528 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.FW_TRANSACTION_DX;

    create foreign table if not exists moh_foreign.FW_TRANSACTION_DX (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "transdate" timestamp,
        "certify_date" timestamp,
        "imm_send_date" timestamp,
        "xray_init_status" varchar(20),
        "xray_final_status" varchar(20),
        "dfit_ind" varchar(1),
        "fit_ind" varchar(1),
        "xray_film_type" varchar(1),
        "created_date" timestamp,
        "modified_date" timestamp
    ) server moh_server options (schema 'MOH', table 'FW_TRANSACTION_DX');

    raise notice 'created foreign table for FW_TRANSACTION_DX';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.FW_TRANSACTION_DX; */

    -- create table if not exists moh.FW_TRANSACTION_DX as select * from moh_foreign.FW_TRANSACTION_DX;

    raise notice 'copied table moh.FW_TRANSACTION_DX';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table FW_TRANSACTION_STATIC', 529 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.FW_TRANSACTION_STATIC;

    create foreign table if not exists moh_foreign.FW_TRANSACTION_STATIC (
        "trans_id" varchar(14),
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "country_code" varchar(3),
        "emp_code" varchar(10),
        "emp_name" varchar(150),
        "emp_address1" varchar(50),
        "emp_address2" varchar(50),
        "emp_address3" varchar(50),
        "emp_address4" varchar(50),
        "emp_postcode" varchar(10),
        "emp_district_code" varchar(7),
        "emp_state_code" varchar(7),
        "doc_code" varchar(10),
        "doc_name" varchar(50),
        "clinic_name" varchar(100),
        "doc_phone" varchar(100),
        "doc_address1" varchar(50),
        "doc_address2" varchar(50),
        "doc_address3" varchar(50),
        "doc_address4" varchar(50),
        "doc_postcode" varchar(10),
        "doc_district_code" varchar(7),
        "doc_state_code" varchar(7),
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "lab_code" varchar(10),
        "lab_name" varchar(50),
        "job_type" varchar(50),
        "sex" varchar(1),
        "dob" timestamp,
        "arrival_date" timestamp,
        "transdate" timestamp,
        "exam_date" timestamp,
        "certify_date" timestamp,
        "reg_ind" numeric,
        "fit_ind" varchar(1),
        "renew_ind" varchar(1),
        "tcupi_ind" varchar(1),
        "creation_date" timestamp
    ) server moh_server options (schema 'MOH', table 'FW_TRANSACTION_STATIC');

    raise notice 'created foreign table for FW_TRANSACTION_STATIC';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.FW_TRANSACTION_STATIC; */

    -- create table if not exists moh.FW_TRANSACTION_STATIC as select * from moh_foreign.FW_TRANSACTION_STATIC;

    raise notice 'copied table moh.FW_TRANSACTION_STATIC';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_DOCTOR_MASTER', 530 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.MOH_DOCTOR_MASTER;

    create foreign table if not exists moh_foreign.MOH_DOCTOR_MASTER (
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
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'MOH_DOCTOR_MASTER');

    raise notice 'created foreign table for MOH_DOCTOR_MASTER';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.MOH_DOCTOR_MASTER; */

    -- create table if not exists moh.MOH_DOCTOR_MASTER as select * from moh_foreign.MOH_DOCTOR_MASTER;

    raise notice 'copied table moh.MOH_DOCTOR_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_FOREIGN_WORKER_MASTER', 531 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.MOH_FOREIGN_WORKER_MASTER;

    create foreign table if not exists moh_foreign.MOH_FOREIGN_WORKER_MASTER (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "date_of_birth" timestamp,
        "arrival_date" timestamp,
        "job_type" varchar(50),
        "sex" varchar(1),
        "country_code" varchar(3),
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'MOH_FOREIGN_WORKER_MASTER');

    raise notice 'created foreign table for MOH_FOREIGN_WORKER_MASTER';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.MOH_FOREIGN_WORKER_MASTER; */

    -- create table if not exists moh.MOH_FOREIGN_WORKER_MASTER as select * from moh_foreign.MOH_FOREIGN_WORKER_MASTER;

    raise notice 'copied table moh.MOH_FOREIGN_WORKER_MASTER';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_FW_DETAIL', 532 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.MOH_FW_DETAIL;

    create foreign table if not exists moh_foreign.MOH_FW_DETAIL (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'MOH_FW_DETAIL');

    raise notice 'created foreign table for MOH_FW_DETAIL';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.MOH_FW_DETAIL; */

    -- create table if not exists moh.MOH_FW_DETAIL as select * from moh_foreign.MOH_FW_DETAIL;

    raise notice 'copied table moh.MOH_FW_DETAIL';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table MOH_FW_TRANSACTION', 533 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.MOH_FW_TRANSACTION;

    create foreign table if not exists moh_foreign.MOH_FW_TRANSACTION (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "exam_date" timestamp,
        "certify_date" timestamp,
        "fit_ind" varchar(1),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "renew_ind" varchar(1),
        "insert_date" timestamp,
        "tcupi_ind" varchar(1)
    ) server moh_server options (schema 'MOH', table 'MOH_FW_TRANSACTION');

    raise notice 'created foreign table for MOH_FW_TRANSACTION';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.MOH_FW_TRANSACTION; */

    -- create table if not exists moh.MOH_FW_TRANSACTION as select * from moh_foreign.MOH_FW_TRANSACTION;

    raise notice 'copied table moh.MOH_FW_TRANSACTION';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NOTIFICATION', 534 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.NOTIFICATION;

    create foreign table if not exists moh_foreign.NOTIFICATION (
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
        "worker_name" varchar(50),
        "employer_code" varchar(10),
        "doctor_code" varchar(10),
        "exam_date" timestamp,
        "arrival_date" timestamp,
        "date_of_birth" timestamp,
        "job_type" varchar(50),
        "country_code" varchar(3),
        "passport_no" varchar(20),
        "qrtn_ind" varchar(1),
        "release_date" timestamp
    ) server moh_server options (schema 'MOH', table 'NOTIFICATION');

    raise notice 'created foreign table for NOTIFICATION';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.NOTIFICATION; */

    -- create table if not exists moh.NOTIFICATION as select * from moh_foreign.NOTIFICATION;

    raise notice 'copied table moh.NOTIFICATION';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table NOTIFICATION_HISTORY', 535 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.NOTIFICATION_HISTORY;

    create foreign table if not exists moh_foreign.NOTIFICATION_HISTORY (
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
        "worker_name" varchar(50),
        "employer_code" varchar(10),
        "doctor_code" varchar(10),
        "exam_date" timestamp,
        "arrival_date" timestamp,
        "date_of_birth" timestamp,
        "job_type" varchar(50),
        "country_code" varchar(3),
        "passport_no" varchar(20),
        "qrtn_ind" varchar(1),
        "release_date" timestamp,
        "process" varchar(10),
        "process_date" timestamp
    ) server moh_server options (schema 'MOH', table 'NOTIFICATION_HISTORY');

    raise notice 'created foreign table for NOTIFICATION_HISTORY';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.NOTIFICATION_HISTORY; */

    -- create table if not exists moh.NOTIFICATION_HISTORY as select * from moh_foreign.NOTIFICATION_HISTORY;

    raise notice 'copied table moh.NOTIFICATION_HISTORY';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATCOL', 536 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.PBCATCOL;

    create foreign table if not exists moh_foreign.PBCATCOL (
        "pbc_tnam" varchar(60),
        "pbc_tid" numeric,
        "pbc_ownr" varchar(60),
        "pbc_cnam" varchar(60),
        "pbc_cid" numeric,
        "pbc_labl" varchar(254),
        "pbc_lpos" numeric,
        "pbc_hdr" varchar(254),
        "pbc_hpos" numeric,
        "pbc_jtfy" numeric,
        "pbc_mask" varchar(61),
        "pbc_case" numeric,
        "pbc_hght" numeric,
        "pbc_wdth" numeric,
        "pbc_ptrn" varchar(61),
        "pbc_bmap" char(1),
        "pbc_init" varchar(254),
        "pbc_cmnt" varchar(254),
        "pbc_edit" varchar(61),
        "pbc_tag" varchar(254)
    ) server moh_server options (schema 'MOH', table 'PBCATCOL');

    raise notice 'created foreign table for PBCATCOL';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.PBCATCOL; */

    -- create table if not exists moh.PBCATCOL as select * from moh_foreign.PBCATCOL;

    raise notice 'copied table moh.PBCATCOL';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATEDT', 537 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.PBCATEDT;

    create foreign table if not exists moh_foreign.PBCATEDT (
        "pbe_name" varchar(60),
        "pbe_edit" varchar(254),
        "pbe_type" numeric,
        "pbe_cntr" numeric,
        "pbe_seqn" numeric,
        "pbe_flag" numeric,
        "pbe_work" varchar(32)
    ) server moh_server options (schema 'MOH', table 'PBCATEDT');

    raise notice 'created foreign table for PBCATEDT';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.PBCATEDT; */

    -- create table if not exists moh.PBCATEDT as select * from moh_foreign.PBCATEDT;

    raise notice 'copied table moh.PBCATEDT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATFMT', 538 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.PBCATFMT;

    create foreign table if not exists moh_foreign.PBCATFMT (
        "pbf_name" varchar(60),
        "pbf_frmt" varchar(254),
        "pbf_type" numeric,
        "pbf_cntr" numeric
    ) server moh_server options (schema 'MOH', table 'PBCATFMT');

    raise notice 'created foreign table for PBCATFMT';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.PBCATFMT; */

    -- create table if not exists moh.PBCATFMT as select * from moh_foreign.PBCATFMT;

    raise notice 'copied table moh.PBCATFMT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATTBL', 539 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.PBCATTBL;

    create foreign table if not exists moh_foreign.PBCATTBL (
        "pbt_tnam" varchar(60),
        "pbt_tid" numeric,
        "pbt_ownr" varchar(60),
        "pbd_fhgt" numeric,
        "pbd_fwgt" numeric,
        "pbd_fitl" char(1),
        "pbd_funl" char(1),
        "pbd_fchr" numeric,
        "pbd_fptc" numeric,
        "pbd_ffce" varchar(36),
        "pbh_fhgt" numeric,
        "pbh_fwgt" numeric,
        "pbh_fitl" char(1),
        "pbh_funl" char(1),
        "pbh_fchr" numeric,
        "pbh_fptc" numeric,
        "pbh_ffce" varchar(36),
        "pbl_fhgt" numeric,
        "pbl_fwgt" numeric,
        "pbl_fitl" char(1),
        "pbl_funl" char(1),
        "pbl_fchr" numeric,
        "pbl_fptc" numeric,
        "pbl_ffce" varchar(36),
        "pbt_cmnt" varchar(254)
    ) server moh_server options (schema 'MOH', table 'PBCATTBL');

    raise notice 'created foreign table for PBCATTBL';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.PBCATTBL; */

    -- create table if not exists moh.PBCATTBL as select * from moh_foreign.PBCATTBL;

    raise notice 'copied table moh.PBCATTBL';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table PBCATVLD', 540 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.PBCATVLD;

    create foreign table if not exists moh_foreign.PBCATVLD (
        "pbv_name" varchar(60),
        "pbv_vald" varchar(254),
        "pbv_type" numeric,
        "pbv_cntr" numeric,
        "pbv_msg" varchar(254)
    ) server moh_server options (schema 'MOH', table 'PBCATVLD');

    raise notice 'created foreign table for PBCATVLD';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.PBCATVLD; */

    -- create table if not exists moh.PBCATVLD as select * from moh_foreign.PBCATVLD;

    raise notice 'copied table moh.PBCATVLD';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TMP_REG_RPT', 541 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TMP_REG_RPT;

    create foreign table if not exists moh_foreign.TMP_REG_RPT (
        "month_year" timestamp,
        "normal" numeric,
        "pati" numeric,
        "total" numeric
    ) server moh_server options (schema 'MOH', table 'TMP_REG_RPT');

    raise notice 'created foreign table for TMP_REG_RPT';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TMP_REG_RPT; */

    -- create table if not exists moh.TMP_REG_RPT as select * from moh_foreign.TMP_REG_RPT;

    raise notice 'copied table moh.TMP_REG_RPT';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_A', 542 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_A;

    create foreign table if not exists moh_foreign.TO_DROP_A (
        "worker_code" varchar(10),
        "certify_date" timestamp,
        "med_ind" numeric
    ) server moh_server options (schema 'MOH', table 'TO_DROP_A');

    raise notice 'created foreign table for TO_DROP_A';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_A; */

    -- create table if not exists moh.TO_DROP_A as select * from moh_foreign.TO_DROP_A;

    raise notice 'copied table moh.TO_DROP_A';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_DM_10JUL2013', 543 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_DM_10JUL2013;

    create foreign table if not exists moh_foreign.TO_DROP_DM_10JUL2013 (
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
        "dregid" numeric(10)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_DM_10JUL2013');

    raise notice 'created foreign table for TO_DROP_DM_10JUL2013';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_DM_10JUL2013; */

    -- create table if not exists moh.TO_DROP_DM_10JUL2013 as select * from moh_foreign.TO_DROP_DM_10JUL2013;

    raise notice 'copied table moh.TO_DROP_DM_10JUL2013';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_DM_17OCT2012', 544 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_DM_17OCT2012;

    create foreign table if not exists moh_foreign.TO_DROP_DM_17OCT2012 (
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
        "dregid" numeric(10)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_DM_17OCT2012');

    raise notice 'created foreign table for TO_DROP_DM_17OCT2012';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_DM_17OCT2012; */

    -- create table if not exists moh.TO_DROP_DM_17OCT2012 as select * from moh_foreign.TO_DROP_DM_17OCT2012;

    raise notice 'copied table moh.TO_DROP_DM_17OCT2012';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_DM_17OCT2012_COPY', 545 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_DM_17OCT2012_COPY;

    create foreign table if not exists moh_foreign.TO_DROP_DM_17OCT2012_COPY (
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
        "dregid" numeric(10)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_DM_17OCT2012_COPY');

    raise notice 'created foreign table for TO_DROP_DM_17OCT2012_COPY';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_DM_17OCT2012_COPY; */

    -- create table if not exists moh.TO_DROP_DM_17OCT2012_COPY as select * from moh_foreign.TO_DROP_DM_17OCT2012_COPY;

    raise notice 'copied table moh.TO_DROP_DM_17OCT2012_COPY';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_DOCTOR_MASTER_BAK', 546 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_DOCTOR_MASTER_BAK;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_DOCTOR_MASTER_BAK (
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
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_DOCTOR_MASTER_BAK');

    raise notice 'created foreign table for TO_DROP_MOH_DOCTOR_MASTER_BAK';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_DOCTOR_MASTER_BAK; */

    -- create table if not exists moh.TO_DROP_MOH_DOCTOR_MASTER_BAK as select * from moh_foreign.TO_DROP_MOH_DOCTOR_MASTER_BAK;

    raise notice 'copied table moh.TO_DROP_MOH_DOCTOR_MASTER_BAK';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_DOC_STAT_2012', 547 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012 (
        "state_name" varchar(20),
        "slab0" numeric(6),
        "slab19" numeric(6),
        "slab49" numeric(6),
        "slab99" numeric(6),
        "slab199" numeric(6),
        "slab299" numeric(6),
        "slab399" numeric(6),
        "slab499" numeric(6),
        "slab599" numeric(6),
        "slab699" numeric(6),
        "slab749" numeric(6),
        "slab799" numeric(6),
        "slab899" numeric(6),
        "slab999" numeric(6),
        "slab1kplus" numeric(6)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_DOC_STAT_2012');

    raise notice 'created foreign table for TO_DROP_MOH_DOC_STAT_2012';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_DOC_STAT_2012; */

    -- create table if not exists moh.TO_DROP_MOH_DOC_STAT_2012 as select * from moh_foreign.TO_DROP_MOH_DOC_STAT_2012;

    raise notice 'copied table moh.TO_DROP_MOH_DOC_STAT_2012';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_DOC_STAT_2012_NEW', 548 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012_NEW;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012_NEW (
        "state_name" varchar(20),
        "slab0" numeric(6),
        "slab19" numeric(6),
        "slab49" numeric(6),
        "slab99" numeric(6),
        "slab199" numeric(6),
        "slab299" numeric(6),
        "slab399" numeric(6),
        "slab499" numeric(6),
        "slab599" numeric(6),
        "slab699" numeric(6),
        "slab749" numeric(6),
        "slab799" numeric(6),
        "slab899" numeric(6),
        "slab999" numeric(6),
        "slab1kplus" numeric(6)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_DOC_STAT_2012_NEW');

    raise notice 'created foreign table for TO_DROP_MOH_DOC_STAT_2012_NEW';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_DOC_STAT_2012_NEW; */

    -- create table if not exists moh.TO_DROP_MOH_DOC_STAT_2012_NEW as select * from moh_foreign.TO_DROP_MOH_DOC_STAT_2012_NEW;

    raise notice 'copied table moh.TO_DROP_MOH_DOC_STAT_2012_NEW';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_DOC_STAT_2012_OLD', 549 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012_OLD;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_DOC_STAT_2012_OLD (
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
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_DOC_STAT_2012_OLD');

    raise notice 'created foreign table for TO_DROP_MOH_DOC_STAT_2012_OLD';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_DOC_STAT_2012_OLD; */

    -- create table if not exists moh.TO_DROP_MOH_DOC_STAT_2012_OLD as select * from moh_foreign.TO_DROP_MOH_DOC_STAT_2012_OLD;

    raise notice 'copied table moh.TO_DROP_MOH_DOC_STAT_2012_OLD';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_FWM_BAK', 550 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_FWM_BAK;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_FWM_BAK (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "date_of_birth" timestamp,
        "arrival_date" timestamp,
        "job_type" varchar(50),
        "sex" varchar(1),
        "country_code" varchar(3),
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_FWM_BAK');

    raise notice 'created foreign table for TO_DROP_MOH_FWM_BAK';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_FWM_BAK; */

    -- create table if not exists moh.TO_DROP_MOH_FWM_BAK as select * from moh_foreign.TO_DROP_MOH_FWM_BAK;

    raise notice 'copied table moh.TO_DROP_MOH_FWM_BAK';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_FW_DETAIL_BAK', 551 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_FW_DETAIL_BAK;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_FW_DETAIL_BAK (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "insert_date" timestamp
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_FW_DETAIL_BAK');

    raise notice 'created foreign table for TO_DROP_MOH_FW_DETAIL_BAK';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_FW_DETAIL_BAK; */

    -- create table if not exists moh.TO_DROP_MOH_FW_DETAIL_BAK as select * from moh_foreign.TO_DROP_MOH_FW_DETAIL_BAK;

    raise notice 'copied table moh.TO_DROP_MOH_FW_DETAIL_BAK';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_MOH_FW_TRANSACTION_BAK', 552 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_MOH_FW_TRANSACTION_BAK;

    create foreign table if not exists moh_foreign.TO_DROP_MOH_FW_TRANSACTION_BAK (
        "worker_code" varchar(10),
        "trans_id" varchar(14),
        "exam_date" timestamp,
        "certify_date" timestamp,
        "fit_ind" varchar(1),
        "doctor_code" varchar(10),
        "employer_code" varchar(10),
        "renew_ind" varchar(1),
        "insert_date" timestamp,
        "tcupi_ind" varchar(1)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_MOH_FW_TRANSACTION_BAK');

    raise notice 'created foreign table for TO_DROP_MOH_FW_TRANSACTION_BAK';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_MOH_FW_TRANSACTION_BAK; */

    -- create table if not exists moh.TO_DROP_MOH_FW_TRANSACTION_BAK as select * from moh_foreign.TO_DROP_MOH_FW_TRANSACTION_BAK;

    raise notice 'copied table moh.TO_DROP_MOH_FW_TRANSACTION_BAK';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_NOTIFICATION_2012', 553 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_NOTIFICATION_2012;

    create foreign table if not exists moh_foreign.TO_DROP_NOTIFICATION_2012 (
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
        "worker_name" varchar(50),
        "employer_code" varchar(10),
        "doctor_code" varchar(10),
        "exam_date" timestamp,
        "arrival_date" timestamp,
        "date_of_birth" timestamp,
        "job_type" varchar(50),
        "country_code" varchar(3),
        "passport_no" varchar(20),
        "qrtn_ind" varchar(1),
        "release_date" timestamp
    ) server moh_server options (schema 'MOH', table 'TO_DROP_NOTIFICATION_2012');

    raise notice 'created foreign table for TO_DROP_NOTIFICATION_2012';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_NOTIFICATION_2012; */

    -- create table if not exists moh.TO_DROP_NOTIFICATION_2012 as select * from moh_foreign.TO_DROP_NOTIFICATION_2012;

    raise notice 'copied table moh.TO_DROP_NOTIFICATION_2012';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_NOTIFICATION_TEST', 554 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_NOTIFICATION_TEST;

    create foreign table if not exists moh_foreign.TO_DROP_NOTIFICATION_TEST (
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
        "worker_name" varchar(50),
        "employer_code" varchar(10),
        "doctor_code" varchar(10),
        "exam_date" timestamp,
        "arrival_date" timestamp,
        "date_of_birth" timestamp,
        "job_type" varchar(50),
        "country_code" varchar(3),
        "passport_no" varchar(20),
        "qrtn_ind" varchar(1),
        "release_date" timestamp
    ) server moh_server options (schema 'MOH', table 'TO_DROP_NOTIFICATION_TEST');

    raise notice 'created foreign table for TO_DROP_NOTIFICATION_TEST';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_NOTIFICATION_TEST; */

    -- create table if not exists moh.TO_DROP_NOTIFICATION_TEST as select * from moh_foreign.TO_DROP_NOTIFICATION_TEST;

    raise notice 'copied table moh.TO_DROP_NOTIFICATION_TEST';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_PATI_ASYRAF', 555 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_PATI_ASYRAF;

    create foreign table if not exists moh_foreign.TO_DROP_PATI_ASYRAF (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "date_of_birth" timestamp,
        "arrival_date" timestamp,
        "transdate" timestamp,
        "certify_date" timestamp,
        "trans_id" varchar(14),
        "fit_ind" varchar(1),
        "reg_ind" numeric(2)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_PATI_ASYRAF');

    raise notice 'created foreign table for TO_DROP_PATI_ASYRAF';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_PATI_ASYRAF; */

    -- create table if not exists moh.TO_DROP_PATI_ASYRAF as select * from moh_foreign.TO_DROP_PATI_ASYRAF;

    raise notice 'copied table moh.TO_DROP_PATI_ASYRAF';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_PATI_ASYRAF_BAK', 556 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_PATI_ASYRAF_BAK;

    create foreign table if not exists moh_foreign.TO_DROP_PATI_ASYRAF_BAK (
        "worker_code" varchar(10),
        "worker_name" varchar(50),
        "passport_no" varchar(20),
        "date_of_birth" timestamp,
        "arrival_date" timestamp,
        "transdate" timestamp,
        "certify_date" timestamp,
        "trans_id" varchar(14),
        "fit_ind" varchar(1),
        "reg_ind" numeric(2)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_PATI_ASYRAF_BAK');

    raise notice 'created foreign table for TO_DROP_PATI_ASYRAF_BAK';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_PATI_ASYRAF_BAK; */

    -- create table if not exists moh.TO_DROP_PATI_ASYRAF_BAK as select * from moh_foreign.TO_DROP_PATI_ASYRAF_BAK;

    raise notice 'copied table moh.TO_DROP_PATI_ASYRAF_BAK';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_QUOTA_POSTCODE', 557 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_QUOTA_POSTCODE;

    create foreign table if not exists moh_foreign.TO_DROP_QUOTA_POSTCODE (
        "post_code" varchar(5),
        "area" varchar(40),
        "quota_set" numeric(5)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_QUOTA_POSTCODE');

    raise notice 'created foreign table for TO_DROP_QUOTA_POSTCODE';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_QUOTA_POSTCODE; */

    -- create table if not exists moh.TO_DROP_QUOTA_POSTCODE as select * from moh_foreign.TO_DROP_QUOTA_POSTCODE;

    raise notice 'copied table moh.TO_DROP_QUOTA_POSTCODE';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_QUOTA_POSTCODE_2007', 558 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_QUOTA_POSTCODE_2007;

    create foreign table if not exists moh_foreign.TO_DROP_QUOTA_POSTCODE_2007 (
        "post_code" varchar(5),
        "area" varchar(40),
        "quota_set" numeric(5)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_QUOTA_POSTCODE_2007');

    raise notice 'created foreign table for TO_DROP_QUOTA_POSTCODE_2007';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_QUOTA_POSTCODE_2007; */

    -- create table if not exists moh.TO_DROP_QUOTA_POSTCODE_2007 as select * from moh_foreign.TO_DROP_QUOTA_POSTCODE_2007;

    raise notice 'copied table moh.TO_DROP_QUOTA_POSTCODE_2007';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_QUOTA_POSTCODE_2008', 559 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_QUOTA_POSTCODE_2008;

    create foreign table if not exists moh_foreign.TO_DROP_QUOTA_POSTCODE_2008 (
        "post_code" varchar(5),
        "area" varchar(40),
        "quota_set" numeric(5)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_QUOTA_POSTCODE_2008');

    raise notice 'created foreign table for TO_DROP_QUOTA_POSTCODE_2008';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_QUOTA_POSTCODE_2008; */

    -- create table if not exists moh.TO_DROP_QUOTA_POSTCODE_2008 as select * from moh_foreign.TO_DROP_QUOTA_POSTCODE_2008;

    raise notice 'copied table moh.TO_DROP_QUOTA_POSTCODE_2008';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table TO_DROP_SWAST_LIST_ASYRAF', 560 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.TO_DROP_SWAST_LIST_ASYRAF;

    create foreign table if not exists moh_foreign.TO_DROP_SWAST_LIST_ASYRAF (
        "xray_code" varchar(10),
        "xray_name" varchar(50),
        "state_name" varchar(15),
        "install_date" varchar(15)
    ) server moh_server options (schema 'MOH', table 'TO_DROP_SWAST_LIST_ASYRAF');

    raise notice 'created foreign table for TO_DROP_SWAST_LIST_ASYRAF';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.TO_DROP_SWAST_LIST_ASYRAF; */

    -- create table if not exists moh.TO_DROP_SWAST_LIST_ASYRAF as select * from moh_foreign.TO_DROP_SWAST_LIST_ASYRAF;

    raise notice 'copied table moh.TO_DROP_SWAST_LIST_ASYRAF';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table USER_INFO', 561 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.USER_INFO;

    create foreign table if not exists moh_foreign.USER_INFO (
        "user_id" varchar(15),
        "password" varchar(15),
        "status" varchar(20)
    ) server moh_server options (schema 'MOH', table 'USER_INFO');

    raise notice 'created foreign table for USER_INFO';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.USER_INFO; */

    -- create table if not exists moh.USER_INFO as select * from moh_foreign.USER_INFO;

    raise notice 'copied table moh.USER_INFO';
    -- /copy table

    raise notice 'now: %', clock_timestamp();

exception when others then
    raise notice 'EXCEPTION ERROR : %', SQLERRM;
    GET STACKED DIAGNOSTICS v_error_stack = PG_EXCEPTION_CONTEXT;
    update copy_logs set remark = remark || v_error_stack || E'\n', end_at = clock_timestamp() where id = v_copy_log_id_table;
end;

update copy_logs set end_at = clock_timestamp() where id = v_copy_log_id_table;

commit;

begin
    -- foreign table
    insert into copy_logs (description, oracle_table_id, begin_at) values ('start table V_BRANCH_REG', 562 , clock_timestamp()) returning id into v_copy_log_id_table;
    
    drop foreign table if exists moh_foreign.V_BRANCH_REG;

    create foreign table if not exists moh_foreign.V_BRANCH_REG (
        "transdate" timestamp,
        "branch" varchar(50),
        "pati" numeric,
        "normal" numeric,
        "total" numeric
    ) server moh_server options (schema 'MOH', table 'V_BRANCH_REG');

    raise notice 'created foreign table for V_BRANCH_REG';
    -- /foreign table

    -- copy table
    /* drop table if exists moh.V_BRANCH_REG; */

    -- create table if not exists moh.V_BRANCH_REG as select * from moh_foreign.V_BRANCH_REG;

    raise notice 'copied table moh.V_BRANCH_REG';
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
