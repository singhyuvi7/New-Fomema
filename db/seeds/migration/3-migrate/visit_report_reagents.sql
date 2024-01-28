\echo "visit_report_reagents.sql loaded"

-- blood groupings
DO $$
    DECLARE
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_blood_groupings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '02_07'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            INSERT INTO visit_report_reagents (
                reagentable_type,
                reagentable_id,
                reagent_id,
                comment,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) 
            VALUES (
                'VisitReportBloodGrouping',
                temp_row.id,
                other_reagent_id,
                temp_row.datavalue,
                temp_row.created_at,
                temp_row.updated_at,
                temp_row.created_by,
                temp_row.updated_by
            );
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - blood groupings done"


-- malaria screening
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_malaria_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '14_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaScreening',
                    temp_row.id,
                    other_reagent_id,
                    r,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - malaria screening done"

-- malaria bfmp
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_malaria_bfmps gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '15_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaBfmp',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - malaria bfmp done"

-- hiv screening
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '16_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivScreening',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hiv screening done"

-- hiv verification
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '17_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivVerification',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hiv verification done"

-- hiv confirmatory
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_confirmatories gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '18_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivConfirmatory',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hiv confirmatory done"

-- hbsag screening
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '19_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagScreening',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hbsag screening done"

-- hbsag verification
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '20_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagVerification',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hbsag verification done"

-- hbsag appeal
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_appeals gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '21_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagAppeal',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hbsag appeal done"

-- vdrl
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_vdrls gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '22_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportVdrl',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - vdrl done"

-- tpha
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_tphas gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '23_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportTpha',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - tpha done"

-- urine_drug_screening
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_drug_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '24_02_A1','24_02_B1'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    urine_drug_category,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugScreening',
                    temp_row.id,
                    CASE WHEN temp_row.rpt_seq = '24_02_A1' THEN 'OPIATES' ELSE 'CANNABINOIDS' END,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - urine_drug_screening done"

-- urine_drug_verification
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_drug_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '25_02_A1','25_02_B1'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    urine_drug_category,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugVerification',
                    temp_row.id,
                    CASE WHEN temp_row.rpt_seq = '25_02_A1' THEN 'OPIATES' ELSE 'CANNABINOIDS' END,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - urine_drug_verification done"

-- urine_pregnancy
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_pregnancy_tests gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '26_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrinePregnancyTest',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - urine_pregnancy done"

-- hcg_verification
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hcg_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '27_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHcgVerification',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - hcg_verification done"

-- urine_biochemistry
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistries gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '28_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistry',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - urine_biochemistry done"

-- urine_biochemistry_verification
DO $$
    DECLARE
        r text;
        other_reagent_id bigint;
        temp_row RECORD;
    begin
        SELECT id into other_reagent_id from reagents where code = 'OTHER';

        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistry_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '29_02'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_reagents (
                    reagentable_type,
                    reagentable_id,
                    reagent_id,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistryVerification',
                    temp_row.id,
                    other_reagent_id,
                    trim(replace(r,'%20',' ')),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_reagents.sql - urine_biochemistry_verification done"

\echo "visit_report_reagents.sql ended"