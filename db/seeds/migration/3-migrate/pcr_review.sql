\echo 'pcr_review.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('pcr_review.sql') into v_log_id; commit;

    insert into pcr_reviews (
        transmitted_at,
        created_at,
        created_by,
        updated_at,
        updated_by,
        pcr_id,
        transaction_id,
        result,
        status,
        legacy_id
    )
    select 
        daf.audit_date as transmitted_at,
        coalesce(daf.create_date, clock_timestamp()) as created_at,
        /* daf.creator_id */ creator_users.id as created_by,
        coalesce(daf.modify_date, clock_timestamp()) as updated_at,
        /* daf.modify_id */ updator_users.id as updated_by,
        /* daf.pcr_code */ r.user_id as pcr_id,
        /* daf.trans_id */ t.id as transaction_id,
        'NORMAL' as result,
        case when daf.audit_date is not null then 'TRANSMITTED' else 'PCR_REVIEW' end as status,
        daf.id as legacy_id
    from fomema_backup_nios.dxpcr_audit_film daf join transactions t on daf.trans_id = t.code 
    left join fomema_backup_nios.v_user_master creators on daf.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on daf.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join radiologists r on daf.pcr_code = r.code 
    order by daf.id desc 
    ;

    perform end_migration_log(v_log_id);

    select start_migration_log('pcr_review.sql - 4020') into v_log_id; commit;
    update pcr_reviews set result = 'ABNORMAL' 
    from fomema_backup_nios.dxpcr_audit_detail dad join fomema_backup_nios.dxpcr_audit_film daf on dad.pcr_audit_film_id = daf.id 
    where pcr_reviews.legacy_id = daf.id and dad.parameter_code = '4020';
    perform end_migration_log(v_log_id);
    
    select start_migration_log('pcr_review.sql - 4118') into v_log_id; commit;
    update pcr_reviews set comment = dac.comments 
    from fomema_backup_nios.dxpcr_audit_comment dac join fomema_backup_nios.dxpcr_audit_film daf on dac.pcr_audit_film_id = daf.id 
    where pcr_reviews.legacy_id = daf.id and dac.parameter_code = '4118';
    perform end_migration_log(v_log_id);
end
$$;

\echo 'pcr_review.sql ended'
