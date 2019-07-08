#!/bin/bash

/usr/sbin/postqueue -p | grep -i daemon | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i cagdasbulten.com | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i root@smtp | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i mail@sgmail3.com | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i cagdasbulten | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i daemon | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i e-godex.com | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i e-godex.com | cut -c1-10 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i root@smtp | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i mail@sgmail3.com | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i cagdasbulten | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -
/usr/sbin/postqueue -p | grep -i bounce | cut -c1-11 | sed 's/  *$//;/^$/d' | /usr/sbin/postsuper -d -

