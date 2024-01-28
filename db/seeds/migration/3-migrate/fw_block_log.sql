\echo 'fw_block_log loaded'

do $$
declare
    v_log_id bigint;
    v_block_other_id bigint;
    v_unblock_other_id bigint;
begin
    select start_migration_log('fw_block_log') into v_log_id; commit;

    drop view if exists v_fw_block;
    create or replace view v_fw_block as
    select fb.fw_block_id, fb.worker_code, fb.status, fw.id as foreign_worker_id, 
    fb.creator_id, fb.created_date, fb.request_comment, creator_users.id as block_requested_by,
    fb.approved_by, fb.approved_date, fb.approved_comment, approvor_users.id as block_approval_by,
    fb.unblock_requestby, fb.unblock_requestdate, fb.unblock_request_comment, unblock_creator_users.id as unblock_requested_by,
    fb.unblocked_by, fb.unblocked_date, fb.unblocked_comment, unblock_approvor_users.id as unblock_approval_by
    from fomema_backup_nios.fw_block fb join foreign_workers fw on fb.worker_code = fw.code
    left join fomema_backup_nios.v_user_master creators on fb.creator_id = creators.uuid
    left join users creator_users on creators.userid = creator_users.code
    left join fomema_backup_nios.v_user_master approvors on fb.approved_by = approvors.uuid
    left join users approvor_users on approvors.userid = approvor_users.code
    left join fomema_backup_nios.v_user_master unblock_creators on fb.unblock_requestby = unblock_creators.uuid
    left join users unblock_creator_users on unblock_creators.userid = unblock_creator_users.code
    left join fomema_backup_nios.v_user_master unblock_approvors on fb.unblocked_by = unblock_approvors.uuid
    left join users unblock_approvor_users on unblock_approvors.userid = unblock_approvor_users.code;

    select id into v_block_other_id from block_reasons where category = 'BLOCK' and code = 'OTHER';
    select id into v_unblock_other_id from block_reasons where category = 'UNBLOCK' and code = 'OTHER';

    -- fomema_backup_nios.fw_block.status = '1' -- PENDING
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at
    )
    select
        vfb.block_requested_by as request_user_id,
        0 as state,
        vfb.created_date as requested_at,
        'BLOCK_FOREIGN_WORKER' as category,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    where vfb.status = '1'
    order by vfb.created_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
block_reason_id: '||v_block_other_id||'
block_comment: "'||regexp_replace(vfb.request_comment, E'\r\n', '\r\n')||'"
blocked: true
blocked_at: '||to_char(vfb.created_date, 'YYYY-MM-DD HH24:MI:SS')||'
blocked_by: '||vfb.block_requested_by as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '1' 
    and ar.state = 0 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '1' 
    and ar.state = 0 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'BLOCK' as action,
        vfb.request_comment as comment,
        vfb.block_requested_by as requested_by,
        vfb.created_date as requested_at,
        v_block_other_id as block_reason_id,
        vfb.block_requested_by as created_by,
        vfb.created_date as created_at,
        vfb.created_date as updated_at,
        vfb.block_requested_by as updated_by
    from v_fw_block vfb
    where vfb.status = '1'
    order by vfb.created_date;

    -- fomema_backup_nios.fw_block.status = '2' -- APPROVE
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        approved_at,
        executed_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.block_requested_by as request_user_id,
        4 as state,
        vfb.created_date as requested_at,
        'BLOCK_FOREIGN_WORKER' as category,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.approved_date as approved_at,
        vfb.approved_date as executed_at,
        'APPROVE' as approval_decision,
        vfb.approved_date as approval_at,
        vfb.block_approval_by as respond_user_id,
        vfb.block_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '2'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
block_reason_id: '||v_block_other_id||'
block_comment: '||regexp_replace(vfb.request_comment, E'\r\n', '\r\n')||'
blocked: true
blocked_at: '||to_char(vfb.created_date, 'YYYY-MM-DD HH24:MI:SS')||'
blocked_by: '||vfb.block_requested_by as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '2' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '2' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_approval_by as user_id,
        vfb.approved_comment as content,
        vfb.approved_date as created_at,
        vfb.approved_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '2' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'BLOCK' as action,
        vfb.request_comment as comment,
        vfb.block_requested_by as requested_by,
        vfb.created_date as requested_at,
        v_block_other_id as block_reason_id,
        vfb.block_requested_by as created_by,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.block_approval_by as updated_by,
        vfb.block_approval_by as approval_by,
        vfb.approved_date as approval_at,
        vfb.approved_comment as approval_comment,
        'APPROVE' as approval_decision
    from v_fw_block vfb
    where vfb.status = '2'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- fomema_backup_nios.fw_block.status = '3' -- REJECT
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        rejected_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.block_requested_by as request_user_id,
        3 as state,
        vfb.created_date as requested_at,
        'BLOCK_FOREIGN_WORKER' as category,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.approved_date as rejected_at,
        'REJECT' as approval_decision,
        vfb.approved_date as approval_at,
        vfb.block_approval_by as respond_user_id,
        vfb.block_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '3'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
