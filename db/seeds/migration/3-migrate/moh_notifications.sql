\echo "moh_notifications.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('moh_notifications.sql') into v_log_id;
        commit;

        insert into moh_notifications (
            transaction_id,
            disease,
            release_flag,
            quarantined,
            quarantine_release_date,
            created_at,
            updated_at,
            notification_release_date
        )
        select
            lt.id,
            noti.disease,
            noti.release_flag,
            noti.qrtn_ind,
            noti.release_date,
            coalesce(noti.creation_date, clock_timestamp()),
            coalesce(noti.action_date, noti.creation_date, clock_timestamp()),
            case
                when noti.release_flag is not null then coalesce(noti.action_date, noti.creation_date, clock_timestamp())
                else null end
        from
            fomema_backup_moh.notification noti
            join transactions lt on lt.code = noti.trans_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "moh_notifications.sql ended"