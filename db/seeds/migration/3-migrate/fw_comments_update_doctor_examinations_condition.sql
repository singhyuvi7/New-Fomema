\echo "fw_comments_update_doctor_examinations_condition.sql loaded"

\echo "Update doctor_examinations.certification_comment - First 200k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.certification_comment - First 200k') into v_log_id;
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
            fwc.parameter_code = '5501'
            and fwc.trans_id < '20060412943351';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.certification_comment - First 200k - End"

\echo "Update doctor_examinations.certification_comment - 200k to 400k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.certification_comment - 200k to 400k') into v_log_id;
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
            fwc.parameter_code = '5501'
            and fwc.trans_id >= '20060412943351'
            and trans_id < '20100517724614';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.certification_comment - 200k to 400k - End"

\echo "Update doctor_examinations.certification_comment - 400k to 600k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.certification_comment - 400k to 600k') into v_log_id;
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
            fwc.parameter_code = '5501'
            and fwc.trans_id >= '20100517724614'
            and trans_id < '20140828922170';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.certification_comment - 400k to 600k - End"

\echo "Update doctor_examinations.certification_comment - 600k to 740k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.certification_comment - 600k to 740k') into v_log_id;
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
            fwc.parameter_code = '5501'
            and fwc.trans_id >= '20140828922170';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.certification_comment - 600k to 873k - End"

\echo "Update doctor_examinations.unsuitable_comment - First 200k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.unsuitable_comment - First 200k') into v_log_id;
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
            fwc.parameter_code = '5502'
            and fwc.trans_id < '20060804606159';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.unsuitable_comment - First 200k - End"

\echo "Update doctor_examinations.unsuitable_comment - 200k to 400k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.unsuitable_comment - 200k to 400k') into v_log_id;
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
            fwc.parameter_code = '5502'
            and fwc.trans_id >= '20060804606159'
            and trans_id < '20120313573362';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.unsuitable_comment - 200k to 400k - End"

\echo "Update doctor_examinations.unsuitable_comment - 400k to 600k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.unsuitable_comment - 400k to 600k') into v_log_id;
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
            fwc.parameter_code = '5502'
            and fwc.trans_id >= '20120313573362'
            and trans_id < '20171005963029';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.unsuitable_comment - 400k to 600k - End"

\echo "Update doctor_examinations.unsuitable_comment - 600k to 740k - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('Update doctor_examinations.unsuitable_comment - 600k to 740k') into v_log_id;
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
            fwc.parameter_code = '5502'
            and fwc.trans_id >= '20171005963029';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Update doctor_examinations.unsuitable_comment - 600k to 740k - End"

\echo "fw_comments_update_doctor_examinations_condition.sql ended"