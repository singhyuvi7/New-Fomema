\echo "first_transaction.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('first_transaction.sql') into v_log_id;
        commit;

        insert into first_transactions (
            passport_number, date_of_birth, gender, country_id, transaction_id, created_at, updated_at
        )
        select t.fw_passport_number, t.fw_date_of_birth, t.fw_gender, t.fw_country_id , min(t.id), clock_timestamp(), clock_timestamp()
        from transactions t
        where t.status not in ('CANCELLED', 'REJECTED')
        group by t.fw_passport_number, t.fw_date_of_birth, t.fw_gender, t.fw_country_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "first_transaction.sql ended"