\echo 'xray_review.sql loaded'

do $$
declare
    v_log_id bigint;
begin

    select start_migration_log('xray_review.sql - dxreview_film') into v_log_id; commit;

    insert into xray_reviews (
        created_at,
        created_by,
        updated_at,
        updated_by,
        result,
        status,
        transaction_id,
        transmitted_at,
        batch_id,
        radiographer_id
    )
    select 
        coalesce(df.create_date, clock_timestamp()) as created_at,
        /* df.creator_id */ creator_users.id as created_by,
        coalesce(df.modify_date, clock_timestamp()) as updated_at,
        /* df.modify_id */ updator_users.id as updated_by,
        case 
            when df.status = 'SUSPICIOUS' then 'SUSPICIOUS'
            when df.status = 'OTHERS' then 'OTHERS'
            when df.status = 'NORMAL' then 'NORMAL'
            when df.status = 'IDENTICAL' then 'IDENTICAL'
            when df.status = 'MISMATCH' then 'MISMATCH'
            when df.status = 'WRONG' then 'WRONGLY_TRANSMITTED'
            else null
        end as result,
        case when df.review_date is null then 'XQCC_REVIEW' else 'TRANSMITTED' end as status,
        /* df.trans_id */ t.id as transaction_id,
        df.review_date as transmitted_at,
        df.batch_id,
        /* df.radiographer_id */ case 
            when df.radiographer_id = 9999 then noreplyusers.id 
            else rusers.id 
        end as radiographer_id
    from fomema_backup_nios.dxreview_film df join transactions t on df.trans_id = t.code 
    left join fomema_backup_nios.v_user_master creators on df.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on df.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join fomema_backup_nios.v_user_master radiographer_users on df.radiographer_id = radiographer_users.uuid 
    left join users rusers on radiographer_users.userid = rusers.code 
    left join users noreplyusers on noreplyusers.email = 'noreply@fomema.com.my'
    order by df.id
    ;
    perform end_migration_log(v_log_id);

    select start_migration_log('xray_review.sql - dxreview_film.is_iqa') into v_log_id; commit;
    update xray_reviews set is_iqa = 'Y' 
    from fomema_backup_nios.dxreview_film df join transactions t on df.trans_id = t.code
    join fomema_backup_nios.dxpcr_pool dp on dp.review_film_id = df.id and dp.status = 'IQA'
    where xray_reviews.transaction_id = t.id;
    perform end_migration_log(v_log_id);

    select start_migration_log('xray_review.sql - xray_review_film') into v_log_id; commit;
    insert into xray_reviews (
        transaction_id,
        result,
        created_by,
        created_at,
        updated_by,
        updated_at,
        transmitted_at,
        status,
        is_iqa
    )
    select 
        t.id as transaction_id,
        case when xrf.status in ('NORMAL', 'SUSPICIOUS', 'IDENTICAL') then xrf.status 
        when xrf.status = 'IQA' then 'NORMAL' else null end as result,
        creator_users.id as created_by,
        coalesce(xrf.create_date, clock_timestamp()) as created_at,
        updator_users.id as updated_by,
        coalesce(xrf.modify_date, clock_timestamp()) as updated_at,
        coalesce(xrf.modify_date, clock_timestamp()) as transmitted_at,
        'TRANSMITTED' as status,
        case when xrf.status = 'IQA' then 'Y' else 'N' end as is_iqa
    from fomema_backup_nios.xray_review_film xrf join transactions t on xrf.trans_id = t.code
    left join fomema_backup_nios.v_user_master creators on xrf.creator_id::numeric = creators.uuid
    left join users creator_users on creators.userid = creator_users.code
    left join fomema_backup_nios.v_user_master updators on xrf.modifier_id::numeric = updators.uuid
    left join users updator_users on updators.userid = updator_users.code
    order by xrf.review_filmid
    ;
    perform end_migration_log(v_log_id);
    
    select start_migration_log('xray_review.sql - comment') into v_log_id; commit;
    insert into xqcc_comments (
        comment,
        created_at,
        created_by,
        commentable_id,
        commentable_type,
        updated_at,
        updated_by
    )
    select 
        dfc.comments,
        coalesce(dfc.create_date, clock_timestamp()) created_at,
        /* dfc.creator_id */ creator_users.id created_by,
        /* dfc.dxry_id */ xr.id commentable_id,
        'XrayReview' commentable_type,
        coalesce(dfc.modify_date, clock_timestamp()) updated_at,
        /* dfc.modify_id */ updator_users.id updated_by
    from fomema_backup_nios.dxreview_film_comment dfc join fomema_backup_nios.dxreview_film df on dfc.dxry_id = df.id 
    join transactions t on t.code = df.trans_id 
    join xray_reviews xr on xr.batch_id = df.batch_id and xr.transaction_id = t.id
    left join fomema_backup_nios.v_user_master creators on dfc.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on dfc.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code
    order by dfc.create_date
    ;

    insert into xqcc_comments (
        comment,
        created_at,
        created_by,
        commentable_id,
        commentable_type,
        updated_at,
        updated_by
    )
    select 
        xrfc.comments,
        coalesce(xrfc.create_date, clock_timestamp()) created_at,
        /* xrfc.creator_id */ creator_users.id created_by,
        /* xrfc.dxry_id */ xr.id commentable_id,
        'XrayReview' commentable_type,
        coalesce(xrfc.modify_date, clock_timestamp()) updated_at,
        /* xrfc.modifier */ updator_users.id updated_by
    from fomema_backup_nios.xray_review_film_comments xrfc
    join transactions t on t.code = xrfc.trans_id 
    join xray_reviews xr on xr.transaction_id = t.id
    left join fomema_backup_nios.v_user_master creators on xrfc.creator_id::integer = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on xrfc.modifier_id::integer = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code
    order by xrfc.create_date
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'xray_review.sql ended'
