\echo "invoices.sql loaded"

-- group : lab
insert into invoices (
	fin_batch_id, invoice_no, batchable_id, batchable_type, 
    total_amount, gst_amount, invoice_amount,
    male_rate, female_rate,
    gst_code, gst_type, gst_tax,
    status, created_at, updated_at,
    created_by, updated_by
) 
select fb.id, im.invoice_no, gp.id ,'ServiceProviderGroup',
   im.bill_amount, im.gst_amount, im.invoice_amount,
   im.male_rate, im.female_rate,
   im.gst_code, im.gst_type, im.gst_tax,
   im.status, im.creation_date, im.modification_date,
   users.id, users.id
from fomema_backup_nios.invoice_master im 
left join service_provider_groups gp on im.service_provider_code = gp.code
left join users on im.creator_id = users.code
left join fin_batches fb on cast(im.batch_number as varchar(10)) = fb.code
where im.group_invoice = 'Y' limit 2;


-- lab
insert into invoices (
	fin_batch_id, invoice_no, batchable_id, batchable_type, 
    total_amount, gst_amount, invoice_amount,
    male_rate, female_rate,
    gst_code, gst_type, gst_tax,
    status, created_at, updated_at,
    created_by, updated_by
) 
select fb.id, im.invoice_no, lab.id ,'Laboratory',
   im.bill_amount, im.gst_amount, im.invoice_amount,
   im.male_rate, im.female_rate,
   im.gst_code, im.gst_type, im.gst_tax,
   im.status, im.creation_date, im.modification_date,
   users.id, users.id
from fomema_backup_nios.invoice_master im 
left join laboratories lab on im.service_provider_code = lab.code
left join users on im.creator_id = users.code
left join fin_batches fb on cast(im.batch_number as varchar(10)) = fb.code
where im.group_invoice = 'N' limit 2;


\echo "invoices.sql ended"
