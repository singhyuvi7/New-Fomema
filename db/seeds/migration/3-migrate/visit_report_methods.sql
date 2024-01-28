\echo "visit_report_methods.sql loaded"

-- blood groupings
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_blood_groupings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '02_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportBloodGrouping',
                    temp_row.id,
                    case when r = 'GEL' THEN 'GEL_CARD' 
                    WHEN r = 'TUBE' THEN 'TUBE' 
                    WHEN r = 'MU_TITREPLATE' THEN 'ΜICRO_TITRE_PLATE' 
                    WHEN r = 'INSTRUMENT' THEN 'AUTOMATED' 
                    ELSE r END,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - blood grouping done"

-- malaria screening
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_malaria_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '14_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(r,'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaScreening',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    WHEN result.method = 'AUTOMATED HAEMATOLOGY ANALYSER' THEN 'MAPSS' 
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - malaria screening done"

-- malaria_bfmp
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_malaria_bfmps gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '15_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS instrumentation,
                    a[2] AS comment
                    INTO result
                FROM (
                    SELECT string_to_array(replace(r,'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaBfmp',
                    temp_row.id,
                    'OTHER',
                    result.instrumentation,
                    result.comment,
                    result.comment,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - malaria_bfmp done"

-- hiv screening
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '16_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivScreening',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA' 
                    when result.method = 'RAPID STRIP ELISA' THEN 'RAPID' 
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hiv screening done"

-- hiv verification
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '17_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivVerification',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hiv verification done"

-- hiv confirmatory
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hiv_confirmatories gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '18_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivConfirmatory',
                    temp_row.id,
                    case when result.method = 'WESTERN BLOT' THEN 'WESTERN_BLOT' 
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hiv confirmatory done"

-- hbsag screening
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '19_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagScreening',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hbsag screening done"

-- hbsag verification
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '20_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagVerification',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hbsag verification done"

-- hbsag appeal
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hbsag_appeals gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '21_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagAppeal',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_methods.sql - hbsag appeal done"

-- vdrl
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_vdrls gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '22_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportVdrl',
                    temp_row.id,
                    'OTHER',
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

\echo "visit_report_methods.sql - vdrl done"

-- tpha
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_tphas gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '23_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportTpha',
                    temp_row.id,
                    'OTHER',
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

\echo "visit_report_methods.sql - tpha done"

-- urine_drug_screening
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_drug_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '24_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                
                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugScreening',
                    temp_row.id,
                    case when result.method = 'RAPID TEST' THEN 'RAPID_TEST_KIT' 
                    when result.method = 'EMIT' THEN 'EMIT'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - urine_drug_screening done"

-- urine_drug_verification
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_drug_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '25_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                
                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugVerification',
                    temp_row.id,
                    case when result.method = 'RAPID TEST' THEN 'RAPID_TEST_KIT' 
                    when result.method = 'EMIT' THEN 'EMIT'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - urine_drug_verification done"

-- urine_pregnancy
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_pregnancy_tests gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '26_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            INSERT INTO visit_report_methods (
                methodable_type,
                methodable_id,
                code,
                instrumentation,
                semi_auto,
                fully_auto,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) 
            VALUES (
                'VisitReportUrinePregnancyTest',
                temp_row.id,
                'OTHER',
                'URINE DIPSTICK',
                temp_row.datavalue,
                temp_row.datavalue,
                temp_row.created_at,
                temp_row.updated_at,
                temp_row.created_by,
                temp_row.updated_by
            );
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - urine_pregnancy done"

-- hcg_verification
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_hcg_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '27_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS method,
                    a[2] AS instrumentation,
                    a[3] AS semi_auto,
                    a[4] AS fully_auto
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(r,'%20',' '),'%3A',':'), '^')
                ) AS dt(a);

                INSERT INTO visit_report_methods (
                    methodable_type,
                    methodable_id,
                    code,
                    instrumentation,
                    semi_auto,
                    fully_auto,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHcgVerification',
                    temp_row.id,
                    case when result.method = 'ELISA' THEN 'ELISA' 
                    when result.method = 'CMIA' THEN 'CMIA'
                    ELSE 'OTHER' END,
                    result.instrumentation,
                    result.semi_auto,
                    result.fully_auto,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - hcg_verification done"

-- urine_biochemistry
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistries gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '28_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            INSERT INTO visit_report_methods (
                methodable_type,
                methodable_id,
                code,
                instrumentation,
                semi_auto,
                fully_auto,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) 
            VALUES (
                'VisitReportUrineBiochemistry',
                temp_row.id,
                'OTHER',
                'URINE DIPSTICK',
                temp_row.datavalue,
                temp_row.datavalue,
                temp_row.created_at,
                temp_row.updated_at,
                temp_row.created_by,
                temp_row.updated_by
            );
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - urine_biochemistry done"

-- urine_biochemistry_verification
DO $$
    DECLARE
        r text;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistry_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '29_01'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            INSERT INTO visit_report_methods (
                methodable_type,
                methodable_id,
                code,
                instrumentation,
                semi_auto,
                fully_auto,
                created_at,
                updated_at,
                created_by,
                updated_by
            ) 
            VALUES (
                'VisitReportUrineBiochemistryVerification',
                temp_row.id,
                'OTHER',
                'URINE DIPSTICK',
                temp_row.datavalue,
                temp_row.datavalue,
                temp_row.created_at,
                temp_row.updated_at,
                temp_row.created_by,
                temp_row.updated_by
            );
        END LOOP;
    END
$$;

\echo "visit_report_methods.sql - urine_biochemistry_verification done"


\echo "visit_report_methods.sql ended"