\echo "bank_drafts_from_draft_master.sql loaded"

-- reference id to track id from migration data
ALTER TABLE bank_drafts ADD COLUMN IF NOT EXISTS master_reference_id bigint;
CREATE INDEX IF NOT EXISTS index_bank_drafts_on_master_reference_id ON bank_drafts (master_reference_id);

ALTER TABLE bank_drafts ADD COLUMN IF NOT EXISTS reference_id bigint;
CREATE INDEX IF NOT EXISTS index_bank_drafts_on_reference_id ON bank_drafts (reference_id);

-- bank_drafts
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bank_drafts_from_draft_master.sql - bank drafts') into v_log_id;
        commit;

        insert into bank_drafts (
            number,payerable_id,payerable_type,bank_id,
            issue_date,issue_place,amount,amount_allocated,
            bad,
            holded,
            created_at,updated_at,created_by,updated_by,
            organization_id,zone_id,
            sync_date,sync_cancel_status,
            bad_at,sync_bad_date,
            process_fee,additional_fee_charge,
            gst_amount,gst_percentage,additional_gst_charge,
            comment,
            master_reference_id, reference_id, from_migration
        ) 
        select dm.payment_no, em.id, 'Employer', banks.id,
        dm.date_issue, dm.bank_area, da.allocation_amount, da.allocation_amount,
        case when dm.status in (0,2,3,4,8) then true else false end,
        case when dm.status = 7 then true else false end,
        da.creation_date,dm.modification_date,creator_users.id, updator_users.id,
        org.id, zones.id, 
        dm.collection_date, dm.collection_cn_status, 
        dm.voided_date, dm.voided_date,
        da.process_fee, dm.other_amount, 
        da.gst_amount, dm.gst_percentage, dm.other_amount_gst, 
        case when dm.comments is null then dm.voided_reason else dm.comments end,
        dm.id, da.id, true
        from fomema_backup_nios.draft_allocation da
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id
        join employers em on da.employer_code = em.code
        join banks on dm.bank_code = banks.code
        left join organizations org on dm.branch_code = org.code
        join zones on dm.zone_code = zones.code
        left join fomema_backup_nios.v_user_master creators on da.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on dm.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where dm.payment_type = 4 and dm.status not in (2,4) and (dm.comments not like '%Receipt Migration%' or dm.comments is null);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "bank_drafts_from_draft_master.sql - normal drafts (employer) done"

-- status 2 (Bad Draft) which replace by 5 (Replacement Cheque)
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bank_drafts_from_draft_master.sql - bad draft with replacement') into v_log_id;
        commit;

        insert into bank_drafts (
            number,payerable_id,payerable_type,bank_id,
            issue_date,issue_place,amount,amount_allocated,
            bad,
            holded,
            created_at,updated_at,created_by,updated_by,
            organization_id,zone_id,
            sync_date,sync_cancel_status,
            bad_at,sync_bad_date,
            process_fee,additional_fee_charge,
            gst_amount,gst_percentage,additional_gst_charge,
            comment,
            master_reference_id, reference_id, from_migration
        )
        select dm_replacement.payment_no, em.id, 'Employer', banks.id,
        dm_replacement.date_issue, dm_replacement.bank_area, da.allocation_amount, da.allocation_amount,
        case when dm_replacement.status in (3,8) then true else false end,
        case when dm_replacement.status = 7 then true else false end,
        da.creation_date,dm_replacement.modification_date,creator_users.id, updator_users.id,
        org.id, zones.id, 
        dm_replacement.collection_date, dm_replacement.collection_cn_status, 
        dm_replacement.voided_date, dm_replacement.voided_date,
        da.process_fee, dm_replacement.other_amount, 
        da.gst_amount, dm_replacement.gst_percentage, dm_replacement.other_amount_gst, 
        case when dm_replacement.comments is null then dm_replacement.voided_reason else dm_replacement.comments end,
        dm_replacement.id, da.id, true
        from fomema_backup_nios.draft_allocation da
        join fomema_backup_nios.draft_master dm on da.draft_master_id = dm.id
        join fomema_backup_nios.draft_master dm_replacement on dm.id = dm_replacement.replacement_draft_id
        join employers em on da.employer_code = em.code
        join banks on dm_replacement.bank_code = banks.code
        left join organizations org on dm_replacement.branch_code = org.code
        join zones on dm_replacement.zone_code = zones.code
        left join fomema_backup_nios.v_user_master creators on da.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on dm_replacement.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        where dm.payment_type = 4 and dm.status in (2) and (dm.comments not like '%Receipt Migration%' or dm.comments is null);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "bank_drafts_from_draft_master.sql - draft with status [2,5] (employer) done"

\echo "bank_drafts_from_draft_master.sql ended"
