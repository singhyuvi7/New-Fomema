\echo "transactions_various_statuses.sql loaded"

\echo "Update transactions.communicable_diseases - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update transactions.communicable_diseases') into v_log_id;
        commit;

        UPDATE
            transactions
        SET
            communicable_diseases = true
        WHERE
            id IN (
                SELECT
                    DISTINCT(ded.transaction_id)
                FROM
                    doctor_examination_details ded join conditions cond on ded.condition_id = cond.id
                WHERE
                    cond.code IN ('3501', '3502', '3503', '3504', '3505', '3506')
            );

        -- original time was 14 minutes.

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update transactions.communicable_diseases - End"

\echo "Update transactions.tcupi_date - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update transactions.tcupi_date') into v_log_id;
        commit;

        UPDATE
            transactions local_trans
        SET
            tcupi_date = qr_request.modify_date
        FROM
            fomema_backup_nios.quarantine_release_request qr_request
        WHERE
            qr_request.trans_id = local_trans.code and
            qr_request.status in ('AT', 'ATP'); -- Accepted TCUPI

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update transactions.tcupi_date - End"

\echo "Update transactions.medical_status - Tcupi Pending Approvals - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update transactions.medical_status - Tcupi Pending Approvals') into v_log_id;
        commit;

        UPDATE
            transactions local_trans
        SET
            medical_status = case
            when local_trans.medical_status = 'CERTIFIED' then 'CERTIFIED'
            else 'TCUPI_PENDING_APPROVAL' end
        FROM
            fomema_backup_nios.quarantine_release_request qrr
        WHERE
            local_trans.code = qrr.trans_id
            and qrr.status = 'TP';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update transactions.medical_status - Tcupi Pending Approvals - End"

\echo "transactions_various_statuses.sql ended"