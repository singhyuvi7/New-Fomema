\echo "set_various_sequences.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('set_various_sequences.sql') into v_log_id;
        commit;

        -- Tcupi letter sequence is now combined, wil ltake from the largest number (which is from xray_letter_refid.
        perform setval('tcupi_letter_seq', (
            cast((
                select max(tcupi_xrayletter_refid) from fomema_backup_nios.quarantine_fw_doc where certification_date > '2020-01-01'
            ) as integer)
        ));

        perform setval('medical_appeals_id_seq', (
            select id from medical_appeals order by id desc limit 1
        ));

        perform setval('medical_appeal_xray_retake_code_seq', (
            select cast(right(shadow_id, 12) as integer) from fomema_backup_nios.fwt_shadow where shadow_id like '88%' order by shadow_id desc limit 1
        ));

        perform end_migration_log(v_log_id);
    END
$$;
\echo "set_various_sequences.sql ended"