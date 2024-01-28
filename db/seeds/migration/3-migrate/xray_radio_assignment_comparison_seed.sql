\echo "xray_radio_assignment_comparison_seed.sql loaded"

\echo "Insert xray_examinations - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('xray_radio_assignment_comparison_seed.sql') into v_log_id;
        commit;

        with xray_radios as (
            select xra.trans_id
            from fomema_backup_nios.xray_radio_assignment xra join fomema_backup_nios.fw_transaction fwt on xra.trans_id = fwt.trans_id
            where fwt.xray_submit_date is null -- 688 rows, 31707
        ),

        no_examinations as (
            select t.code
            from transactions t left join xray_examinations xe on xe.sourceable_id = t.id and xe.sourceable_type = 'Transaction'
            where t.code in (select * from xray_radios) and xe.id is null
        )

        insert into xray_examinations (
            sourceable_type, sourceable_id, transaction_id,
            xray_ref_number,
            xray_examination_not_done,
            transmitted_at, xray_taken_date,
            updated_at, created_at,
            result
        )
        select
            'Transaction' sourceable_type, lt.id, lt.id,
            fwt.xray_ref_no,
            case
                when fwt.xray_notdone_ind = 'N' then 'NO'
                when fwt.xray_notdone_ind = 'Y' then 'YES'
                else 'NO' end not_done,
            fwt.xray_submit_date, fwt.xray_testdone_date,
            coalesce(fwt.xray_submit_date, clock_timestamp()) updated_at, coalesce(fwt.xray_submit_date, clock_timestamp()) created_at,
            case
                when fwt.xray_notdone_ind = 'N' then 'NORMAL'
                when fwt.xray_notdone_ind = 'Y' then 'ABNORMAL'
                else 'NORMAL' end result
        from
            transactions lt join fomema_backup_nios.fw_transaction fwt on lt.code = fwt.trans_id
        where
            lt.code in (select * from no_examinations);

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Insert xray_examinations - End"

\echo "xray_radio_assignment_comparison_seed.sql ended"