#!/bin/bash
# Update SMTP Gateway Server Scripts
# Version: 1.0.1.2009080000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L https://gitlab.com/emreozudogru/public-scripts/raw/master/update-smtpgw.sh | sudo sh
#
# Download and update common files
curl -L https://gitlab.com/emreozudogru/public-scripts/raw/master/update-common.sh | sudo sh

# Download and update shared files
shared=( spamhaus-ban.sh )
for i in "${shared[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/emreozudogru/public-scripts/raw/master/shared/$i -O /usr/local/bin/$i
	chmod +x /usr/local/bin/$i
done
if grep "sh /usr/local/bin/spamhaus-ban.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "0 */6 * * * sh /usr/local/bin/spamhaus-ban.sh" >>  /var/spool/cron/root; fi

# Download and update spesific files
mkdir -p /root/Scripts
array=( update.bad.phising.sh kuyrukkontrol2019.sh mailsil.sh postfix-delete.pl)
for i in "${array[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/emreozudogru/public-scripts/raw/master/smtpgw/$i -O /usr/local/bin/$i
	chmod +x /usr/local/bin/$i
done

if grep "/usr/local/bin/update.bad.phising.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "0 */4 * * * /usr/local/bin/update.bad.phising.sh" >>  /var/spool/cron/root; fi
if grep "/usr/local/bin/kuyrukkontrol2019.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "*/30 * * * * sh /usr/local/bin/kuyrukkontrol2019.sh" >>  /var/spool/cron/root; fi
#if grep "/usr/local/bin/mailsil.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "*/5 * * * * /usr/local/bin/mailsil.sh" >>  /var/spool/cron/root; fi
if grep "find /var/dcc/log/ -name "msg.*" -print0 | xargs -0 rm" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "* 1 * * * find /var/dcc/log/ -name "msg.*" -print0 | xargs -0 rm" >>  /var/spool/cron/root; fi
if grep "rm -rf /var/EFA/backup/backup-*" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "* 1 * * *  rm -rf /var/EFA/backup/backup-*" >>  /var/spool/cron/root; fi

/usr/local/bin/update.bad.phising.sh
/usr/local/bin/kuyrukkontrol2019.sh
#/usr/local/bin/mailsil.sh
/usr/local/bin/spamhaus-ban.sh
find /var/dcc/log/ -name "msg.*" -print0 | xargs -0 rm
rm -rf /var/EFA/backup/backup-*
