\echo 'retake_reason.sql loaded'

do $$
declare
    maxid bigint;
    v_log_id bigint;
begin
    select start_migration_log('retake_reason.sql') into v_log_id;
    commit;

    insert into retake_reasons (id, name, created_at, updated_at) 
    select id::bigint, description, clock_timestamp(), clock_timestamp() 
    from fomema_backup_nios.dxpcr_retake_reasons;

    select max(id) into maxid from retake_reasons;
    perform setval('retake_reasons_id_seq', maxid);	

    perform end_migration_log(v_log_id);
end;
$$;

\echo 'retake_reason.sql ended'
