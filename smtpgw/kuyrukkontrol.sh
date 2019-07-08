#!/bin/bash

command=`/usr/sbin/postqueue -p|grep Requests|awk '{print $5}'`
fieldNum="1"

#threshold=100        #sinir deger
#echo $command
#xx=$($command | cut -f$fieldNum -d' ')
xx=$(/usr/sbin/postqueue -p|/bin/grep Requests|/bin/awk '{print $5}')
#xx=$($command)
#echo $xx

MAILQ=`echo ""; /usr/bin/mailq > /root/Scripts/mailq.txt; cat /root/Scripts/mailq.txt | awk '{print $7}' | sort | uniq -c | sort -n | tail`

if [ $xx -ge 2000 ] ; then
        echo "smtpgw1.turk.net kuyrugunda yogunluk var. Kuyruktaki mail adedi: $xx $MAILQ"|/bin/mail -s "smtpgw1.turk.net kuyrugunda yogunluk var" sistem@turknet.net.tr noc@netone.net.tr
fi
