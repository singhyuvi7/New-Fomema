/*
psql --host=pgm-zf82wg22ao895g40mo.pgsql.kualalumpur.rds.aliyuncs.com --port=1433 -U deployer -W fomema_stagingali

DROP SERVER IF EXISTS fomema_backup cascade;

CREATE SERVER fomema_backup
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host '172.24.184.162', port '5432', dbname 'fomema_backup');

ALTER SERVER fomema_backup
    OWNER TO deployer;
GRANT USAGE ON FOREIGN SERVER fomema_backup TO deployer;

create user mapping if not exists for deployer server fomema_backup options (user 'deployer', password 'bookdoc#123');
*/

-- variable
--\set local_db_username deployer
\prompt 'enter db username: ' local_db_username
-- /variable

create extension if not exists postgres_fdw;

create schema if not exists fomema_backup_nios;

create schema if not exists fomema_backup_portal;

drop server if exists fomema_backup cascade;

create server if not exists fomema_backup foreign data wrapper postgres_fdw options (host '47.254.234.183', port '5432', dbname 'fomema_backup');
-- create server if not exists fomema_backup foreign data wrapper postgres_fdw options (host '47.254.238.117', port '5432', dbname 'fomema_backup');

drop user mapping if exists for :local_db_username server fomema_backup;

create user mapping if not exists for :local_db_username server fomema_backup options (user 'deployer', password 'bookdoc#123');

grant usage on foreign server fomema_backup to :local_db_username;

\i nios_master.sql;
\i nios_transaction.sql;
\i nios_history.sql;
\i nios_log.sql;
\i portal_all.sql;
