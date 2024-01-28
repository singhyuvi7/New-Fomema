\echo "visit_report_bfmp_details.sql loaded"

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
                '14_16'
            ) AND lb.datavalue IS NOT NULL
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.datavalue, '|') LOOP

                SELECT 
                    a[1] AS name,
                    a[2] AS laboratory_name,
                    a[3] AS referred_laboratory_send_record
                    INTO result
                FROM (
                    SELECT string_to_array(replace(r,'%20',' '), '^')
                ) AS dt(a);

                INSERT INTO visit_report_bfmp_details (
                    bfmp_detailable_type,
                    bfmp_detailable_id,
                    name,
                    laboratory_name,
                    referred_laboratory_send_record,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    'VisitReportMalariaScreening',
                    temp_row.id,
                    result.name,
                    result.laboratory_name,
                    CASE WHEN result.referred_laboratory_send_record = 'N/A' THEN null 
                    ELSE result.referred_laboratory_send_record END,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_bfmp_details.sql - malaria screening done"

\echo "visit_report_bfmp_details.sql ended"