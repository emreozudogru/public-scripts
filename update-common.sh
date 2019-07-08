#!/bin/bash
# Update Common Server Scripts
# Version: 1.0.0.1900000000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L http://10.2.1.54/sistem/public-scripts/raw/master/update-common.sh | sudo sh
#
# Download and update files

array=( spamhaus-ban.sh diskusage.sh )
for i in "${array[@]}"
do
	echo $i
	wget --backups=1 http://10.2.1.54/sistem/public-scripts/raw/master/common/$i -O /root/Scripts/$i
	chmod +x /root/Scripts/$i
done