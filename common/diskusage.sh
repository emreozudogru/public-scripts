#!/bin/bash

#admin email hesabi
ADMIN="sistem@turknet.net.tr"

#destek email hesabi
SUPPORT="noc@turknet.net.tr"

#belirlenen threshold degeri
THRESHOLD=95

#hostname
HOSTNAME=$(hostname)

#mail client
MAIL=/bin/mail

# tum disk bilgileri buraya depolaniyor
EMAIL=""

for line in $(df -hP | egrep '^/dev/' | awk '{ print $6 "_:_" $5 }')
do

        part=$(echo "$line" | awk -F"_:_" '{ print $1 }')
        part_usage=$(echo "$line" | awk -F"_:_" '{ print $2 }' | cut -d'%' -f1 )

        if [ $part_usage -ge $THRESHOLD -a -z "$EMAIL" ];
        then
                EMAIL="$(date): $HOSTNAME sunucusunda disk alani dolmak uzeredir.\n"
                EMAIL="$EMAIL\n$part ($part_usage%) >= (Threshold = $THRESHOLD%)"

        elif [ $part_usage -ge $THRESHOLD ];
        then
                EMAIL="$EMAIL\n$part ($part_usage%) >= (Threshold = $THRESHOLD%)"
        fi
done 

if [ -n "$EMAIL" ];
then
        echo -e "$EMAIL" | $MAIL -s "Disk Dolulugu Uyarisi: $HOSTNAME Sunucusunda Yetersiz Disk Alani" "$ADMIN" "$SUPPORT"
fi
