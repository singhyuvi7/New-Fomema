\echo "employer_account.sql loaded"

DO $$
    DECLARE
        temp_row RECORD;
        reason_id bigint;
        emp_id bigint;
        v_log_id bigint;
    begin
        select start_migration_log('employer_account.sql - block worker') into v_log_id;
        commit;

        SELECT id into reason_id from block_reasons where code = 'PAYMENTISSUE';

        FOR temp_row IN
           SELECT employer_code,SUM(amount) as sum
           FROM fomema_backup_nios.employer_account
           WHERE employer_code LIKE 'E%'
           GROUP BY employer_code
           HAVING SUM(amount) < 0
        LOOP
            SELECT id into emp_id FROM employers where code = temp_row.employer_code;

            IF emp_id IS NOT NULL THEN
                UPDATE foreign_workers
                SET blocked = 'true', block_reason_id = reason_id, blocked_at = NOW(), block_comment = 'EMPLOYER ACCOUNT AMOUNT IS BELOW 0'
                WHERE employer_id = emp_id; 
            END IF;
        END LOOP;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "employer_account.sql - block worker if employer sum is negative done"

\echo "employer_account.sql ended"
