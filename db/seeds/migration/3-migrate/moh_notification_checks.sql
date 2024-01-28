\echo "moh_notification_checks.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('moh_notification_checks.sql') into v_log_id;
        commit;

        with transaction_and_dates as (
            select lt.id, max(coalesce(noti.release_date, noti.certify_date)) result_date
            from moh.notification noti join transactions lt on lt.code = noti.trans_id
            group by lt.id
        )

        insert into moh_notification_checks (
            transaction_id,
            final_result,
            final_result_date,
            created_at,
            updated_at
        )
        select
            id,
            'UNSUITABLE',
            result_date,
            clock_timestamp(),
            clock_timestamp()
        from
            transaction_and_dates;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "moh_notification_checks.sql ended"