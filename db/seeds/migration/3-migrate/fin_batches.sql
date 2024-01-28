\echo "fin_batches.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('fin_batches.sql') into v_log_id;
    commit;

	-- fin_batch_master
	insert into fin_batches (
		code, start_date, end_date, created_at, updated_at, status
	) 
	select fb.batch_number, fb.batch_startdate, fb.batch_enddate, fb.batch_startdate, fb.batch_startdate, 'SUCCESS'
	from fomema_backup_nios.fin_batch_master fb
	where fb.batch_number >= 20160501 and fb.batch_number < 20201004;

    perform end_migration_log(v_log_id);
end
$$;


\echo "fin_batches.sql ended"
