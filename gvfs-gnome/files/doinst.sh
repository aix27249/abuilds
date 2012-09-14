chroot . usr/bin/gio-querymodules usr/lib/gio/modules
# This stuff produces tons of warnings, we know about it, they cannot be solved with this version of gvfs, so let them go to /dev/null:
chroot . usr/bin/glib-compile-schemas usr/share/glib-2.0/schemas 2>/dev/null >/dev/null

if [ "`pwd`" = "/" ] ; then
	killall -USR1 gvfsd > /dev/null
fi

