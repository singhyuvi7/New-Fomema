\echo "visit_report_control_cell_conditions.sql loaded"

-- blood groupings
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_blood_groupings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '02_10','02_10_2'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_cell,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(r, '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_cell_id,
                    rhesus,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportBloodGrouping',
                    temp_row.id,
                    case when result.control_cell = 'A' THEN 1 
                    WHEN result.control_cell = 'B' THEN 2 
                    WHEN result.control_cell = 'AB' THEN 3 
                    WHEN result.control_cell = 'O' THEN 4 
                    ELSE null END,
                    CASE WHEN temp_row.rpt_seq = '02_10' THEN 'POSITIVE' WHEN temp_row.rpt_seq = '02_10_2' THEN 'NEGATIVE' END,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - blood grouping done"

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
                '14_14'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaScreening',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - malaria screening done"

-- malaria bfmp
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
                '15_14'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaBfmp',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - malaria bfmp done"

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
                '16_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivScreening',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hiv screening done"

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
                '17_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivVerification',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hiv verification done"

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
                '18_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHivConfirmatory',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hiv confirmatory done"

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
                '19_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagScreening',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hbsag screening done"

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
                '20_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagVerification',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hbsag verification done"

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
                '21_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHbsagAppeal',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hbsag appeal done"

-- vdrl
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_vdrls gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '22_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportVdrl',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - vdrl done"

-- tpha
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_tphas gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '23_05'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportTpha',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - tpha done"

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
                '24_06','24_06_2'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    urine_drug_category,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugScreening',
                    temp_row.id,
                    CASE WHEN temp_row.rpt_seq = '24_06' THEN 'OPIATES' ELSE 'CANNABINOIDS' END,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - urine_drug_screening done"

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
                '25_06','25_06_2'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    urine_drug_category,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineDrugVerification',
                    temp_row.id,
                    CASE WHEN temp_row.rpt_seq = '25_06' THEN 'OPIATES' ELSE 'CANNABINOIDS' END,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - urine_drug_verification done"

-- urine_pregnancy
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_pregnancy_tests gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '26_06'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrinePregnancyTest',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - urine_pregnancy done"

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
                '27_06'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportHcgVerification',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - hcg_verification done"

-- urine_biochemistry
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistries gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '28_06'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistry',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - urine_biochemistry done"

-- urine_biochemistry_verification
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_biochemistry_verifications gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '29_06'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP
                SELECT 
                    a[1] AS control_name,
                    a[2] AS lot_number,
                    a[3] AS expiry
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(r,'%29',')'),'%28','('),'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_control_cell_conditions (
                    control_cell_conditionable_type,
                    control_cell_conditionable_id,
                    control_name,
                    lot_number,
                    expiry,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistryVerification',
                    temp_row.id,
                    result.control_name,
                    result.lot_number,
                    to_date(result.expiry,'DD-MM-YYYY'),
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_control_cell_conditions.sql - urine_biochemistry_verification done"

\echo "visit_report_control_cell_conditions.sql ended"