#!/bin/sh

# Add user and group
if ! grep -q "^rpc:" etc/group; then
    if ! grep -q ":32:" etc/group; then
	chroot . groupadd -r -g 32 rpc &>/dev/null
    else
	chroot . groupadd -r rpc &>/dev/null
    fi
fi

if ! grep -q "^rpc:" etc/passwd; then
    if ! grep -q ":32:" etc/passwd; then
	chroot . useradd -r -u 32 -g rpc -d /dev/null -s /bin/false -c "Rpcbind Daemon" rpc &>/dev/null
    else
	chroot . useradd -r -g rpc -d /dev/null -s /bin/false -c "Rpcbind Daemon" rpc &>/dev/null
    fi
fi
