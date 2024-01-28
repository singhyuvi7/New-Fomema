\echo "order_payments_from_draft_master.sql loaded"

-- order_payments
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('order_payments_from_draft_master.sql') into v_log_id;
        commit;

        insert into order_payments (
            order_id,amount,reference,
            comment,
            created_at,updated_at,created_by,updated_by,
            issue_date,
            bad,holded,
            bad_at,sync_date,sync_bad_date,
            process_fee,additional_fee_charge,
            gst_amount,gst_percentage,additional_gst_charge,
            sync_cancel_status,
            from_migration
        ) 
        select orders.id, orders.amount, dm.payment_no,
        case when dm.voided_reason is null then dm.comments else dm.voided_reason end,
        da.creation_date, da.creation_date, orders.created_by, orders.updated_by,
        dm.date_issue,
        case when dm.status in (0,3,8) then true else false end,
        case when dm.status = 7 then true else false end,
        dm.voided_date, dm.collection_date, dm.voided_date,
        da.process_fee, dm.other_amount, 
        da.gst_amount, dm.gst_percentage, dm.other_amount_gst,
        dm.collection_cn_status,
        true
        from orders
        join fomema_backup_nios.draft_allocation da on orders.reference_id = da.id
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "order_payments_from_draft_master.sql ended"
