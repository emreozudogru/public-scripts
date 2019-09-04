#!/bin/bash
# Update Mail Server Scripts
# Version: 1.0.0.1900000000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L https://gitlab.com/frmax/public-scripts/raw/master/update-mail.sh | sudo sh
#

# Download and update common files
curl -L https://gitlab.com/frmax/public-scripts/raw/master/update-common.sh | sudo sh

# Download and update shared files
shared=( spamhaus-ban.sh )
for i in "${shared[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/frmax/public-scripts/raw/master/shared/$i -O /root/Scripts/$i
	chmod +x /root/Scripts/$i
done
if grep "sh /root/Scripts/spamhaus-ban.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "0 */6 * * * sh /root/Scripts/spamhaus-ban.sh" >>  /var/spool/cron/root; fi

# Download and update spesific files
spesific=( transport-queue-check.sh )
for i in "${spesific[@]}"
do
	echo $i
	wget --backups=1 https://gitlab.com/frmax/public-scripts/raw/master/mail/$i -O /root/Scripts/$i
	chmod +x /root/Scripts/$i
done