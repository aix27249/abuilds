# Add udev-postmount to default runlevel, but only if doing system update: at system installation time, it should be done by installer.
if [ "`pwd`" = "/" ] ; then
	if ! rc-update | grep -q udev-postmount; then
		rc-update add udev-postmount default
	fi
fi
