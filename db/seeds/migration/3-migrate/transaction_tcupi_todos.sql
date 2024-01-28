/*
quarantine_tcupi_todolist
    tcupi_todolist_id -- 14
    qrrid
    date_completed
    comments
    createby - joins to v_user_master via uuid
    create_date
    modify_by - KHADIJAH - this joins to v_user_master via userid instead of uuid
    modify_date
    testdone  - Y or N
    others_comments -- if tcupi type is others, use this.

In our system
    1    GP's report on correction of vision
    2    To get the commitment letter from the employer
    3    Repeat ABO (Rh) grouping and send to two different labs
    4    Need verification of ID
    5    Repeat CXR
    6    To audit CXR by FOMEMA
    7    Others
    8    Repeat U/FEME
    9    Renal Profile
    10   FBS and HBA1C
    11   Ultrasound
    12   To get ophthalmologis's report
    13   To get further assessment report
    14   Repeat urine drug
    15   Repeat UPT

In Fomema
    1  Repeat U/FEME
    2   Renal Profile
    3   FBS and HBA1C
    4   Ultrasound
    5   GP's report on correction of vision
    6   To get the commitment letter from the employer
    7   Repeat CXR
    8   To get ophthalmologis's report
    9   To get further assessment report
    10  Repeat ABO (Rh) grouping and send to two different labs
    11  Need verification of ID
    12  Repeat urine drug
    13  Repeat UPT
    14  Others
    15  To audit CXR*
*/

\echo "transaction_tcupi_todos.sql - TcupiReviews - loaded"

DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('transaction_tcupi_todos.sql - TcupiReviews') into v_log_id;
        commit;

        insert into transaction_tcupi_todos (
            tcupi_todo_id,
            done,
            completed_date,
            comment,
            created_at,
            updated_at,
            created_by,
            updated_by,
            tcupi_review_id,
            description_other
        )
        select
            case
                when qtt.tcupi_todolist_id = 1 then 8
                when qtt.tcupi_todolist_id = 2 then 9
                when qtt.tcupi_todolist_id = 3 then 10
                when qtt.tcupi_todolist_id = 4 then 11
                when qtt.tcupi_todolist_id = 5 then 1
                when qtt.tcupi_todolist_id = 6 then 2
                when qtt.tcupi_todolist_id = 7 then 5
                when qtt.tcupi_todolist_id = 8 then 12
                when qtt.tcupi_todolist_id = 9 then 13
                when qtt.tcupi_todolist_id = 10 then 3
                when qtt.tcupi_todolist_id = 11 then 4
                when qtt.tcupi_todolist_id = 12 then 14
                when qtt.tcupi_todolist_id = 13 then 15
                when qtt.tcupi_todolist_id = 14 then 7
                when qtt.tcupi_todolist_id = 15 then 6
                else null end,
            case
                when qtt.testdone = 'Y' then true
                else false end,
            qtt.date_completed,
            qtt.comments,
            coalesce(qtt.create_date, clock_timestamp()),
            coalesce(qtt.create_date, qtt.modify_date, clock_timestamp()),
            creator_local.id,
            case
                when updator_local.id is not null then updator_local.id
                when doctors.id is not null then doctors.id
                end,
            tr.id,
            qtt.others_comments
        from
            fomema_backup_nios.quarantine_tcupi_todolist qtt join tcupi_reviews tr on qtt.qrrid = tr.qrrid
            left join fomema_backup_nios.v_user_master creator_user on qtt.createby = creator_user.uuid
            left join users creator_local on creator_user.userid = creator_local.code
            left join fomema_backup_nios.v_user_master updator_user on qtt.modify_by = updator_user.userid
            left join users updator_local on updator_user.userid = updator_local.code
            left join doctors on qtt.modify_by = doctors.code
        order by
            qtt.qrrid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "transaction_tcupi_todos.sql - TcupiReviews - ended"

