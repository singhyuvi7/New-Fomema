\echo "visit_report_specimen_tubes.sql loaded"

DO $$
    DECLARE
        datavalue text;
        temp_row RECORD;
        visitor_id bigint; 
    begin
        FOR temp_row IN
            SELECT vr.id as id, lb.datavalue, vr.created_at, vr.updated_at, vr.created_by, vr.updated_by
            FROM fomema_backup_nios.visit_rpt_labdetail lb 
            JOIN visit_reports vr ON lb.report_id = vr.report_id
            where lb.rpt_seq = '01_12' and lb.datavalue is not null
        LOOP
            FOREACH datavalue IN ARRAY string_to_array(temp_row.datavalue, ',') LOOP

                INSERT INTO visit_report_specimen_tubes (
                    visit_report_id,
                    category,
                    created_at,
                    updated_at,
                    created_by,
                    updated_by
                ) 
                VALUES (
                    temp_row.id,
                    case when datavalue = 'LITHIUM HEPARIN' THEN 'LITHIUM_HEPARIN' ELSE datavalue END,
                    temp_row.created_at,
                    temp_row.updated_at,
                    temp_row.created_by,
                    temp_row.updated_by
                );

            END LOOP;
        END LOOP;
    END
$$;

\echo "visit_report_specimen_tubes.sql ended"
