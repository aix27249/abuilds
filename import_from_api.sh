#!/bin/bash
set -e
PKGLIST=`sqlite3 /var/mpkg/packages.db "select distinct package_name from packages;"`
COUNT=`echo $PKGLIST | wc -l`
NOW=0
for i in $PKGLIST ; do
	NOW=`expr $NOW + 1`
	echo '['$NOW'/'$COUNT'] Importing ' $i
	mkdir $i
	rm -f abuild.tar.xz
	wget http://api.agilialinux.ru/bt/$i -O abuild.tar.xz
	( cd $i ; tar xf ../abuild.tar.xz )
done


