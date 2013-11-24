#!/bin/sh

GROUP_NAME="locate"

# Add user and group
if ! grep -q "^${GROUP_NAME}:" etc/group; then
    if ! grep -q "^slocate:" etc/group; then
	if ! grep -q ":21:" etc/group; then
	    chroot . groupadd -g 21 $GROUP_NAME &>/dev/null
	else
	    chroot . groupadd $GROUP_NAME &>/dev/null
	fi
    else
	chroot . groupmod -n $GROUP_NAME slocate &>/dev/null
    fi
fi
