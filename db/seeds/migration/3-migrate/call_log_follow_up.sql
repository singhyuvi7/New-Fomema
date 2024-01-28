\echo "call_log_follow_up.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('call_log_follow_up.sql') into v_log_id;
    commit;

insert into call_log_follow_ups (
    call_log_id, comment, 
    created_at, created_by, 
    updated_at, updated_by, 
    id
) 
select fu.case_id::bigint, fu.action_taken, 
coalesce(fu.creation_date, clock_timestamp()) as created_at, /* fu.creator_id */ creator_users.id as created_by, 
coalesce(fu.modify_date, clock_timestamp()) as updated_at, /* fu.modify_id */ updator_users.id as updated_by, 
fu.id::bigint 
from fomema_backup_nios.xqcc_followup fu 
left join fomema_backup_nios.v_user_master creators on fu.creator_id::numeric = creators.uuid 
left join users creator_users on creators.userid = creator_users.code 
left join fomema_backup_nios.v_user_master updators on fu.modify_id::numeric = updators.uuid 
left join users updator_users on updators.userid = updator_users.code
order by fu.creation_date;

perform setval('call_log_follow_ups_id_seq', (select coalesce(max(id), 1) from call_log_follow_ups));

    perform end_migration_log(v_log_id);
end
$$;

\echo "call_log_follow_up.sql ended"
