/*
psql -U deployer -W fomema_backup -f all-backup.sql 2>&1 | tee -a ~/logs/all-backup-20201028.sql.log
*/

\i 1-prepare-schema.sql;

\i 2-1-backup-nios-master.sql;

\i 2-2-backup-nios-transaction.sql;

\i 2-3-backup-nios-log.sql;

\i 2-4-backup-nios-history.sql;

\i 2-5-backup-portal.sql;

\i 2-6-backup-moh.sql;