block_reason_id: '||v_block_other_id||'
block_comment: '||regexp_replace(vfb.request_comment, E'\r\n', '\r\n')||'
blocked: true
blocked_at: '||to_char(vfb.created_date, 'YYYY-MM-DD HH24:MI:SS')||'
blocked_by: '||vfb.block_requested_by as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '3' 
    and ar.state = 3 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '3' 
    and ar.state = 3 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_approval_by as user_id,
        vfb.approved_comment as content,
        vfb.approved_date as created_at,
        vfb.approved_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '3' 
    and ar.state = 3 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'BLOCK' as action,
        vfb.request_comment as comment,
        vfb.block_requested_by as requested_by,
        vfb.created_date as requested_at,
        v_block_other_id as block_reason_id,
        vfb.block_requested_by as created_by,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.block_approval_by as updated_by,
        vfb.block_approval_by as approval_by,
        vfb.approved_date as approval_at,
        vfb.approved_comment as approval_comment,
        'REJECT' as approval_decision
    from v_fw_block vfb
    where vfb.status = '3'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- fomema_backup_nios.fw_block.status = '4' -- UNBLOCKED
    -- UNBLOCKED # block-approved
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        approved_at,
        executed_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.block_requested_by as request_user_id,
        4 as state,
        vfb.created_date as requested_at,
        'BLOCK_FOREIGN_WORKER' as category,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.approved_date as approved_at,
        vfb.approved_date as executed_at,
        'APPROVE' as approval_decision,
        vfb.approved_date as approval_at,
        vfb.block_approval_by as respond_user_id,
        vfb.block_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '4'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
block_reason_id: '||v_block_other_id||'
block_comment: '||regexp_replace(vfb.request_comment, E'\r\n', '\r\n')||'
blocked: true
blocked_at: '||to_char(vfb.created_date, 'YYYY-MM-DD HH24:MI:SS')||'
blocked_by: '||vfb.block_requested_by as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- UNBLOCKED # block-approved-request-comment
    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- UNBLOCKED # block-approved-approval-comment
    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_approval_by as user_id,
        vfb.approved_comment as content,
        vfb.approved_date as created_at,
        vfb.approved_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'BLOCK' as action,
        vfb.request_comment as comment,
        vfb.block_requested_by as requested_by,
        vfb.created_date as requested_at,
        v_block_other_id as block_reason_id,
        vfb.block_requested_by as created_by,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.block_approval_by as updated_by,
        vfb.block_approval_by as approval_by,
        vfb.approved_date as approval_at,
        vfb.approved_comment as approval_comment,
        'APPROVE' as approval_decision
    from v_fw_block vfb
    where vfb.status = '4'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- UNBLOCKED # unblock-approved
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        approved_at,
        executed_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.unblock_requested_by as request_user_id,
        4 as state,
        vfb.unblock_requestdate as requested_at,
        'UNBLOCK_FOREIGN_WORKER' as category,
        vfb.unblock_requestdate as created_at,
        vfb.unblocked_date as updated_at,
        vfb.unblocked_date as approved_at,
        vfb.unblocked_date as executed_at,
        'APPROVE' as approval_decision,
        vfb.unblocked_date as approval_at,
        vfb.unblock_approval_by as respond_user_id,
        vfb.unblock_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '4'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
