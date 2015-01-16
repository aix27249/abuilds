#!/bin/sh

ln -s  usr/lib/qt/bin/qtconfig usr/bin/qtconfig
chmod 777 var/tmp
echo "#"> etc/udev/rules.d/70-persistent-net.rules 
echo "#"> lib/udev/rules.d/80-net-name-slot.rules
