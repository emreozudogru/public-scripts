#!/bin/bash
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#

# set your options here
#
#CONFIGDIR='/opt/MailScanner/etc';
CONFIGDIR='/etc/MailScanner';
THEURL='http://phishing.mailscanner.info/phishing.bad.sites.conf';


PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/etc:/usr/local/bin:/usr/sfw/bin
export PATH

if [ -d $CONFIGDIR ]; then
    cd $CONFIGDIR
else
    logger -p mail.warn -t update.phishing.sites Cannot find MailScanner configuration directory, update failed.
    echo Cannot find MailScanner configuration directory.
    echo Auto-updates of phishing.bad.sites.conf will not happen.
    exit 1
fi

# check for the custom config file and create if missing
if [ ! -f $CONFIGDIR/phishing.bad.sites.custom ]; then
	echo '# Add your custom Phishing bad sites to the' >> $CONFIGDIR/phishing.bad.sites.custom
	echo '# phishing.bad.sites.custom file in your MailScanner' >> $CONFIGDIR/phishing.bad.sites.custom 
	echo '# directory. Note that phishing.bad.sites.conf is' >> $CONFIGDIR/phishing.bad.sites.custom
	echo '# overwritten when update_bad_phishing_sites is executed.' >> $CONFIGDIR/phishing.bad.sites.custom
	echo '#' >> $CONFIGDIR/phishing.bad.sites.custom
fi

curl --compressed -o $CONFIGDIR/phishing.bad.sites.conf.master $THEURL || \
wget --no-check-certificate -O $CONFIGDIR/phishing.bad.sites.conf.master $THEURL || \
( logger -p mail.warn -t update.bad.phishing.sites Cannot find wget or curl, update failed. ; echo Cannot find wget or curl to do phishing sites update. ; exit 1 )

if [ -s phishing.bad.sites.conf.master ]; then
    cat phishing.bad.sites.custom phishing.bad.sites.conf.master | \
    uniq > phishing.bad.sites.conf.new
    rm -f phishing.bad.sites.conf
    mv -f phishing.bad.sites.conf.new phishing.bad.sites.conf
    chmod a+r phishing.bad.sites.conf
    logger -p mail.info -t update.bad.phishing.sites Phishing bad sites list updated
else
    logger -p mail.info -t update.bad.phishing.sites Phishing bad sites list update failed!
fi
rm -f phishing.bad.sites.conf.master

exit 0