unblock_reason_id: '||v_block_other_id||'
unblock_comment: '||regexp_replace(vfb.unblock_request_comment, E'\r\n', '\r\n')||'
blocked: false' as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- UNBLOCKED # unblock-approved-request-comment
    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- UNBLOCKED # unblock-approved-approval-comment
    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.unblocked_by as user_id,
        vfb.unblocked_comment as content,
        vfb.unblocked_date as created_at,
        vfb.unblocked_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '4' 
    and ar.state = 4 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'UNBLOCK' as action,
        vfb.unblock_request_comment as comment,
        vfb.unblock_requested_by as requested_by,
        vfb.unblock_requestdate as requested_at,
        v_unblock_other_id as block_reason_id,
        vfb.unblock_requested_by as created_by,
        vfb.unblock_requestdate as created_at,
        vfb.unblocked_date as updated_at,
        vfb.unblock_approval_by as updated_by,
        vfb.unblock_approval_by as approval_by,
        vfb.unblocked_date as approval_at,
        vfb.unblocked_comment as approval_comment,
        'APPROVE' as approval_decision
    from v_fw_block vfb
    where vfb.status = '4'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- fomema_backup_nios.fw_block.status = '6' -- REJECT_UNBLOCKED
    -- block-approved
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        approved_at,
        executed_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.block_requested_by as request_user_id,
        4 as state,
        vfb.created_date as requested_at,
        'BLOCK_FOREIGN_WORKER' as category,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.approved_date as approved_at,
        vfb.approved_date as executed_at,
        'APPROVE' as approval_decision,
        vfb.approved_date as approval_at,
        vfb.block_approval_by as respond_user_id,
        vfb.block_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '6'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
block_reason_id: '||v_block_other_id||'
block_comment: '||regexp_replace(vfb.request_comment, E'\r\n', '\r\n')||'
blocked: true
blocked_at: '||to_char(vfb.created_date, 'YYYY-MM-DD HH24:MI:SS')||'
blocked_by: '||vfb.block_requested_by as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '6' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '6' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_approval_by as user_id,
        vfb.approved_comment as content,
        vfb.approved_date as created_at,
        vfb.approved_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.created_date = ar.created_at and vfb.status = '6' 
    and ar.state = 4 and ar.category = 'BLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'BLOCK' as action,
        vfb.request_comment as comment,
        vfb.block_requested_by as requested_by,
        vfb.created_date as requested_at,
        v_block_other_id as block_reason_id,
        vfb.block_requested_by as created_by,
        vfb.created_date as created_at,
        vfb.approved_date as updated_at,
        vfb.block_approval_by as updated_by,
        vfb.block_approval_by as approval_by,
        vfb.approved_date as approval_at,
        vfb.approved_comment as approval_comment,
        'APPROVE' as approval_decision
    from v_fw_block vfb
    where vfb.status = '6'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- unblock-rejected
    insert into approval_requests (
        request_user_id,
        state,
        requested_at,
        category,
        created_at,
        updated_at,
        rejected_at,
        approval_decision,
        approval_at,
        respond_user_id,
        approval_user_id
    )
    select
        vfb.unblock_requested_by as request_user_id,
        3 as state,
        vfb.unblock_requestdate as requested_at,
        'UNBLOCK_FOREIGN_WORKER' as category,
        vfb.unblock_requestdate as created_at,
        vfb.unblocked_date as updated_at,
        vfb.unblocked_date as rejected_at,
        'REJECT' as approval_decision,
        vfb.unblocked_date as approval_at,
        vfb.unblock_approval_by as respond_user_id,
        vfb.unblock_approval_by as approval_user_id
    from v_fw_block vfb
    where vfb.status = '6'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_items (
        request_id,
        resource_id,
        resource_type,
        event,
        params,
        created_at,
        updated_at
    )
    select
        ar.id as request_id,
        vfb.foreign_worker_id as resource_id,
        'ForeignWorker' as resource_type,
        'update' as event,
        '---
