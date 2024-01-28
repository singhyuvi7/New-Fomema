/*
    fw_appeal_comment
        creator_id          numeric(10,0)
        modification_id     numeric(10,0) - This always seem to be the same as creator id. Lets just ignore.
*/

\echo "medical_appeal_comments.sql loaded"
DO $$
    DECLARE
        v_log_id bigint;
        noreply_user_id int;
    BEGIN
        select start_migration_log('medical_appeal_comments.sql') into v_log_id;
        commit;

        select id into noreply_user_id from users where code = 'NOREPLY' limit 1;

        insert into medical_appeal_comments (
            medical_appeal_id,
            created_by,
            updated_by,
            comment,
            created_at,
            updated_at
        )
        select
            ma.id,
            case
                when comment_user.id is null then noreply_user_id
                else comment_user.id end,
            case
                when comment_user.id is null then noreply_user_id
                else comment_user.id end,
            fac.comments,
            coalesce(fac.creation_date, fac.modification_date, clock_timestamp()),
            coalesce(fac.modification_date, fac.creation_date, clock_timestamp())
        from
            fomema_backup_nios.fw_appeal_comment fac
            join medical_appeals ma on ma.id = fac.appealid
            left join fomema_backup_nios.v_user_master creator_user on fac.creator_id = creator_user.uuid
            left join users comment_user on creator_user.userid = comment_user.code
        order by
            fac.appeal_commentid;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "medical_appeal_comments.sql ended"