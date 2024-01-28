\echo "fw_details_update_laboratory_examinations.sql loaded"

\echo "Update laboratory_examinations.elisa - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.elisa') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1041';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.elisa - End"

\echo "Update laboratory_examinations.hbsag - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.hbsag') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1042';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.hbsag - End"

\echo "Update laboratory_examinations.vdrl - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.vdrl') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1043';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.vdrl - End"

\echo "Update laboratory_examinations.tpha - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.tpha') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '10431';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.tpha - End"

\echo "Update laboratory_examinations.malaria - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.malaria') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1044';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.malaria - End"

\echo "Update laboratory_examinations.bfmp - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.bfmp') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '10441';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.bfmp - End"

\echo "Update laboratory_examinations.opiates - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.opiates') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1057';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.opiates - End"

\echo "Update laboratory_examinations.cannabis - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.cannabis') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1058';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.cannabis - End"

\echo "Update laboratory_examinations.pregnancy - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.pregnancy') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1059';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.pregnancy - End"

\echo "Update laboratory_examinations.pregnancy_serum_beta_hcg - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.pregnancy_serum_beta_hcg') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '10591';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.pregnancy_serum_beta_hcg - End"

\echo "Update laboratory_examinations.sugar - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.sugar') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1053';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.sugar - End"

\echo "Update laboratory_examinations.albumin - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.albumin') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '1054';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.albumin - End"

\echo "Update laboratory_examinations.sugar_value - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.sugar_value') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id, text_value
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id, cast(fwd.parameter_value as float)
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '10535';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.sugar_value - End"

\echo "Update laboratory_examinations.albumin_value - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.albumin_value') into v_log_id;
        commit;

        insert into laboratory_examination_details (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id, text_value
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id, cast(fwd.parameter_value as float)
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_detail fwd on local_trans.code = fwd.trans_id
            join conditions on conditions.code = fwd.parameter_code
        where
            fwd.parameter_code = '10545';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.albumin_value - End"

\echo "Update laboratory_examinations.abnormal_reason - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.abnormal_reason') into v_log_id;
        commit;

        insert into laboratory_examination_comments (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id, comment
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id, fwc.comments
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            parameter_code = '1056';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.abnormal_reason - End"

\echo "Update laboratory_examinations.blood_group_other - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examinations.blood_group_other') into v_log_id;
        commit;

        insert into laboratory_examination_comments (
            created_at, updated_at, transaction_id, laboratory_examination_id, condition_id, comment
        )
        select
            coalesce(le.created_at, clock_timestamp()), coalesce(le.created_at, clock_timestamp()),
            local_trans.id, le.id, conditions.id, fwc.comments
        from
            laboratory_examinations le join transactions local_trans on local_trans.id = le.transaction_id
            join fomema_backup_nios.fw_comment fwc on local_trans.code = fwc.trans_id
            join conditions on conditions.code = fwc.parameter_code
        where
            parameter_code = '10411';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examinations.blood_group_other - End"

\echo "Update laboratory_examination.result - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update laboratory_examination.result') into v_log_id;
        commit;

        with trans_ids as (
            select id from transactions where code in (
                select distinct(trans_id) from fomema_backup_nios.fw_detail fwd
                where fwd.parameter_code in ('1041', '1042', '10431', '10441', '1057', '1058', '10591', '1053', '1054')
            )
        )

        UPDATE
            laboratory_examinations le
        SET
            result = 'ABNORMAL'
        WHERE
            le.transaction_id in (select id from trans_ids);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update laboratory_examination.result - End"

\echo "fw_details_update_laboratory_examinations.sql ended"