\echo "fw_monitor_log loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('fw_monitor_log') into v_log_id; commit;

    insert into fw_monitor_logs (
        foreign_worker_id,
        monitor_reason_id,
        monitor_comment,
        created_by,
        created_at,
        updated_by,
        updated_at,
        unmonitor_comment,
        monitor_request_by,
        monitor_request_at,
        unmonitor_request_by,
        unmonitor_request_at
    )
    select 
        fw.id as foreign_worker_id,
        mr.id as monitor_reason_id,
        fm.comments as monitor_comment,
        creator_users.id as created_by,
        coalesce(fm.creation_date, clock_timestamp()) as created_at,
        updator_users.id as updated_by,
        coalesce(fm.modification_date, clock_timestamp()) as updated_at,
        fm.removal_comments as unmonitor_comment,
        creator_users.id as monitor_request_by,
        coalesce(fm.creation_date, clock_timestamp()) as monitor_request_at,
        case when fm.status = 'C' then updator_users.id else null end as unmonitor_request_by,
        case when fm.status = 'C' then coalesce(fm.modification_date, clock_timestamp()) else null end as unmonitor_request_at
    from fomema_backup_nios.fw_monitor fm join foreign_workers fw on fm.bc_worker_code = fw.code
    left join monitor_reasons mr on fm.reason_code = mr.code
    left join fomema_backup_nios.v_user_master creators on fm.creator_id = creators.uuid
    left join users creator_users on creators.userid = creator_users.code
    left join fomema_backup_nios.v_user_master updators on fm.modification_id = updators.uuid
    left join users updator_users on updators.userid = updator_users.code
    order by fm.creation_date;

    with tmp_tbl as (
        select foreign_worker_id, monitor_reason_id, monitor_comment, unmonitor_comment, 
        rank() over (partition by foreign_worker_id order by monitor_request_at desc)
        from fw_monitor_logs
    )
    update foreign_workers set 
        monitor_comment = tmp_tbl.monitor_comment, 
        monitor_reason_id = tmp_tbl.monitor_reason_id, 
        unmonitor_comment = tmp_tbl.unmonitor_comment
    from tmp_tbl
    where foreign_workers.id = tmp_tbl.foreign_worker_id and tmp_tbl.rank = 1;

    perform end_migration_log(v_log_id);
end
$$;

\echo "fw_monitor_log ended"
