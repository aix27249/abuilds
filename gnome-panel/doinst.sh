GCONF_CONFIG_SOURCE=`chroot . usr/bin/gconftool-2 --get-default-source | sed 's|/etc|etc|'`
chroot . usr/bin/gconftool-2 --config-source="${GCONF_CONFIG_SOURCE}" --direct --load \
etc/gconf/schemas/panel-default-setup.entries >/dev/null
