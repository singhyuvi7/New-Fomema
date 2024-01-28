\echo "sp_transactions_payments.sql loaded"

-- doctors
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_transactions_payments.sql - doctor') into v_log_id;
        commit;

		insert into sp_transactions_payments (
			transaction_id, service_providable_id, amount, service_providable_type, pay_at, created_at, created_by, updated_at, updated_by
		) 
		select tr.id, sp.id, pm.amount, 'Doctor', pm.payment_date, pm.modification_date, creator_users.id, pm.modification_date, creator_users.id
		from fomema_backup_nios.pay_trans_manual pm
		join doctors sp on pm.sp_code = sp.code
		join transactions tr on pm.trans_id = tr.code
		left join fomema_backup_nios.v_user_master creators on pm.modify_id = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
		where pm.sp_type = 'D';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_transactions_payments.sql - doctor done"

-- Xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_transactions_payments.sql - xray') into v_log_id;
        commit;

		insert into sp_transactions_payments (
			transaction_id, service_providable_id, amount, service_providable_type, pay_at, created_at, created_by, updated_at, updated_by
		) 
		select tr.id, sp.id, pm.amount, 'XrayFacility', pm.payment_date, pm.modification_date, creator_users.id, pm.modification_date, creator_users.id
		from fomema_backup_nios.pay_trans_manual pm
		join xray_facilities sp on pm.sp_code = sp.code
		join transactions tr on pm.trans_id = tr.code
		left join fomema_backup_nios.v_user_master creators on pm.modify_id = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
		where pm.sp_type = 'X';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_transactions_payments.sql - xray done"

-- Lab
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('sp_transactions_payments.sql - lab') into v_log_id;
        commit;

		insert into sp_transactions_payments (
			transaction_id, service_providable_id, amount, service_providable_type, pay_at, created_at, created_by, updated_at, updated_by
		) 
		select tr.id, sp.id, pm.amount, 'Laboratory', pm.payment_date, pm.modification_date, creator_users.id, pm.modification_date, creator_users.id
		from fomema_backup_nios.pay_trans_manual pm
		join laboratories sp on pm.sp_code = sp.code
		join transactions tr on pm.trans_id = tr.code
		left join fomema_backup_nios.v_user_master creators on pm.modify_id = creators.uuid
        left join users creator_users on creators.userid = creator_users.code
		where pm.sp_type = 'L';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "sp_transactions_payments.sql - lab done"

\echo "sp_transactions_payments.sql ended"
