\echo "bank_draft_allocations.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bank_draft_allocations.sql') into v_log_id;
        commit;

        insert into bank_draft_allocations (
            bank_draft_id,amount,
            created_at,updated_at,created_by,updated_by,
            allocatable_type,allocatable_id
        ) 
        select bd.id, bd.amount_allocated, 
        bd.created_at, bd.updated_at, bd.created_by, bd.updated_by,
        'Order', orders.id
        from bank_drafts bd
        join orders on concat('RE-',bd.number,'-',bd.reference_tranno) = orders.code
        where orders.category in ('DOCTOR_REGISTRATION','XRAY_FACILITY_REGISTRATION','LABORATORY_REGISTRATION','RADIOLOGIST_REGISTRATION','DOCTOR_CHANGE_ADDRESS');

        perform end_migration_log(v_log_id);
    END
$$;

\echo "bank_draft_allocations.sql ended"
