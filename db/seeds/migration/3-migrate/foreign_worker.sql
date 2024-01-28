\echo 'foreign_worker.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('foreign_worker.sql - insert') into v_log_id; commit;
    perform rebuild_index_prepare('foreign_workers');

    insert into foreign_workers (
        code, 
        name, 
        created_at, 
        date_of_birth, 
        passport_number, 
        gender, 
        job_type_id, 
        arrival_date, 
        country_id, 
        employer_id, 
        monitoring, 
        blocked, 
        created_by, 
        updated_by, 
        updated_at, 
        pati, 
        gender_amended_at,
        approval_status
    ) 
    select 
        fw.worker_code as code, 
        fw.worker_name as name, 
        /* fw.creation_date */ coalesce(fw.creation_date, clock_timestamp()) as created_at, 
        fw.date_of_birth as date_of_birth, 
        fw.passport_no as passport_number, 
        fw.sex as gender, 
        /* fw.job_type */ job_types.id as job_type_id, 
        fw.arrival_date as arrival_date, 
        /* fw.country_code */ countries.id as country_id, 
        /* fw.employer_code */ employers.id as employer_id, 
        /* fw.ismonitor */ case when fw.ismonitor = 'Y' then 'Y' else 'N' end as monitoring, 
        /* fw.isimmblock */ case when fw.isimmblock = 'Y' then true else false end as blocked, 
        /* fw.creator_id */ creator_users.id as created_by, 
        /* fw.modify_id */ updator_users.id as updated_by, 
        coalesce(fw.modification_date, clock_timestamp()) as updated_at, 
        /* fw.pati */ case when fw.pati = 'Y' then true else false end as pati, 
        ea.creation_date as gender_amended_at,
        'UPDATE_APPROVED' as approval_status
    from fomema_backup_nios.v_foreign_worker_master fw 
    left join countries on countries.old_code = fw.country_code 
    left join job_types on fw.job_type = job_types.name 
    left join fomema_backup_nios.v_user_master creators on fw.creator_id = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join fomema_backup_nios.v_user_master updators on fw.modify_id = updators.uuid 
    left join users updator_users on updators.userid = updator_users.code 
    left join employers on fw.employer_code = employers.code 
    left join fomema_backup_nios.employer_account ea on ea.worker_code = fw.worker_code and ea.type = 33 -- 33 is payment for gender amendment
    order by fw.creation_date
    ;

    perform end_migration_log(v_log_id);

    select start_migration_log('foreign_worker.sql - rebuild index') into v_log_id; commit;
    perform rebuild_index('foreign_workers');
    perform end_migration_log(v_log_id);
end
$$;

\echo 'foreign_worker.sql ended'
