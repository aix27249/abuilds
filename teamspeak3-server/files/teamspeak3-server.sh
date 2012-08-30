#!/bin/bash

. /etc/conf.d/teamspeak3-server

ARCH=`arch`
cd /var/lib/teamspeak3-server/
if [ $ARCH == "x86_64" ]; then
    LD_LIBRARY_PATH="${LIB_PATH}:${LD_LIBRARY_PATH}" /opt/teamspeak3-server/ts3server_linux_amd64 $TS_ARGS
else
    LD_LIBRARY_PATH="${LIB_PATH}:${LD_LIBRARY_PATH}" /opt/teamspeak3-server/ts3server_linux_x86 $TS_ARGS
fi
exit $?
