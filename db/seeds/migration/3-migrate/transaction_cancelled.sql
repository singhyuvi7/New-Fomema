\echo 'transaction_cancelled.sql loaded'

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('transaction_cancelled.sql') into v_log_id; commit;

    insert into transactions (
        code, doctor_id, employer_id, laboratory_id, radiologist_id, xray_facility_id, fw_code, foreign_worker_id,
        transaction_date,
        updated_by, updated_at,
        created_by, created_at,
        ignore_expiry, ignore_merts_expiry_at,
        fw_gender,
        fw_name, fw_date_of_birth, fw_passport_number, fw_country_id, fw_job_type_id,
        organization_id, expired_at,
        doctor_fp_result, xray_fp_result,
        status,
        med_ind_count, reg_ind,
        fw_maid_online,
        registration_type
    )
    select
        fwt.trans_id, doctors.id, employers.id, laboratories.id, radiologists.id, xray_facilities.id, fwt.worker_code, foreign_workers.id,
        fwt.transdate,
        updator_users.id, coalesce(fwt.modification_date, fwt.transdate, clock_timestamp()),
        creator_users.id, fwt.transdate,
        case when fwt.imr_ind = 'Y' then true else false end, coalesce(fwt.modification_date, clock_timestamp()),
        fwt.sex,
        foreign_workers.name, foreign_workers.date_of_birth, foreign_workers.passport_number, foreign_workers.country_id, foreign_workers.job_type_id,
        organizations.id, fwt.transdate + interval '30' day,
        2, 2,
        'CANCELLED',
        fwt.med_ind, fwt.reg_ind,
        'FOMEMA',
        case when fwt.renew_ind = 'Y' then 1 else 0 end
    from
        fomema_backup_nios.fw_transaction_cancel fwt
        left join doctors on fwt.doctor_code = doctors.code
        left join employers on fwt.employer_code = employers.code
        left join laboratories on fwt.laboratory_code = laboratories.code
        left join radiologists on fwt.radiologist_code = radiologists.code
        left join xray_facilities on fwt.xray_code = xray_facilities.code
        left join foreign_workers on fwt.worker_code = foreign_workers.code
        left join fomema_backup_nios.v_user_master updators on fwt.modify_id = updators.uuid
        left join users updator_users on updators.userid = updator_users.code
        left join users creator_users on fwt.created_by is not null and substring(fwt.created_by, 3) = creator_users.code
        left join organizations on fwt.created_by is not null and substring(fwt.created_by, 1, 2) = organizations.code and organizations.org_type = 'BRANCH'
    order by
        fwt.transdate
    ;

    insert into transaction_cancels (
        transaction_id,
        cancelled_at,
        cancelled_by,
        status,
        updated_by, updated_at,
        created_by, created_at
    )
    select
        t.id as transaction_id,
        fwtc.cancel_date as cancelled_at,
        cancel_users.id as cancelled_by,
        'COMPLETED' as status,
        cancel_users.id as updated_by, coalesce(fwtc.modification_date, clock_timestamp()) as updated_at,
        cancel_users.id as created_by, coalesce(fwtc.modification_date, clock_timestamp()) as created_at
    from
        fomema_backup_nios.fw_transaction_cancel fwtc
        join transactions t on fwtc.trans_id = t.code
        left join fomema_backup_nios.v_user_master updators on fwtc.modify_id = updators.uuid
        left join users updator_users on updators.userid = updator_users.code
        left join users creator_users on fwtc.created_by is not null and substring(fwtc.created_by, 3) = creator_users.code
        left join users cancel_users on updators.userid = cancel_users.code
    order by
        fwtc.transdate
    ;

    perform end_migration_log(v_log_id);
end
$$;

\echo 'transaction_cancelled.sql end'