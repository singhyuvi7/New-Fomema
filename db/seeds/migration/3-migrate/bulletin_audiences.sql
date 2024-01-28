\echo "bulletin_audiences.sql loaded"

-- target xray, radiologist, lab, doctor without specific users
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bulletin_audiences.sql - target X,R,L,D without specific users') into v_log_id;
        commit;

        insert into bulletin_audiences (
            bulletin_id,
            bulletin_audienceable_type,
            created_at,updated_at
        )
        select bl.id, 
        case when bm.target = 'X' then 'XrayFacility' 
        when bm.target = 'R' then 'Radiologist' 
        when bm.target = 'L' then 'Laboratory' 
        when bm.target = 'D' then 'Doctor' end,
        bl.created_at, bl.updated_at
        from bulletins bl 
        join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
        where bm.target in ('X','R','L','D');

        perform end_migration_log(v_log_id);
    END
$$;
\echo "bulletin_audiences.sql - target X,R,L,D without specific users done"

-- target all without specific users
DO $$
    DECLARE
        temp_row RECORD;
        v_log_id bigint;
        audience text;
        audiences varchar[] := ARRAY['Doctor','Laboratory','XrayFacility','Radiologist'];
    BEGIN
        select start_migration_log('bulletin_audiences.sql - target all without specific users') into v_log_id;
        commit;


        FOR temp_row IN
            select bl.id, bl.created_at, bl.updated_at
            from bulletins bl 
            join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
            where bm.target = 'A'
        LOOP
            FOREACH audience IN ARRAY audiences LOOP
                insert into bulletin_audiences (
                    bulletin_id,
                    bulletin_audienceable_type,
                    created_at,updated_at
                ) values (
                    temp_row.id,
                    audience,
                    temp_row.created_at, temp_row.updated_at
                );
            END LOOP; 
        END LOOP;

        perform end_migration_log(v_log_id);
    END
$$;
\echo "bulletin_audiences.sql - target all without specific users done"

-- target specific users
DO $$
    DECLARE
        v_log_id bigint;
    BEGIN
        select start_migration_log('bulletin_audiences.sql - target specific users') into v_log_id;
        commit;

        insert into bulletin_audiences (
            bulletin_id,
            bulletin_audienceable_type,
            bulletin_audienceable_id,
            created_at,updated_at
        )
        select bl.id, 
        'XrayFacility',
        sp.id,
        bl.created_at, bl.updated_at
        from bulletins bl 
        join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
        join fomema_backup_nios.bulletin_target bt on bm.bulletinid = bt.bulletinid
        join xray_facilities sp on bt.usercode = sp.code
        where bm.target = 'U' and bt.usercode like 'X%';

        insert into bulletin_audiences (
            bulletin_id,
            bulletin_audienceable_type,
            bulletin_audienceable_id,
            created_at,updated_at
        )
        select bl.id, 
        'Radiologist',
        sp.id,
        bl.created_at, bl.updated_at
        from bulletins bl 
        join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
        join fomema_backup_nios.bulletin_target bt on bm.bulletinid = bt.bulletinid
        join radiologists sp on bt.usercode = sp.code
        where bm.target = 'U' and bt.usercode like 'R%';

        insert into bulletin_audiences (
            bulletin_id,
            bulletin_audienceable_type,
            bulletin_audienceable_id,
            created_at,updated_at
        )
        select bl.id, 
        'Laboratory',
        sp.id,
        bl.created_at, bl.updated_at
        from bulletins bl 
        join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
        join fomema_backup_nios.bulletin_target bt on bm.bulletinid = bt.bulletinid
        join laboratories sp on bt.usercode = sp.code
        where bm.target = 'U' and bt.usercode like 'L%';

        insert into bulletin_audiences (
            bulletin_id,
            bulletin_audienceable_type,
            bulletin_audienceable_id,
            created_at,updated_at
        )
        select bl.id, 
        'Doctor',
        sp.id,
        bl.created_at, bl.updated_at
        from bulletins bl 
        join fomema_backup_nios.bulletin_master bm on bl.reference_id = bm.bulletinid
        join fomema_backup_nios.bulletin_target bt on bm.bulletinid = bt.bulletinid
        join doctors sp on bt.usercode = sp.code
        where bm.target = 'U' and bt.usercode like 'D%';

        perform end_migration_log(v_log_id);
    END
$$;
\echo "bulletin_audiences.sql - target specific users done"

\echo "bulletin_audiences.sql ended"
