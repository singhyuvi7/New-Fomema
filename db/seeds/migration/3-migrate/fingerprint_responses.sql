\echo "fingerprint_responses.sql loaded"

-- error status : doc
insert into fingerprint_responses (
	visitable_type,visitable_id,
    row_count,foreign_worker_id,
    status_code,
    status_message,
    description,
    request_datetime,
    response_datetime,
    created_at,updated_at
) 
select 'Doctor',doc.id, 
    0, fw.id, 
    case when br.error_ind = 1 then 'GWY0005'
    when br.error_ind = 2 then 'GWY0004'
    else 
        'error'
    end,
    'Error',
    case when br.error_ind = 1 then 'Below Threshold'
    when br.error_ind = 2 then 'Matching Not Found'
    when br.error_ind = 5 then 'Change Coupling'
    when br.error_ind = 6 then 'Expired Case'
    when br.error_ind = 7 then 'Pending HTTP Action'
    else 
        'ERROR'
    end,
    insertdate,insertdate,insertdate,insertdate
from fomema_backup_nios.fw_biodata_reenrolment br
left join doctors doc on br.sp_code = doc.code
left join foreign_workers fw on br.worker_code = fw.code
where br.sp_code is not null and br.sp_code LIKE 'D%';

\echo "fingerprint_responses.sql - error status(doc) done"

-- error status : xray
insert into fingerprint_responses (
	visitable_type,visitable_id,
    row_count,foreign_worker_id,
    status_code,
    status_message,
    description,
    request_datetime,
    response_datetime,
    created_at,updated_at
) 
select 'XrayFacility',xray.id, 
    0, fw.id, 
    case when br.error_ind = 1 then 'GWY0005'
    when br.error_ind = 2 then 'GWY0004'
    else 
        'error'
    end,
    'Error',
    case when br.error_ind = 1 then 'Below Threshold'
    when br.error_ind = 2 then 'Matching Not Found'
    when br.error_ind = 5 then 'Change Coupling'
    when br.error_ind = 6 then 'Expired Case'
    when br.error_ind = 7 then 'Pending HTTP Action'
    else 
        'ERROR'
    end,
    insertdate,insertdate,insertdate,insertdate
from fomema_backup_nios.fw_biodata_reenrolment br
left join xray_facilities xray on br.sp_code = xray.code
left join foreign_workers fw on br.worker_code = fw.code
where br.sp_code is not null and br.sp_code LIKE 'X%';

\echo "fingerprint_responses.sql - error status(xray) done"

-- success status : doc
insert into fingerprint_responses (
	transaction_id,visitable_type,visitable_id,
    row_count,foreign_worker_id,
    status_code,
    status_message,
    description,
    request_datetime,
    response_datetime,
    created_at,updated_at
) 
select tr.id,'Doctor',doc.id, 
    1, fw.id, 
    'GWY0000',
    'SUCCESS',
    'Finger Print Matched',
    ft.docfp_date,ft.docfp_date,ft.docfp_date,ft.docfp_date
from fomema_backup_nios.fw_transaction ft
left join transactions tr on ft.trans_id = tr.code
left join doctors doc on ft.doctor_code = doc.code
left join foreign_workers fw on ft.worker_code = fw.code
where ft.docfp is not null;

\echo "fingerprint_responses.sql - success status(doc) ended"

-- success status : xray
insert into fingerprint_responses (
	transaction_id,visitable_type,visitable_id,
    row_count,foreign_worker_id,
    status_code,
    status_message,
    description,
    request_datetime,
    response_datetime,
    created_at,updated_at
) 
select tr.id,'XrayFacility',xray.id, 
    1, fw.id, 
    'GWY0000',
    'SUCCESS',
    'Finger Print Matched',
    ft.xrayfp_date,ft.xrayfp_date,ft.xrayfp_date,ft.xrayfp_date
from fomema_backup_nios.fw_transaction ft
left join transactions tr on ft.trans_id = tr.code
left join xray_facilities xray on ft.xray_code = xray.code
left join foreign_workers fw on ft.worker_code = fw.code
where ft.xrayfp is not null;

\echo "fingerprint_responses.sql - success status(xray) ended"

\echo "fingerprint_responses.sql ended"
