#!/bin/bash
# Postfix Transport Queue Check
# Version: 1.0.1.1907030000
# Script written by Emre Ozudogru
# To update this file to last version please run following:
#
# wget --backups=1 http://10.2.1.54/sistem/script-mailserver/raw/master/transport-queue-check.sh -O /root/Scripts/transport-queue-check.sh; chmod +x /root/Scripts/transport-queue-check.sh
#
HOSTNAME=$(hostname)
queuesize=$(/usr/sbin/postqueue -p| grep Requests | /bin/awk '{print $5}')
dailyusernames=$(echo ""; grep sasl_username /usr/local/psa/var/log/maillog > /tmp/sasl_username.txt; cat /tmp/sasl_username.txt | awk '{print $9}' | sort | uniq -c | sort -nr | awk '$1 > 700')
mailqueue=$(/usr/sbin/postqueue -p | grep '[0-2][1-9]:[0-6][0-9]:[0-6][0-9]' | awk '{print $7}'| sort | uniq -c | sort -nr| awk '$1 > 100')
if [ $queuesize -ge 500 ]; then
echo -e "Merhaba NOC;\nE-posta iletim kuyrugunda yogunluk olan sunucu: $HOSTNAME\nKuyruktaki e-posta adedi: $queuesize.\n\nBu gun en cok oturum acan kullanicilar:$dailyusernames\n\nIletim kuyrugundaki en cok adina mail gonderilmeye calisilan e-posta adresleri:\n$mailqueue \n\nNOT:\n* Oturum acma sayisinin yuksek olmasi illaki o kullanicida problem oldugunu gostermez. Incelenmesi gerekir.\n* Adina e-posta gonderilmeye calisilan adreslerin ilaki problemli kullaniciya ait olmasi gerekmez, kullanici baska adresler adina e-posta gondermeye calisiyor olabilir." | /bin/mail -s "$HOSTNAME kuyrugunda yogunluk var." sistem@turknet.net.tr noc@turknet.net.tr 
fi
