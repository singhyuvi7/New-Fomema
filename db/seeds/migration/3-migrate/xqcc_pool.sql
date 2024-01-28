\echo 'xqcc_pool.sql loaded'

do $$
declare
    v_main_id bigint;
begin
    select start_migration_log('xqcc_pool.sql') into v_main_id;
    commit;

    insert into xqcc_pools (
        status,
        created_at,
        updated_at,
        transaction_id,
        picked_up_at,
        source,
        case_type,
        picked_up_by,
        created_by,
        updated_by
    )
    select 
        case when dxbasket.status in ('CHECK', 'NORMAL') then 'XQCC_POOL' else 'ASSIGN' end as status,
        dxbasket.submit_date as created_at,
        coalesce(dxbasket.submit_date, clock_timestamp()) as updated_at,
        /* dxbasket.trans_id */ t.id as transaction_id,
        dxbasket.pickup_date as picked_up_at,
        /* dxbasket.source_ref */ case when dxbasket.source_ref = 1 then 'MERTS' when dxbasket.source_ref = 2 then 'PENDING_REVIEW' else null end as source,
        case when dxbasket.source_ref = 1 then 'XRAY_EXAMINATION_NORMAL' when dxbasket.source_ref = 2 then 'XQCC_PENDING_REVIEW_XQCC_POOL' else null end as case_type,
        /* df.radiographer_id */ users.id as picked_up_by, 
        creator_users.id as created_by,
        updator_users.id as updated_by 
    from fomema_backup_nios.dxbasket join transactions t on dxbasket.trans_id = t.code 
    left join fomema_backup_nios.dxreview_film df on dxbasket.trans_id = df.trans_id and dxbasket.batch_id = df.batch_id 
    left join fomema_backup_nios.v_user_master ruser on df.radiographer_id = ruser.uuid 
    left join users on ruser.userid = users.code
    left join fomema_backup_nios.v_user_master creators on df.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on df.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    order by dxbasket.submit_date
    ;

    perform end_migration_log(v_main_id);
end
$$;

\echo 'xqcc_pool.sql ended'
