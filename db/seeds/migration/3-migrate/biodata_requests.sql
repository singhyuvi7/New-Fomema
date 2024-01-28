\echo "biodata_requests.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('biodata_requests.sql') into v_log_id;
    commit;

	insert into biodata_requests (
		foreign_worker_id, app_transaction_id, gender, passport_no, nationality, date_of_birth, created_at, updated_at
	) 
	select fw.id, um.trans_id, um.gender, um.passport_no, um.nationality, um.date_of_birth, um.creation_date, um.creation_date
	from fomema_backup_nios.foreign_worker_biodata um
	join foreign_workers fw on um.worker_code = fw.code;

    perform end_migration_log(v_log_id);
end
$$;

\echo "biodata_requests.sql ended"
