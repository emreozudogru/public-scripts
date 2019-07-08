#!/bin/bash
zaman=$(date +"%m-%d-%Y %T")
/usr/bin/mailq |grep -B 1 "550 5.1.1"|grep "^[A-F0-9]"|awk '{print $1}'|/usr/sbin/postsuper -d -
qcount=$(/usr/bin/mailq | grep -c "^[A-F0-9]")
rcount=$(/sbin/iptables -L -n |wc -l)
echo $zaman "Mail     :" $qcount >> /root/Scripts/que-size.log
echo $zaman "Iptables :" $rcount >> /root/Scripts/que-size.log
/usr/sbin/postqueue -p | grep -v "musterihizmetleri@turk.net"| awk '/^[0-9,A-F]/ {print $7}' | sort | uniq -c | sort -n > /root/Scripts/que.out
while read -r a b; do
if [ "$a" -gt 50 ]
then
echo $(date) $a $b >> /root/Scripts/que-del.log
echo $(date) >> /root/Scripts/que-del-perl.log
/usr/bin/perl /root/Scripts/postfix-delete.pl $b >> /root/Scripts/que-del-perl.log 2>&1
echo "---------------------------------------------------" >> /root/Scripts/que-del-perl.log
fi
done < /root/Scripts/que.out 
