with tbl as (
	select fct.worker_code, fw.code fw_code, fw.id fw_id, 
	fct.userid, users.id user_id, fw.blocked_by, fct.modify_date, fw.blocked_at
	from fomema_backup_nios.fw_change_trans fct
	join foreign_workers fw on fct.worker_code = fw.code and fct.modify_date = fw.blocked_at
	join users on fct.userid = users.code
	where fct.table_name = 'FOREIGN_WORKER_MASTER' and fct.field_name = 'ISIMMBLOCK' and fct.new_value = 'Y'
)
update foreign_workers set blocked_by = tbl.user_id
from tbl where tbl.fw_id = foreign_workers.id;