\echo "transaction_tcupi_todos.sql - MedicalReviews - loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('transaction_tcupi_todos.sql - MedicalReviews') into v_log_id;
        commit;

        insert into transaction_tcupi_todos (
            tcupi_todo_id,
            done,
            completed_date,
            comment,
            created_at,
            updated_at,
            created_by,
            updated_by,
            medical_review_id,
            description_other
        )
        select
            case
                when qtt.tcupi_todolist_id = 1 then 8
                when qtt.tcupi_todolist_id = 2 then 9
                when qtt.tcupi_todolist_id = 3 then 10
                when qtt.tcupi_todolist_id = 4 then 11
                when qtt.tcupi_todolist_id = 5 then 1
                when qtt.tcupi_todolist_id = 6 then 2
                when qtt.tcupi_todolist_id = 7 then 5
                when qtt.tcupi_todolist_id = 8 then 12
                when qtt.tcupi_todolist_id = 9 then 13
                when qtt.tcupi_todolist_id = 10 then 3
                when qtt.tcupi_todolist_id = 11 then 4
                when qtt.tcupi_todolist_id = 12 then 14
                when qtt.tcupi_todolist_id = 13 then 15
                when qtt.tcupi_todolist_id = 14 then 7
                when qtt.tcupi_todolist_id = 15 then 6
                else null end,
            case
                when qtt.testdone = 'Y' then true
                else false end,
            qtt.date_completed,
            qtt.comments,
            coalesce(qtt.create_date, clock_timestamp()),
            coalesce(qtt.create_date, qtt.modify_date, clock_timestamp()),
            creator_local.id,
            case
                when updator_local.id is not null then updator_local.id
                when doctors.id is not null then doctors.id
                end,
            mr.id,
            qtt.others_comments
        from
            fomema_backup_nios.quarantine_tcupi_todolist qtt join medical_reviews mr on qtt.qrrid = mr.qrrid
            left join fomema_backup_nios.v_user_master creator_user on qtt.createby = creator_user.uuid
            left join users creator_local on creator_user.userid = creator_local.code
            left join fomema_backup_nios.v_user_master updator_user on qtt.modify_by = updator_user.userid
            left join users updator_local on updator_user.userid = updator_local.code
            left join doctors on qtt.modify_by = doctors.code
        order by
            qtt.qrrid;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "transaction_tcupi_todos.sql - MedicalReviews - ended"

\echo "transaction_tcupi_todos.sql - Missed Out Todos - loaded"
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('transaction_tcupi_todos.sql - Missed Out Todos') into v_log_id;
        commit;

        with transaction_ids as (
            select transaction_id from medical_reviews where medical_mle1_decision = 'TCUPI' and id not in (
                select distinct(medical_review_id) from transaction_tcupi_todos where medical_review_id is not null
            )
        ),

        trans_todo_pair as (
            select tr.transaction_id, ttt.tcupi_todo_id, ttt.description_other
            from tcupi_reviews tr join transaction_tcupi_todos ttt on tr.id = ttt.tcupi_review_id
            where transaction_id in (select * from transaction_ids)
            group by transaction_id, tcupi_todo_id, description_other
            order by transaction_id
        )

        insert into transaction_tcupi_todos (
            tcupi_todo_id,
            done,
            created_at,
            updated_at,
            medical_review_id,
            description_other
        )
        select
            tdp.tcupi_todo_id,
            false,
            coalesce(mr.updated_at, clock_timestamp()),
            coalesce(mr.updated_at, clock_timestamp()),
            mr.id,
            tdp.description_other
        from
            medical_reviews mr join trans_todo_pair tdp on mr.transaction_id = tdp.transaction_id
        where
            mr.medical_mle1_decision = 'TCUPI'
        order by
            mr.id;

        perform end_migration_log(v_log_id);
    END
$$;

\echo "transaction_tcupi_todos.sql - Missed Out Todos - ended"