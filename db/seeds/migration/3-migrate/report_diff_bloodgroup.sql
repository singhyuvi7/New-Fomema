\echo "report_diff_bloodgroup.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('report_diff_bloodgroup.sql') into v_log_id;
        commit;

        insert into report_diff_bloodgroups (
            foreign_worker_code,
            doctor_code_1,
            doctor_code_2,
            doctor_code_3,
            transaction_code_1,
            transaction_code_2,
            transaction_code_3,
            blood_group_1,
            blood_group_2,
            blood_group_3,
            rhesus_1,
            rhesus_2,
            rhesus_3,
            created_at,
            updated_at,
            created_by,
            updated_by
        )
        select
            rdb.worker_code,
            rdb.doctor_code_me1,
            rdb.doctor_code_me2,
            rdb.doctor_code_me3,
            rdb.trans_id_me1,
            rdb.trans_id_me2,
            rdb.trans_id_me3,
            rdb.blood_group_me1,
            rdb.blood_group_me2,
            rdb.blood_group_me3,
            rdb.rh_me1,
            rdb.rh_me2,
            rdb.rh_me3,
            rdb.created_date,
            rdb.created_date,
            users.id,
            users.id
        from
            fomema_backup_nios.report_diff_bloodgroup rdb
            left join fomema_backup_nios.v_user_master v_users on v_users.uuid = rdb.created_by
            left join users on users.code = v_users.userid
        order by
            rdb.created_date asc;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "report_diff_bloodgroup.sql ended"