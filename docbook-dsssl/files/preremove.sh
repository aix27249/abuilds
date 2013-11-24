# Update catalog:
chroot . install-catalog --remove /etc/sgml/dsssl-docbook-stylesheets.cat \
		  /usr/share/sgml/docbook/dsssl-stylesheets-PKGVER/catalog
chroot . install-catalog --remove /etc/sgml/dsssl-docbook-stylesheets.cat \
		  /usr/share/sgml/docbook/dsssl-stylesheets-PKGVER/common/catalog
chroot . install-catalog --remove /etc/sgml/sgml-docbook.cat \
		  /etc/sgml/dsssl-docbook-stylesheets.cat

