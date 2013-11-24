
if ! grep -q "^dovecot:" etc/group; then
    if ! grep -q ":202:" etc/group; then
        chroot . groupadd -g 202 dovecot &>/dev/null
    else
        chroot . groupadd dovecot &>/dev/null
    fi
fi

if ! grep -q "^dovecot:" etc/passwd; then
    if ! grep -q ":202:" etc/passwd; then
        chroot . useradd -u 202 -d /dev/null -s /bin/false -g 202 dovecot &>/dev/null
    else
        chroot . useradd -d /dev/null -s /bin/false -g 202 dovecot &>/dev/null
    fi
fi

# Default login user
if ! grep -q "^dovenull:" etc/passwd; then
    chroot . useradd -d /dev/null -s /bin/false -g 202 dovenull &>/dev/null
fi


