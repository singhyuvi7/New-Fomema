\echo 'update_foreign_worker_latest_transaction_id.sql loaded'

do $$
declare
    v_log_id bigint;
    fw_count bigint;
    loop_counter bigint := 0;
    start_range bigint := 0;
    end_range bigint := 0;
    range_value bigint := 10000;
begin
    select start_migration_log('update_foreign_worker_latest_transaction_id.sql') into v_log_id;
    commit;

    select count(*) into fw_count from foreign_workers;
    fw_count := (fw_count/range_value) + 1;

    loop
        exit when loop_counter = fw_count;
        raise notice 'Loop counter -> %', loop_counter;
        start_range := range_value * loop_counter;
        end_range := start_range + range_value;
        raise notice 'fw.id Range -> % to %', start_range, end_range;

        UPDATE foreign_workers fw
        SET latest_transaction_id = trans.id
        FROM transactions trans
        WHERE trans.id = (select id from transactions where foreign_worker_id = fw.id and transaction_date >= '1998-03-14' order by transaction_date desc limit 1) 
        and fw.id > start_range and fw.id <= end_range;

        loop_counter := loop_counter + 1;
    end loop;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'update_foreign_worker_latest_transaction_id.sql ended'
