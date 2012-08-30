# Adding spectrum user and group
GRP=`cat etc/group | grep spectrum | head -n 1`
if [ "$GRP" = "" ] ; then
	echo "Creating group spectrum"
	chroot . groupadd spectrum
fi
# Create user if not exists
USR=`cat etc/passwd | grep spectrum | head -n 1`
if [ "$USR" = "" ] ; then
	echo "Creating user spectrum"
	chroot . useradd -g spectrum -d /var/lib/spectrum spectrum
fi
chroot . chown -R spectrum:spectrum /var/lib/spectrum
chroot . chown -R spectrum:spectrum /var/log/spectrum
chroot . chown -R spectrum:spectrum /var/run/spectrum

echo ""
echo "===================================================================="
echo "There is no way to launch spectrum using /etc/init.d yet. Please"
echo "use 'spectrumctl start' with root privileges. Make sure you have"
echo "per-protocol configs in /etc/spectrum!"
echo "===================================================================="
