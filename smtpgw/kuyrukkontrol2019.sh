#cikti=$(/usr/bin/mailq | awk '{print $7}' | tr ' @ ' ' ' | awk '{print $2}' | tr '.' ' ' | awk '{print $1}'| grep -v -e '^$' | grep -v 'hotmail\|yahoo\|gmail\|' | /bin/sort | /usr/bin/uniq -c | /bin/sort -n > /root/Scripts/ciktikuyruk2019.txt)
cikti=$(/usr/bin/mailq | awk '{print $7}' | tr ' @ ' ' ' | awk '{print $2}' | grep -v -e '^$' | grep -v 'hotmail.com\|yahoo.com\|gmail.com' | /bin/sort | /usr/bin/uniq -c | /bin/sort -n > /root/Scripts/ciktikuyruk2019.txt)
#cikti=$(/usr/bin/mailq | awk '{print $7}' | tr ' @ ' ' ' | awk '{print $2}' | grep -v -e '^$' | /bin/sort | /usr/bin/uniq -c | /bin/sort -n >> /root/Scripts/ciktikuyruk2019.txt)
#cat /root/Scripts/ciktikuyruk2019.txt
perl /root/Scripts/postfix-delete.pl MAILER
#echo $cikti
while read -r i j; do

if [ "$i" -gt "100" ]; then

perl /root/Scripts/postfix-delete.pl $j


fi

done < /root/Scripts/ciktikuyruk2019.txt

