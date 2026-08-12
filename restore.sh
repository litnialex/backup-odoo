#!/bin/sh


set -e
alias s3cmd="s3cmd --host=$S3_ENDPOINT --host-bucket=$S3_ENDPOINT --config=/root/s3cfg"

mkdir -p /var/lib/odoo

export latest_rev=`duplicacy list | tail -n 1 | awk '{print $4}'`
duplicacy restore -overwrite -delete -r $latest_rev
echo 'Filestore restored from S3'
chown -R 101:101 /var/lib/odoo

cd /var/lib/backup
s3cmd get -e -q --force $S3_BUCKET/latest.dump.gz restore.dump.gz
echo 'Latest backup restored from S3'

echo 'CREATE DATABASE "15_od.projectname.pl" WITH OWNER odoo' | psql -U odoo -d template1
[ -f restore.dump ] || gzip -d restore.dump.gz
cat restore.dump  | psql -U odoo -d 15_od.projectname.pl
