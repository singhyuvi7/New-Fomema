\echo "status_schedule.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('status_schedule.sql') into v_log_id; commit;

    insert into status_schedules (
        status_scheduleable_id,
        status_scheduleable_type,
        "comment",
        previous_status,
        "status",
        created_by,
        created_at,
        updated_by,
        updated_at,
        "from",
        "to"
    )
    select
        case 
            when sc.category = 'D' then doctors.id
            when sc.category = 'L' then laboratories.id
            when sc.category = 'R' then radiologists.id
            when sc.category = 'X' then xray_facilities.id
            else null
        end as status_scheduleable_id,
        case 
            when sc.category = 'D' then 'Doctor'
            when sc.category = 'L' then 'Laboratory'
            when sc.category = 'R' then 'Radiologist'
            when sc.category = 'X' then 'XrayFacility'
            else null
        end as status_scheduleable_type,
        sc.comments as comment,
        case
            when sc.old_status = 'Y' or sc.old_status is null then 'ACTIVE'
            when sc.old_status = 'N' then 'INACTIVE'
        end as previous_status,
        case
            when sc.new_status = 'Y' or sc.new_status is null then 'ACTIVE'
            when sc.new_status = 'N' then 'INACTIVE'
        end as status,
        creator_users.id as created_by,
        coalesce(sc.creation_date, clock_timestamp()) as created_at,
        updator_users.id as updated_by,
        coalesce(sc.modification_date, clock_timestamp()) as updated_at,
        coalesce(sc.suspend_start, sc.creation_date) as from,
        sc.suspend_end as to
    from fomema_backup_nios.suspension_comments sc left join doctors on sc.bc_user_code = doctors.code and sc.category = 'D'
    left join laboratories on sc.bc_user_code = laboratories.code and sc.category = 'L'
    left join radiologists on sc.bc_user_code = radiologists.code and sc.category = 'R'
    left join xray_facilities on sc.bc_user_code = xray_facilities.code and sc.category = 'X'
    left join fomema_backup_nios.v_user_master creators on creators.uuid = sc.creator_id
    left join users creator_users on creators.userid = creator_users.code
    left join fomema_backup_nios.v_user_master updators on updators.uuid = sc.modify_id
    left join users updator_users on updators.userid = updator_users.code
    order by sc.suspendid;

    perform end_migration_log(v_log_id);
end
$$;

\echo "status_schedule.sql ended"
