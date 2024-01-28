\echo "update_transaction_bypass.sql loaded"

DO $$
    DECLARE
        temp_row RECORD;
        v_log_id bigint;
    BEGIN
        select start_migration_log('update_transaction_bypass.sql') into v_log_id;
        commit;

        -- if sp_code null or 'D', bypass both
        -- if sp_code is 'X', bypass Xray only
        FOR temp_row IN
            select a.error_ind,bypass.id as bypass_id, LEFT(a.sp_code,1) as sp_code, b.trans_id, a.insertdate
            from fomema_backup_nios.fw_biodata_reenrolment a
            join fomema_backup_nios.foreign_worker_biodata b on a.worker_code= b.worker_code
            join z_bypass_fingerprint_reason_mappings z_bypass on a.error_ind = z_bypass.oldcode
            join bypass_fingerprint_reasons bypass on z_bypass.newcode = bypass.code
            where b.afis_id is null and b.passport_no is not null
            order by a.insertdate ASC
        LOOP
            IF temp_row.sp_code = 'X' THEN
				UPDATE transactions
                SET xray_bypass_fingerprint_reason_id = temp_row.bypass_id, xray_bypass_fingerprint_date = temp_row.insertdate, xray_fp = true
                WHERE code = temp_row.trans_id;
			ELSE
                UPDATE transactions
                SET doctor_bypass_fingerprint_reason_id = temp_row.bypass_id, doctor_bypass_fingerprint_date = temp_row.insertdate, doctor_fp = true, xray_bypass_fingerprint_reason_id = temp_row.bypass_id, xray_bypass_fingerprint_date = temp_row.insertdate, xray_fp = true
                WHERE code = temp_row.trans_id;
			END IF;
        END LOOP;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_transaction_bypass.sql ended"