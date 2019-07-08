#!/bin/bash

#Config Backup
rsync -az /etc tnlbuser@212.154.100.22:/home/tnlbuser/Dun/TN_SMTPGW1

# Home Folder Backup
rsync -az /home/sistem tnlbuser@212.154.100.22:/home/tnlbuser/Dun/TN_SMTPGW1

# root Folder Backup
rsync -az /root tnlbuser@212.154.100.22:/home/tnlbuser/Dun/TN_SMTPGW1


# maillog Folder Backup

#rsync -az --exclude='lastlog' /var/log/ tnlbuser@212.154.100.22:/home/tnlbuser/Dun/TN_SMTPGW1/logs
