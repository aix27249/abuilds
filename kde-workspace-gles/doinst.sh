#!/bin/sh

if [ -x usr/bin/update-desktop-database ]; then
  usr/bin/update-desktop-database usr/share/applications >/dev/null 2>&1
fi

if [ -x usr/bin/update-mime-database ]; then
  usr/bin/update-mime-database usr/share/mime >/dev/null 2>&1
fi

[ "`cat etc/group | grep ^kdm:`" = "" ] && chroot . groupadd -g 135 kdm
if [ "`cat etc/passwd | grep ^kdm:`" != "" ] ; then
	chroot . usr/sbin/usermod -d /var/lib/kdm -c 'KDE Display Manager' -s /sbin/nologin kdm > /dev/null 2>&1
else
	chroot . usr/sbin/useradd -c 'KDE Display Manager' -u 135 -g kdm -d /var/lib/kdm -s /sbin/nologin kdm
fi
chroot . passwd -l kdm > /dev/null
chroot . chown -R kdm:kdm var/lib/kdm > /dev/null

