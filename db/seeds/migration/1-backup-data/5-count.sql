drop table if exists public.copy_counts;

CREATE TABLE if not exists public.copy_counts
(
    id bigserial,
    created_at timestamp(0) without time zone default current_timestamp,
    updated_at timestamp(0) without time zone default current_timestamp,
    schema_name varchar,
    table_name varchar,
    record_count bigint
);

do $$
declare
    v_error_stack text;
    v_copy_log_id_process bigint;
    v_copy_log_id_item bigint;
    rec record;
	v_count bigint;
begin
    for rec in (
		select * from information_schema.tables 
		where table_schema in ('nios', 'portal', 'moh') 
	) loop
		execute 'select count(*) from ' || rec.table_schema || '.' || rec.table_name into v_count;
		raise notice 'schema: %, table: %, count: %', rec.table_schema, rec.table_name, v_count;
        insert into public.copy_counts (schema_name, table_name, record_count) values (rec.table_schema, rec.table_name, v_count);
    end loop;
end;
$$;

/*
SELECT 'select count(1) ' ||tablename|| ' from fomema_backup_nios.'||tablename ||' ;'
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND  schemaname = 'fomema_backup_nios' 
and tablename like '%master'
order by tablename;
*/