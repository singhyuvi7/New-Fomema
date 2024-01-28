/*
    status
    C   150303  - Completed
    CL  31109   - Closed
    DA  700     - Doctor Assigned
    DC  35      - Document Completed
    N   36      - New
    PC  31      - Pending Appeal Close Request

    "PENDING_TODO"       => "To be reviewed",
    "EXAMINATION"        => "Doctor Examination",
    "DOCUMENT_COMPLETED" => "Document completed",
    "PENDING_APPROVAL"   => "Awaiting approval",
    "CLOSED"             => "Closed appeal"

    appeal_success
    N   20800   - Pending Decision
    S   100940  - Successful
    U   60474   - Unsuccessful

    "SUCCESSFUL" => "Successful",
    "UNSUCCESSFUL" => "Unsuccessful",
    "CANCEL/CLOSE" => "Cancelled"

    Leftover columns
        creator_id  varchar(10)
*/

\echo "medical_appeals.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        noreply_user_id int;
    BEGIN
        select start_migration_log('medical_appeals.sql') into v_log_id;
        commit;

        select id into noreply_user_id from users where code = 'NOREPLY' limit 1;

        /*
            Could not map these officers, numbers on the right are how many appeals they are the officers of.
            Latest case is from 2006 for all of these users.
            Officers that are null or test are ignore. officers with only 1 or 2 cases are also ignore.
                S.MOORTHY   36
                test    3
                SUNDRAMBAL  4
                DUMMY MEDICAL INSP. 1
                LISA TAN    868
                S.C.HONG    67
                S.S.MOORTHY 2735
                RAJI    1
                null 1080
        */

        -- these users were matched from v_user_master, where they either have duplicates, or the name is slightly different.
        with uuid_displayname as (
            select 413 uuid, 'MUHAMMAD KHAIRULASRAF B MUHAMMAD YUSOF' displayname union
            select 489, 'MUHAMMAD ZAMRI BIN BAHARUDDIN' union
            select 55, 'RAMADAS' union
            select 32, 'AZANEE' union
            select 55, 'DAS' union
            select 31, 'DAYANA' union
            select 341, 'DR LIM EWE SENG' union
            select 341, 'DR.LIM EWE SENG' union
            select 341, 'DR.LIM' union
            select 9, 'KSLIM' union
            select 7, 'DR NIK' union
            select 39, 'DRSATHIA' union
            select 43, 'GHANI' union
            select 181, 'HAIRANI ZAINAL' union
            select 8, 'HT CHEW' union
            select 141, 'LILY MARWANI' union
            select 141, 'LILY MARWANI BT. MOHD. RADZI' union
            select 43, 'MMGHANI' union
            select 43, 'M M GHANI' union
            select 11, 'MALAR' union
            select 82, 'PANNIRSELVAM A/L RAJAMANIKAM' union
            select 314, 'MOHAMAD FADZIRUL BIN MOHAMAD MASRI' union
            select 28, 'SELVA' union
            select 29, 'SKWAN' union

            select uuid, displayname from fomema_backup_nios.v_user_master where displayname in (
                select distinct(officer_incharge) from fomema_backup_nios.fw_appeal
            ) and displayname not in ('MUHAMMAD KHAIRULASRAF B MUHAMMAD YUSOF', 'MUHAMMAD ZAMRI BIN BAHARUDDIN', 'RAMADAS') -- There are 2 ramadas, if not excluded, it will create duplicate records.
        )

        insert into medical_appeals (
            id, transaction_id, doctor_id, doctor_reason, appeal_reason,
            created_at,
            updated_at,
            registered_by_type,
            created_by,
            status,
            result,
            completed_at,
            officer_in_charge_id,
            officer_assigned_at
        )
        select
            fa.appealid, local_trans.id, doc.id, fa.appeal_start_comments, fa.comments,
            coalesce(fa.creation_date, fa.modification_date, clock_timestamp()),
            coalesce(fa.modification_date, fa.result_date, fa.creation_date, clock_timestamp()),
            case -- registered_by_type
                when left(fa.creator_id, 1) = 'D' then 'Doctor'
                else 'User' end,
            case -- created_by
                when fa.creator_id = '9999' then noreply_user_id
                when left(fa.creator_id, 1) = 'D' then doctor_creator.id
                else creator_user.id end,
            case -- status
                when fa.status = 'N' then 'PENDING_TODO'
                when fa.status = 'DA' then 'EXAMINATION'
                when fa.status = 'DC' then 'DOCUMENT_COMPLETED'
                when fa.status = 'PC' then 'PENDING_APPROVAL'
                when fa.status in ('C', 'CL') then 'CLOSED'
                else null end,
            case -- result
                when fa.appeal_success = 'S' then 'SUCCESSFUL'
                when fa.appeal_success = 'U' then 'UNSUCCESSFUL'
                when fa.appeal_success = 'N' and fa.iscancelled = 'Y' and fa.status = 'CL' then 'CANCEL/CLOSE'
                else null end,
            case -- completed_at
                when fa.status in ('C', 'CL') then coalesce(fa.modification_date)
                else null end,
            case -- officer_in_charge_id
                when oic.id is not null then oic.id
                when officer_incharge is not null then noreply_user_id
                else null end,
            case -- officer_assigned_at
                when officer_incharge is null then null
                else coalesce(fa.creation_date, fa.modification_date, clock_timestamp()) end
        from
            fomema_backup_nios.fw_appeal fa
            join transactions local_trans on fa.trans_id = local_trans.code
            left join doctors doc on doc.code = fa.appeal_doctor_code
            left join doctors doctor_creator on doctor_creator.code = fa.creator_id
            left join fomema_backup_nios.v_user_master v_creator_user on fa.creator_id = cast(v_creator_user.uuid as varchar(10))
            left join users creator_user on v_creator_user.userid = creator_user.code
            left join uuid_displayname ud on ud.displayname = fa.officer_incharge
            left join fomema_backup_nios.v_user_master oic_user on oic_user.uuid = ud.uuid
            left join users oic on oic_user.userid = oic.code;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_appeals.sql ended"

