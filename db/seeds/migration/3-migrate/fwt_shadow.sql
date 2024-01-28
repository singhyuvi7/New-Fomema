\echo "fwt_shadow.sql"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fwt_shadow') into v_log_id;
        commit;

        UPDATE
            medical_appeals ma
        SET
            xray_facility_id = xf.id
        FROM
            fomema_backup_nios.fwt_shadow fs
            join xray_facilities xf on xf.code = fs.xray_code
        WHERE
            ma.id = fs.appeal_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fwt_shadow.sql"