\echo 'xqcc_transaction.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xqcc_transaction.sql - xqcc_quarantine_fw_doc.certification_date') into v_log_id; commit;
    update transactions set certification_date = xqfd.certification_date 
    from fomema_backup_nios.xqcc_quarantine_fw_doc xqfd 
    where xqfd.trans_id = transactions.code and xqfd.certification_date is not null;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - xqcc_pools') into v_log_id; commit;
    update transactions set xray_status = 'XQCC_POOL' 
    from xqcc_pools 
    where xqcc_pools.transaction_id = transactions.id and xqcc_pools.status = 'XQCC_POOL';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - xray_reviews') into v_log_id; commit;
    update transactions set xray_status = 'XQCC_REVIEW', xray_review_id = xray_reviews.id 
    from xray_reviews 
    where xray_reviews.transaction_id = transactions.id and xray_reviews.status = 'XQCC_REVIEW';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - pcr_pools') into v_log_id; commit;
    update transactions set xray_status = 'PCR_POOL' 
    from pcr_pools 
    where pcr_pools.transaction_id = transactions.id and pcr_pools.status = 'PCR_POOL';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - pcr_reviews') into v_log_id; commit;
    update transactions set xray_status = 'PCR_REVIEW', pcr_review_id = pcr_reviews.id 
    from pcr_reviews 
    where pcr_reviews.transaction_id = transactions.id and pcr_reviews.status = 'PCR_REVIEW';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - xray_pending_reviews') into v_log_id; commit;
    update transactions set xray_status = 'XQCC_PENDING_REVIEW', xray_pending_review_id = xray_pending_reviews.id 
    from xray_pending_reviews 
    where xray_pending_reviews.transaction_id = transactions.id and xray_pending_reviews.status = 'XQCC_PENDING_REVIEW';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - xray_pending_decisions') into v_log_id; commit;
    update transactions set xray_status = 'XQCC_PENDING_DECISION', xray_pending_decision_id = xray_pending_decisions.id 
    from xray_pending_decisions 
    where xray_pending_decisions.transaction_id = transactions.id and xray_pending_decisions.status = 'XQCC_PENDING_DECISION';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - xray_pending_decisions approval') into v_log_id; commit;
    update transactions set xray_status = 'XQCC_PENDING_DECISION_APPROVAL', xray_pending_decision_id = xray_pending_decisions.id 
    from xray_pending_decisions 
    where xray_pending_decisions.transaction_id = transactions.id and xray_pending_decisions.status = 'XQCC_PENDING_DECISION_APPROVAL';
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - certified') into v_log_id; commit;
    update transactions set xray_status = 'CERTIFIED' 
    from fomema_backup_nios.fw_transaction fwt
    where fwt.trans_id = transactions.code and fwt.xr = 1;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - transactions.pcr_review_id') into v_log_id; commit;
    with tmp_tables as (
        select id, transaction_id, created_at, rank() over (partition by transaction_id order by created_at desc) 
        from pcr_reviews
    )
    update transactions set pcr_review_id = tmp_tables.id 
    from tmp_tables where transactions.pcr_review_id is null and tmp_tables.transaction_id = transactions.id and tmp_tables.rank = 1;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - transactions.xray_pending_decision_id') into v_log_id; commit;
    with tmp_tables as (
        select id, transaction_id, created_at, rank() over (partition by transaction_id order by created_at desc) 
        from xray_pending_decisions
    )
    update transactions set xray_pending_decision_id = tmp_tables.id 
    from tmp_tables where transactions.xray_pending_decision_id is null and tmp_tables.transaction_id = transactions.id and tmp_tables.rank = 1;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - transactions.xray_pending_review_id') into v_log_id; commit;
    with tmp_tables as (
        select id, transaction_id, created_at, rank() over (partition by transaction_id order by created_at desc) 
        from xray_pending_reviews
    )
    update transactions set xray_pending_review_id = tmp_tables.id 
    from tmp_tables where transactions.xray_pending_review_id is null and tmp_tables.transaction_id = transactions.id and tmp_tables.rank = 1;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - transactions.xray_retake_id') into v_log_id; commit;
    with tmp_tables as (
        select id, transaction_id, created_at, rank() over (partition by transaction_id order by created_at desc) 
        from xray_retakes
    )
    update transactions set xray_retake_id = tmp_tables.id 
    from tmp_tables where transactions.xray_retake_id is null and tmp_tables.transaction_id = transactions.id and tmp_tables.rank = 1;
    perform end_migration_log(v_log_id);

    select start_migration_log('xqcc_transaction.sql - transactions.xray_review_id') into v_log_id; commit;
    create table if not exists z_xray_review_female_ranks as
    select xr.id, xr.transaction_id, rank() over (partition by xr.transaction_id order by xr.created_at desc) as rank 
    from xray_reviews xr join transactions t on xr.transaction_id = t.id join foreign_workers fw on t.foreign_worker_id = fw.id
    where fw.gender = 'F';
    create index if not exists z_xray_review_female_ranks_transaction_id_index on z_xray_review_female_ranks (transaction_id);
    create index if not exists z_xray_review_female_ranks_rank_index on z_xray_review_female_ranks (rank);

    create table if not exists z_xray_review_male_ranks as
    select xr.id, xr.transaction_id, rank() over (partition by xr.transaction_id order by xr.created_at desc) as rank 
    from xray_reviews xr join transactions t on xr.transaction_id = t.id join foreign_workers fw on t.foreign_worker_id = fw.id
    where fw.gender = 'M';
    create index if not exists z_xray_review_male_ranks_transaction_id_index on z_xray_review_male_ranks (transaction_id);
    create index if not exists z_xray_review_male_ranks_rank_index on z_xray_review_male_ranks (rank);

    update transactions set xray_review_id = zxrr.id
    from z_xray_review_female_ranks zxrr
    where zxrr.transaction_id = transactions.id and zxrr.rank = 1;

    update transactions set xray_review_id = zxrr.id
    from z_xray_review_male_ranks zxrr
    where zxrr.transaction_id = transactions.id and zxrr.rank = 1;

    drop table if exists z_xray_review_female_ranks cascade;
    drop table if exists z_xray_review_male_ranks cascade;
    perform end_migration_log(v_log_id);

end
$$;

\echo 'xqcc_transaction.sql ended'
