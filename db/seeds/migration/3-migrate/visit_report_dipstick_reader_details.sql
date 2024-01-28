\echo "visit_report_dipstick_reader_details.sql loaded"

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
                '28_04'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS code,
                    a[2] AS comment
                    INTO result
                FROM (
                    SELECT string_to_array(replace(r,'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_dipstick_reader_details (
                    dipstick_reader_detailable_type,
                    dipstick_reader_detailable_id,
                    code,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistry',
                    temp_row.id,
                    CASE WHEN result.code = 'MANUAL' THEN 'MANUAL' WHEN result.code LIKE '%AUTOMATED%' THEN 'AUTOMATED' ELSE null END,
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

\echo "visit_report_dipstick_reader_details.sql - urine_biochemistry done"

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
                '29_04'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS code,
                    a[2] AS comment
                    INTO result
                FROM (
                    SELECT string_to_array(replace(r,'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_dipstick_reader_details (
                    dipstick_reader_detailable_type,
                    dipstick_reader_detailable_id,
                    code,
                    comment,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportUrineBiochemistryVerification',
                    temp_row.id,
                    CASE WHEN result.code = 'MANUAL' THEN 'MANUAL' WHEN result.code LIKE '%AUTOMATED%' THEN 'AUTOMATED' ELSE null END,
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

\echo "visit_report_dipstick_reader_details.sql - urine_biochemistry_verification done"

\echo "visit_report_dipstick_reader_details.sql ended"