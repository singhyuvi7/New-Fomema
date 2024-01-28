\echo "invoice_items.sql loaded"

-- lab
insert into invoice_items (
	sp_fin_batch_id, transaction_id, invoice_no,
    itemable_id, itemable_type, sex,
    created_at, updated_at,
    created_by, updated_by
) 
select iv.id, tr.id, id.invoice_no,
   lab.id, 'Laboratory', id.sex,
   id.creation_date, id.modification_date,
   iv.created_by, iv.updated_by
from fomema_backup_nios.invoice_detail id 
left join invoices iv on id.invoice_no = iv.invoice_no
left join laboratories lab on id.member_code = lab.code 
left join transactions tr on id.trans_id = tr.code limit 2;


\echo "invoice_items.sql ended"
