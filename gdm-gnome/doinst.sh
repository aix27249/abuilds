#!/bin/bash
getent group gdm >/dev/null 2>&1 || groupadd -g 120 gdm
if getent passwd gdm > /dev/null 2>&1; then
	chroot . usr/sbin/usermod -d /var/lib/gdm -c 'Gnome Display Manager' -s /sbin/nologin gdm > /dev/null 2>&1
else
	chroot . usr/sbin/useradd -c 'Gnome Display Manager' -u 120 -g gdm -d /var/lib/gdm -s /sbin/nologin gdm
fi
passwd -l gdm > /dev/null
chown -R gdm:gdm var/lib/gdm > /dev/null
chown -R root:gdm var/lib/gdm/.gconf.mandatory

