\echo "visit_report_visitors.sql loaded"

-- officer 1
insert into visit_report_visitors (
    visit_report_id, visitor_id,
    created_at,updated_at,
    created_by,updated_by
) 
select vr.id, users.id,
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by
from fomema_backup_nios.visit_rpt_docxray rpt 
join visit_reports vr on rpt.report_id = vr.report_id
left join users users on rpt.fomema_officer1 = users.code
where rpt.fomema_officer1 is not null;

-- officer 2
insert into visit_report_visitors (
    visit_report_id, visitor_id,
    created_at,updated_at,
    created_by,updated_by
) 
select vr.id, users.id,
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by
from fomema_backup_nios.visit_rpt_docxray rpt 
join visit_reports vr on rpt.report_id = vr.report_id
left join users users on rpt.fomema_officer2 = users.code
where rpt.fomema_officer2 is not null;

-- officer 3
insert into visit_report_visitors (
    visit_report_id, visitor_id,
    created_at,updated_at,
    created_by,updated_by
) 
select vr.id, users.id,
    vr.created_at, vr.updated_at,
    vr.created_by, vr.updated_by
from fomema_backup_nios.visit_rpt_docxray rpt 
join visit_reports vr on rpt.report_id = vr.report_id
left join users users on rpt.fomema_officer3 = users.code
where rpt.fomema_officer3 is not null;

\echo "visit_report_visitors.sql (doc and xray) done"

-- lab

DO $$
    DECLARE
        insp_name text;
        temp_row RECORD;
        visitor_id bigint; 
    begin
        FOR temp_row IN
            SELECT visit_reports.id as id, lb.insp_team, lb.creation_date, lb.modify_date
            FROM fomema_backup_nios.visit_rpt_labmaster lb 
            JOIN visit_reports ON lb.report_id = visit_reports.report_id
            where insp_team is not null
        LOOP
            FOREACH insp_name IN ARRAY string_to_array(temp_row.insp_team, ',') LOOP

                SELECT id into visitor_id from users where name = insp_name;

                IF visitor_id IS NOT NULL THEN
                    INSERT INTO visit_report_visitors (
                        visit_report_id,
                        visitor_id,
                        created_at,
                        updated_at
                    ) 
                    VALUES (
                        temp_row.id,
                        visitor_id,
                        temp_row.creation_date,
                        temp_row.modify_date
                    );
                END IF;
            END LOOP;
        END LOOP;
    END
$$;

\echo "visit_report_visitors.sql (lab) done"

\echo "visit_report_visitors.sql ended"
