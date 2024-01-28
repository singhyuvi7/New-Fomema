
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_table bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start copy moh process', clock_timestamp()) returning id into v_copy_log_id_process;
        
insert into public.migration_logs (description, start_at) values ('start copy table fw_detail_static', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists moh.fw_detail_static;

    create foreign table if not exists moh.fw_detail_static (
        "trans_id" varchar(14),
        "parameter_code" varchar(10),
        "med_history" varchar(5),
        "effected_date" timestamp,
        "parameter_value" varchar(20),
        "creation_date" timestamp
    ) server fomema_backup options (schema_name 'moh', table_name 'fw_detail_static');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_moh.fw_detail_static; */

    create table if not exists fomema_backup_moh.fw_detail_static as select * from moh.fw_detail_static;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table fw_transaction_static', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists moh.fw_transaction_static;

    create foreign table if not exists moh.fw_transaction_static (
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
    ) server fomema_backup options (schema_name 'moh', table_name 'fw_transaction_static');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_moh.fw_transaction_static; */

    create table if not exists fomema_backup_moh.fw_transaction_static as select * from moh.fw_transaction_static;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;
        
insert into public.migration_logs (description, start_at) values ('start copy table notification', clock_timestamp()) returning id into v_copy_log_id_table; commit;
begin
    -- foreign table
    drop foreign table if exists moh.notification;

    create foreign table if not exists moh.notification (
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
    ) server fomema_backup options (schema_name 'moh', table_name 'notification');
    -- /foreign table

    -- copy table
    /* drop table if exists fomema_backup_moh.notification; */

    create table if not exists fomema_backup_moh.notification as select * from moh.notification;
    -- /copy table
end;
update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_table; commit;

    
    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
