\echo "myimms_transactions.sql loaded"

-- myimms_queue
do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('myimms_transactions.sql - myimms_queue') into v_log_id;
    commit;

	insert into myimms_transactions (
		transaction_id, status, created_at, updated_at
	) 
	select tr.id, case when um.myimms_reply is NULL then '97' else um.myimms_reply end, um.modify_date,um.modify_date
	from fomema_backup_nios.myimms_queue um
	join transactions tr on um.trans_id = tr.code
	join fomema_backup_nios.fw_transaction fwt on tr.code = fwt.trans_id
	where fwt.imm_send_ind != 'B' and um.modify_date = (select max(modify_date) from fomema_backup_nios.myimms_queue mq where mq.trans_id = tr.code);

    perform end_migration_log(v_log_id);
end
$$;

\echo "myimms_transactions.sql myimms_queue done"

-- for blocked foreign worker that send to IMMS
do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('myimms_transactions.sql - blocked foreign worker') into v_log_id;
    commit;

	insert into myimms_transactions (
		transaction_id, status, 
		created_at, 
		updated_at
	)
	select tr.id, '98', 
	-- case when fwt.imm_send_date is not null then fwt.imm_send_date else fwt.certify_date end,
	coalesce(fwt.imm_send_date, fwt.certify_date, fwt.modification_date, clock_timestamp()) created_at, 
	-- case when fwt.imm_send_date is not null then fwt.imm_send_date else fwt.certify_date end
	coalesce(fwt.imm_send_date, fwt.certify_date, fwt.modification_date, clock_timestamp()) updated_at 
	from fomema_backup_nios.fw_transaction fwt
	join transactions tr on fwt.trans_id = tr.code
	where fwt.imm_send_ind = 'B' and fwt.fit_ind is not null;

    perform end_migration_log(v_log_id);
end
$$;
\echo "myimms_transactions.sql - blocked foreign worker done"

\echo "myimms_transactions.sql ended"
