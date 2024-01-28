\echo 'update_foreign_worker_plks.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('update_foreign_worker_plks.sql') into v_log_id;
    commit;

    UPDATE foreign_workers fw
    SET plks_number = case when br.renewal_count_years is not null then br.renewal_count_years else 0 end
    FROM biodata_responses br
    WHERE br.id = (select id from biodata_responses temp_br where fw.id = temp_br.foreign_worker_id order by temp_br.created_at desc limit 1);

    perform end_migration_log(v_log_id);
end
$$;

\echo 'update_foreign_worker_plks.sql ended'
