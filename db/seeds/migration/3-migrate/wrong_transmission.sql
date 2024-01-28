\echo "wrong_transmission.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('wrong_transmission.sql') into v_log_id;
        commit;

        insert into transaction_reversions (
            transaction_id,
            created_by,
            exam_type,
            issues,
            created_at,
            updated_at
        )
        select
            lt.id,
            mod_user.id,
            case
                when xf.id is not null then 'XrayExamination'
                when doc.id is not null then 'DoctorExamination'
                when lab.id is not null then 'LaboratoryExamination'
                else 'Unknown' end,
            wt.comments,
            coalesce(wt.modify_date, clock_timestamp()),
            coalesce(wt.modify_date, clock_timestamp())
        from
            fomema_backup_nios.wrong_transmission wt
            join transactions lt on wt.trans_id = lt.code
            left join users mod_user on mod_user.code = wt.modify_id
            left join xray_facilities xf on wt.provider_code = xf.code
            left join laboratories lab on wt.provider_code = lab.code
            left join doctors doc on wt.provider_code = doc.code
        order by
            wt.modify_date;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "wrong_transmission.sql ended"