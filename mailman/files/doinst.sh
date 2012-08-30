# Make sure the group and user "mailman" exists on this system and has the correct values
file /bin/bash | grep x86-64 >/dev/null
if [ "$?" = "0" ] ; then
	LIBDIRSUFFIX=64
else
	echo ""
fi
if grep -q "^mailman:" /etc/group &> /dev/null ; then
	groupmod -g 83 -n mailman mailman &> /dev/null
else
	groupadd -g 83 mailman &> /dev/null
fi
if grep -q "^mailman:" /etc/passwd 2> /dev/null ; then
	usermod -s /sbin/nologin -c "GNU Mailing List Manager" -d /usr/lib$LIBDIRSUFFIX/mailman -u 83 -g mailman mailman &> /dev/null
else
	useradd -s /sbin/nologin -c "GNU Mailing List Manager" -d /usr/lib$LIBDIRSUFFIX/mailman -u 83 -g mailman -M -r mailman &> /dev/null
fi

cd /usr/lib$LIBDIRSUFFIX/mailman && bin/check_perms > /dev/null
