\echo 'xqcc_review_identical.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xqcc_review_identical.sql - dxreview_film_identical') into v_log_id; commit;
    insert into xqcc_review_identicals (
        created_at,
        updated_at,
        xray_review_id,
        identical_xray_review_id
    )
    select 
        main_xray_reviews.created_at created_at,
        main_xray_reviews.created_at updated_at,
        /* dfi.trans_id identical_case_transaction_code, df.trans_id main_case_transaction_code, 
        main_t.id main_t_id, */ main_xray_reviews.id main_xr_id, 
        /* identical_t.id identical_t_id, */ identical_xray_reviews.id identical_xr_id
    from fomema_backup_nios.dxreview_film_identical dfi 
    join fomema_backup_nios.dxreview_film df on dfi.dxry_id = df.id 
    join transactions main_t on df.trans_id = main_t.code 
    join xray_reviews main_xray_reviews on main_t.id = main_xray_reviews.transaction_id 
    join transactions identical_t on dfi.trans_id = identical_t.code 
    join xray_reviews identical_xray_reviews on identical_t.id = identical_xray_reviews.transaction_id
    order by main_xray_reviews.created_at
    ;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_review_identical.sql - xray_review_film_identical') into v_log_id; commit;
    insert into xqcc_review_identicals (
        created_at,
        updated_at,
        xray_review_id,
        identical_xray_review_id
    )
    select 
        main_xray_reviews.created_at created_at,
        main_xray_reviews.created_at updated_at,
        main_xray_reviews.id main_xr_id, 
        identical_xray_reviews.id identical_xr_id
    from fomema_backup_nios.xray_review_film_identical xrfi join fomema_backup_nios.xray_review_film xrf on xrfi.review_filmid = xrf.review_filmid 
    join transactions main_t on xrf.trans_id = main_t.code join xray_reviews main_xray_reviews on main_t.id = main_xray_reviews.transaction_id 
    join transactions identical_t on xrfi.trans_id = identical_t.code join xray_reviews identical_xray_reviews on identical_t.id = identical_xray_reviews.transaction_id
    order by main_xray_reviews.created_at
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'xqcc_review_identical.sql ended'
