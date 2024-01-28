# staging - public: pgm-zf869fh6t87yp6qnco.pgsql.kualalumpur.rds.aliyuncs.com
# production - public: pgm-zf8925x192450oh32o.pgsql.kualalumpur.rds.aliyuncs.com
# 0 3 * * * /home/fong/fomema-logs/daily.sh >> /home/fong/fomema-logs/job.log 2>1&

DATEM1="$(date --date='-8 days' +'%Y%m%d')"
DATESQL="$(date --date='-7 days' +'%Y-%m-%d')"
#DATEM1="$(date -v-8d +'%Y%m%d')"
#DATESQL="$(date -v-7d +'%Y-%m-%d')"
BACKUP_DIR="/home/fong/fomema-logs/$DATEM1"
HOST="pgm-zf8925x192450oh32o.pgsql.kualalumpur.rds.aliyuncs.com"
PORT="1921"
DB="fomema"
USER="deployer"
echo $DATEM1
echo $DATESQL
echo $BACKUP_DIR

mkdir -p $BACKUP_DIR
array=( fongtest fongtest2 )
for TABLE in "${array[@]}"
do
    echo "### $TABLE ###"
    pg_dump -U $USER --host=$HOST --port=$PORT -t $TABLE $DB > "$BACKUP_DIR/$TABLE-$DATEM1.sql"
    psql -U $USER --host=$HOST --port=$PORT $DB -c "delete from $TABLE where created_at < '$DATESQL';"
    psql -U $USER --host=$HOST --port=$PORT $DB -c "vacuum $TABLE;"
done

gzip -f $BACKUP_DIR/*.sql
