\echo "deactivate_duplicate_fw.sql loaded"

do $$
declare
    v_log_id bigint;
    rec record;
begin
    select start_migration_log('deactivate_duplicate_fw.sql') into v_log_id; commit;

drop view if exists v_z_dup_fws;
drop table if exists z_dup_fws;

create table z_dup_fws as
select fw.passport_number, fw.gender, fw.country_id, fw.date_of_birth, fw.status,
count(distinct fw.id) fw_id_count, count(distinct fw.code) as fw_code_count, count(distinct t.id) as transaction_count, 
min(t.transaction_date) min_transaction_date, max(t.transaction_date) max_transaction_date,
string_agg(t.code, ',') all_transaction_code, string_agg(fw.code, ',') all_fw_code, '' as keep_fw_code
from foreign_workers fw left join transactions t on fw.id = t.foreign_worker_id
where fw.status = 'ACTIVE'
group by fw.passport_number, fw.gender, fw.country_id, fw.date_of_birth, fw.status
having count(distinct fw.id) > 1
order by fw_id_count desc;

update z_dup_fws set keep_fw_code = fw.code
from foreign_workers fw join transactions t on t.foreign_worker_id = fw.id and fw.status = 'ACTIVE'
where z_dup_fws.passport_number = fw.passport_number and z_dup_fws.gender = fw.gender 
and z_dup_fws.country_id = fw.country_id and z_dup_fws.date_of_birth = fw.date_of_birth 
and t.transaction_date = z_dup_fws.max_transaction_date;

with tbl as (
	select fw.passport_number, fw.gender, fw.country_id, fw.date_of_birth, fw.updated_at, fw.code fw_code, zdf.fw_id_count, 
	rank() over (partition by fw.passport_number, fw.gender, fw.country_id, fw.date_of_birth order by fw.updated_at desc) as rank
	from z_dup_fws zdf join foreign_workers fw on zdf.passport_number = fw.passport_number and zdf.gender = fw.gender 
	and zdf.country_id = fw.country_id and zdf.date_of_birth = fw.date_of_birth and fw.status = 'ACTIVE'
)
update z_dup_fws set keep_fw_code = tbl.fw_code
from tbl
where z_dup_fws.passport_number = tbl.passport_number and z_dup_fws.gender = tbl.gender 
and z_dup_fws.country_id = tbl.country_id and z_dup_fws.date_of_birth = tbl.date_of_birth
and z_dup_fws.transaction_count = 0 and tbl.rank = 1;

create or replace view v_z_dup_fws as 
select *, 'update foreign_workers set status = ''INACTIVE'' '||
'where code in (''' || replace(replace(trim(replace(all_fw_code, keep_fw_code, ''), ','), ',,', ','), ',', ''', ''') || ''');' as update_sql
from z_dup_fws;

for rec in (
    select * from v_z_dup_fws order by passport_number
) loop
    execute rec.update_sql;
end loop;

    perform end_migration_log(v_log_id);
end
$$;

\echo "deactivate_duplicate_fw.sql end"
