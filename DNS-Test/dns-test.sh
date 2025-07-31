#/bin/bash
#Get Top 1 M CSV
aria2c wget https://tranco-list.eu/top-1m.csv.zip
unzip -u top-1m.csv.zip
dos2unix top-1m.csv
INPUT=top-1m.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read number domain
do
	echo "\n$number" - "$domain"
	dig +noall +answer any $domain @193.192.98.30 | tail -n1
done < $INPUT
IFS=$OLDIFS
