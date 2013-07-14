# Update SGML catalog:
chroot . install-catalog --add /etc/sgml/openjade-1.3.3_pre1.cat \
	/usr/share/sgml/openjade-1.3.3_pre1/catalog
chroot . install-catalog --add ${pkgdir}/etc/sgml/sgml-docbook.cat \
	/etc/sgml/openjade-1.3.3_pre1.cat

# Update system configuration:
echo "SYSTEM \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" \
	\"/usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd\"" >> \
	usr/share/sgml/openjade-1.3.3_pre1/catalog

