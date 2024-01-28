\echo "district_health_office.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('district_health_office.sql') into v_log_id;
    commit;

insert into district_health_offices (
	code, name,
	address1, address2, address3, address4, 
	postcode, phone, fax, email, pic_name, 
	town_id, state_id, status, 
	created_by, created_at, updated_by, updated_at
) 
select doff.office_code, doff.office_name, 
doff.address1, doff.address2, doff.address3, doff.address4, 
doff.post_code, doff.phone, doff.fax, doff.email_id, doff.primary_contact_person, 
/* doff.district_code */ towns.id town_id, /* doff.state_code */ states.id state_id, case when doff.status_code = 'Y' then 'ACTIVE' else 'INACTIVE' end status, 
/* doff.creator_id */ creator_users.id created_by, doff.creation_date, /* doff.modify_id */ updator_users.id updated_by, doff.modification_date 
from fomema_backup_nios.district_office doff 
left join states on doff.state_code = states.code 
left join towns on doff.district_code = towns.code 
left join fomema_backup_nios.v_user_master creators on doff.creator_id = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on doff.modify_id = updators.uuid 
left join users updator_users on updators.userid = updator_users.code
order by doff.creation_date;

    perform end_migration_log(v_log_id);
end
$$;

\echo "district_health_office.sql ended"
