\echo "orders_from_receipt.sql loaded"

DO $$
    DECLARE
        pm_id bigint;
        v_log_id bigint;
    BEGIN
        select start_migration_log('orders_from_receipt.sql') into v_log_id;
        commit;

        SELECT id into pm_id from payment_methods where code = 'BANKDRAFT';

        insert into orders (
            code,customerable_id,customerable_type,
            payment_method_id,
            category,
            date,amount,
            status,comment,
            created_at,updated_at,created_by,updated_by,
            organization_id,paid_at
        )
        select concat('RE-',bd.number,'-',bd.reference_tranno), bd.payerable_id, bd.payerable_type,
        pm_id,
        case when rec.service_type = 'CA' then 'DOCTOR_CHANGE_ADDRESS' 
        when rec.service_type = 'DR' then 'DOCTOR_REGISTRATION' 
        when rec.service_type = 'XR' then 'XRAY_FACILITY_REGISTRATION' 
        when rec.service_type = 'LR' then 'LABORATORY_REGISTRATION' 
        when rec.service_type = 'RR' then 'RADIOLOGIST_REGISTRATION' end,
        bd.created_at, bd.amount_allocated,
        'PAID', rec.comments,
        bd.created_at, bd.updated_at, bd.created_by, bd.updated_by,
        bd.organization_id, bd.created_at
        from bank_drafts bd
        join fomema_backup_nios.receipt rec on bd.reference_tranno = rec.tranno
        where rec.service_type in ('CA','DR','XR','LR','RR') and rec.creation_date >= '2015-04-01';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "orders_from_receipt.sql ended"
