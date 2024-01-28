\echo "orders_from_draft_master.sql loaded"

-- reference id to track id from migration data
ALTER TABLE orders ADD COLUMN IF NOT EXISTS  master_reference_id bigint;
CREATE INDEX IF NOT EXISTS index_order_on_master_reference_id ON orders (master_reference_id);

ALTER TABLE orders ADD COLUMN IF NOT EXISTS reference_id bigint;
CREATE INDEX IF NOT EXISTS index_order_on_reference_id ON orders (reference_id);

-- orders (not from branch)
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('orders_from_draft_master.sql - branch') into v_log_id;
        commit;

        insert into orders (
            code,customerable_id,customerable_type,
            payment_method_id,category,date,amount,
            status,comment,
            created_at,updated_at,created_by,updated_by,
            organization_id,paid_at,
            master_reference_id, reference_id
        )
        select concat('DA-',da.id::varchar), em.id, 'Employer', 
        pm.id as payment_method_id, 'MIGRATION', da.creation_date, da.allocation_amount,
        'PAID', dm.comments, 
        dm.creation_date,dm.modification_date,creator_users.id, updator_users.id,
        org.id, da.creation_date, 
        dm.id as master_reference_id, da.id as reference_id
        from fomema_backup_nios.draft_allocation da
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id
        join employers em on da.employer_code = em.code
        left join organizations org on dm.branch_code = org.code
        join fomema_backup_nios.payment_method nios_pm on dm.payment_type = nios_pm.payment_type
        join payment_methods pm on nios_pm.description = pm.name
        left join fomema_backup_nios.v_user_master creators on da.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on dm.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where dm.payment_type != 4 and dm.branch_code != 'PT' and dm.status not in (2,4);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "orders_from_draft_master.sql - branch done"

-- orders (portal - fpx)
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('orders_from_draft_master.sql - portal(FPX)') into v_log_id;
        commit;

        insert into orders (
            code,customerable_id,customerable_type,
            payment_method_id,category,date,amount,
            status,comment,
            created_at,updated_at,created_by,updated_by,
            organization_id,paid_at,
            master_reference_id, reference_id
        )
        select concat('DA-',da.id::varchar), em.id, 'Employer', 
        pm.id as payment_method_id, 'TRANSACTION_REGISTRATION', da.creation_date, dm.payment_amount,
        'PAID', dm.comments, 
        dm.date_issue,dm.date_issue,creator_users.id, updator_users.id,
        org.id, dm.date_issue, 
        dm.id as master_reference_id, da.id as reference_id
        from fomema_backup_nios.draft_allocation da
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id
        join employers em on da.employer_code = em.code
        join organizations org on dm.branch_code = org.code
        join fomema_backup_nios.payment_method nios_pm on dm.payment_type = nios_pm.payment_type
        left join payment_methods pm on nios_pm.description = pm.name
        left join fomema_backup_nios.v_user_master creators on da.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on dm.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where dm.payment_type = 114 and dm.branch_code = 'PT' and dm.status not in (2,4);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "orders_from_draft_master.sql - portal(FPX) done"

-- orders (portal - other payment)
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('orders_from_draft_master.sql - portal(others)') into v_log_id;
        commit;

        insert into orders (
            code,customerable_id,customerable_type,
            payment_method_id,category,date,amount,
            status,comment,
            created_at,updated_at,created_by,updated_by,
            organization_id,paid_at,
            master_reference_id, reference_id
        )
        select concat('DA-',da.id::varchar), em.id, 'Employer', 
        pm.id as payment_method_id, 'TRANSACTION_REGISTRATION', da.creation_date, da.allocation_amount,
        'PAID', dm.comments, 
        dm.creation_date,dm.modification_date,creator_users.id, updator_users.id,
        org.id, da.creation_date, 
        dm.id as master_reference_id, da.id as reference_id
        from fomema_backup_nios.draft_allocation da
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id
        join employers em on da.employer_code = em.code
        join organizations org on dm.branch_code = org.code
        join fomema_backup_nios.payment_method nios_pm on dm.payment_type = nios_pm.payment_type
        left join payment_methods pm on nios_pm.description = pm.name
        left join fomema_backup_nios.v_user_master creators on da.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on dm.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where dm.payment_type != 4 and dm.payment_type != 114 and dm.branch_code = 'PT' and dm.status not in (2,4);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "orders_from_draft_master.sql - portal(others) done"

\echo "orders_from_draft_master.sql ended"
