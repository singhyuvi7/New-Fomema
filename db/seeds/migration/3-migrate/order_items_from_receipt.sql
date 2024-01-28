\echo "order_items_from_receipt.sql loaded"

DO $$
    DECLARE
        doc_reg_id bigint;
        xray_reg_id bigint;
        lab_reg_id bigint;
        radiologist_reg_id bigint;
        change_address_id bigint;
        v_log_id bigint;
    BEGIN
        select start_migration_log('order_items_from_receipt.sql') into v_log_id;
        commit;

        SELECT id into doc_reg_id from fees where code = 'DOCTOR_REGISTRATION';
        SELECT id into xray_reg_id from fees where code = 'XRAY_FACILITY_REGISTRATION';
        SELECT id into lab_reg_id from fees where code = 'LABORATORY_REGISTRATION';
        SELECT id into radiologist_reg_id from fees where code = 'RADIOLOGIST_REGISTRATION';
        SELECT id into change_address_id from fees where code = 'DOCTOR_CHANGE_ADDRESS';

        insert into order_items (
            order_id,order_itemable_id,order_itemable_type,
            fee_id,
            amount,
            created_at,updated_at,created_by,updated_by
        ) 
        select orders.id, orders.customerable_id, orders.customerable_type,
        case when category = 'DOCTOR_REGISTRATION' then doc_reg_id 
        when category = 'XRAY_FACILITY_REGISTRATION' then xray_reg_id 
        when category = 'LABORATORY_REGISTRATION' then lab_reg_id 
        when category = 'RADIOLOGIST_REGISTRATION' then radiologist_reg_id 
        when category = 'DOCTOR_CHANGE_ADDRESS' then change_address_id end,
        orders.amount,
        orders.created_at, orders.updated_at, orders.created_by, orders.updated_by
        from orders
        where category in ('DOCTOR_REGISTRATION','XRAY_FACILITY_REGISTRATION','LABORATORY_REGISTRATION','RADIOLOGIST_REGISTRATION','DOCTOR_CHANGE_ADDRESS');

        perform end_migration_log(v_log_id);
    END
$$;

\echo "order_items_from_receipt.sql ended"
