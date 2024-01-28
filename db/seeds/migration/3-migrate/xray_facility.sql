\echo 'xray_facility.sql loaded'

do $$
declare
    v_log_id bigint;
	co_id bigint;
    new_ic_id bigint;
	v_roc_id bigint;
begin
    select start_migration_log('xray_facility.sql') into v_log_id;
    commit;

	select id into co_id from payment_methods where code = 'OUT_CASHORDER';
    select id into new_ic_id from payment_methods where code = 'OUT_GIRONEWIC';
	select id into v_roc_id from payment_methods where code = 'OUT_GIROROC';

    with nios_group as (
        select g.id, g.group_code, g.service_type, g.email_address, g.bank_account_no, g.bank_account_holder_name, banks.id as bank_id, g.roc, count(g.id) as cnt
        from fomema_backup_nios.service_providers_group g
        join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
        left join banks on g.bank_code = banks.code
        where g.service_type = 'X'
        group by g.id, g.group_code, g.service_type, g.email_address, g.bank_account_no, g.bank_account_holder_name, banks.id, g.roc
    )

insert into xray_facilities (
	code, name, 
	company_name, 
    business_registration_number,
	created_at, 
	address1, address2, address3, address4, 
	postcode, phone, fax, 
	town_id, state_id, country_id, 
	email, qualification, status, comment, 
	created_by, updated_by, updated_at, 
	xray_license_number, xray_fac_flag, xray_file_number, 
	district_health_office_id, icno, 
	radiologist_operated, radiologist_name, 
	apc_year, apc_number, male_rate, female_rate, 
	bank_account_number, bank_id, film_type, 
	license_holder_name, mobile, renewal_agreement_date, fp_device,
	service_provider_group_id, 
	registration_approved_at,
	activated_at,
	payment_method_id,
	email_payment, bank_payment_id
) 
select xm.xray_code, xm.xray_name, 
case when nios_group.cnt = 1 then nios_group.bank_account_holder_name else null end, 
case when nios_group.cnt = 1 then nios_group.roc else null end,
coalesce(xm.creation_date, clock_timestamp()) created_at, 
coalesce(xm.address1,''), coalesce(xm.address2,''), coalesce(xm.address3,''), coalesce(xm.address4,''), 
xm.post_code, xm.phone, xm.fax, 
/* xm.district_code */ towns.id town_id, /* xm.state_code */ states.id state_id, /* xm.country_code */ countries.id country_id, 
xm.email_id, xm.qualification, /* xm.status_code */ case when xm.status_code = 'Y' then 'ACTIVE' 
else 'INACTIVE' end status, xm.comments, 
/* xm.creator_id */ creator_users.id created_by, /* xm.modify_id */ updator_users.id updated_by, coalesce(xm.modification_date, clock_timestamp()) updated_at, 
xm.license, /* xm.xray_fac_flag */ case when xm.xray_fac_flag = 'Y' then true else false end xray_fac_flag, xm.xregid, 
/* xm.nearest_district_office */ dho.id district_health_office_id, coalesce(xm.xray_ic_new, xm.xray_ic_old), 
/* xm.radiooperated */ case when xm.radiooperated = 'Y' then true else false end radiologist_operated, xm.radiologist_name, 
xm.apc_year::integer, xm.apc_no, 
22.50,
22.50,
case when nios_group.cnt = 1 then nios_group.bank_account_no else xm.bank_account_no end, 
case when nios_group.cnt = 1 then nios_group.bank_id else banks.id end, 
/* xm.digital_image */ case when xm.digital_image = 1 then 'DIGITAL' else 'ANALOG' end film_type, 
xm.primary_contact_person, xm.mobile_no, xm.renewal_date, xm.fp_device,
case when nios_group.cnt = 1 then null else sp_group.id end service_provider_group_id,
case when xm.status_code = 'Y' then coalesce(xm.creation_date, clock_timestamp()) end,
case when xm.status_code = 'Y' then coalesce(xm.creation_date, clock_timestamp()) end,
case when nios_group.cnt = 1 then (case when nios_group.bank_account_no is null then co_id else v_roc_id end)
when xm.bank_account_no is null then co_id
when xm.mystics_ic = 0 then co_id 
when xm.mystics_ic in (1,2) then new_ic_id end,
case when nios_group.cnt = 1 then nios_group.email_address else xm.email_id end, 
case when nios_group.cnt = 1 then nios_group.roc else coalesce(xm.xray_ic_new, xm.xray_ic_old) end
from fomema_backup_nios.xray_master xm
left join states on states.code = xm.state_code 
left join towns on towns.code = xm.district_code 
left join countries on countries.old_code = xm.country_code 
left join fomema_backup_nios.v_user_master creators on xm.creator_id = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on xm.modify_id = updators.uuid 
left join users updator_users on updators.userid = updator_users.code 
left join fomema_backup_nios.district_office doff on doff.office_code = xm.nearest_district_office 
left join district_health_offices dho on dho.code = doff.office_code 
left join banks on xm.bank_code = banks.code
left join fomema_backup_nios.service_providers_group_member group_member on xm.xray_code = group_member.service_member
left join nios_group on group_member.service_providers_group_id = nios_group.id
left join service_provider_groups sp_group on nios_group.group_code = sp_group.code
order by xm.creation_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'xray_facility.sql ended'
