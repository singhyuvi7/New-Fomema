/*
psql -U deployer -W --host=pgm-zf8925x192450oh360350.pgsql.kualalumpur.rds.aliyuncs.com --port=1921 fomema -f all.sql 2>&1 | tee -a ~/logs/all-20201002.sql.log
*/

\i all-copy.sql;

\i all-index.sql;
