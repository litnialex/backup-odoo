#!/bin/sh


echo BACKUP_IS_STARTED `date`

set -eu

cd /root/

# Copy Odoo files
export DUPLICACY_ATTRIBUTE_THRESHOLD=1
duplicacy backup > /dev/null 2>&1

# Backup postgresql
if [ "$1" = "daily" ]; then
  export name=daily_`date +'%u'`
elif [ "$1" = "weekly" ]; then
  export name=weekly_`date +'%d'`
elif [ "$1" = "monthly" ]; then
  export name=`date '+%Y_%m_%d'`
else
  echo Pass backup parameter
  exit 1
fi

export filename="prod_$name.dump.gz"

cd /var/lib/backup
pg_dump -U odoo prod | gzip > $filename 
s3cmd put -e -q $filename $S3_BUCKET
mv -f $filename latest.dump.gz
s3cmd put -e -q latest.dump.gz $S3_BUCKET

# Remove old files
find /var/lib/backup -type f -name '*.dump.gz' -mtime +30 -exec rm {} \;

echo BACKUP_IS_DONE `date`
