\echo 'transaction_comment.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('transaction_comment.sql') into v_log_id; commit;
    insert into transaction_comments (
        transaction_id,
        created_at,
        updated_at,
        created_by,
        comment
    )
    select 
        t.id as transaction_id,
        coalesce(fec.comment_date, clock_timestamp()) as created_at,
        coalesce(fec.comment_date, clock_timestamp()) as updated_at,
        coalesce(u2.id, u1.id) as created_by,
        fec.comments as comment
    from fomema_backup_nios.fw_extra_comments fec join transactions t on fec.trans_id = t.code
    left join users u1 on fec.userid ~ '[a-zA-Z]' and fec.userid = u1.code
    left join fomema_backup_nios.v_user_master vum on fec.userid ~ '^[0-9]+$' and fec.userid = vum.uuid::varchar
    left join users u2 on vum.userid = u2.code
    order by fec.comment_date
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'transaction_comment.sql end'
