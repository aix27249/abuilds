#!/bin/sh

# Add user and group
if ! grep -q "^www-data:" etc/group; then
    if ! grep -q ":33:" etc/group; then
	chroot . groupadd -g 33 www-data &>/dev/null
    else
	chroot . groupadd www-data &>/dev/null
    fi
fi

if ! grep -q "^www-data:" etc/passwd; then
    if ! grep -q ":33:" etc/passwd; then
	chroot . useradd -u 33 -d /dev/null -s /bin/false -c "www-data" -g 33 www-data &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "www-data" -g 33 www-data &>/dev/null
    fi
fi

