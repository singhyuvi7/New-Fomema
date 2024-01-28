\echo "organization.sql loaded"

-- insert into organizations (code, name, org_type, created_at, updated_at) 
-- values ('FOMEMA', 'FOMEMA', 'HEADQUARTER', clock_timestamp(), clock_timestamp());

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('organization.sql') into v_log_id;
    commit;

insert into organizations (
	code, name, 
	address1, address2, address3, address4, 
	postcode, town_id, state_id, phone, fax, 
	email, created_by, org_type, 
	bank_code, bank_co, bank_acctno, zone_id,
	created_at, updated_at
) 
select branches.branch_code, branches.name, 
branches.address1, branches.address2, branches.address3, branches.address4, 
branches.post_code, towns.id town_id, states.id state_id, branches.phone, branches.fax, 
branches.email, null, 'HEADQUARTER', 
branches.bank_code, branches.bank_co, branches.bank_acctno, zones.id zone_id, 
clock_timestamp(), clock_timestamp()
from fomema_backup_nios.branches left join states on branches.state = states.name 
left join towns on branches.district = towns.name 
left join zones on branches.bank_zone = zones.code
where  branch_type in ('HQ');

-- branch
insert into organizations (
	parent_id, code, name, 
	address1, address2, address3, address4, 
	postcode, town_id, state_id, phone, fax, 
	email, created_by, org_type, 
	bank_code, bank_co, bank_acctno, zone_id,
	created_at, updated_at
) 
select (select id from organizations where code = 'HQ' order by id asc limit 1) parent_id, branches.branch_code, branches.name, 
branches.address1, branches.address2, branches.address3, branches.address4, 
branches.post_code, towns.id town_id, states.id state_id, branches.phone, branches.fax, 
branches.email, null, 'BRANCH', 
branches.bank_code, branches.bank_co, branches.bank_acctno, zones.id zone_id, 
clock_timestamp(), clock_timestamp()
from fomema_backup_nios.branches left join states on branches.state = states.name 
left join towns on branches.district = towns.name 
left join zones on branches.bank_zone = zones.code
where  branch_type in ('EM','PM');

insert into organizations (
	parent_id, name, address1, org_type, created_at, updated_at
) 
select (select id from organizations where code = 'HQ') parent_id, name,  address, 'WAREHOUSE', clock_timestamp(), clock_timestamp()
from fomema_backup_nios.xqcc_warehouse;

    perform end_migration_log(v_log_id);
end
$$;

\echo "organization.sql ended"
