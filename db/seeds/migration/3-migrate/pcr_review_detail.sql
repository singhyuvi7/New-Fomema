\echo 'pcr_review_detail.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('pcr_review_detail.sql') into v_log_id; commit;
    insert into pcr_review_details (
        pcr_review_id, 
        condition_id, 
        text_value,
        created_at,
        updated_at
    ) 
    select pr.id as pcr_review_id, 
    c.id as condition_id, 
    dad.parameter_value as text_value,
    coalesce(pr.transmitted_at, pr.updated_at, pr.created_at) as created_at,
    coalesce(pr.transmitted_at, pr.updated_at, pr.created_at) as updated_at
    from fomema_backup_nios.dxpcr_audit_detail dad join fomema_backup_nios.dxpcr_audit_film daf on dad.pcr_audit_film_id = daf.id 
    join conditions c on dad.parameter_code = c.code
    join transactions t on daf.trans_id = t.code
    join pcr_reviews pr on pr.transaction_id = t.id
    order by pr.transmitted_at, pr.updated_at, pr.created_at
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'pcr_review_detail.sql ended'
