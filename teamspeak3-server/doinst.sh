# Adding teamspeak3 user and group
GRP=`cat etc/group | grep teamspeak3 | head -n 1`
if [ "$GRP" = "" ] ; then
	echo "Creating group teamspeak3"
	chroot . groupadd teamspeak3
fi
# Create user if not exists
USR=`cat etc/passwd | grep teamspeak3 | head -n 1`
if [ "$USR" = "" ] ; then
	echo "Creating user teamspeak3"
	chroot . useradd -g teamspeak3 -d /var/lib/teamspeak3-server/ teamspeak3
fi
chroot . chown -R teamspeak3:teamspeak3 /var/lib/teamspeak3-server/
