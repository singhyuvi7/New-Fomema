\echo "fw_details_laboratory_examinations.sql loaded"

/*
FROM condition_master
Laboratory Results -> ALL these are labs (10xx)
    1041    HIV Antibody (ELISA)
        => laboratory_examinations.elisa "REACTIVE|NEGATIVE"

    1042    HBsAg
        => laboratory_examinations.hbsag "REACTIVE|NEGATIVE"

    1043    VDRL
        => laboratory_examinations.vdrl "REACTIVE|NEGATIVE"

    10431   TPHA
        => laboratory_examinations.tpha "REACTIVE|NEGATIVE"

    1044    Malaria
        => laboratory_examinations.malaria "POSITIVE|NEGATIVE"

    10441   BRMP
        => laboratory_examinations.bfmp "POSITIVE|NEGATIVE"

    1057    Urine - Opiates
        => laboratory_examinations.opiates "POSITIVE|NEGATIVE"

    1058    Urine - Cannabis
        => laboratory_examinations.cannabis "POSITIVE|NEGATIVE"

    1059    Urine - Pregnancy Test
        => laboratory_examinations.pregnancy "POSITIVE|NEGATIVE"

    10591   HCG
        => laboratory_examinations.pregnancy_serum_beta_hcg "POSITIVE|NEGATIVE"

    1053    Urine - Sugar
        => laboratory_examinations.sugar "PRESENT|ABSENT"

    1054    Urine - Albumin
        => laboratory_examinations.albumin "PRESENT|ABSENT"

    10535   Urine - Sugar : Millimoles per litre
        => laboratory_examinations.sugar_value

    10545   Urine - Sugar Albumin : Millimoles per litre
        => laboratory_examinations.albumin_value

    10411   Looks like blood group other (from fw_comment)
        => laboratory_examinations.blood_group_other

    1056   Laboratory Comment/Abnormal reason
        => laboratory_examinations.abnormal_reason

    888     Means laboratory transmitted from web service.
    case '666' : $fwdobj->L1_IBTV2 = 'Y'; --> Must save as ibtv2 -> this is an old webservice.
    case '777' : $fwdobj->L1_IBTV3 = 'Y'; --> Must save as ibtv3 -> this is an old webservice.
        => laboratory_examinations.web_service_indicator boolean
        This is saved in a different file -> fw_details_update_laboratory_examinations_web_service.sql

From fw_comment
    ('10411', '1056')

From fw_detail
    ('1041', '1042', '1043', '10431', '1044', '10441', '1057', '1058', '1059', '10591', '1053', '1054', '10535', '10545', '888')

Skip for later -> Must save this in its own table, for all the old data.
    1051    Urine - Color
    1052    Urine - Specific Gravity
    1055    Urine - Microscopic Examination
    10551   Lab Urinology - Reason -> from fw_comment, not used
    1071    Slit Skin Smear (to be done if indicated) -> Not used
    10531   Urine - Sugar : Level 1+
    10532   Urine - Sugar : Level 2+
    10533   Urine - Sugar : Level 3+
    10534   Urine - Sugar : Level 4+
    10541   Urine - Sugar Albumin : Level 1+
    10542   Urine - Sugar Albumin : Level 2+
    10543   Urine - Sugar Albumin : Level 3+
    10544   Urine - Sugar Albumin : Level 4+
    case '10521' : $fwdobj->L1_LABSGVALUE = $_ora_db->GetField("PARAMETER_VALUE"); break;

Dont migrate
    10552 - Not in use. Only 1 record from 2007.
    5104    Laboratory Result Comments -> All empty

LaboratoryExamination
- Columns migrated
    transaction_id
        => seed on insert

    laboratory_id
        => seed on insert

    transmitted_at
    created_at
    updated_at
        => fw_transaction.lab_submit_date

    blood_group "B"
        => fw_transaction.bld_grp

    blood_group_rhesus "+VE|-VE",
        => fw_transaction.rh 'Y|N' -> '+VE|-VE'

    result
        => anything abnormal (dont check vdrl, malaria, pregnancy cause will check tpha, bfmp, pregnancy_serum_beta_hcg) or exam not done, is ABNORMAL else NORMAL

    laboratory_test_not_done "YES|NO"
        => fw_transaction.lab_notdone_ind 'Y|N'

    specimen_taken_date
        => fw_transaction.lab_specimen_taken_date

    specimen_received_date
        => fw_transaction.lab_specimen_date

    blood_specimen_barcode
        => fw_transaction.blood_barcode_no

    urine_specimen_barcode
        => fw_transaction.urine_barcode_no

- Columns skipped/uneccesary
    blood_group_rhesus_other -> This is new, will be nil
*/

\echo "Insert laboratory_examinations - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('laboratory_examinations.sql - inserting laboratory_examinations defaults') into v_log_id;
        commit;

        insert into laboratory_examinations (
            transaction_id, laboratory_id,
            transmitted_at,
            created_at, updated_at,
            blood_specimen_barcode, urine_specimen_barcode,
            specimen_taken_date, specimen_received_date,
            laboratory_test_not_done,
            blood_group_rhesus,
            result,
            web_service_indicator, blood_group
        )
        select
            local_trans.id, local_trans.laboratory_id,
            nios_trans.lab_submit_date,
            coalesce(nios_trans.lab_submit_date, clock_timestamp()), coalesce(nios_trans.lab_submit_date, clock_timestamp()),
            nios_trans.blood_barcode_no, nios_trans.urine_barcode_no,
            nios_trans.lab_specimen_taken_date, nios_trans.lab_specimen_date,
            case when nios_trans.lab_notdone_ind = 'N' then 'NO' when nios_trans.lab_notdone_ind = 'Y' then 'YES' else 'NO' end,
            case when nios_trans.rh = 'N' then '-VE' when nios_trans.rh = 'Y' then '+VE' else null end,
            case when nios_trans.lab_notdone_ind = 'N' then 'NORMAL' when nios_trans.lab_notdone_ind = 'Y' then 'ABNORMAL' else 'NORMAL' end,
            false, nios_trans.bld_grp
        from
            transactions local_trans join fomema_backup_nios.fw_transaction nios_trans on local_trans.code = nios_trans.trans_id
        where
            local_trans.laboratory_transmit_date is not null
        order by
            local_trans.transaction_date;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Insert laboratory_examinations - End"

\echo "fw_details_laboratory_examinations.sql ended"