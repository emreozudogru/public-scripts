kontrol="netone.com.tr"
kontrol2=`cat /etc/postfix/domains|grep $3|wc -l`
if [ "$3" == "$kontrol" ]
then
exit 0
elif [ $kontrol2 -eq 0 ]
then
echo $3
echo $3 >> /etc/postfix/domains
echo $3	"	relay:mail01.turknetcloud.com" >> /etc/postfix/transport
postmap hash:/etc/postfix/transport
service MailScanner restart
else
exit 0
fi
