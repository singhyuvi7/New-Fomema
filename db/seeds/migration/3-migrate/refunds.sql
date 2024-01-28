


\echo "refunds.sql loaded"

DO $$
    DECLARE
        pm_id bigint;
        v_log_id bigint;
    BEGIN
        select start_migration_log('refunds.sql') into v_log_id;
        commit;

        SELECT id into pm_id from payment_methods where code = 'OUT_GIRONEWIC';

        -- those with approval
        insert into refunds (
            code,customerable_id,customerable_type,
            payment_method_id,category,
            date,amount,
            status,
            comment,
            request_by,request_at,
            approval_decision,
            approval_comment,approval_by,approval_at,
            created_at,updated_at,created_by,updated_by,
            organization_id,fail_reason,
            payment_date,reference,unutilised,
            sync_date
        )
        select
        pr.id::varchar, emp.id, 'Employer', 
        pm_id, 'MANUAL', 
        pr.creation_date, pr.amount, 
        case when pr.status = 1 then 'NEW' 
        when pr.status = 2 then 'PAYMENT_SUCCESS' 
        when pr.status = 3 then 'REJECTED' 
        when pr.status = 4 then 'CANCELLED' 
        when pr.status = 5 then 'PAYMENT_SUCCESS' 
        when pr.status = 6 then 'PAYMENT_SUCCESS' 
        when pr.status = 7 then 'PAYMENT_FAILED' end,
        pr.comments, 
        creator_users.id, pr.creation_date,
        case when pra.approve_status = 'A' then 'APPROVE' when pra.approve_status = 'R' then 'REJECT' end,
        pra.comments,approval_users.id, pra.modification_date,
        pr.creation_date,pr.modification_date,creator_users.id, updator_users.id,
        org.id, case when pra.approve_status = 'R' then pra.comments end,
        pr.payment_date, pr.reference_no, true, 
        case when pr.status not in (1,3,4) then pr.modification_date end
        from fomema_backup_nios.payment_refund pr
        join employers emp on pr.employer_code = emp.code
        join fomema_backup_nios.payment_refund_approval pra on pr.id = pra.refund_id
        left join fomema_backup_nios.v_user_master creators on pr.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on pr.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        left join fomema_backup_nios.v_user_master approval on pra.modify_id = approval.uuid 
        left join users approval_users on approval.userid = approval_users.code
        join organizations org on pr.branch_code = org.code
        where pr.refund_type = 3 and pr.status not in (1,4) and pra.id = (select max(id) from fomema_backup_nios.payment_refund_approval where refund_id = pr.id);

        -- those not in approval
        insert into refunds (
            code,customerable_id,customerable_type,
            payment_method_id,category,
            date,amount,
            status,
            comment,
            request_by,request_at,
            created_at,updated_at,created_by,updated_by,
            organization_id,
            payment_date,reference,unutilised
        )
        select
        pr.id::varchar, emp.id, 'Employer', 
        pm_id, 'MANUAL', 
        pr.creation_date, pr.amount, 
        case when pr.status = 1 then 'NEW' 
        when pr.status = 2 then 'PAYMENT_SUCCESS' 
        when pr.status = 3 then 'REJECTED' 
        when pr.status = 4 then 'CANCELLED' 
        when pr.status = 5 then 'PAYMENT_SUCCESS' 
        when pr.status = 6 then 'PAYMENT_SUCCESS' 
        when pr.status = 7 then 'PAYMENT_FAILED' end,
        pr.comments, 
        creator_users.id, pr.creation_date,
        pr.creation_date,pr.modification_date,creator_users.id, updator_users.id,
        org.id,
        pr.creation_date, pr.reference_no, true
        from fomema_backup_nios.payment_refund pr
        join employers emp on pr.employer_code = emp.code
        left join fomema_backup_nios.v_user_master creators on pr.creator_id = creators.uuid 
        left join users creator_users on creators.userid = creator_users.code 
        left join fomema_backup_nios.v_user_master updators on pr.modify_id = updators.uuid 
        left join users updator_users on updators.userid = updator_users.code
        join organizations org on pr.branch_code = org.code
        where pr.refund_type = 3 and pr.status in (1,4);

        perform end_migration_log(v_log_id);
    END
$$;

\echo "refunds.sql ended"
