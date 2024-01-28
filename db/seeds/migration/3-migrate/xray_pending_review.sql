\echo 'xray_pending_review.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_pending_review.sql') into v_log_id; commit;

	with dp as (
		select *, rank() over (partition by trans_id order by create_date desc, modify_date desc, id desc) as rank
		from fomema_backup_nios.dxpcr_pool
	), xra as (
		select *, rank() over (partition by xqrrid order by approval_date desc) as rank
		from fomema_backup_nios.xquarantine_release_approval
	)
	insert into xray_pending_reviews (
		transaction_id, 
		quarantine_reason, 
		quarantine_type, 
		status, 
		transmitted_at, 
		reviewed_by,
		created_at, 
		updated_at, 
		updated_by, 
		source,
		-- comment, -- NF-1800, xqcc pending review comment can be empty, use find in MLE comment tab
		decision
	)
	select 
		t.id as transaction_id, 
		xqfd.quarantine_reason as quarantine_reason, 
		xqfd.source as quarantine_type,
		case 
			when dp.trans_id is null and d.trans_id is null and xra.xqrreqid is null then 'XQCC_PENDING_REVIEW' 
			else 'TRANSMITTED' 
		end as status,
		case 
			when xqfd.status = 'N' then null 
			else coalesce(xqfd.time_inserted, clock_timestamp()) 
		end as transmitted_at,
		case 
			when xqfd.status = 'N' then null 
			else updator_users.id 
		end as reviewed_by,
		coalesce(xqfd.time_inserted, clock_timestamp()) as created_at, 
		coalesce(xqfd.modification_date, clock_timestamp()) as updated_at, 
		updator_users.id as updated_by, 
		case 
			when xqfd.qrtn_source = 1 then 'MERTS' 
			when xqfd.qrtn_source = 2 then 'MEDICAL' 
			when xqfd.qrtn_source = 3 then 'PCR' 
			when xqfd.qrtn_source = 4 then 'XQCC' 
			else null 
		end as source,
		-- xrr.comments as comment, -- NF-1800, xqcc pending review comment can be empty, use find in MLE comment tab
		case 
			when dp.trans_id is not null then 'PCR_AUDIT'
			when d.trans_id is not null then 'RADIOGRAPHER_REVIEW'
			else null
		end as decision
	from fomema_backup_nios.xqcc_quarantine_fw_doc xqfd join transactions t on xqfd.trans_id = t.code
	left join dp on xqfd.trans_id = dp.trans_id and dp.rank = 1
	left join fomema_backup_nios.dxbasket d on xqfd.trans_id = d.trans_id
	left join fomema_backup_nios.xquarantine_release_request xrr on xrr.trans_id = xqfd.trans_id
	left join xra on xrr.xqrrid = xra.xqrrid and xra.rank = 1
	left join fomema_backup_nios.v_user_master updators on xqfd.modification_id = updators.uuid 
	left join users updator_users on updators.userid = updator_users.code 
	where xqfd.qrtn_source = 1
	order by xqfd.time_inserted;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'xray_pending_review.sql ended'
