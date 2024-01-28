\echo "transaction_quarantine_reasons_fw_doc_10008.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
        quarantine_id integer := 0;
    BEGIN
        select start_migration_log('transaction_quarantine_reasons_fw_doc_10008.sql') into v_log_id;
        commit;

        /*
            Please note that in new system, we are using
            10008 - In-House PCR does not agree with the Digital X-Ray finding.
            10013 - In-House PCR does not agree with the Digital X-Ray finding. Case transferred by XQCC Department.
            For cases in quarantine_fw_doc, these fall under third concurrence, and it is 10013 in the new system.
        */

        select id into quarantine_id from quarantine_reasons where code = '10013' limit 1;
        raise notice 'Quarantine Reason ID -> %', quarantine_id;


        insert into transaction_quarantine_reasons (
            transaction_id, quarantine_reason_id, created_at, updated_at
        )
        select
            lt.id, quarantine_id, coalesce(qfd.time_inserted, clock_timestamp()), coalesce(qfd.time_inserted, clock_timestamp())
        from
            transactions lt
            join fomema_backup_nios.quarantine_fw_doc qfd on qfd.trans_id = lt.code
        where
            qrtn_source = 4;
            -- quarantine_reason like '%10008%';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "transaction_quarantine_reasons_fw_doc_10008.sql ended"