\echo "visit_report_laboratory_personnels.sql loaded"

DO $$
    DECLARE
        r text;
        result RECORD;
        temp_row RECORD;
    begin
        FOR temp_row IN
            SELECT visit_reports.id as id, lb.attd_lab_personnel, lb.creation_date, lb.modify_date
            FROM fomema_backup_nios.visit_rpt_labmaster lb 
            LEFT JOIN visit_reports ON lb.report_id = visit_reports.report_id
            where attd_lab_personnel is not null
        LOOP
            FOREACH r IN ARRAY string_to_array(temp_row.attd_lab_personnel, '|') LOOP
                SELECT 
                    a[1] AS name,
                    a[2] AS designation
                    INTO result
                FROM (
                    SELECT regexp_split_to_array(r, ',')
                ) AS dt(a);

                INSERT INTO visit_report_laboratory_personnels (
                    visit_report_id,
                    name,
                    designation,
                    created_at,
                    updated_at
                ) 
                VALUES (
                    temp_row.id,
                    result.name,
                    result.designation,
                    temp_row.creation_date,
                    temp_row.modify_date
                );
            END LOOP;
        END LOOP;

    END
$$;

\echo "visit_report_laboratory_personnels.sql ended"
