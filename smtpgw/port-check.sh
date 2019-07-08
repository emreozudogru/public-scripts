#!/bin/bash
today=`date '+%Y-%m-%d_%H:%M:%S'`;
function checkport {
	if nc -zv -w30 $1 $2 <<< '' &> /dev/null
	then
		echo "[+] $today Port $1/$2 is open"
	else
		echo "[-] $today Port $1/$2 is closed"
	fi
}
checkport 'dns1.turk.net' 53
checkport 'dns-g1.turk.net' 53
checkport 'dns-g2.turk.net' 53
checkport 'dns2.turk.net' 53

