\echo 'xray_pending_decision.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('xray_pending_decision.sql') into v_log_id; commit;

	insert into xray_pending_decisions (
		transaction_id, 
		status,
		decision,
		comment,
		reviewed_at,
		reviewed_by,
		created_by,
		created_at,
		updated_by,
		updated_at,
		approval_decision,
		approval_comment,
		approval_by,
		transmitted_at,
		condition_hiv,
		condition_tuberculosis,
		condition_malaria,
		condition_leprosy,
		condition_std,
		condition_hepatitis,
		condition_cancer,
		condition_epilepsy,
		condition_psychiatric_disorder,
		condition_other,
		condition_urine_for_pregnant,
		condition_urine_for_opiates,
		condition_urine_for_cannabis,
		condition_hypertension,
		condition_heart_diseases,
		condition_bronchial_asthma,
		condition_diabetes_mellitus,
		condition_peptic_ulcer,
		condition_kidney_diseases
	)
	select 
		t.id as transaction_id,
		/* xqfd.status */ case 
			when xqfd.status = 'N' then 'XQCC_PENDING_DECISION' 
			when xqfd.status = 'S' then 
				case 
					when xrr.status in ('A', 'R') then 'TRANSMITTED'
					else 'XQCC_PENDING_DECISION_APPROVAL'
				end
			when xqfd.status in ('A', 'R') then 'TRANSMITTED' 
			else null 
		end as status,
		/* xqfd.inspstatus */ case 
			when xqfd.status = 'N' then null 
			when xqfd.inspstatus = 'Y' then 'UNSUITABLE' 
			when xqfd.inspstatus = 'N' then 'SUITABLE' 
			else null 
		end as decision,
		xrr.comments as comment,
		coalesce(xrr.creation_date, clock_timestamp()) as reviewed_at,
		/* xrr.request_by */ creator_users.id as reviewed_by,
		/* xrr.request_by */ creator_users.id as created_by,
		coalesce(xqfd.time_inserted, clock_timestamp()) as created_at,
		/* xqfd.modification_id */ updator_users.id as updated_by,
		coalesce(xqfd.modification_date, clock_timestamp()) as updated_at,
		case when xra.status = 'A' then 'APPROVE' when xra.status = 'R' then 'REJECT' else null end approval_decision,
		xra.comments as approval_comment,
		/* xra.approval_id */ approval_users.id as approval_by,
		case when xqfd.status in ('A', 'R') then xra.approval_date else null end as transmitted_at,
		case when qif.d6_hiv = 'Y' then 'YES' when qif.d6_hiv = 'N' then 'NO' else null end as condition_hiv,
		case when qif.d6_tb = 'Y' then 'YES' when qif.d6_tb = 'N' then 'NO' else null end as condition_tuberculosis,
		case when qif.d6_malaria = 'Y' then 'YES' when qif.d6_malaria = 'N' then 'NO' else null end as condition_malaria,
		case when qif.d6_leprosy = 'Y' then 'YES' when qif.d6_leprosy = 'N' then 'NO' else null end as condition_leprosy,
		case when qif.d6_std = 'Y' then 'YES' when qif.d6_std = 'N' then 'NO' else null end as condition_std,
		case when qif.d6_hepatitis = 'Y' then 'YES' when qif.d6_hepatitis = 'N' then 'NO' else null end as condition_hepatitis,
		case when qif.d6_cancer = 'Y' then 'YES' when qif.d6_cancer = 'N' then 'NO' else null end as condition_cancer,
		case when qif.d6_epilepsy = 'Y' then 'YES' when qif.d6_epilepsy = 'N' then 'NO' else null end as condition_epilepsy,
		case when qif.d6_psych = 'Y' then 'YES' when qif.d6_psych = 'N' then 'NO' else null end as condition_psychiatric_disorder,
		case when qif.d6_others = 'Y' then 'YES' when qif.d6_others = 'N' then 'NO' else null end as condition_other,
		case when qif.d6_pregnant = 'Y' then 'YES' when qif.d6_pregnant = 'N' then 'NO' else null end as condition_urine_for_pregnant,
		case when qif.d6_opiates = 'Y' then 'YES' when qif.d6_opiates = 'N' then 'NO' else null end as condition_urine_for_opiates,
		case when qif.d6_cannabis = 'Y' then 'YES' when qif.d6_cannabis = 'N' then 'NO' else null end as condition_urine_for_cannabis,
		case when qif.d6_hypertension = 'Y' then 'YES' when qif.d6_hypertension = 'N' then 'NO' else null end as condition_hypertension,
		case when qif.d6_heart_diseases = 'Y' then 'YES' when qif.d6_heart_diseases = 'N' then 'NO' else null end as condition_heart_diseases,
		case when qif.d6_asthma = 'Y' then 'YES' when qif.d6_asthma = 'N' then 'NO' else null end as condition_bronchial_asthma,
		case when qif.d6_diabetes = 'Y' then 'YES' when qif.d6_diabetes = 'N' then 'NO' else null end as condition_diabetes_mellitus,
		case when qif.d6_ulcer = 'Y' then 'YES' when qif.d6_ulcer = 'N' then 'NO' else null end as condition_peptic_ulcer,
		case when qif.d6_kidney = 'Y' then 'YES' when qif.d6_kidney = 'N' then 'NO' else null end as condition_kidney_diseases
	from fomema_backup_nios.xqcc_quarantine_fw_doc xqfd join transactions t on xqfd.trans_id = t.code 
	left join fomema_backup_nios.xquarantine_release_request xrr on xqfd.trans_id = xrr.trans_id 
	left join fomema_backup_nios.xquarantine_release_approval xra on xrr.xqrrid = xra.xqrrid 
	left join fomema_backup_nios.dxpcr_audit_film daf on daf.trans_id = xqfd.trans_id 
	left join fomema_backup_nios.v_user_master creators on xrr.request_by = creators.uuid 
	left join users creator_users on creators.userid = creator_users.code 
	left join fomema_backup_nios.v_user_master updators on xqfd.modification_id = updators.uuid 
	left join users updator_users on updators.userid = updator_users.code 
	left join fomema_backup_nios.v_user_master approvors on xra.approval_id = approvors.uuid 
	left join users approval_users on approvors.userid = approval_users.code
	left join fomema_backup_nios.quarantine_insp_findings qif on xqfd.trans_id = qif.trans_id
	where (xqfd.qrtn_source != 1 or xqfd.qrtn_source is null) or (xqfd.qrtn_source = 1 and daf.id is not null) or (xrr.xqrrid is not null)
	order by xqfd.time_inserted
	;

	with tbl as (
		select 
			t.id as transaction_id,
			/* xqfd.status */ case 
				when xqfd.status = 'N' then 'XQCC_PENDING_DECISION' 
				when xqfd.status = 'S' then 
					case 
						when xrr.status in ('A', 'R') then 'TRANSMITTED'
						else 'XQCC_PENDING_DECISION_APPROVAL'
					end
				when xqfd.status in ('A', 'R') then 'TRANSMITTED' 
				else null 
			end as status,
			/* xqfd.inspstatus */ case 
				when xqfd.status = 'N' then null 
				when xqfd.inspstatus = 'Y' then 'UNSUITABLE' 
				when xqfd.inspstatus = 'N' then 'SUITABLE' 
				else null 
			end as decision,
			xrr.comments as comment,
			coalesce(xrr.creation_date, clock_timestamp()) as reviewed_at,
			/* xrr.request_by */ creator_users.id as reviewed_by,
			/* xrr.request_by */ creator_users.id as created_by,
			coalesce(xqfd.time_inserted, clock_timestamp()) as created_at,
			/* xqfd.modification_id */ updator_users.id as updated_by,
			coalesce(xqfd.modification_date, clock_timestamp()) as updated_at,
			case when xra.status = 'A' then 'APPROVE' when xra.status = 'R' then 'REJECT' else null end approval_decision,
			xra.comments as approval_comment,
			/* xra.approval_id */ approval_users.id as approval_by,
			case when xqfd.status in ('A', 'R') then xra.approval_date else null end as transmitted_at,
			case when qif.d6_hiv = 'Y' then 'YES' when qif.d6_hiv = 'N' then 'NO' else null end as condition_hiv,
			case when qif.d6_tb = 'Y' then 'YES' when qif.d6_tb = 'N' then 'NO' else null end as condition_tuberculosis,
			case when qif.d6_malaria = 'Y' then 'YES' when qif.d6_malaria = 'N' then 'NO' else null end as condition_malaria,
			case when qif.d6_leprosy = 'Y' then 'YES' when qif.d6_leprosy = 'N' then 'NO' else null end as condition_leprosy,
			case when qif.d6_std = 'Y' then 'YES' when qif.d6_std = 'N' then 'NO' else null end as condition_std,
			case when qif.d6_hepatitis = 'Y' then 'YES' when qif.d6_hepatitis = 'N' then 'NO' else null end as condition_hepatitis,
			case when qif.d6_cancer = 'Y' then 'YES' when qif.d6_cancer = 'N' then 'NO' else null end as condition_cancer,
			case when qif.d6_epilepsy = 'Y' then 'YES' when qif.d6_epilepsy = 'N' then 'NO' else null end as condition_epilepsy,
			case when qif.d6_psych = 'Y' then 'YES' when qif.d6_psych = 'N' then 'NO' else null end as condition_psychiatric_disorder,
			case when qif.d6_others = 'Y' then 'YES' when qif.d6_others = 'N' then 'NO' else null end as condition_other,
			case when qif.d6_pregnant = 'Y' then 'YES' when qif.d6_pregnant = 'N' then 'NO' else null end as condition_urine_for_pregnant,
			case when qif.d6_opiates = 'Y' then 'YES' when qif.d6_opiates = 'N' then 'NO' else null end as condition_urine_for_opiates,
			case when qif.d6_cannabis = 'Y' then 'YES' when qif.d6_cannabis = 'N' then 'NO' else null end as condition_urine_for_cannabis,
			case when qif.d6_hypertension = 'Y' then 'YES' when qif.d6_hypertension = 'N' then 'NO' else null end as condition_hypertension,
			case when qif.d6_heart_diseases = 'Y' then 'YES' when qif.d6_heart_diseases = 'N' then 'NO' else null end as condition_heart_diseases,
			case when qif.d6_asthma = 'Y' then 'YES' when qif.d6_asthma = 'N' then 'NO' else null end as condition_bronchial_asthma,
			case when qif.d6_diabetes = 'Y' then 'YES' when qif.d6_diabetes = 'N' then 'NO' else null end as condition_diabetes_mellitus,
			case when qif.d6_ulcer = 'Y' then 'YES' when qif.d6_ulcer = 'N' then 'NO' else null end as condition_peptic_ulcer,
			case when qif.d6_kidney = 'Y' then 'YES' when qif.d6_kidney = 'N' then 'NO' else null end as condition_kidney_diseases,
			string_agg(xra.status, ', ') over (partition by xrr.trans_id) as xra_status_join,
			count(xrr.xqrrid) over (partition by xrr.trans_id) as xqrrid_count,
			xrr.trans_id,
			xpd.id as xray_pending_decision_id,
			xpd.updated_by as xray_pending_decision_updated_by,
			xpd.updated_at as xray_pending_decision_updated_at
		from fomema_backup_nios.xqcc_quarantine_fw_doc xqfd join transactions t on xqfd.trans_id = t.code 
		left join fomema_backup_nios.xquarantine_release_request xrr on xqfd.trans_id = xrr.trans_id 
		left join fomema_backup_nios.xquarantine_release_approval xra on xrr.xqrrid = xra.xqrrid 
		left join fomema_backup_nios.dxpcr_audit_film daf on daf.trans_id = xqfd.trans_id 
		left join fomema_backup_nios.v_user_master creators on xrr.request_by = creators.uuid 
		left join users creator_users on creators.userid = creator_users.code 
		left join fomema_backup_nios.v_user_master updators on xqfd.modification_id = updators.uuid 
		left join users updator_users on updators.userid = updator_users.code 
		left join fomema_backup_nios.v_user_master approvors on xra.approval_id = approvors.uuid 
		left join users approval_users on approvors.userid = approval_users.code
		left join fomema_backup_nios.quarantine_insp_findings qif on xqfd.trans_id = qif.trans_id
		left join xray_pending_decisions xpd on xpd.transaction_id = t.id and xpd.created_at = xqfd.time_inserted
		where (
			(xqfd.qrtn_source != 1 or xqfd.qrtn_source is null) 
			or (xqfd.qrtn_source = 1 and daf.id is not null) 
			or (xrr.xqrrid is not null)
		)
		and xra.xqrrid is not null
		order by xqfd.trans_id, xqfd.time_inserted
	)
	insert into xray_pending_decisions (
		transaction_id, 
		status,
		decision,
		comment,
		reviewed_at,
		reviewed_by,
		created_by,
		created_at,
		updated_by,
		updated_at,
		approval_decision,
		approval_comment,
		approval_by,
		transmitted_at,
		condition_hiv,
		condition_tuberculosis,
		condition_malaria,
		condition_leprosy,
		condition_std,
		condition_hepatitis,
		condition_cancer,
		condition_epilepsy,
		condition_psychiatric_disorder,
		condition_other,
		condition_urine_for_pregnant,
		condition_urine_for_opiates,
		condition_urine_for_cannabis,
		condition_hypertension,
		condition_heart_diseases,
		condition_bronchial_asthma,
		condition_diabetes_mellitus,
		condition_peptic_ulcer,
		condition_kidney_diseases,
		sourceable_type,
		sourceable_id
	)
	select 
		transaction_id, 
		'XQCC_PENDING_DECISION' as status,
		null as decision,
		null as comment,
		null as reviewed_at,
		null as  reviewed_by,
		xray_pending_decision_updated_by as created_by,
		xray_pending_decision_updated_at as created_at,
		xray_pending_decision_updated_by as updated_by,
		xray_pending_decision_updated_at as updated_at,
		null as approval_decision,
		null as approval_comment,
		null as approval_by,
		null as transmitted_at,
		condition_hiv,
		condition_tuberculosis,
		condition_malaria,
		condition_leprosy,
		condition_std,
		condition_hepatitis,
		condition_cancer,
		condition_epilepsy,
		condition_psychiatric_disorder,
		condition_other,
		condition_urine_for_pregnant,
		condition_urine_for_opiates,
		condition_urine_for_cannabis,
		condition_hypertension,
		condition_heart_diseases,
		condition_bronchial_asthma,
		condition_diabetes_mellitus,
		condition_peptic_ulcer,
		condition_kidney_diseases,
		'XrayPendingDecision' as sourceable_type,
		xray_pending_decision_id as sourceable_id
	from tbl where xqrrid_count = 1 and xra_status_join = 'R'
	;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'xray_pending_decision.sql ended'
