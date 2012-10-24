if [ ! -f etc/xml/catalog ]; then
	xmlcatalog --noout --create etc/xml/catalog
fi

xmlcatalog --noout --add "rewriteSystem" \
	"http://docbook.sourceforge.net/release/xsl/%PKGVER%" \
	"/usr/share/xml/docbook/xsl-stylesheets-%PKGVER%" \
	etc/xml/catalog

xmlcatalog --noout --add "rewriteURI" \
	"http://docbook.sourceforge.net/release/xsl/%PKGVER%" \
	"/usr/share/xml/docbook/xsl-stylesheets-%PKGVER%" \
	etc/xml/catalog &&

	xmlcatalog --noout --add "rewriteSystem" \
	"http://docbook.sourceforge.net/release/xsl/current" \
	"/usr/share/xml/docbook/xsl-stylesheets-%PKGVER%" \
	etc/xml/catalog &&

	xmlcatalog --noout --add "rewriteURI" \
	"http://docbook.sourceforge.net/release/xsl/current" \
	"/usr/share/xml/docbook/xsl-stylesheets-%PKGVER%" \
	etc/xml/catalog
