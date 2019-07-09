#!/bin/bash
# Update SMTP Gateway Server Scripts
# Version: 1.0.0.1900000000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L https://gitlab.com/frmax/public-scripts/raw/master/update-smtpgw.sh | sudo sh
#
# Download and update files

array=( update.bad.phising.sh backup.sh kuyrukkontrol2019.sh mailsil.sh)
for i in "${array[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/frmax/public-scripts/raw/master/smtpgw/$i -O /root/Scripts/$i
	chmod +x /root/Scripts/$i
done

if grep "/root/Scripts/update.bad.phising.sh" /var/spool/cron/root; then echo "update.bad.phising.sh Entry already in crontab"; else echo "0 */4 * * * /root/Scripts/update.bad.phising.sh" >>  /var/spool/cron/root; fi
if grep "/root/Scripts/backup.sh" /var/spool/cron/root; then echo "backup.sh Entry already in crontab"; else echo "02 03 * * * sh /root/Scripts/backup.sh" >>  /var/spool/cron/root; fi
if grep "/root/Scripts/kuyrukkontrol2019.sh" /var/spool/cron/root; then echo "kuyrukkontrol2019.sh Entry already in crontab"; else echo "*/30 * * * * sh /root/Scripts/kuyrukkontrol2019.sh" >>  /var/spool/cron/root; fi
if grep "/root/Scripts/mailsil.sh" /var/spool/cron/root; then echo " mailsil.sh Entry already in crontab"; else echo "*/5 * * * * /root/Scripts/mailsil.sh" >>  /var/spool/cron/root; fi

if grep "find /var/dcc/log/ -name "msg.*" -print0 | xargs -0 rm" /var/spool/cron/root; then echo "find Entry already in crontab"; else echo "* 1 * * * find /var/dcc/log/ -name "msg.*" -print0 | xargs -0 rm" >>  /var/spool/cron/root; fi
if grep "rm -rf /var/EFA/backup/backup" /var/spool/cron/root; then echo "/var/EFA/backup/backup Entry already in crontab"; else echo "* 1 * * *  rm -rf /var/EFA/backup/backup-*" >>  /var/spool/cron/root; fi



