\echo "fw_detail_static.sql loaded"

\echo "fw_detail_static.sql - Updating hiv"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating hiv') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            hiv = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3501';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating hiv"

\echo "fw_detail_static.sql - Updating tuberculosis"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating tuberculosis') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            tuberculosis = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3502';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating tuberculosis"

\echo "fw_detail_static.sql - Updating malaria"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating malaria') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            malaria = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3503';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating malaria"

\echo "fw_detail_static.sql - Updating leprosy"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating leprosy') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            leprosy = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3504';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating leprosy"

\echo "fw_detail_static.sql - Updating std"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating std') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            std = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3505';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating std"

\echo "fw_detail_static.sql - Updating hepatitis"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating hepatitis') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            hepatitis = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3506';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating hepatitis"

\echo "fw_detail_static.sql - Updating cancer"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating cancer') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            cancer = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3507';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating cancer"

\echo "fw_detail_static.sql - Updating epilepsy"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating epilepsy') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            epilepsy = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3508';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating epilepsy"

\echo "fw_detail_static.sql - Updating psychiatric_disorder"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating psychiatric_disorder') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            psychiatric_disorder = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3509';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating psychiatric_disorder"

\echo "fw_detail_static.sql - Updating other"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating other') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            other = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3520';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating other"

\echo "fw_detail_static.sql - Updating hypertension"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating hypertension') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            hypertension = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3514';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating hypertension"

\echo "fw_detail_static.sql - Updating heart_diseases"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating heart_diseases') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            heart_diseases = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3515';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating heart_diseases"

\echo "fw_detail_static.sql - Updating bronchial_asthma"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating bronchial_asthma') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            bronchial_asthma = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3516';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating bronchial_asthma"

\echo "fw_detail_static.sql - Updating diabetes_mellitus"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating diabetes_mellitus') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            diabetes_mellitus = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3517';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating diabetes_mellitus"

\echo "fw_detail_static.sql - Updating peptic_ulcer"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating peptic_ulcer') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            peptic_ulcer = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3518';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating peptic_ulcer"

\echo "fw_detail_static.sql - Updating kidney_diseases"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating kidney_diseases') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            kidney_diseases = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3519';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating kidney_diseases"

\echo "fw_detail_static.sql - Updating pregnant"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating pregnant') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            pregnant = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3510';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating pregnant"

\echo "fw_detail_static.sql - Updating opiates"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating opiates') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            opiates = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3511';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating opiates"

\echo "fw_detail_static.sql - Updating cannabis"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('fw_detail_static - Updating cannabis') into v_log_id;
        commit;

        UPDATE
            transaction_statics ts
        SET
            cannabis = 1
        FROM
            fomema_backup_moh.fw_detail_static fds
        WHERE
            ts.code = fds.trans_id and
            fds.parameter_code = '3512';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "fw_detail_static.sql - Updating cannabis"

\echo "fw_detail_static.sql ended"