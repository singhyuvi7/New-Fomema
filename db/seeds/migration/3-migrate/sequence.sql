
\echo 'sequence.sql loaded';

do $$
declare
    rec record;
    seq varchar;
    v_log_id bigint;
begin
    select start_migration_log('sequence.sql') into v_log_id;
    commit;

for rec in (select * from fomema_backup_nios.code_master where type_ind in ('E', 'W', 'D', 'L', 'X', 'R') and name_first in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9')) loop
    seq := lower('code_' || rec.type_ind || rec.state_code || rec.name_first || '_seq');
    execute 'select setval(''' || seq || ''', ' || rec.last_issue_no || ')';
end loop;

    perform end_migration_log(v_log_id);
end;
$$;

\echo 'sequence.sql end';
