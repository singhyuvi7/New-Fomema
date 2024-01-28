\echo "bank_drafts_from_receipt(change_address).sql loaded"

-- reference tranno to track id from migration data
ALTER TABLE bank_drafts ADD COLUMN IF NOT EXISTS reference_tranno varchar;
CREATE INDEX IF NOT EXISTS index_bank_drafts_on_reference_tranno ON bank_drafts (reference_tranno);

-- bank_drafts - change_address(dummy)
DO $$
    DECLARE
        dummy_id bigint;
        v_log_id bigint;
    BEGIN
        select start_migration_log('bank_drafts_from_receipt(change_address).sql') into v_log_id;
        commit;

        SELECT id into dummy_id from doctors where code = 'D123456789';

        insert into bank_drafts (
            number, payerable_id, payerable_type,
            bank_id, issue_date, issue_place,
            amount,amount_allocated,
            bad,
            holded,
            created_at,updated_at,created_by,updated_by,
            organization_id,zone_id,
            sync_date,
            bad_at,
            sync_bad_date,
            gst_amount, comment,
            reference_tranno, from_migration
        ) 
        select rec_detail.payment_no, dummy_id, 'Doctor',
        banks.id, rec_detail.date_issue, rec_detail.branch_area, 
        rec_detail.payment_amount, rec_detail.payment_amount,
        case when rec.status = 'U' then false else true end,
        false, 
        rec.creation_date,rec.modification_date,creator_users.id, updator_users.id,
        org.id, zones.id,
        case when rec.status = 'U' then rec.creation_date + interval '2' day end,
        case when rec.status in ('C','NU') then rec.creation_date + interval '2' day end,
        case when rec.status in ('C','NU') then rec.creation_date + interval '2' day end,
        rec.gst_amount, rec.comments, 
        rec.tranno, true
        from fomema_backup_nios.receipt rec
        join fomema_backup_nios.receipt_detail rec_detail on rec.tranno = rec_detail.tranno
        join banks on rec_detail.bank_code = banks.code
        left join fomema_backup_nios.v_user_master creators on rec.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on rec.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        join organizations org on rec.branch_code = org.code
        join zones on rec_detail.zone_code = zones.code
        where rec.service_type = 'CA' and rec.creation_date >= '2015-04-01';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "bank_drafts_from_receipt(change_address).sql - dummy done"

\echo "bank_drafts_from_receipt(change_address).sql ended"
