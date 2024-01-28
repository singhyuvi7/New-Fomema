
do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
begin
    insert into public.migration_logs (description, start_at) values ('start index nios master process', clock_timestamp()) returning id into v_copy_log_id_process;

insert into public.migration_logs (description, start_at) values ('start index agent_master.post_code, idx_agent_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_post_code on fomema_backup_nios.agent_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_master.district_code, idx_agent_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_district_code on fomema_backup_nios.agent_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_master.state_code, idx_agent_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_state_code on fomema_backup_nios.agent_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_master.country_code, idx_agent_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_country_code on fomema_backup_nios.agent_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_master.branch_code, idx_agent_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_branch_code on fomema_backup_nios.agent_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index agent_master.status_code, idx_agent_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_agent_master_on_status_code on fomema_backup_nios.agent_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index bank_master.bank_code, idx_bank_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bank_master_on_bank_code on fomema_backup_nios.bank_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index bank_master.swift_code, idx_bank_master_on_swift_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_bank_master_on_swift_code on fomema_backup_nios.bank_master(swift_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index code_master.state_code, idx_code_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_code_master_on_state_code on fomema_backup_nios.code_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index code_state_master.state_code, idx_code_state_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_code_state_master_on_state_code on fomema_backup_nios.code_state_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index code_state_master.map_code, idx_code_state_master_on_map_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_code_state_master_on_map_code on fomema_backup_nios.code_state_master(map_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index condition_master.parameter_code, idx_condition_master_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_condition_master_on_parameter_code on fomema_backup_nios.condition_master(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index country_master.country_code, idx_country_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_country_master_on_country_code on fomema_backup_nios.country_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index district_master.district_code, idx_district_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_master_on_district_code on fomema_backup_nios.district_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_master.country_code, idx_district_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_master_on_country_code on fomema_backup_nios.district_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index district_master.state_code, idx_district_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_district_master_on_state_code on fomema_backup_nios.district_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_master.doctor_code, idx_doctor_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_doctor_code on fomema_backup_nios.doctor_master(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.post_code, idx_doctor_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_post_code on fomema_backup_nios.doctor_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.state_code, idx_doctor_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_state_code on fomema_backup_nios.doctor_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.district_code, idx_doctor_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_district_code on fomema_backup_nios.doctor_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.country_code, idx_doctor_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_country_code on fomema_backup_nios.doctor_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.radiologist_code, idx_doctor_master_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_radiologist_code on fomema_backup_nios.doctor_master(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.xray_code, idx_doctor_master_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_xray_code on fomema_backup_nios.doctor_master(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.laboratory_code, idx_doctor_master_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_laboratory_code on fomema_backup_nios.doctor_master(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.status_code, idx_doctor_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_status_code on fomema_backup_nios.doctor_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.prefer_xray_code, idx_doctor_master_on_prefer_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_prefer_xray_code on fomema_backup_nios.doctor_master(prefer_xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.gst_code, idx_doctor_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_gst_code on fomema_backup_nios.doctor_master(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index doctor_master.bank_code, idx_doctor_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_master_on_bank_code on fomema_backup_nios.doctor_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index doctor_parameter_master.parameter_code, idx_doctor_parameter_master_on_parameter_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_doctor_parameter_master_on_parameter_code on fomema_backup_nios.doctor_parameter_master(parameter_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index draft_master.approval_code, idx_draft_master_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_approval_code on fomema_backup_nios.draft_master(approval_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.bank_code, idx_draft_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_bank_code on fomema_backup_nios.draft_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.branch_code, idx_draft_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_branch_code on fomema_backup_nios.draft_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.contact_district_code, idx_draft_master_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_contact_district_code on fomema_backup_nios.draft_master(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.contact_post_code, idx_draft_master_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_contact_post_code on fomema_backup_nios.draft_master(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.contact_state_code, idx_draft_master_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_contact_state_code on fomema_backup_nios.draft_master(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index draft_master.zone_code, idx_draft_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_draft_master_on_zone_code on fomema_backup_nios.draft_master(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.approval_code, idx_employer_alloc_master_on_approval_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_approval_code on fomema_backup_nios.employer_alloc_master(approval_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.bank_code, idx_employer_alloc_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_bank_code on fomema_backup_nios.employer_alloc_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.branch_code, idx_employer_alloc_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_branch_code on fomema_backup_nios.employer_alloc_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.contact_district_code, idx_employer_alloc_master_on_contact_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_contact_district_code on fomema_backup_nios.employer_alloc_master(contact_district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.contact_post_code, idx_employer_alloc_master_on_contact_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_contact_post_code on fomema_backup_nios.employer_alloc_master(contact_post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.contact_state_code, idx_employer_alloc_master_on_contact_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_contact_state_code on fomema_backup_nios.employer_alloc_master(contact_state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_alloc_master.zone_code, idx_employer_alloc_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_alloc_master_on_zone_code on fomema_backup_nios.employer_alloc_master(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index employer_master.company_regno, idx_employer_master_on_company_regno', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_company_regno on fomema_backup_nios.employer_master(company_regno);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.icpassport_no, idx_employer_master_on_icpassport_no', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_icpassport_no on fomema_backup_nios.employer_master(icpassport_no);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.employer_code, idx_employer_master_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_employer_code on fomema_backup_nios.employer_master(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.business_code, idx_employer_master_on_business_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_business_code on fomema_backup_nios.employer_master(business_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.country_code, idx_employer_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_country_code on fomema_backup_nios.employer_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.state_code, idx_employer_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_state_code on fomema_backup_nios.employer_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.district_code, idx_employer_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_district_code on fomema_backup_nios.employer_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.status_code, idx_employer_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_status_code on fomema_backup_nios.employer_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.post_code, idx_employer_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_post_code on fomema_backup_nios.employer_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.doctor_code, idx_employer_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_doctor_code on fomema_backup_nios.employer_master(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index employer_master.branch_code, idx_employer_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_employer_master_on_branch_code on fomema_backup_nios.employer_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index fin_batch_master.batch_number, idx_fin_batch_master_on_batch_number', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_fin_batch_master_on_batch_number on fomema_backup_nios.fin_batch_master(batch_number);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index foreign_clinic_master.clinic_code, idx_foreign_clinic_master_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_clinic_master_on_clinic_code on fomema_backup_nios.foreign_clinic_master(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_clinic_master.country_code, idx_foreign_clinic_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_clinic_master_on_country_code on fomema_backup_nios.foreign_clinic_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_clinic_master.status_code, idx_foreign_clinic_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_clinic_master_on_status_code on fomema_backup_nios.foreign_clinic_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_cancel.worker_code, idx_foreign_worker_master_cancel_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_cancel_on_worker_code on fomema_backup_nios.foreign_worker_master_cancel(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_cancel.country_code, idx_foreign_worker_master_cancel_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_cancel_on_country_code on fomema_backup_nios.foreign_worker_master_cancel(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_cancel.employer_code, idx_foreign_worker_master_cancel_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_cancel_on_employer_code on fomema_backup_nios.foreign_worker_master_cancel(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_cancel.status_code, idx_foreign_worker_master_cancel_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_cancel_on_status_code on fomema_backup_nios.foreign_worker_master_cancel(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_cancel.clinic_code, idx_foreign_worker_master_cancel_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_cancel_on_clinic_code on fomema_backup_nios.foreign_worker_master_cancel(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_delete.worker_code, idx_foreign_worker_master_delete_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_delete_on_worker_code on fomema_backup_nios.foreign_worker_master_delete(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_delete.country_code, idx_foreign_worker_master_delete_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_delete_on_country_code on fomema_backup_nios.foreign_worker_master_delete(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_delete.employer_code, idx_foreign_worker_master_delete_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_delete_on_employer_code on fomema_backup_nios.foreign_worker_master_delete(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_delete.status_code, idx_foreign_worker_master_delete_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_delete_on_status_code on fomema_backup_nios.foreign_worker_master_delete(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index foreign_worker_master_delete.clinic_code, idx_foreign_worker_master_delete_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_foreign_worker_master_delete_on_clinic_code on fomema_backup_nios.foreign_worker_master_delete(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index invoice_master.service_provider_code, idx_invoice_master_on_service_provider_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_invoice_master_on_service_provider_code on fomema_backup_nios.invoice_master(service_provider_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index invoice_master.gst_code, idx_invoice_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_invoice_master_on_gst_code on fomema_backup_nios.invoice_master(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index jobtype_master.status_code, idx_jobtype_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_jobtype_master_on_status_code on fomema_backup_nios.jobtype_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index laboratory_master.laboratory_code, idx_laboratory_master_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_laboratory_code on fomema_backup_nios.laboratory_master(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.post_code, idx_laboratory_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_post_code on fomema_backup_nios.laboratory_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.state_code, idx_laboratory_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_state_code on fomema_backup_nios.laboratory_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.district_code, idx_laboratory_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_district_code on fomema_backup_nios.laboratory_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.country_code, idx_laboratory_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_country_code on fomema_backup_nios.laboratory_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.status_code, idx_laboratory_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_status_code on fomema_backup_nios.laboratory_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.gst_code, idx_laboratory_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_gst_code on fomema_backup_nios.laboratory_master(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index laboratory_master.bank_code, idx_laboratory_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_laboratory_master_on_bank_code on fomema_backup_nios.laboratory_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index lab_rates_master.lab_code, idx_lab_rates_master_on_lab_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_lab_rates_master_on_lab_code on fomema_backup_nios.lab_rates_master(lab_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index myimms_country_master.nios_country_code, idx_myimms_country_master_on_nios_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_myimms_country_master_on_nios_country_code on fomema_backup_nios.myimms_country_master(nios_country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index myimms_country_master.myimms_country_code, idx_myimms_country_master_on_myimms_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_myimms_country_master_on_myimms_country_code on fomema_backup_nios.myimms_country_master(myimms_country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index post_master.post_code, idx_post_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_post_master_on_post_code on fomema_backup_nios.post_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index radiologist_master.radiologist_code, idx_radiologist_master_on_radiologist_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_radiologist_code on fomema_backup_nios.radiologist_master(radiologist_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.post_code, idx_radiologist_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_post_code on fomema_backup_nios.radiologist_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.district_code, idx_radiologist_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_district_code on fomema_backup_nios.radiologist_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.state_code, idx_radiologist_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_state_code on fomema_backup_nios.radiologist_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.country_code, idx_radiologist_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_country_code on fomema_backup_nios.radiologist_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.status_code, idx_radiologist_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_status_code on fomema_backup_nios.radiologist_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.gst_code, idx_radiologist_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_gst_code on fomema_backup_nios.radiologist_master(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index radiologist_master.bank_code, idx_radiologist_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_radiologist_master_on_bank_code on fomema_backup_nios.radiologist_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;




insert into public.migration_logs (description, start_at) values ('start index scb_pay_master.worker_code, idx_scb_pay_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_on_worker_code on fomema_backup_nios.scb_pay_master(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_master.doctor_code, idx_scb_pay_master_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_on_doctor_code on fomema_backup_nios.scb_pay_master(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_master.xray_clinic_code, idx_scb_pay_master_on_xray_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_on_xray_clinic_code on fomema_backup_nios.scb_pay_master(xray_clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index scb_pay_master_upload.worker_code, idx_scb_pay_master_upload_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_upload_on_worker_code on fomema_backup_nios.scb_pay_master_upload(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_master_upload.doctor_code, idx_scb_pay_master_upload_on_doctor_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_upload_on_doctor_code on fomema_backup_nios.scb_pay_master_upload(doctor_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index scb_pay_master_upload.xray_clinic_code, idx_scb_pay_master_upload_on_xray_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_scb_pay_master_upload_on_xray_clinic_code on fomema_backup_nios.scb_pay_master_upload(xray_clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index service_providers_bank_master.bank_code, idx_service_providers_bank_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_bank_master_on_bank_code on fomema_backup_nios.service_providers_bank_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index service_providers_bank_master.swift_code, idx_service_providers_bank_master_on_swift_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_service_providers_bank_master_on_swift_code on fomema_backup_nios.service_providers_bank_master(swift_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index state_master.state_code, idx_state_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_state_master_on_state_code on fomema_backup_nios.state_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index state_master_rpt.state_code, idx_state_master_rpt_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_state_master_rpt_on_state_code on fomema_backup_nios.state_master_rpt(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index state_post_master.state_code, idx_state_post_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_state_post_master_on_state_code on fomema_backup_nios.state_post_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index state_post_master.post_code, idx_state_post_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_state_post_master_on_post_code on fomema_backup_nios.state_post_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;






insert into public.migration_logs (description, start_at) values ('start index user_master.branch_code, idx_user_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_user_master_on_branch_code on fomema_backup_nios.user_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index v_appeal_master.trans_id, idx_v_appeal_master_on_trans_id', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_appeal_master_on_trans_id on fomema_backup_nios.v_appeal_master(trans_id);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_appeal_master.worker_code, idx_v_appeal_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_appeal_master_on_worker_code on fomema_backup_nios.v_appeal_master(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.creation_date, idx_v_foreign_worker_master_on_creation_date', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_creation_date on fomema_backup_nios.v_foreign_worker_master(creation_date);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.worker_code, idx_v_foreign_worker_master_on_worker_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_worker_code on fomema_backup_nios.v_foreign_worker_master(worker_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.country_code, idx_v_foreign_worker_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_country_code on fomema_backup_nios.v_foreign_worker_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.employer_code, idx_v_foreign_worker_master_on_employer_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_employer_code on fomema_backup_nios.v_foreign_worker_master(employer_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.status_code, idx_v_foreign_worker_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_status_code on fomema_backup_nios.v_foreign_worker_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index v_foreign_worker_master.clinic_code, idx_v_foreign_worker_master_on_clinic_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_foreign_worker_master_on_clinic_code on fomema_backup_nios.v_foreign_worker_master(clinic_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



insert into public.migration_logs (description, start_at) values ('start index visit_rpt_labmaster.laboratory_code, idx_visit_rpt_labmaster_on_laboratory_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_rpt_labmaster_on_laboratory_code on fomema_backup_nios.visit_rpt_labmaster(laboratory_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index visit_rpt_labmaster.cov_districtcode, idx_visit_rpt_labmaster_on_cov_districtcode', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_visit_rpt_labmaster_on_cov_districtcode on fomema_backup_nios.visit_rpt_labmaster(cov_districtcode);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index v_user_master.branch_code, idx_v_user_master_on_branch_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_v_user_master_on_branch_code on fomema_backup_nios.v_user_master(branch_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index xray_master.xray_code, idx_xray_master_on_xray_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_xray_code on fomema_backup_nios.xray_master(xray_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.post_code, idx_xray_master_on_post_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_post_code on fomema_backup_nios.xray_master(post_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.district_code, idx_xray_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_district_code on fomema_backup_nios.xray_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.state_code, idx_xray_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_state_code on fomema_backup_nios.xray_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.country_code, idx_xray_master_on_country_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_country_code on fomema_backup_nios.xray_master(country_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.status_code, idx_xray_master_on_status_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_status_code on fomema_backup_nios.xray_master(status_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.gst_code, idx_xray_master_on_gst_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_gst_code on fomema_backup_nios.xray_master(gst_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index xray_master.bank_code, idx_xray_master_on_bank_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_xray_master_on_bank_code on fomema_backup_nios.xray_master(bank_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;


insert into public.migration_logs (description, start_at) values ('start index zone_master.zone_code, idx_zone_master_on_zone_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_zone_master_on_zone_code on fomema_backup_nios.zone_master(zone_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index zone_master.state_code, idx_zone_master_on_state_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_zone_master_on_state_code on fomema_backup_nios.zone_master(state_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;

    insert into public.migration_logs (description, start_at) values ('start index zone_master.district_code, idx_zone_master_on_district_code', clock_timestamp()) returning id into v_copy_log_id_item;
    commit;

    create index if not exists idx_zone_master_on_district_code on fomema_backup_nios.zone_master(district_code);

    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_item;



    update public.migration_logs set end_at = clock_timestamp() where id = v_copy_log_id_process;

end;
$$;
