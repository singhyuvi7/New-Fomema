\echo "update_transaction_order_item.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_transaction_order_item.sql') into v_log_id;
        commit;

		UPDATE transactions
		SET order_item_id = order_items.id
		FROM
			order_items
		WHERE transactions.code = order_items.reference_trans_id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_transaction_order_item.sql ended"
