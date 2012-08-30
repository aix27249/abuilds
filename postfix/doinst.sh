#!/bin/sh

# Add user and group
if ! grep -q "^postfix:" etc/group; then
    if ! grep -q ":200:" etc/group; then
	chroot . groupadd -g 200 postfix &>/dev/null
    else
	chroot . groupadd postfix &>/dev/null
    fi
fi

if ! grep -q "^postfix:" etc/passwd; then
    if ! grep -q ":200:" etc/passwd; then
	chroot . useradd -u 200 -d /dev/null -s /bin/false -c "Postfix" -g 200 postfix &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "Postfix" -g 200 postfix &>/dev/null
    fi
fi

if ! grep -q "^postdrop:" etc/group; then
    if ! grep -q ":201:" etc/group; then
	chroot . groupadd -g 201 postdrop &>/dev/null
    else
	chroot . groupadd postdrop &>/dev/null
    fi
fi

# This will set the permissions on all postfix files correctly
chroot . postfix set-permissions

# Change log locations
# TODO: Seems very weird, but let it be so while it works
sed -i '/^mail.\*.*maillog$/ c\
mail.warn                                               -/var/log/mail.warn\
mail.info                                               -/var/log/mail.info\
mail.err                                                -/var/log/mail.err\
mail.*                                                  -/var/log/mail.log
' etc/syslog.conf

touch var/log/mail.{warn,info,err,log}
