\echo 'xqcc_transaction_comment.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xqcc_transaction_comment.sql') into v_log_id; commit;
    insert into xqcc_transaction_comments (
        transaction_id,
        created_at,
        updated_at,
        created_by,
        comment,
        source,
        category
    )
    select 
        t.id as transaction_id,
        coalesce(xfec.comment_date, clock_timestamp()) as created_at,
        coalesce(xfec.comment_date, clock_timestamp()) as updated_at,
        coalesce(u2.id, u1.id) as created_by,
        xfec.comments as comment,
        xfec.source as source,
        xfec.type as category
    from fomema_backup_nios.xqcc_fw_extra_comments xfec join transactions t on xfec.trans_id = t.code
    left join users u1 on xfec.userid ~ '[a-zA-Z]' and xfec.userid = u1.code
    left join fomema_backup_nios.v_user_master vum on xfec.userid ~ '^[0-9]+$' and xfec.userid = vum.uuid::varchar
    left join users u2 on vum.userid = u2.code
    order by xfec.comment_date;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'xqcc_transaction_comment.sql end'
