\echo "fw_details_update_laboratory_examinations_web_service.sql ended"

\echo "Update laboratory_examinations.web_service_indicator - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.web_service_indicator') into v_log_id;
        commit;

        with transaction_ids as (
            select distinct(lt.id)
            from fomema_backup_nios.fw_detail fwd
            join transactions lt on lt.code = fwd.trans_id
            where parameter_code in ('666', '777', '888')
        )

        UPDATE
            laboratory_examinations le
        SET
            web_service_indicator = true
        WHERE
            le.transaction_id in (select id from transaction_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.web_service_indicator - End"

\echo "fw_details_update_laboratory_examinations_web_service.sql ended"