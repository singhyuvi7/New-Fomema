\echo "transaction_created_by.sql loaded"

do $$
declare
    v_log_id bigint;
    v_admin_id bigint;
begin
    select start_migration_log('transaction_created_by.sql') into v_log_id; commit;
    select id into v_admin_id from users where username = 'ADMIN';
    update transactions set created_by = u.id 
    from employers e join users u on e.id = u.userable_id and u.userable_type = 'Employer' 
    where transactions.created_by = v_admin_id and transactions.employer_id = e.id;
    perform end_migration_log(v_log_id);
end
$$;

\echo "transaction_created_by.sql ended"
