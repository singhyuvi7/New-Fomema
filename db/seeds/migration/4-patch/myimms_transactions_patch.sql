
\echo 'myimms_transactions_patch.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('myimms_transactions_patch.sql') into v_log_id; commit;

    with tbl as (
        select tr.id, ft.imm_send_date
        from transactions tr
        join fomema_backup_nios.fw_transaction ft on tr.code = ft.trans_id 
        left join myimms_transactions mt on tr.id = mt.transaction_id
        where ft.imm_send_date is not null
        and tr.created_at >= '1998-03-14'
        and mt.id is null
    )

    INSERT INTO myimms_transactions (transaction_id,status,created_at,updated_at)
    SELECT id,'1' ,imm_send_date, imm_send_date
    FROM tbl;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'myimms_transactions_patch.sql ended'