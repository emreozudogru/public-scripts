#!/bin/bash
# Update Common Server Scripts
# Version: 1.0.0.1900000000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L https://gitlab.com/frmax/public-scripts/raw/master/update-common.sh | sudo sh
#
# Download and update files
mkdir -p /root/Scripts
array=( spamhaus-ban.sh diskusage.sh )
for i in "${array[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/frmax/public-scripts/raw/master/common/$i -O /root/Scripts/$i
	chmod +x /root/Scripts/$i
done

if grep "sh /root/Scripts/spamhaus-ban.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "0 */6 * * * sh /root/Scripts/spamhaus-ban.sh" >>  /var/spool/cron/root; fi
if grep "sh /root/Scripts/diskusage.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "00  * * * * sh /root/Scripts/diskusage.sh" >>  /var/spool/cron/root; fi

sh /root/Scripts/spamhaus-ban.sh
sh /root/Scripts/diskusage.sh
