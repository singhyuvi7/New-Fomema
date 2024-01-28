\echo "create_order_from_employer_account.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
        v_payment_method_id bigint;
    BEGIN
        select start_migration_log('create_order_from_employer_account - order') into v_log_id;
        commit;

        SELECT id into v_payment_method_id from payment_methods where code = 'OTHERS';

        -- payment method = order
        -- master_reference_id = employer_account.id
        INSERT INTO orders (
            code,
            customerable_id, customerable_type,
            payment_method_id, category, 
            date, amount, status, 
            created_at, updated_at,
            organization_id, paid_at, master_reference_id,
            comment,
            created_by, updated_by
        )
        select concat('S',to_char( ea.creation_date, 'YYYYMMDD'),ea.id),
        emp.id, 'Employer',
        v_payment_method_id, 'TRANSACTION_REGISTRATION',
        ea.creation_date, ABS(ea.amount), 'PAID',
        ea.creation_date,ea.modification_date,
        org.id, ea.creation_date, ea.id,
        'MIGRATE_FROM_EMPLOYER_ACCOUNT',
        creator_users.id, updator_users.id
        from transactions tr 
        join fomema_backup_nios.employer_account ea on tr.code = ea.trans_id 
        join employers emp on ea.employer_code = emp.code
        join organizations org on ea.branch_code = org.code
        left join fomema_backup_nios.v_user_master creators on ea.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on ea.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where type = 8 and ea.creation_date >= '2020-01-01' and tr.order_item_id is null;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "create_order_from_employer_account - order done"

DO $$
    DECLARE
        v_log_id bigint;
        male_fee_id bigint;
        female_fee_id bigint;
    BEGIN
        select start_migration_log('create_order_from_employer_account - order_items') into v_log_id;
        commit;

        SELECT id into male_fee_id from fees where code = 'TRANSACTION_MALE';
        SELECT id into female_fee_id from fees where code = 'TRANSACTION_FEMALE';

        INSERT INTO order_items (
            order_id, order_itemable_id, order_itemable_type,
            fee_id, 
            amount, 
            created_at, updated_at, 
            created_by, updated_by,
            gender, reference_trans_id,
            comment
        )
        select ord.id, fw.id, 'ForeignWorker',
        case when ea.sex = 'M' then male_fee_id else female_fee_id end, 
        ord.amount, 
        ord.created_at, ord.updated_at,
        ord.created_by, ord.updated_by,
        ea.sex, ea.trans_id,
        'MIGRATE_FROM_EMPLOYER_ACCOUNT'
        from orders ord
        join fomema_backup_nios.employer_account ea on ord.master_reference_id = ea.id 
        join foreign_workers fw on ea.worker_code = fw.code
        where ord.comment = 'MIGRATE_FROM_EMPLOYER_ACCOUNT' and ea.creation_date >= '2020-01-01';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "create_order_from_employer_account - order_items done"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('create_order_from_employer_account - transactions') into v_log_id;
        commit;

        update transactions set order_item_id = oi.id
        from order_items oi
        where transactions.code = oi.reference_trans_id
        and oi.created_at >= '2020-01-01' and oi.comment = 'MIGRATE_FROM_EMPLOYER_ACCOUNT';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "create_order_from_employer_account - transactions done"

\echo "create_order_from_employer_account.sql ended"
