\echo "visit_report_gcms_details.sql loaded"

-- urine_drug_screening
DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
        category text;
        categories varchar[] := ARRAY['OPIATES','CANNABINOIDS'];
    begin
        FOR temp_row IN
           SELECT gp.id, lb.rpt_seq, lb.datavalue, gp.created_at, gp.updated_at, gp.created_by, gp.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_report_urine_drug_screenings gp ON lb.report_id = gp.report_id
            where lb.rpt_seq in (
                '24_16'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS code,
                    a[2] AS comment
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(replace(r,'%20',' '),'%2C',','),'%28','('),'%29',')'), '^')
                ) AS dt(a);

                FOREACH category IN ARRAY categories LOOP
                    INSERT INTO visit_report_gcms_details (
                        gcms_detailable_type,
                        gcms_detailable_id,
                        urine_drug_category,
                        code,
                        comment,
                        created_at,
                        updated_at,
                        created_by,
                        updated_by
                    ) 
                    VALUES (
                        'VisitReportUrineDrugScreening',
                        temp_row.id,
                        category,
                        CASE WHEN result.code = 'Refer to ABRC' THEN 'REFER_ABRC' ELSE 'OTHER' END,
                        result.comment,
                        temp_row.created_at,
                        temp_row.updated_at,
                        temp_row.created_by,
                        temp_row.updated_by
                    );
                END LOOP; 

            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_gcms_details.sql - urine_drug_screening done"

\echo "visit_report_gcms_details.sql ended"