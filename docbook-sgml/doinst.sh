# DTD 3.1
chroot . install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
     /usr/share/sgml/docbook/sgml-dtd-3.1/catalog 
chroot . install-catalog --add /etc/sgml/sgml-docbook-dtd-3.1.cat \
     /etc/sgml/sgml-docbook.cat

# Use only the most current 3.x version of DocBook SGML DTD:
cat >> usr/share/sgml/docbook/sgml-dtd-3.1/catalog << "EOF"
  -- Begin Single Major Version catalog changes --

PUBLIC "-//Davenport//DTD DocBook V3.0//EN" "docbook.dtd"

  -- End Single Major Version catalog changes --
EOF

# DTD 4.5
chroot . install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /usr/share/sgml/docbook/sgml-dtd-4.5/catalog 
chroot . install-catalog --add /etc/sgml/sgml-docbook-dtd-4.5.cat \
    /etc/sgml/sgml-docbook.cat

# Use only the most current 4.x version of DocBook SGML DTD :
cat << EOF >> usr/share/sgml/docbook/sgml-dtd-4.5/catalog
  -- Begin Single Major Version catalog changes --
EOF
for i in 4.4 4.3 4.2 4.1 4.0; do
cat << EOF >> usr/share/sgml/docbook/sgml-dtd-4.5/catalog
PUBLIC "-//OASIS//DTD DocBook V${i}//EN" "docbook.dtd"
EOF
done
cat << EOF >> usr/share/sgml/docbook/sgml-dtd-4.5/catalog

  -- End Single Major Version catalog changes --
EOF

