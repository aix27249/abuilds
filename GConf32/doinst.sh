ldconfig -r .
chmod 755 etc/gconf/gconf.xml.system
if [ "`uname -m`" = "x86_64" ] ; then
	usr/bin/gio-querymodules usr/lib64/gio/modules
else
	usr/bin/gio-querymodules usr/lib/gio/modules
fi
