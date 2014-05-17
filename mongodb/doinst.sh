[ "`cat etc/group | grep ^mongodb:`" = "" ] && chroot . groupadd mongodb
if [ "`cat etc/passwd | grep ^mongodb:`" = "" ] ; then
	useradd -r -g mongodb -d /var/lib/mongodb -s /bin/bash mongodb
fi
chroot . chown -R mongodb:daemon /var/lib/mongodb
chroot . chown -R mongodb:daemon /var/log/mongodb

