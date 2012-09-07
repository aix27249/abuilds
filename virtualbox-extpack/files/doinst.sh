GRP=`cat etc/group | grep vboxusers | head -n 1`
if [ "$GRP" = "" ] ; then
	chroot . groupadd vboxusers
fi

udevadm control --reload-rules
