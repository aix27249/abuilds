LCDFILTER=`ls /etc/fonts/conf.d/10-lcd-filter.conf`
HELVETICAFIX=`ls /etc/fonts/conf.d/99-replace-helvetica.conf`
if [ $LCDFILTER == "" ]; then
    chroot . ln -s /etc/fonts/conf.avail/10-lcd-filter.conf /etc/fonts/conf.d
fi
if [ $HELVETICAFIX == "" ]; then
    chroot . ln -s /etc/fonts/conf.avail/99-replace-helvetica.conf /etc/fonts/conf.d
fi
