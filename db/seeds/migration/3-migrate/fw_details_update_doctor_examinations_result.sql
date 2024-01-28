\echo "fw_details_update_doctor_examinations_result.sql loaded"

\echo "Update doctor_examination.result - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examination.result') into v_log_id;
        commit;

        with trans_ids as (
            select id from transactions where code in (
                select distinct(trans_id) from fomema_backup_nios.fw_detail fwd
                where fwd.parameter_code in ('3101', '3102', '3103', '3104', '3105', '3106', '3107', '3108', '3201', '3202', '3203', '3204', '3205', '3206', '3207', '3209', '3210', '3401', '3402', '3403', '3404', '3405', '3406', '3407', '3408', '3409', '3410', '3411', '3412', '3413', '3011', '3012', '3013', '3021', '3022', '3031', '3032', '3034', '3035', '3036', '3037', '3041', '3053', '3054', '3055', '3056', '3057', '3077', '3058', '3059', '3060', '3061', '3062', '3063', '3064', '3078', '3065', '3066', '3067', '3068', '3069', '3070', '3071', '3042', '3043', '3044', '3045', '3046', '3047', '3072', '3033', '3051', '3052', '3073', '3074', '3075', '3076')
            )
        )

        UPDATE
            doctor_examinations de
        SET
            result = 'ABNORMAL'
        WHERE
            de.transaction_id in (select id from trans_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examination.result - End"

\echo "fw_details_update_doctor_examinations_result.sql ended"