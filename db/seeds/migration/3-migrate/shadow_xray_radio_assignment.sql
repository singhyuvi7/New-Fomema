\echo "shadow_xray_radio_assignment.sql"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('shadow_xray_radio_assignment') into v_log_id;
        commit;

        UPDATE
            medical_appeals ma
        SET
            radiologist_id = rad.id
        FROM
            fomema_backup_nios.shadow_xray_radio_assignment sxra
            join radiologists rad on rad.code = sxra.bc_radiologist_code
        WHERE
            ma.code = sxra.trans_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "shadow_xray_radio_assignment.sql"