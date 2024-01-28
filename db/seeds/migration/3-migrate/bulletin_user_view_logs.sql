\echo "bulletin_user_view_logs.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bulletin_user_view_logs.sql') into v_log_id;
        commit;

        insert into bulletin_user_view_logs (
            bulletin_id,user_id, acknowledged,
            created_at,updated_at
        )
        select bl.id, sp.id, true,
        ba.ackdate, ba.ackdate
        from fomema_backup_nios.bulletin_acknowledge ba
        join bulletins bl on ba.bulletinid = bl.reference_id
        join users sp on ba.usercode = sp.code;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "bulletin_user_view_logs.sql ended"