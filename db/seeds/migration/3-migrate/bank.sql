\echo "bank.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('bank.sql') into v_log_id;
    commit;

insert into banks (code, name, status, swift_code, local_bank, routing, routing2, bank_draft_expiry_day, created_at, updated_at) 
select bm.bank_code, bm.bank_name, 
case when bm.isactive = 'Y' then 'ACTIVE' else 'INACTIVE' end isactive, 
bm.swift_code, 
case when bm.local_bank = 'Y' then true else false end local_bank, 
bm.routing, bm.routing2, coalesce(bde.valid_days, 0), clock_timestamp(), clock_timestamp()
from fomema_backup_nios.bank_master bm 
left join fomema_backup_nios.bank_draft_expiry bde 
on bm.bank_code = bde.bank_code;

    perform end_migration_log(v_log_id);
end
$$;

\echo "bank.sql ended"