/*
    Scripts run for 2020-08-27 - All pending because moving task to restructuring DB.
    -- These users cant be mapped because they have branch code of 0
    select displayname, email_id, userid, branch_code, status from fomema_backup_nios.v_user_master where displayname like '%ZAHIDAH%' union
    select displayname, email_id, userid, branch_code, status from fomema_backup_nios.v_user_master where displayname like '%NURZAHIRAH%'
    select name, email, code from users where code like '%KHADIJAH%'

    with uuid_displayname as (
        select 413 uuid, 'MUHAMMAD KHAIRULASRAF B MUHAMMAD YUSOF' displayname union
        select 489, 'MUHAMMAD ZAMRI BIN BAHARUDDIN' union
        select 55, 'RAMADAS' union
        select 32, 'AZANEE' union
        select 55, 'DAS' union
        select 31, 'DAYANA' union
        select 341, 'DR LIM EWE SENG' union
        select 341, 'DR.LIM EWE SENG' union
        select 341, 'DR.LIM' union
        select 9, 'KSLIM' union
        select 7, 'DR NIK' union
        select 39, 'DRSATHIA' union
        select 43, 'GHANI' union
        select 181, 'HAIRANI ZAINAL' union
        select 8, 'HT CHEW' union
        select 141, 'LILY MARWANI' union
        select 141, 'LILY MARWANI BT. MOHD. RADZI' union
        select 43, 'MMGHANI' union
        select 43, 'M M GHANI' union
        select 11, 'MALAR' union
        select 82, 'PANNIRSELVAM A/L RAJAMANIKAM' union
        select 314, 'MOHAMAD FADZIRUL BIN MOHAMAD MASRI' union
        select 28, 'SELVA' union
        select 29, 'SKWAN' union
        select 396, 'ZAHIDAH BT ABDUL FAROUK' union
        select 467, 'NURZAHIRAH BT ZAINAL' union
        select 390, 'SITI KHADIJAH BT MOHD TERMIZI' union

        select uuid, displayname from fomema_backup_nios.v_user_master where displayname in (
            select distinct(officer_incharge) from fomema_backup_nios.fw_appeal
        ) and displayname not in ('MUHAMMAD KHAIRULASRAF B MUHAMMAD YUSOF', 'MUHAMMAD ZAMRI BIN BAHARUDDIN', 'RAMADAS')
    )

    -- Checking if users can be joined to vum.
        select fa.officer_incharge, array_agg(distinct(mle1.code)), count(*)
        from fomema_backup_nios.fw_appeal fa
        left join uuid_displayname ud on ud.displayname = fa.officer_incharge
        left join fomema_backup_nios.v_user_master vum on ud.uuid = vum.uuid
        left join users mle1 on mle1.code = vum.userid
        group by fa.officer_incharge
*/