unblock_reason_id: '||v_block_other_id||'
unblock_comment: '||regexp_replace(vfb.unblock_request_comment, E'\r\n', '\r\n')||'
blocked: false' as params,
        ar.created_at as created_at,
        ar.updated_at as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '6' 
    and ar.state = 3 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.block_requested_by as user_id,
        vfb.request_comment as content,
        vfb.created_date as created_at,
        vfb.created_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '6' 
    and ar.state = 3 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    insert into approval_comments (
        request_id,
        user_id,
        content,
        created_at,
        updated_at
    )
    select 
        ar.id as request_id,
        vfb.unblocked_by as user_id,
        vfb.unblocked_comment as content,
        vfb.unblocked_date as created_at,
        vfb.unblocked_date as updated_at
    from v_fw_block vfb
    join approval_requests ar on vfb.unblock_requestdate = ar.created_at and vfb.status = '6' 
    and ar.state = 3 and ar.category = 'UNBLOCK_FOREIGN_WORKER'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- unblock log
    insert into fw_block_logs (
        foreign_worker_id,
        action,
        comment,
        requested_by,
        requested_at,
        block_reason_id,
        created_by,
        created_at,
        updated_at,
        updated_by,
        approval_by,
        approval_at,
        approval_comment,
        approval_decision
    )
    select
        vfb.foreign_worker_id as foreign_worker_id,
        'UNBLOCK' as action,
        vfb.unblock_request_comment as comment,
        vfb.unblock_requested_by as requested_by,
        vfb.unblock_requestdate as requested_at,
        v_unblock_other_id as block_reason_id,
        vfb.unblock_requested_by as created_by,
        vfb.unblock_requestdate as created_at,
        vfb.unblocked_date as updated_at,
        vfb.unblock_approval_by as updated_by,
        vfb.unblock_approval_by as approval_by,
        vfb.unblocked_date as approval_at,
        vfb.unblocked_comment as approval_comment,
        'REJECT' as approval_decision
    from v_fw_block vfb
    where vfb.status = '6'
    order by vfb.created_date, vfb.approved_date, vfb.unblock_requestdate, vfb.unblocked_date;

    -- fomema_backup_nios.fw_block.status = '5' -- PENDING_UNBLOCKED -- no record

    update foreign_workers set approval_status = 'UPDATE_PENDING_APPROVAL'
    from v_fw_block vfb
    where foreign_workers.id = vfb.foreign_worker_id and vfb.status = '1';

    with block_tbl as (
        select 
            foreign_worker_id, 
            comment as block_comment, 
            block_reason_id, 
            requested_at as blocked_at, 
            requested_by as blocked_by,
            rank() over (partition by foreign_worker_id order by requested_at desc) as rank
        from fw_block_logs where action = 'BLOCK'
    )
    update foreign_workers set 
        block_reason_id = block_tbl.block_reason_id, 
        block_comment = block_tbl.block_comment, 
        blocked_at = block_tbl.blocked_at, 
        blocked_by = block_tbl.blocked_by
    from block_tbl
    where foreign_workers.id = block_tbl.foreign_worker_id and block_tbl.rank = 1;

    with unblock_tbl as (
        select 
            foreign_worker_id, 
            comment as unblock_comment, 
            block_reason_id as unblock_reason_id, 
            rank() over (partition by foreign_worker_id order by requested_at desc) as rank
        from fw_block_logs where action = 'UNBLOCK'
    )
    update foreign_workers set 
        unblock_reason_id = unblock_tbl.unblock_reason_id, 
        unblock_comment = unblock_tbl.unblock_comment
    from unblock_tbl
    where foreign_workers.id = unblock_tbl.foreign_worker_id and unblock_tbl.rank = 1;

    with tmp_tbl as (
        select fw.id as fw_id, fw.code as fw_code, fw.blocked as fw_blocked, rank() over (partition by fct.worker_code order by fct.modify_date desc) as rank,
        fct.field_name, fct.new_value as fct_new_value, fct.comments, fct.userid, fct.modify_date, fct2.new_value as fct2_new_value
        from foreign_workers fw 
        left join fomema_backup_nios.fw_block fb on fw.code = fb.worker_code and fw.blocked is true
        left join fomema_backup_nios.fw_change_trans fct on fw.code = fct.worker_code and fw.blocked is true
        and fct.table_name = 'FOREIGN_WORKER_MASTER' and fct.field_name = 'ISIMMBLOCK' and fct.new_value = 'Y'
        left join fomema_backup_nios.fw_change_trans fct2 on fw.code = fct2.worker_code and fw.blocked is true
        and fct2.table_name = 'FOREIGN_WORKER_MASTER' and fct2.field_name = 'IMMBLOCKED_BY' and fct2.modify_date = fct.modify_date
        where fb.fw_block_id is null and fct.field_name is not null
    )
    update foreign_workers set block_comment = tmp_tbl.comments, blocked_at = tmp_tbl.modify_date, blocked_by = users.id
    from tmp_tbl left join users on tmp_tbl.fct2_new_value = users.code
    where tmp_tbl.fw_code = foreign_workers.code and tmp_tbl.rank = 1;

    perform end_migration_log(v_log_id);
end;
$$;

\echo 'fw_block_log ended'
