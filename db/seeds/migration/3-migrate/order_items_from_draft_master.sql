\echo 'order_items_from_draft_master.sql loaded';

-- reference trans id to track id from migration data
ALTER TABLE order_items ADD COLUMN IF NOT EXISTS  reference_trans_id varchar;
CREATE INDEX IF NOT EXISTS index_order_item_on_reference_trans_id ON order_items (reference_trans_id);

DO $$
    DECLARE
        male_fee_id bigint;
        female_fee_id bigint;
        v_log_id bigint;
    BEGIN
        select start_migration_log('order_items_from_draft_master.sql') into v_log_id;
        commit;

        SELECT id into male_fee_id from fees where code = 'TRANSACTION_MALE';
        SELECT id into female_fee_id from fees where code = 'TRANSACTION_FEMALE';

        insert into order_items (
            order_id,order_itemable_id,order_itemable_type,
            fee_id,
            amount,
            created_at,updated_at,created_by,updated_by,
            gender,
            reference_trans_id
        ) 
        select orders.id, fw.id, 'ForeignWorker',
        case when du.utilise_amount = 180 then male_fee_id when du.utilise_amount = 190 then female_fee_id end,
        du.utilise_amount, 
        orders.created_at, orders.updated_at, orders.created_by, orders.updated_by,
        case when du.utilise_amount = 180 then 'M' when du.utilise_amount = 190 then 'F' end,
        du.trans_id
        from orders
        join fomema_backup_nios.draft_master dm on orders.master_reference_id = dm.id
        join fomema_backup_nios.draft_usage du on dm.id = du.draft_master_id
        join foreign_workers fw on du.worker_code = fw.code
        where orders.category = 'TRANSACTION_REGISTRATION';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "order_items_from_draft_master.sql ended"