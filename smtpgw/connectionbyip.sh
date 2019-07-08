netstat -antu |grep 193.192.98.36:25|awk '{print$5}'|sort -n|awk -F ':' '{print$1}' |uniq -c |sort -n
