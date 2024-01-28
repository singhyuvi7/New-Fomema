\echo 'employer.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('employer.sql') into v_log_id;
    commit;

drop table if exists z_employer_type_mappings;

create table if not exists z_employer_type_mappings (
    oldcode numeric(1),
    newcode character varying
);

create index if not exists idx_z_employer_type_mappings_on_oldcode on z_employer_type_mappings(oldcode);
create index if not exists idx_z_employer_type_mappings_on_newcode on z_employer_type_mappings(newcode);

insert into z_employer_type_mappings (oldcode, newcode) values (null, 'INDIVIDUAL');
insert into z_employer_type_mappings (oldcode, newcode) values (0, 'INDIVIDUAL');
insert into z_employer_type_mappings (oldcode, newcode) values (1, 'INDIVIDUAL');
insert into z_employer_type_mappings (oldcode, newcode) values (2, 'COMPANY');
insert into z_employer_type_mappings (oldcode, newcode) values (3, 'INDIVIDUAL');

insert into employers (
    code, name, 
    address1, address2, address3, address4, 
    country_id, state_id, town_id, 
    status, created_at, postcode, 
    phone, fax, email, pic_name, pic_phone, comment, 
    created_by, updated_by, updated_at, 
    organization_id, blacklisted, blacklisted_at, 
    business_registration_number, ic_passport_number, 
    bad_payment, employer_type_id, approval_status
) 
select em.employer_code, em.employer_name, 
em.address1, em.address2, em.address3, em.address4, 
/* em.country_code */ countries.id country_id, /* em.state_code */ states.id state_id, /* em.district_code */ towns.id town_id, 
/* em.status_code */ case when em.status_code = 'Y' then 'ACTIVE' else 'INACTIVE' end status, coalesce(em.creation_date, clock_timestamp()) created_at, em.post_code, 
em.phone, em.fax, em.email_id, em.primary_contact_person, em.primary_contact_phone, em.comments, 
/* em.creator_id */ creator_users.id created_by, /* em.modify_id */ updator_users.id updated_by, coalesce(em.modification_date, clock_timestamp()) updated_at, 
/* em.branch_code */ organizations.id organization_id, /* em.isblacklisted */ case when em.isblacklisted = 'Y' then true else false end blacklisted, em.blacklisted_date, 
em.company_regno, em.icpassport_no, 
/* em.badpayment_ind */ case when em.badpayment_ind = 1 then true else false end bad_payment, /* em.employer_type */ employer_types.id employer_type_id, 'UPDATE_APPROVED' as approval_status
from fomema_backup_nios.employer_master em 
left join states on states.code = em.state_code 
left join towns on towns.code = em.district_code 
left join countries on countries.old_code = em.country_code 
left join fomema_backup_nios.v_user_master creators on em.creator_id = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on em.modify_id = updators.uuid 
left join users updator_users on updators.userid = updator_users.code 
left join organizations on em.branch_code = organizations.code 
left join z_employer_type_mappings on coalesce(em.employer_type, 1) = z_employer_type_mappings.oldcode 
left join employer_types on z_employer_type_mappings.newcode = employer_types.name
order by em.creation_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'employer.sql ended'
