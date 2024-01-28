\echo 'fw_critical_info.sql loaded'

do $$
declare
    v_log_id bigint;
    rec_fw_critical_info record;
    rec_fw_critical_info_detail record;
    v_approval_request_id bigint;
    v_approval_item_id bigint;
    v_fw_amendment_id bigint;
begin
    select start_migration_log('fw_critical_info.sql') into v_log_id; commit;

    drop table if exists z_amendment_reasons_mappings;
    create table if not exists z_amendment_reasons_mappings (
        oldcode numeric(1),
        newcode character varying
    );
    create index if not exists idx_z_amendment_reasons_mappings_on_oldcode on z_amendment_reasons_mappings(oldcode);
    create index if not exists idx_z_amendment_reasons_mappings_on_newcode on z_amendment_reasons_mappings(newcode);
    insert into z_amendment_reasons_mappings (oldcode, newcode) values (1, 'PASSPORT');
    insert into z_amendment_reasons_mappings (oldcode, newcode) values (2, 'INPUT_ERROR');
    insert into z_amendment_reasons_mappings (oldcode, newcode) values (3, 'AUTHORITY_REQUEST');
    insert into z_amendment_reasons_mappings (oldcode, newcode) values (4, 'OTHER');

    for rec_fw_critical_info in (
        select
            fci.*, 
            fw.id as foreign_worker_id,
            'FOREIGN_WORKER_AMENDMENT' as category,
            case
                when fci.status = '1' then 0 -- pending
                when fci.status = '2' then 2 -- approved
                when fci.status = '3' then 3 -- rejected
            end as state,
            case
                when fci.status = '2' then 'APPROVE'
                when fci.status = '3' then 'REJECT'
                else null
            end as approval_decision,
            creator_users.id as request_user_id,
            coalesce(fci.request_date, clock_timestamp()) as requested_at,
            approvor_users.id as respond_user_id,
            approvor_users.id as approval_user_id,
            case
                when fci.status = '2' then coalesce(fci.approved_date, clock_timestamp())
                else null
            end as approved_at,
            case
                when fci.status = '2' then coalesce(fci.approved_date, clock_timestamp())
                else null
            end as executed_at,
            case
                when fci.status = '3' then coalesce(fci.approved_date, clock_timestamp())
                else null
            end as rejected_at,
            coalesce(fci.createdate, clock_timestamp()) as created_at,
            coalesce(fci.modifydate, clock_timestamp()) as updated_at,
            ar.id as amendment_reason_id
        from
            fomema_backup_nios.fw_critical_info fci
            join foreign_workers fw on fci.worker_code = fw.code
            left join fomema_backup_nios.v_user_master creators on creators.uuid = fci.createby
            left join users creator_users on creators.userid = creator_users.code
            left join fomema_backup_nios.v_user_master updators on updators.uuid = fci.modifyby
            left join users updator_users on updators.userid = updator_users.code
            left join fomema_backup_nios.v_user_master approvors on approvors.uuid = fci.approvedby
            left join users approvor_users on approvors.userid = approvor_users.code
            left join z_amendment_reasons_mappings zarm on fci.reason = zarm.oldcode
            left join amendment_reasons ar on zarm.newcode = ar.code
    ) loop
        insert into approval_requests (
            category,
            state,
            approval_decision,
            request_user_id,
            requested_at,
            respond_user_id,
            approval_user_id,
            approved_at,
            executed_at,
            rejected_at,
            created_at,
            updated_at
        ) values (
            rec_fw_critical_info.category,
            rec_fw_critical_info.state,
            rec_fw_critical_info.approval_decision,
            rec_fw_critical_info.request_user_id,
            rec_fw_critical_info.requested_at,
            rec_fw_critical_info.respond_user_id,
            rec_fw_critical_info.approval_user_id,
            rec_fw_critical_info.approved_at,
            rec_fw_critical_info.executed_at,
            rec_fw_critical_info.rejected_at,
            rec_fw_critical_info.created_at,
            rec_fw_critical_info.updated_at
        ) returning id into v_approval_request_id;

        insert into approval_items (
            request_id,
            resource_id,
            resource_type,
            event,
            params,
            created_at,
            updated_at
        ) values (
            v_approval_request_id,
            rec_fw_critical_info.foreign_worker_id,
            'ForeignWorker',
            'update',
            '',
            rec_fw_critical_info.created_at,
            rec_fw_critical_info.updated_at
        ) returning id into v_approval_item_id;

        insert into fw_amendments (
            foreign_worker_id,
            comment,
            approval_comment,
            created_by,
            created_at,
            updated_by,
            updated_at,
            approval_item_id
        ) values (
            rec_fw_critical_info.foreign_worker_id,
            rec_fw_critical_info.reason_others,
            rec_fw_critical_info.approved_comment,
            rec_fw_critical_info.request_user_id,
            rec_fw_critical_info.created_at,
            rec_fw_critical_info.respond_user_id,
            rec_fw_critical_info.updated_at,
            v_approval_item_id
        ) returning id into v_fw_amendment_id;

        if rec_fw_critical_info.amendment_reason_id is not null then
            insert into fw_amendment_reasons (
                fw_amendment_id,
                amendment_reason_id,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) values (
                v_fw_amendment_id,
                rec_fw_critical_info.amendment_reason_id,
                rec_fw_critical_info.created_at,
                rec_fw_critical_info.updated_at,
                rec_fw_critical_info.request_user_id,
                rec_fw_critical_info.respond_user_id
            );
        end if;

        for rec_fw_critical_info_detail in (
            select fcid.*, 
            case 
                when fcid.critical_column = 'DOB' then 'date_of_birth' 
                when fcid.critical_column = 'COUNTRY' then 'country_id' 
                when fcid.critical_column = 'PASSPORT' then 'passport_number'
                else lower(fcid.critical_column)
            end as field,
            case when fcid.critical_column = 'DOB' then to_char(to_date(critical_old, 'DD/MM/YYYY'), 'YYYY-MM-DD') else critical_old end as old_value,
            case when fcid.critical_column = 'DOB' then to_char(to_date(critical_new, 'DD/MM/YYYY'), 'YYYY-MM-DD') else critical_new end as new_value
            from fomema_backup_nios.fw_critical_info_detail fcid 
            where fcid.fw_critical_id = rec_fw_critical_info.fw_critical_id
        ) loop
            insert into fw_amendment_details (
                fw_amendment_id,
                field,
                old_value,
                new_value,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) values (
                v_fw_amendment_id,
                rec_fw_critical_info_detail.field,
                rec_fw_critical_info_detail.old_value,
                rec_fw_critical_info_detail.new_value,
                rec_fw_critical_info.created_at,
                rec_fw_critical_info.updated_at,
                rec_fw_critical_info.request_user_id,
                rec_fw_critical_info.respond_user_id
            );
        end loop;
    end loop;
    perform end_migration_log(v_log_id);
end
$$;

\echo 'fw_critical_info.sql ended'