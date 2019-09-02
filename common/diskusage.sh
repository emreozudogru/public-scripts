#!/bin/bash
# 
# update code 	
# wget --backups=1 https://gitlab.com/frmax/public-scripts/raw/master/common/diskusage.sh -O /usr/local/bin/diskusage.sh
# if grep "sh /usr/local/bin/diskusage.sh" /var/spool/cron/root; then echo "Entry already in crontab"; else echo "00  * * * * sh /usr/local/bin/diskusage.sh" >>  /var/spool/cron/root; fi
#

#admin email hesabi
ADMIN="sistem@turknet.net.tr"

#destek email hesabi
SUPPORT="noc@turknet.net.tr"

#belirlenen threshold degeri
THRESHOLDPERCENT=90
THRESHOLDBYTE=104857600‬

#hostname
HOSTNAME=$(hostname)

#mail client
MAIL=/bin/mail

# tum disk bilgileri buraya depolaniyor
EMAIL=""

for line in $(df -P | egrep '^/dev/' | awk '{ print $6 "_:_" $5 "-:-" $4 }')
do

        part=$(echo "$line" | awk -F"_:_" '{ print $1 }')
        part_usage_percent=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )
		part_usage_byte=$(echo "$line" | awk -F"-:-" '{ print $2 }' )

        if [ $part_usage_percent -ge $THRESHOLDPERCENT -a -z "$EMAIL" ] && [ $part_usage_byte -ge $THRESHOLDBYTE -a -z "$EMAIL" ];
        then
                EMAIL="$(date): $HOSTNAME sunucusunda disk alani dolmak uzeredir.\n"
                EMAIL="$EMAIL\n$part ($part_usage_percent%) >= (Threshold = $THRESHOLDPERCENT%)\n"
				EMAIL="$EMAIL\n$part ($part_usage_byte%) >= (Threshold = $THRESHOLDBYTE%)"

        elif [ $part_usage_percent -ge $THRESHOLDPERCENT ] && [ $part_usage_byte -ge $THRESHOLDBYTE ];
        then
                EMAIL="$EMAIL\n$part ($part_usage_percent%) >= (Threshold = $THRESHOLDPERCENT%)"
				EMAIL="$EMAIL\n$part ($part_usage_byte%) >= (Threshold = $THRESHOLDBYTE%)"

        fi
done 

if [ -n "$EMAIL" ];
then
        echo -e "$EMAIL" | $MAIL -s "Disk Dolulugu Uyarisi: $HOSTNAME Sunucusunda Yetersiz Disk Alani" "$ADMIN" "$SUPPORT"
fi
