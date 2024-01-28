\echo "myimms.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('myimms.sql') into v_log_id;
    commit;

	-- myimms_queue
	insert into myimms (
		batch_code, created_at, updated_at
	) 
	select DISTINCT um.batch_num, um.queue_date, um.queue_date
	from fomema_backup_nios.myimms_queue um;

    perform end_migration_log(v_log_id);
end
$$;

\echo "myimms.sql ended"

