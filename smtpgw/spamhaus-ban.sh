#!/bin/bash
/sbin/iptables -F
/sbin/iptables -X
/sbin/service iptables stop
/sbin/service iptables start
rm -rf /root/Scripts/drop.lasso
#Script to add firewall rules to a linux system to completely block
#all traffic to and from networks in the spamhaus drop list.

#Copyright 2009, William Stearns, wstearns@pobox.com
#Released under the GPL.  This and other tools can be found at
#http://www.stearns.org/

#Sole (optional) command line parameter is the file location of the
#drop list, such as:

cd /root/Scripts/
wget -nv -N http://www.spamhaus.org/drop/{,e}drop.lasso -O drop.lasso
#wget http://www.spamhaus.org/drop/drop.lasso
# ./spamhaus-drop /var/lib/drop.lasso

#While the DROP file should be regularly updated, this should 
#probably be about once per day or less frequently; do _not_ 
#download DROP more than once an hour.

if [ -n "$1" ]; then
	DropList="$1"
else
	DropList="./drop.lasso"
fi
if [ ! -s "$DropList" ]; then
	echo "Unable to find drop list file $DropList .  Perhaps do:" >&2
	echo "wget https://www.spamhaus.org/drop/drop.lasso -O $DropList"
	echo "exiting." >&2
	exit 1
fi

if [ ! -x /sbin/iptables ]; then
	echo "Missing iptables command line tool, exiting." >&2
	exit 1
fi

cat "$DropList" \
 | sed -e 's/;.*//' \
 | grep -v '^ *$' \
 | while read OneNetBlock ; do
	/sbin/iptables -I INPUT -s "$OneNetBlock" -j DROP
	/sbin/iptables -I OUTPUT -d "$OneNetBlock" -j DROP
	/sbin/iptables -I FORWARD -s "$OneNetBlock" -j DROP
	/sbin/iptables -I FORWARD -d "$OneNetBlock" -j DROP
done
#TurkNet Kara Liste
/sbin/iptables -A INPUT -s 77.73.88.82 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.194 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.195 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.196 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.197 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.198 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.199 -j DROP
/sbin/iptables -A INPUT -s 185.87.122.200 -j DROP
/sbin/iptables -A INPUT -s 185.86.5.231 -j DROP
/sbin/iptables -A INPUT -s 185.86.5.232 -j DROP
/sbin/iptables -A INPUT -s 185.86.5.233 -j DROP
/sbin/iptables -A INPUT -s 185.48.182.162 -j DROP
/sbin/iptables -A INPUT -s 185.132.126.78 -j DROP
/sbin/iptables -A INPUT -s 178.254.6.94 -j DROP
/sbin/iptables -A INPUT -s 185.132.126.79 -j DROP
/sbin/iptables -A INPUT -s 104.223.163.95 -j DROP
/sbin/iptables -A INPUT -s 185.132.126.81 -j DROP
/sbin/iptables -A INPUT -s 160.20.12.176 -j DROP

#TurkNet Beyaz Liste
/sbin/iptables -A INPUT -s 10.2.8.0/24 -p tcp -m tcp --dport 443 -j ACCEPT
/sbin/iptables -A INPUT -s 10.2.1.28/32 -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -s 10.2.8.0/24 -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -s 193.192.97.3/32 -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -s 193.192.97.2/32 -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -s 172.26.1.2/32 -p tcp -m tcp --dport 22 -j ACCEPT
/sbin/iptables -A INPUT -s 193.192.122.63/32 -p tcp -m tcp --dport 22 -j ACCEPT
