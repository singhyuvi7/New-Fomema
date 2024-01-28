\echo 'xray_review_detail.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_review_detail.sql') into v_log_id; commit;
    insert into xray_review_details (
        xray_review_id, 
        condition_id, 
        text_value,
        created_at,
        updated_at
    ) 
    select 
        xr.id as xray_review_id, 
        c.id as condition_id, 
        dfd.parameter_value as text_value,
        coalesce(xr.transmitted_at, xr.updated_at, xr.created_at) as created_at,
        coalesce(xr.transmitted_at, xr.updated_at, xr.created_at) as updated_at
    from fomema_backup_nios.dxreview_film_detail dfd join fomema_backup_nios.dxreview_film df on dfd.dxry_id = df.id 
    join conditions c on dfd.parameter_code = c.code
    join transactions t on df.trans_id = t.code
    join xray_reviews xr on xr.transaction_id = t.id
    order by xr.transmitted_at, xr.updated_at
    ;

    insert into xray_review_details (
        xray_review_id, 
        condition_id, 
        text_value,
        created_at,
        updated_at
    ) 
    select 
        xr.id as xray_review_id,
        c.id as condition_id,
        xrfd.parameter_value as text_value,
        coalesce(xr.transmitted_at, xr.updated_at, xr.created_at) as created_at,
        coalesce(xr.transmitted_at, xr.updated_at, xr.created_at) as updated_at
    from fomema_backup_nios.xray_review_film_detail xrfd
    join conditions c on xrfd.parameter_code = c.code
    join transactions t on xrfd.trans_id = t.code
    join xray_reviews xr on xr.transaction_id = t.id
    order by xr.transmitted_at, xr.updated_at
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'xray_review_detail.sql ended'
