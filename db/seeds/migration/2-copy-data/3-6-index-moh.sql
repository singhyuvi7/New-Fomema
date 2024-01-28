
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index moh process', clock_timestamp()) returning id into v_copy_log_id_process;

insert into public.migration_logs (description, start_at) values ('start index fw_detail_static.parameter_code, idx_fw_detail_static_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_static_on_parameter_code on fomema_backup_moh.fw_detail_static(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_detail_static.trans_id, idx_fw_detail_static_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_detail_static_on_trans_id on fomema_backup_moh.fw_detail_static(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fw_transaction_static.emp_district_code, idx_fw_transaction_static_on_emp_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_static_on_emp_district_code on fomema_backup_moh.fw_transaction_static(emp_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_static.doc_district_code, idx_fw_transaction_static_on_doc_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_static_on_doc_district_code on fomema_backup_moh.fw_transaction_static(doc_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_static.trans_id, idx_fw_transaction_static_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_static_on_trans_id on fomema_backup_moh.fw_transaction_static(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_transaction_static.country_code, idx_fw_transaction_static_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_transaction_static_on_country_code on fomema_backup_moh.fw_transaction_static(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index notification.trans_id, idx_notification_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_notification_on_trans_id on fomema_backup_moh.notification(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index notification.created_by, idx_notification_on_created_by', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_notification_on_created_by on fomema_backup_moh.notification(created_by);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
