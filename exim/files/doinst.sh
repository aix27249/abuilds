chroot . getent group exim >/dev/null 2>&1 || chroot . groupadd -g 79 exim 
if chroot . getent passwd exim > /dev/null 2>&1; then
	chroot . usr/sbin/usermod -d /var/spool/exim -c 'Exim MTA' -s /sbin/nologin exim > /dev/null 2>&1
else
	chroot . usr/sbin/useradd -c 'Exim MTA' -u 79 -g exim -d /var/spool/exim -s /sbin/nologin exim 
fi
chroot . passwd -l exim > /dev/null
chroot . chown root.exim /var/spool/exim /var/log/exim
chroot . chown exim.exim /var/spool/exim/db
chroot . chmod u+s /usr/sbin/exim

