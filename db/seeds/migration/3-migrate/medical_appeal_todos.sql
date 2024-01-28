/*
    Mapped over
    [1, "Appeal for Digital X-Ray."],
        => 33  Appeal for Digital X-Ray

    [2, "To request for HIV Confirmatory test (Western Blot) on primary blood/serum sample."],
        => 1   HIV Confirmatory test on primary blood/serum sample kept by the original lab.

    [3, "Declaration form verifying ID of FW."],
        => 2   Declaration form verifying ID of FW.

    [5, "To get Dermatologist assessment report for Slit Skin Test."],
        => 4   Dermatologist assessment report.

    [6, "To request for Hbs/AG (ELISA/CMIA) screening test on duplicated sample of original blood/serum sample."],
        => 5   Hbs/AG confirmatory test on the primary blood/serum sample kept by the original laboratory.

    [7, "To get Psychiatrist's assessment report."],
        => 6   Psychiatrist's assessment report.

    [8, "To get Neurologist assessment report."],
        => 7   Neurologist assessment report.

    [9, "To get Oncologist assessment report."],
        => 8   Oncologist assessment report.

    [10, "To request for opiates confirmation test (GCMS) on primary urine sample kept by the original lab."],
        => 12  GCMS for opiates on primary urine sample kept by the original lab.

    [11, "To request for Cannabinoids Confirmation test (GCMS) on primary urine sample kept by the original lab."],
        => 13  GCMS for Canabinolds on primary urine sample kept by the original lab.

    [12, "To do Hypertension assessment report with BP measurement before and after treatment."],
        => 14  Hypertension assessment report with BP measurement before and after treatment. Other related systemic examination, especially for signs of target organ damage.

    [15, "Employer's commitment letter."],
        => 15  Employer's commitment letter.

    [16, "To get Cardiologist's assessment with ECHO report."],
        => 16  Cardiologist's assessent with ECHO report.

    [17, "To get Respiratory/Chest Physician's assessment report."],
        => 17  Respiratory/Chest Physician's assessment report.

    [18, "To do FBS and HBA1C before and after treatment."],
        => 18  Diabetic assessment report and other related systems examination, especially for signs of target organ damage, FBS and HbAIC before and after treatment.

    [20, "Surgeon's assessment report."],
        => 21  Surgeon's assessment report.

    [21, "Physician's assessment report."],
        => 19  Surgeon's/Physician's assessment report.

    [22, "Orthopedic Surgeon's assessment report."],
        => 24  Orthopedic Surgeon's assessment report.

    [24, "To get Nephrologist‘s/ Urologist’s assessment report if needed."],
        => 27  Nephrologist's assessment report.

    [25, "To do aided Vision assessment report."],
        => 29  Further assessment with added vision.

    [26, "To get Ophthalmologist's assessment report (if necessary)."]
        => 30  Ophthalmologist's assessment report (if necessary)

    Newly added, nothing to map.
    [13, "To get Physician assessment report if needed."],
    [14, "Other related systemic examination, especially for signs of target organ damage."],
    [23, "To Repeat Urine Albumin."],
    [19, "To get Endocrinologist / Physician assessment report if needed."],
    [4, "To submit new evidence (X-Ray film) with report to Medical Department FOMEMA within 7 days."],

    No longer in use, will migrate to appeal_todo with is_active: false column.
    [27 , "Request for Chest X-ray Audit to XQCC"],
        => 3   Request for Chest X-ray Audit to XQCC

    [28 , "No appeal."],
        => 9   No appeal.

    [29 , "Send original slide to Makmal Kesihatan Awam Sg. Buloh through Pantai Fomema."],
        => 10  Send original slide to Makmal Kesihatan Awam Sg. Buloh through Pantai Fomema.
t
    [30 , "Serum HCG test on primary blood/serum sample kept by the original lab."],
        => 11  Serum �HCG test on primary blood/serum sample kept by the original lab.

    [31 , "Urologist assessment report."],
        => 20  Urologist assessment report.

    [32 , "O&G Specialist's Assessment Report"],
        => 22  O&G Specialist's Assessment Report

    [33 , "Physician assessment including Full Blood Picture report."],
        => 23  Physician assessment including Full Blood Picture report.

    [34 , "Repeat U/FEME and Renal Profile."],
        => 26  Repeat U/FEME and Renal Profile.

    [35 , "Thyroid Function Test."],
        => 28  Thyroid Function Test.

    [36 , "Ultrasound report of the abdomen."],
        => 31  Ultrasound report of the abdomen.

    [37 , "Please contact FOMEMA."]]
        => 32  Please contact FOMEMA.

    [38, "Orthopedic/Surgeon assessment report"]
        => 25  Orthopedic/Surgeon assessment report.


    fw_appeal_todolist
        dr_date             timestamp
        fo_date             timestamp
        dr_done             varchar(1)
        fo_done             varchar(1)
*/

\echo "medical_appeal_todos.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('medical_appeal_todos.sql') into v_log_id;
        commit;

        insert into medical_appeal_todos (
            medical_appeal_id,
            appeal_todo_id,
            comment,
            completed_at,
            created_at,
            updated_at,
            secondary_type
        )
        select
            ma.id,
            case
                when fat.todoid = 33 then 1
                when fat.todoid = 1 then 2
                when fat.todoid = 2 then 3
                when fat.todoid = 4 then 5
                when fat.todoid = 5 then 6
                when fat.todoid = 6 then 7
                when fat.todoid = 7 then 8
                when fat.todoid = 8 then 9
                when fat.todoid = 12 then 10
                when fat.todoid = 13 then 11
                when fat.todoid = 14 then 12
                when fat.todoid = 15 then 15
                when fat.todoid = 16 then 16
                when fat.todoid = 17 then 17
                when fat.todoid = 18 then 18
                when fat.todoid = 21 then 20
                when fat.todoid = 19 then 21
                when fat.todoid = 24 then 22
                when fat.todoid = 25 then 22
                when fat.todoid = 27 then 24
                when fat.todoid = 29 then 25
                when fat.todoid = 30 then 26
                when fat.todoid = 3  then 27
                when fat.todoid = 9  then 28
                when fat.todoid = 10 then 29
                when fat.todoid = 11 then 30
                when fat.todoid = 20 then 31
                when fat.todoid = 22 then 32
                when fat.todoid = 23 then 33
                when fat.todoid = 26 then 34
                when fat.todoid = 28 then 35
                when fat.todoid = 31 then 36
                when fat.todoid = 32 then 37
                else null end,
            fat.comments,
            case when fat.dr_done = 'Y' then fat.dr_date else null end,
            coalesce(fat.createdate, fat.modifydate, clock_timestamp()),
            coalesce(fat.modifydate, fat.createdate, clock_timestamp()),
            case
                when fat.todoid in (1, 5, 12, 13) then 'Laboratory'
                when fat.todoid = 33 then 'Xray'
                else null end
        from
            fomema_backup_nios.fw_appeal_todolist fat
            join medical_appeals ma on ma.id = fat.appealid
        order by
            fat.appeal_todolist_id;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_appeal_todos.sql ended"