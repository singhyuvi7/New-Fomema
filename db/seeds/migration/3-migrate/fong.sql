do $$
declare
    v_log_id bigint;
begin

    select start_migration_log('fw_monitor_log.sql - patch') into v_log_id; commit;
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

    select start_migration_log('fw_block_log.sql - patch') into v_log_id; commit;

    with block_tbl as (
        select 
            foreign_worker_id, 
            comment as block_comment, 
            block_reason_id, 
            requested_at as blocked_at, 
            requested_by as blocked_by,
            rank() over (partition by foreign_worker_id order by requested_at desc) as rank
        from fw_block_logs where action = 'BLOCK'
    )
    update foreign_workers set 
        block_reason_id = block_tbl.block_reason_id, 
        block_comment = block_tbl.block_comment, 
        blocked_at = block_tbl.blocked_at, 
        blocked_by = block_tbl.blocked_by
    from block_tbl
    where foreign_workers.id = block_tbl.foreign_worker_id and block_tbl.rank = 1;

    with unblock_tbl as (
        select 
            foreign_worker_id, 
            comment as unblock_comment, 
            block_reason_id as unblock_reason_id, 
            rank() over (partition by foreign_worker_id order by requested_at desc) as rank
        from fw_block_logs where action = 'UNBLOCK'
    )
    update foreign_workers set 
        unblock_reason_id = unblock_tbl.unblock_reason_id, 
        unblock_comment = unblock_tbl.unblock_comment
    from unblock_tbl
    where foreign_workers.id = unblock_tbl.foreign_worker_id and unblock_tbl.rank = 1;

    perform end_migration_log(v_log_id);

end;
$$;
