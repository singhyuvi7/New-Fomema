\echo 'foreign_worker_changes.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('foreign_worker_changes.sql') into v_log_id; commit;
    insert into foreign_worker_changes (
        foreign_worker_id,
        field,
        old_value,
        new_value,
        created_by,
        created_at,
        updated_at
    )
    select 
       fw.id as foreign_worker_id,
       case when fwcid.critical_column = 'COUNTRY' then 'country_id'
       when fwcid.critical_column = 'DOB' then 'date_of_birth'
       when fwcid.critical_column = 'PASSPORT' then 'passport_number' 
       else lower(fwcid.critical_column) end as field,
       case when fwcid.critical_column = 'COUNTRY' then coalesce(old_countries.id::varchar, fwcid.critical_old)
       else fwcid.critical_old end as old_value,
       case when fwcid.critical_column = 'COUNTRY' then coalesce(new_countries.id::varchar, fwcid.critical_new)
       else fwcid.critical_new end as new_value,
       creator_users.id as created_by,
       coalesce(fwci.createdate, clock_timestamp()) as created_at,
       coalesce(fwci.modifydate, clock_timestamp()) as updated_at
    from fomema_backup_nios.fw_critical_info fwci join foreign_workers fw on fwci.worker_code = fw.code 
    join fomema_backup_nios.fw_critical_info_detail fwcid on fwci.fw_critical_id = fwcid.fw_critical_id 
    left join fomema_backup_nios.v_user_master creators on fwci.createby = creators.uuid 
    left join users creator_users on creators.userid = creator_users.code 
    left join countries old_countries on fwcid.critical_column = 'COUNTRY' and old_countries.old_code = fwcid.critical_old 
    left join countries new_countries on fwcid.critical_column = 'COUNTRY' and new_countries.old_code = fwcid.critical_new 
    order by fwci.createdate
    ;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'foreign_worker_changes.sql ended'
