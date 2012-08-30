chroot . usr/sbin/groupadd i2p 2>/dev/null || true
chroot . usr/sbin/useradd -s /bin/false -g i2p -d /opt/i2p i2p 2>/dev/null || true
chroot . chown -R i2p:i2p opt/i2p
