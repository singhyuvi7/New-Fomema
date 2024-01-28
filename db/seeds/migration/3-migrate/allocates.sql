\echo "allocates.sql loaded"

-- coupling trans : lab
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('allocates.sql - lab') into v_log_id;
        commit;

        insert into allocates (
            doctor_id,
            old_allocatable_id,old_allocatable_type,
            new_allocatable_id,new_allocatable_type,
            created_at,updated_at,
            created_by,updated_by
        ) 
        select doc.id,
            old_sp.id, 'Laboratory',
            new_sp.id, 'Laboratory',
            dl.transdate, dl.modification_date,
            updator_users.id, updator_users.id
        from fomema_backup_nios.coupling_trans dl 
        left join doctors doc on dl.bc_doctor_code = doc.code
        left join laboratories old_sp on dl.bc_old_laboratory_code = old_sp.code
        left join laboratories new_sp on dl.bc_laboratory_code = new_sp.code
        left join fomema_backup_nios.v_user_master updators on dl.modification_id = updators.uuid
        left join users updator_users on updators.userid = updator_users.code
        where dl.bc_laboratory_code is not null or dl.bc_old_laboratory_code is not null;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "allocates.sql - laboratory done"

-- xray
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('allocates.sql - xray') into v_log_id;
        commit;

        insert into allocates (
            doctor_id,
            old_allocatable_id,old_allocatable_type,
            new_allocatable_id,new_allocatable_type,
            created_at,updated_at,
            created_by,updated_by
        ) 
        select doc.id,
            old_sp.id, 'XrayFacility',
            new_sp.id, 'XrayFacility',
            dl.transdate, dl.modification_date,
            updator_users.id, updator_users.id
        from fomema_backup_nios.coupling_trans dl 
        left join doctors doc on dl.bc_doctor_code = doc.code
        left join xray_facilities old_sp on dl.bc_old_xray_code = old_sp.code
        left join xray_facilities new_sp on dl.bc_xray_code = new_sp.code
        left join fomema_backup_nios.v_user_master updators on dl.modification_id = updators.uuid
        left join users updator_users on updators.userid = updator_users.code
        where dl.bc_old_xray_code is not null or dl.bc_xray_code is not null;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "allocates.sql - xray done"
-- end

\echo "allocates.sql ended"