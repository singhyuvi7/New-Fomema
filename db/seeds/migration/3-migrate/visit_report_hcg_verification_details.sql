\echo "visit_report_hcg_verification_details.sql loaded"

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
                '26_16'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS details_type,
                    a[2] AS laboratory_name,
                    a[3] AS referred_laboratory_send_record
                    INTO result
                FROM (
                    SELECT string_to_array(replace(replace(replace(replace(r,'%20',' '),'%2C',','),'%28','('),'%29',')'), '^')
                ) AS dt(a);

                IF result.details_type = 'CONDUCTED' THEN
                    INSERT INTO visit_report_hcg_verification_details (
                        hcg_verification_detailable_type,
                        hcg_verification_detailable_id,
                        conducted,
                        referred_laboratory_name,
                        referred_laboratory_send_record,
                        created_at,
                        updated_at,
                        created_by,
                        updated_by
                    ) 
                    VALUES (
                        'VisitReportUrinePregnancyTest',
                        temp_row.id,
                        'true',
                        result.laboratory_name,
                        CASE WHEN result.referred_laboratory_send_record = 'YES' THEN 'YES'
                        WHEN result.referred_laboratory_send_record = 'NO' THEN 'NO'
                        ELSE null END,
                        temp_row.created_at,
                        temp_row.updated_at,
                        temp_row.created_by,
                        temp_row.updated_by
                    );
                ELSIF result.details_type = 'REFERRED LABORATORY' THEN 
                    INSERT INTO visit_report_hcg_verification_details (
                        hcg_verification_detailable_type,
                        hcg_verification_detailable_id,
                        referred_laboratory,
                        referred_laboratory_name,
                        referred_laboratory_send_record,
                        created_at,
                        updated_at,
                        created_by,
                        updated_by
                    ) 
                    VALUES (
                        'VisitReportUrinePregnancyTest',
                        temp_row.id,
                        'true',
                        result.laboratory_name,
                        CASE WHEN result.referred_laboratory_send_record = 'N/A' THEN null 
                        ELSE result.referred_laboratory_send_record END,
                        temp_row.created_at,
                        temp_row.updated_at,
                        temp_row.created_by,
                        temp_row.updated_by
                    );
                END IF;

            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_hcg_verification_details.sql - urine_pregnancy done"

\echo "visit_report_hcg_verification_details.sql ended"