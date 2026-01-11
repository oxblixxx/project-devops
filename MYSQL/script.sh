##
##  THIS SCRIPT IS USED TO DUMB DATABASES IN A MYSQL SERVER
##
USER="root"
#@PASS="your_password"
OUTDIR="/root/db-backup"
SKIP="information_schema|performance_schema|mysql|sys"


cd "$OUTDIR"

mysql -u"$USER"  -e 'SHOW DATABASES;' -s --skip-column-names \
| grep -Ev "$SKIP" \
| while read DB; do
  echo "Dumping $DB"
  mysqldump -u"$USER" "$DB" > "$OUTDIR/${DB}.sql"
done
