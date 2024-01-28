
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index portal process', clock_timestamp()) returning id into v_copy_log_id_process;


insert into public.migration_logs (description, start_at) values ('start index employer_registration.state_code, idx_employer_registration_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_state_code on fomema_backup_portal.employer_registration(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_registration.post_code, idx_employer_registration_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_post_code on fomema_backup_portal.employer_registration(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_registration.country_code, idx_employer_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_country_code on fomema_backup_portal.employer_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_registration.previous_employer_code, idx_employer_registration_on_previous_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_previous_employer_code on fomema_backup_portal.employer_registration(previous_employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_registration.employer_code, idx_employer_registration_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_employer_code on fomema_backup_portal.employer_registration(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_registration.district_code, idx_employer_registration_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_registration_on_district_code on fomema_backup_portal.employer_registration(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index fw_amendment.trans_id, idx_fw_amendment_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_amendment_on_trans_id on fomema_backup_portal.fw_amendment(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_amendment.country_code, idx_fw_amendment_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_amendment_on_country_code on fomema_backup_portal.fw_amendment(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_amendment.country_code_new, idx_fw_amendment_on_country_code_new', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_amendment_on_country_code_new on fomema_backup_portal.fw_amendment(country_code_new);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index fw_amendment.worker_code, idx_fw_amendment_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fw_amendment_on_worker_code on fomema_backup_portal.fw_amendment(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index insurance_purchase.employer_code, idx_insurance_purchase_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_insurance_purchase_on_employer_code on fomema_backup_portal.insurance_purchase(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment.empcode, idx_payment_on_empcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_empcode on fomema_backup_portal.payment(empcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment.bank_code, idx_payment_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_bank_code on fomema_backup_portal.payment(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index payment.zone_code, idx_payment_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_on_zone_code on fomema_backup_portal.payment(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index payment_log.empcode, idx_payment_log_on_empcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_payment_log_on_empcode on fomema_backup_portal.payment_log(empcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index user_master.usercode, idx_user_master_on_usercode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_usercode on fomema_backup_portal.user_master(usercode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index user_master.state_code, idx_user_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_state_code on fomema_backup_portal.user_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index user_master.post_code, idx_user_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_post_code on fomema_backup_portal.user_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index user_master.country_code, idx_user_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_country_code on fomema_backup_portal.user_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index user_master.district_code, idx_user_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_district_code on fomema_backup_portal.user_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index worker_list.country_code, idx_worker_list_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_list_on_country_code on fomema_backup_portal.worker_list(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_list.employer_code, idx_worker_list_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_list_on_employer_code on fomema_backup_portal.worker_list(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_list.worker_code, idx_worker_list_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_list_on_worker_code on fomema_backup_portal.worker_list(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_list.imm_ners_reason_code, idx_worker_list_on_imm_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_list_on_imm_ners_reason_code on fomema_backup_portal.worker_list(imm_ners_reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_list.imm_employer_postcode, idx_worker_list_on_imm_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_list_on_imm_employer_postcode on fomema_backup_portal.worker_list(imm_employer_postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_log.doctor_code, idx_worker_log_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_log_on_doctor_code on fomema_backup_portal.worker_log(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_registration.trans_id, idx_worker_registration_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_trans_id on fomema_backup_portal.worker_registration(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.country_code, idx_worker_registration_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_country_code on fomema_backup_portal.worker_registration(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.employer_code, idx_worker_registration_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_employer_code on fomema_backup_portal.worker_registration(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.worker_code, idx_worker_registration_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_worker_code on fomema_backup_portal.worker_registration(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.doctor_code, idx_worker_registration_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_doctor_code on fomema_backup_portal.worker_registration(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.previous_worker_code, idx_worker_registration_on_previous_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_previous_worker_code on fomema_backup_portal.worker_registration(previous_worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.imm_ners_reason_code, idx_worker_registration_on_imm_ners_reason_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_imm_ners_reason_code on fomema_backup_portal.worker_registration(imm_ners_reason_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index worker_registration.imm_employer_postcode, idx_worker_registration_on_imm_employer_postcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_on_imm_employer_postcode on fomema_backup_portal.worker_registration(imm_employer_postcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index worker_registration_hdr.employer_code, idx_worker_registration_hdr_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_worker_registration_hdr_on_employer_code on fomema_backup_portal.worker_registration_hdr(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
