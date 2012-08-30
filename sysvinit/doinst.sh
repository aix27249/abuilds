
# Make backup of old init in case of epic failure:
if [ -r sbin/init ] ; then
	mv sbin/init sbin/init.old
fi

mv sbin/init.new sbin/init

if [ ! -r var/log/btmp ] ; then
	( cd var/log && umask 077 && touch btmp )
fi

# Everybody things that restarting init on install is a good idea. Ok, let's do it too:
if [ "`pwd`" = "/" ] ; then
	/sbin/init u
fi
