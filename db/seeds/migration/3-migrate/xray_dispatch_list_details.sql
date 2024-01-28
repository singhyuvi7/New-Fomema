\echo "xray_dispatch_list_details.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_dispatch_list_details.sql') into v_log_id; commit;

    insert into xray_dispatch_items (
        xray_dispatch_id,
        transaction_id,
        created_at,
        updated_at,
        created_by,
        updated_by
    ) 
    select  
        xd.id as xray_dispatch_id,
        t.id as transaction_id,
        xd.created_at,
        xd.updated_at,
        xd.created_by,
        xd.updated_by
    from fomema_backup_nios.xray_dispatch_list_details xdld join xray_dispatches xd on xdld.dispatch_listid::varchar = xd.code
    join transactions t on xdld.trans_id = t.code
    order by xd.created_at;

    perform end_migration_log(v_log_id);
end
$$;

\echo "xray_dispatch_list_details.sql ended"
