\echo "update_foreign_workers_organization_id.sql loaded"

DO $$
    DECLARE
        v_log_id bigint;
        pt_id bigint;
    BEGIN
        select start_migration_log('update_foreign_workers_organization_id.sql') into v_log_id;
        commit;

        select id into pt_id from organizations where code = 'PT';

        update foreign_workers set organization_id = users.userable_id
        from users 
        where foreign_workers.created_by = users.id
        and foreign_workers.created_at < '2020-11-02'
        and users.userable_type = 'Organization';

        update foreign_workers set organization_id = pt_id
        from users 
        where foreign_workers.created_by = users.id
        and foreign_workers.created_at < '2020-11-02'
        and users.userable_type = 'Employer';
        
        perform end_migration_log(v_log_id);
    END
$$;

\echo "update_foreign_workers_organization_id.sql ended"