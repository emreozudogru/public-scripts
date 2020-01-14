#!/bin/bash
# Install Zabbix Agent
# Version: 1.0.0.1900000000
# Script written by Emre Ozudogru
#
# To update this file to last version please run following:
# curl -L https://gitlab.com/frmax/public-scripts/raw/master/install_zabbix-agent.sh | sudo sh
#
# Detect OS Version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
#elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    #...
#elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    #...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi

#Install Zabbix Agent
echo OS: $OS
echo Ver: $VER
if [ $OS -eq "CentOS" ]; then
echo OS is CentOS
else
echo OS not detected
fi


