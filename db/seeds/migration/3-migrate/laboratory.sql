
\echo 'laboratory.sql loaded';

do $$
declare
    v_log_id bigint;
    roc_id bigint;
    co_id bigint;
begin
    select start_migration_log('laboratory.sql') into v_log_id;
    commit;

    select id into roc_id from payment_methods where code = 'OUT_GIROROC';
    select id into co_id from payment_methods where code = 'OUT_CASHORDER';

drop table if exists z_laboratory_type_mappings;

create table if not exists z_laboratory_type_mappings (
    oldcode character varying,
    newcode character varying
);

create index if not exists idx_z_laboratory_type_mappings_on_oldcode on z_laboratory_type_mappings(oldcode);
create index if not exists idx_z_laboratory_type_mappings_on_newcode on z_laboratory_type_mappings(newcode);

insert into z_laboratory_type_mappings (oldcode, newcode) values ('L', 'FULL');
insert into z_laboratory_type_mappings (oldcode, newcode) values ('C', 'COLLECTION');
insert into z_laboratory_type_mappings (oldcode, newcode) values ('P', 'PARTIAL');

    with nios_group as (
        select g.id, g.group_code, g.service_type, g.email_address, g.male_rate, g.female_rate, g.bank_account_no, g.bank_account_holder_name, banks.id as bank_id, count(g.id) as cnt
        from fomema_backup_nios.service_providers_group g
        join fomema_backup_nios.service_providers_group_member m on g.id = m.service_providers_group_id
        left join banks on g.bank_code = banks.code
        where g.service_type = 'L'
        group by g.id, g.group_code, g.service_type, g.email_address, g.male_rate, g.female_rate, g.bank_account_no, g.bank_account_holder_name, banks.id
    )

insert into laboratories (
    code, name, company_name, created_at, business_registration_number, 
    address1, address2, address3, address4, postcode, phone, fax, 
    state_id, town_id, country_id, 
    email, pic_name, pic_phone, laboratory_type_id, qualification, 
    status, comment, district_health_office_id, 
    created_by, updated_by, updated_at, 
    service_provider_group_id, license, license_year, 
    web_service, web_service_passphrase, 
	male_rate, female_rate, 
    bank_account_number, bank_id, renewal_agreement_date,
    registration_approved_at,
    activated_at,
    payment_method_id,
    email_payment, 
    bank_payment_id
) 
select laboratory_code, lm.laboratory_name, 
case when nios_group.cnt = 1 then nios_group.bank_account_holder_name else null end, 
coalesce(lm.creation_date, clock_timestamp()) as created_at, lm.registration_no, 
coalesce(lm.address1,''), coalesce(lm.address2,''), coalesce(lm.address3,''), coalesce(lm.address4,''), 
lm.post_code, lm.phone, lm.fax, 
/* lm.state_code */ states.id state_id, /* lm.district_code */ towns.id town_id, /* lm.country_code */ countries.id country_id, 
lm.email_id, lm.primary_contact_person, lm.primary_contact_phone, /* lm.lab_type */ laboratory_types.id, lm.qualification, 
/* lm.status_code */ case when lm.status_code = 'Y' then 'ACTIVE' 
else 'INACTIVE' end status, lm.comments, /* lm.nearest_district_office */ dho.id district_health_office_id, 
/* lm.creator_id */ creator_users.id created_by, /* lm.modify_id */ updator_users.id updated_by, coalesce(lm.modification_date, clock_timestamp()), 
case when nios_group.cnt = 1 then null else sp_group.id end service_provider_group_id,
 lm.license, lm.license_year::integer, 
/* lm.web_service_access */ case when lm.web_service_access = 'Y' then true else false end web_service, lm.passphrase, 
case when nios_group.cnt = 1 then nios_group.male_rate else lm.male_rate end,
case when nios_group.cnt = 1 then nios_group.female_rate else lm.female_rate end,
case when nios_group.cnt = 1 then nios_group.bank_account_no else lm.bank_account_no end, 
case when nios_group.cnt = 1 then nios_group.bank_id else banks.id end, 
lm.renewal_date, 
case when lm.status_code = 'Y' then coalesce(lm.creation_date, clock_timestamp()) end,
case when lm.status_code = 'Y' then coalesce(lm.creation_date, clock_timestamp()) end,
case when nios_group.cnt = 1 then (case when nios_group.bank_account_no is null then co_id else roc_id end)
when lm.bank_account_no is null then co_id else roc_id end,
case when nios_group.cnt = 1 then nios_group.email_address else lm.email_id end,
lm.registration_no
from fomema_backup_nios.laboratory_master lm 
left join states on states.code = lm.state_code 
left join towns on towns.code = lm.district_code 
left join countries on countries.old_code = lm.country_code 
left join fomema_backup_nios.v_user_master creators on lm.creator_id = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on lm.modify_id = updators.uuid 
left join users updator_users on updators.userid = updator_users.code 
left join fomema_backup_nios.district_office doff on doff.office_code = lm.nearest_district_office 
left join district_health_offices dho on dho.code = doff.office_code 
left join banks on lm.bank_code = banks.code 
left join z_laboratory_type_mappings on z_laboratory_type_mappings.oldcode = lm.lab_type 
left join laboratory_types on laboratory_types.name = z_laboratory_type_mappings.newcode
left join fomema_backup_nios.service_providers_group_member group_member on lm.laboratory_code = group_member.service_member
left join nios_group on group_member.service_providers_group_id = nios_group.id
left join service_provider_groups sp_group on nios_group.group_code = sp_group.code
order by lm.creation_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'laboratory.sql ended';
