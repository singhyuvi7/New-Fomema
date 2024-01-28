\echo "bulletins.sql loaded"

-- reference id to track id from migration data
ALTER TABLE bulletins ADD COLUMN IF NOT EXISTS reference_id bigint;
CREATE INDEX IF NOT EXISTS index_bulletins_on_reference_id ON bulletins (reference_id);

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bulletins.sql') into v_log_id;
        commit;

        insert into bulletins (
            title,
            content,
            publish_from,publish_to,
            require_acknowledge,
            created_at,updated_at,
            created_by,updated_by,
            reference_id
        )
        select replace(replace(replace(replace(bm.subject,'&amp;', '&'),'&quot;', '"'),'&lt;', '<'),'&gt;', '>'), 
        replace(replace(replace(replace(bm.notice,'&amp;', '&'),'&quot;', '"'),'&lt;', '<'),'&gt;', '>'),
        bm.start_date, case when bm.expiry_date is not null then bm.expiry_date else (NOW()-INTERVAL '1 DAY') end,
        false,
        bm.createdate, bm.modifydate,
        creator_users.id, updator_users.id,
        bulletinid
        from fomema_backup_nios.bulletin_master bm
        left join users creator_users on bm.createby = creator_users.code 
        left join users updator_users on bm.modifyby = updator_users.code
        order by bm.createdate;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "bulletins.sql ended"