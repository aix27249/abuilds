#!/bin/sh

rm -rf /etc/fonts/conf.d/10-lcd-filter.conf
ln -s /etc/fonts/conf.avail/10-lcd-filter.conf /etc/fonts/conf.d
rm -rf /etc/fonts/conf.d/99-replace-helvetica.conf
ln -s /etc/fonts/conf.avail/99-replace-helvetica.conf /etc/fonts/conf.d
