\echo "call_log.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('call_log.sql') into v_log_id;
    commit;

drop table if exists z_call_log_case_type_mappings;

create table if not exists z_call_log_case_type_mappings (
    oldcode numeric(1),
    newcode character varying
);

create index if not exists idx_z_call_log_case_type_mappings_on_oldcode on z_call_log_case_type_mappings(oldcode);
create index if not exists idx_z_call_log_case_type_mappings_on_newcode on z_call_log_case_type_mappings(newcode);

insert into z_call_log_case_type_mappings (oldcode, newcode) values (1, 'NONCOMP');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (2, 'LATESUB');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (3, 'REPEAT');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (4, 'DIGITAL');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (5, 'OTHER');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (6, 'AUDITRAD');
insert into z_call_log_case_type_mappings (oldcode, newcode) values (7, 'COMPLAINT');

insert into call_logs (
    id, callable_id, callable_type, 
    called_at, 
    phone, discussant_name, fax, 
    email, issue, comment, 
    status, 
    created_at, created_by, 
    updated_at, updated_by, 
    call_log_case_type_id
) 
select xc.case_id::bigint, /* xc.xray_code */ xf.id callable_id, 'XrayFacility' callable_type, 
/* xc.call_date, xc.call_time */ xc.call_date::date + xc.call_time::time called_at, 
xc.phone_no, xc.discussant_name, xc.fax_no, 
xc.email_id, xc.issue, xc.remarks, 
/* xc.status */ case when xc.status = 'O' then 'OPEN' else 'CLOSE' end status, 
coalesce(xc.creation_date, clock_timestamp()) as created_at, /* xc.creator_id */ creator_users.id as created_by, 
coalesce(xc.modify_date, clock_timestamp()) as updated_at, /* xc.modify_id */ updator_users.id as updated_by, 
/* xc.case_type */ call_log_case_types.id call_log_case_type_id 
from fomema_backup_nios.xqcc_calllog xc 
left join xray_facilities xf on xc.xray_code = xf.code 
left join fomema_backup_nios.v_user_master creators on xc.creator_id::numeric = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on xc.modify_id::numeric = updators.uuid 
left join users updator_users on updators.userid = updator_users.code 
left join z_call_log_case_type_mappings on xc.case_type = z_call_log_case_type_mappings.oldcode 
left join call_log_case_types on z_call_log_case_type_mappings.newcode = call_log_case_types.code
order by xc.creation_date;

perform setval('call_logs_id_seq', (select coalesce(max(id), 1) from call_logs));

    perform end_migration_log(v_log_id);
end
$$;

\echo "call_log.sql ended"
