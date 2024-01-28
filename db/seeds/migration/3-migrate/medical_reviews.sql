/*
Release Request
    qrrid   numeric(18,0)
    trans_id    varchar(14)
    comments    varchar(4000)
    status  varchar(5) --> I don't think this is necessary, just look at release approval to check. This is more important for TCUPI.
        status  count
        Medical PR only
        P   84 -- Pending for approval
        A   625253 -- Approved -> Only for medstatus = Y or N
        R   4064 -- Rejected -> Only for medstatus = Y or N
        PT  0    -- Request for TCUPI pending for approval
        AT  48132 -- Request for TCUPI Approved
        RT  1676 -- Request for TCUPI Rejected

        -- This is interesting, this is only in Medical PR, after TCUPI has started, it will become AT (Request for TCUPI Approved).
        -- This is in Medical PR only, but need to create new instance of TCUPI as well, otherwise the flow wont be correct in new system.
        ATP 12 -- Tcupi Approved & Pending Investigation. -> Looks like this will be become AT when TCUPI begins. A new request will be made after that.

        TCUPI only
        TP  0    -- Pedning Review Tcupi Pending (pending release approval)
        TA  48131 -- Pending Review tcupi approved
        TR  1213 -- Pending review tcupi rejected


    - 2020-10-26 -> Additional statuses
    define('PENDING_REVIEW_TCUPI_PENDING',TP);
    define('PENDING_REVIEW_TCUPI_PENDING_SAVE',TPS);
    define('PENDING_REVIEW_TCUPI_APPROVED',TA);
    define('PENDING_REVIEW_TCUPI_REJECTED_PENDING',TRP);
    define('PENDING_REVIEW_TCUPI_REJECTED',TR);

        TCUPI only
        TPS -- In Tcupi, was saved.
        TRP -- In Tcupi, was rejected, pending new tcupi.



    medstatus   character(1)
        Y Unsuitable
        N Suitable
        T TCUPI

    request_by  numeric(10,0)
    creation_date   timestamp

Release Approval
    qrrid
    status - A or R
    comments
    approval_id - 397
    approval_date - datetime

*/

\echo "medical_reviews.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        loop_counter integer := 0;
        start_range integer := 0;
        end_range integer := 0;
    BEGIN
        select start_migration_log('medical_reviews.sql') into v_log_id;
        commit;

        loop
            exit when loop_counter = 3;
            raise notice 'Loop counter -> %', loop_counter;
            start_range := 250000 * loop_counter;
            end_range := start_range + 250000;
            raise notice 'qrrid Range -> % to %', start_range, end_range;

            insert into medical_reviews (
                transaction_id,
                medical_mle1_id,
                medical_mle1_decision,
                medical_mle1_comment,
                medical_mle1_decision_at,
                medical_mle2_id,
                medical_mle2_decision,
                medical_mle2_comment,
                medical_mle2_decision_at,
                created_at,
                updated_at,
                qrrid
            )
            select
                local_trans.id,
                mle1.id,
                case when qr_request.medstatus = 'Y' then 'UNSUITABLE' when qr_request.medstatus = 'N' then 'SUITABLE' when qr_request.medstatus = 'T' then 'TCUPI' else null end,
                qr_request.comments,
                qr_request.creation_date,
                mle2.id,
                case when qr_approval.status = 'A' then 'APPROVE' when qr_approval.status = 'R' then 'REJECT' else null end,
                qr_approval.comments,
                qr_approval.approval_date,
                coalesce(qr_request.creation_date, clock_timestamp()),
                coalesce(qr_approval.approval_date, qr_request.modify_date, qr_request.creation_date, clock_timestamp()),
                qr_request.qrrid
            from
                fomema_backup_nios.quarantine_release_request qr_request
                join transactions local_trans on qr_request.trans_id = local_trans.code
                left join fomema_backup_nios.quarantine_release_approval qr_approval on qr_approval.qrrid = qr_request.qrrid
                left join fomema_backup_nios.v_user_master request_user on qr_request.request_by = request_user.uuid
                left join users mle1 on request_user.userid = mle1.code
                left join fomema_backup_nios.v_user_master approval_user on qr_approval.approval_id = approval_user.uuid
                left join users mle2 on approval_user.userid = mle2.code
            where
                qr_request.status not in ('TP', 'TA', 'TR', 'TPS', 'TRP') -- Omit TCUPI related.
                and qr_request.qrrid > start_range and qr_request.qrrid <= end_range
            order by
                qr_request.qrrid;

            loop_counter := loop_counter + 1;
        end loop;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_reviews.sql ended"