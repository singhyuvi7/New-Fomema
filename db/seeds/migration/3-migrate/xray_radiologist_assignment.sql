\echo "xray_radiologist_assignment.sql loaded"

\echo "Update transactions.xray_reporter_type - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update transactions.xray_reporter_type') into v_log_id;
        commit;

        with only_distinct as (
            SELECT DISTINCT ON (trans_id)
                trans_id, bc_radiologist_code
            FROM fomema_backup_nios.xray_radio_assignment xra
            ORDER BY trans_id, create_date DESC
        )

        UPDATE
            transactions local_trans
        SET
            xray_reporter_type = 'RADIOLOGIST',
            radiologist_id = radiologists.id -- We migrate radiologist_id from xray_radio_assignment, because fw_transaction radiologist codes are bugged.
        FROM
            only_distinct xra
            join radiologists on xra.bc_radiologist_code = radiologists.code
        WHERE
            local_trans.code = xra.trans_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update transactions.xray_reporter_type - End"

\echo "Update xray_examinations radiologist columns UPDATE 1 - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations radiologist columns UPDATE 1') into v_log_id;
        commit;

        UPDATE
            xray_examinations xe
        SET
            radiologist_assigned_at = xra.assignment_date,
            radiologist_started_at = xra.lock_date,
            radiologist_saved_at = xra.report_date ,
            radiologist_transmitted_at = xra.report_date
        FROM
            transactions local_trans join fomema_backup_nios.xray_radio_assignment xra on local_trans.code = xra.trans_id
        WHERE
            xe.transaction_id = local_trans.id and xe.sourceable_type = 'Transaction';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations radiologist columns UPDATE 1 - End"

\echo "Update xray_examinations radiologist columns UPDATE 2 - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations radiologist columns UPDATE 2') into v_log_id;
        commit;

        -- Need to update a second time, because some xray_assignments have multiple rows for the same trans_id.
        -- Need to order by create_date desc, then update using only the latest.
        -- I can't use this in the first update, because for some reason the function select distinct on becomes too complex the more selected columns you use.
        -- When running on the entire xray_radio_assignment with the below select columns (without where query), it kept crashing the queries.
        with only_distinct as (
            SELECT DISTINCT ON (trans_id)
                trans_id, create_date, assignment_date, lock_date, report_date
            FROM fomema_backup_nios.xray_radio_assignment
            where trans_id in ('20200227551857', '20180828914421', '20190410826731', '20181224899781', '20190131545622', '20180111782559', '20180322663715')
            ORDER BY trans_id, create_date DESC
        )

        UPDATE
            xray_examinations xe
        SET
            radiologist_assigned_at = xra.assignment_date,
            radiologist_started_at = xra.lock_date,
            radiologist_saved_at = xra.report_date ,
            radiologist_transmitted_at = xra.report_date
        FROM
            only_distinct xra
            join transactions local_trans on local_trans.code = xra.trans_id
        WHERE
            xe.transaction_id = local_trans.id and xe.sourceable_type = 'Transaction';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations radiologist columns UPDATE 2 - End"

\echo "xray_radiologist_assignment.sql ended"