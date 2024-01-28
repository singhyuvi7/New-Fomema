\echo "fw_details_xray_examinations.sql loaded"

/*
FROM condition_master
Xray Results -> All these are Xrays (20xx)
    2001    Thoracic Cage
        => xray_examinations.thoracic_cage "ABNORMAL|NORMAL"

    2002    Heart Shape and Size (CTR if applicable)
        => xray_examinations.heart_shape_and_size "ABNORMAL|NORMAL"

    2003    Mediastinum and Hila
        => xray_examinations.mediastinum_and_hila "ABNORMAL|NORMAL"

    2004    Pleura / Hemidiaphragms / Costopherenic Angles
        => xray_examinations.pleura_hemidiaphragms_costopherenic_angles "ABNORMAL|NORMAL"

    2011    Lung Fields
        => xray_examinations.lung_fields "ABNORMAL|NORMAL"

    2012    Focal Lesion (E.g. Old/New PTB, Maglinancy)
        => xray_examinations.focal_lesion "YES|NO"

    2013    Any Other Abnormalities
        => xray_examinations.other_findings "YES|NO"

    2101    Details of abnormalities for Thoracic Cage
        => xray_examinations.thoracic_cage_comment

    2102    Details of abnormalities for Heart Shape and Size
        => xray_examinations.heart_shape_and_size_comment

    2111    Details of abnormalities for Lung Fields
        => xray_examinations.lung_fields_comment

    2103    Details of abnormalities for Mediastinum and Hila
        => xray_examinations.mediastinum_and_hila_comment

    2104    Details of abnormalities for Pleura/ Hemidiaphragms/ Costopherenic Angles
        => xray_examinations.pleura_hemidiaphragms_costopherenic_angles_comment

    2112    Details of abnormalities for Focal Lesion (E.g. Old/New PTB, Maglinancy)
        => xray_examinations.focal_lesion_comment

    2113    Details of abnormalities for Any Other Abnormalities
        => xray_examinations.other_findings_comment

    2014    Impression
        => xray_examinations.impression

From fw_comment
    ('2014', '2101', '2102', '2103', '2104', '2111', '2112', '2113')

XrayExamination
- Columns migrated
    sourceable_id
        => set on insert, same as transaction_id

    sourceable_type
        => 'Transaction'

    transaction_id
        => set on insert

    xray_ref_number
        => fw_transaction.xray_ref_no

    result
        => If any of 2001-2004 or 2011-2013 is abnormal or exam not done, set as ABNORMAL, else NORMAL

    transmitted_at
    updated_at
    created_at
        => fw_transaction.xray_submit_date

    xray_taken_date
        => fw_transaction.xray_testdone_date

    xray_examination_not_done "NO|YES"
        => fw_transaction.xray_notdone_ind

- Columns skipped/uneccesary
    radiologist_saved_at
    radiologist_started_at
    radiologist_transmitted_at
    radiologist_aborted_at
    radiologist_assigned_at
    created_by
    updated_by
    xray_api_error
    upload_status -> Skip, not yet used, because to be used for more than 1 service provider. so far still only salinee.
*/

\echo "Insert xray_examinations - Start"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('xray_examinations.sql - inserting xray_examinations defaults') into v_log_id;
        commit;

        insert into xray_examinations (
            sourceable_type, sourceable_id, transaction_id,
            xray_ref_number,
            xray_examination_not_done,
            transmitted_at, updated_at, created_at, xray_taken_date,
            result
        )
        select
            'Transaction', local_trans.id, local_trans.id,
            nios_trans.xray_ref_no,
            case when nios_trans.xray_notdone_ind = 'N' then 'NO' when nios_trans.xray_notdone_ind = 'Y' then 'YES' else 'NO' end,
            nios_trans.xray_submit_date, coalesce(nios_trans.xray_submit_date, clock_timestamp()), coalesce(nios_trans.xray_submit_date, clock_timestamp()), nios_trans.xray_testdone_date,
            case when nios_trans.xray_notdone_ind = 'N' then 'NORMAL' when nios_trans.xray_notdone_ind = 'Y' then 'ABNORMAL' else 'NORMAL' end
        from
            transactions local_trans join fomema_backup_nios.fw_transaction nios_trans on local_trans.code = nios_trans.trans_id
        where
            local_trans.xray_transmit_date is not null
        order by
            local_trans.transaction_date;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "Insert xray_examinations - End"

\echo "fw_details_xray_examinations.sql ended"