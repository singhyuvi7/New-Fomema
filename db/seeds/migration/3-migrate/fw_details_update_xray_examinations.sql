\echo "fw_details_update_xray_examinations.sql loaded"

\echo "Update xray_examinations.thoracic_cage - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.thoracic_cage') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2001';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.thoracic_cage - End"

\echo "Update xray_examinations.heart_shape_and_size - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.heart_shape_and_size') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2002';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.heart_shape_and_size - End"

\echo "Update xray_examinations.mediastinum_and_hila - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.mediastinum_and_hila') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2003';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.mediastinum_and_hila - End"

\echo "Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2004';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles - End"

\echo "Update xray_examinations.lung_fields - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.lung_fields') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2011';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.lung_fields - End"

\echo "Update xray_examinations.focal_lesion - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.focal_lesion') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2012';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.focal_lesion - End"

\echo "Update xray_examinations.other_findings - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.other_findings') into v_log_id;
        commit;

        insert into xray_examination_details (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            parameter_code = '2013';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.other_findings - End"

\echo "Update xray_examinations.thoracic_cage_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.thoracic_cage_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2101';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.thoracic_cage_comment - End"

\echo "Update xray_examinations.heart_shape_and_size_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.heart_shape_and_size_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2102';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.heart_shape_and_size_comment - End"

\echo "Update xray_examinations.lung_fields_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.lung_fields_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2111';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.lung_fields_comment - End"

\echo "Update xray_examinations.mediastinum_and_hila_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.mediastinum_and_hila_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2103';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.mediastinum_and_hila_comment - End"

\echo "Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2104';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.pleura_hemidiaphragms_costopherenic_angles_comment - End"

\echo "Update xray_examinations.focal_lesion_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.focal_lesion_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2112';

        perform end_migration_log(v_log_id);
    END
$$;

\echo "Update xray_examinations.other_findings_comment - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.other_findings_comment') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2113';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.other_findings_comment - End"

\echo "Update xray_examinations.result - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.impression') into v_log_id;
        commit;

        insert into xray_examination_comments (
            created_at, updated_at, transaction_id, xray_examination_id, condition_id, comment
        )
        select
            coalesce(xe.created_at, clock_timestamp()), coalesce(xe.created_at, clock_timestamp()),
            local_trans.id, xe.id, conditions.id, fwc.comments
        from
            xray_examinations xe join transactions local_trans on local_trans.id = xe.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            fwc.parameter_code = '2014';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.impression - End"

\echo "Update xray_examinations.result - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update xray_examinations.result') into v_log_id;
        commit;

        with trans_ids as (
            select id from transactions where code in (
                select distinct(trans_id) from fomema_backup_nios.fw_detail fwd
                where fwd.parameter_code in ('2001', '2002', '2003', '2004', '2011', '2012', '2013')
            )
        )

        UPDATE
            xray_examinations xe
        SET
            result = 'ABNORMAL'
        WHERE
            xe.transaction_id in (select id from trans_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update xray_examinations.result - End"

\echo "fw_details_update_xray_examinations.sql ended"
