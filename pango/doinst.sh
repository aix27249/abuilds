if [[ ! -d "etc/pango/" ]] ; then mkdir -p etc/pango/ ; fi
chroot . usr/bin/pango-querymodules > etc/pango/pango.modules
