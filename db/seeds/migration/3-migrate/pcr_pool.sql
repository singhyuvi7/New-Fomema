\echo 'pcr_pool.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('pcr_pool.sql') into v_log_id;
    commit;

    insert into pcr_pools (
        created_at, 
        created_by, 
        updated_at, 
        updated_by, 
        picked_up_by, 
        case_type, 
        transaction_id, 
        source,
        picked_up_at,
        status
    )
    select 
        coalesce(dp.create_date, clock_timestamp()) as created_at, 
        /* creator_id */ creator_users.id as created_by, 
        coalesce(dp.modify_date, clock_timestamp()) as updated_at, 
        /* modify_id */ updator_users.id as updated_by, 
        /* pcr_code */ r.user_id as picked_up_by, 
        /* status */ case 
            when dp.status = 'ABNORMAL' then 'XRAY_EXAMINATION_ABNORMAL'
            when dp.status = 'APPEAL' then 'XRAY_EXAMINATION_APPEAL'
            when dp.status = 'AUDIT' then 'XQCC_PENDING_REVIEW_PCR_POOL'
            when dp.status = 'IDENTICAL' then 'XQCC_REVIEW_IDENTICAL'
            when dp.status = 'IQA' then 'XQCC_REVIEW_IQA'
            when dp.status = 'MISMATCH' then 'XQCC_REVIEW_MISMATCH'
            when dp.status = 'SUSPICIOUS' then 'XQCC_REVIEW_SUSPICIOUS'
            when dp.status = 'WRONG' then 'XQCC_REVIEW_WRONG_TRANSMISSION'
            else null 
        end as case_type, 
        /* trans_id */ t.id as transaction_id, 
        source_ref as source,
        case 
            when dp.pcr_code is null then null 
            else coalesce(dp.modify_date, clock_timestamp()) 
        end as picked_up_at,
        case 
            when pcr_code is null then 'PCR_POOL' 
            else 'ASSIGN' 
        end as status
    from fomema_backup_nios.dxpcr_pool dp join transactions t on dp.trans_id = t.code 
    left join fomema_backup_nios.v_user_master creators on case when dp.creator_id ~* '[a-z]' then null else dp.creator_id::bigint end = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on case when dp.modify_id ~* '[a-z]' then null else dp.modify_id::bigint end = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join radiologists r on dp.pcr_code = r.code
    order by dp.create_date;

    insert into pcr_pools (
        transaction_id,
        case_type,
        status,
        source,
        sourceable_type,
        sourceable_id,
        created_at,
        updated_at,
        created_by,
        updated_by
    )
    select
        t.id as transaction_id,
        'XQCC_REVIEW_MISMATCH',
        'PCR_POOL',
        'XQCC_REVIEW',
        'XrayReview',
        xr.id,
        xr.updated_at,
        xr.updated_at,
        xr.updated_by,
        xr.updated_by
    from fomema_backup_nios.dxreview_film df join transactions t on df.trans_id = t.code
    join fomema_backup_nios.fw_transaction fwt on t.code = fwt.trans_id and fwt.xr != 1
    join xray_reviews xr on t.id = xr.transaction_id
    left join pcr_pools pp on pp.transaction_id = t.id
    where df.status = 'MISMATCH' and pp.id is null;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'pcr_pool.sql ended'
