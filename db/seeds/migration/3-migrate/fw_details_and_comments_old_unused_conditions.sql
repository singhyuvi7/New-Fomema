\echo "fw_details_and_comments_old_unused_conditions.sql loaded"

\echo "fw_details_and_comments_old_unused_conditions - Without parameter_value - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_details_and_comments_old_unused_conditions - Without parameter_value') into v_log_id;
        commit;

        insert into doctor_examination_details (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, text_value
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwd.parameter_value
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code in ('1051', '1052', '1055', '10531', '10532', '10533', '10534', '10541', '10542', '10543', '10544', '10521');

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_details_and_comments_old_unused_conditions - Without parameter_value - End"

\echo "fw_details_and_comments_old_unused_conditions - Comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_details_and_comments_old_unused_conditions - Comment - Start') into v_log_id;
        commit;

        insert into doctor_examination_comments (
            created_at, updated_at, transaction_id, doctor_examination_id, condition_id, comment
        )
        select
            coalesce(de.created_at, clock_timestamp()), coalesce(de.created_at, clock_timestamp()),
            local_trans.id, de.id, conditions.id, fwc.comments
        from
            doctor_examinations de join transactions local_trans on local_trans.id = de.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '10551';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_details_and_comments_old_unused_conditions - Comment - Start"


\echo "fw_details_and_comments_old_unused_conditions.sql ended"