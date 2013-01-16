#!/bin/bash

VER=1.7.5

PKGLIST="eina \
eet \
evas \
evas_generic_loaders \
ecore \
eio \
embryo \
edje \
efreet \
e_dbus \
eeze \
emotion \
ethumb \
elementary"



for i in $PKGLIST ; do
	( cd $i && mkpkg -bv $VER -si || exit 1 )
done
