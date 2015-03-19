chmod 666 usr/local/share/udev-mount/baza2.dev
chmod 666 usr/local/share/udev-mount/baza2.tmp
chmod 666 usr/local/share/udev-mount/test1
chmod 666 usr/local/share/udev-mount/test
chmod 666 usr/local/share/udev-mount/cd.tmp
chmod 666 usr/local/share/udev-mount/baza_proc
mkdir mnt/sr0
echo "#myuser  ALL=NOPASSWD:/sbin/shutdown,/sbin/poweroff,/usr/bin/eject,/bin/mount,/bin/umount,/usr/sbin/parted">>etc/sudoers


