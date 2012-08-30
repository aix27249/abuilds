# Create group if not exists
GRP=`cat etc/group | grep jabber | head -n 1`
if [ "$GRP" = "" ] ; then
	echo "Creating group jabber"
	chroot . groupadd jabber
fi

# Create user if not exists
USR=`cat etc/passwd | grep ejabberd | head -n 1`
if [ "$USR" = "" ] ; then
	echo "Creating user ejabberd"
	chroot . useradd -g jabber -d /var/lib/ejabberd ejabberd
fi

# Set new permissions
chroot . chown -R ejabberd:jabber var/log/ejabberd
chroot . chown -R ejabberd:jabber var/spool/ejabberd
chroot . chown -R ejabberd:jabber var/lib/ejabberd
chroot . chown root:jabber usr/libLIBDIRSUFFIX/ejabberd/priv/bin/epam
chroot . chown root:jabber etc/ejabberd/ejabberd.cfg etc/ejabberd/ejabberdctl.cfg etc/ejabberd
chroot . chmod 4750 usr/libLIBDIRSUFFIX/ejabberd/priv/bin/epam

