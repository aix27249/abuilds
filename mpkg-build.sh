#!/bin/sh
MODULES="mpkgsupport nwidgets mpkg-core mpkg-console mpkg-i18n mpkg-parted mklivecd libagiliasetup agilia-gui-installer agilia-text-installer"

BUILD=${BUILD:-1}

set -e
for i in $MODULES ; do
	( cd $i && mkpkg -si -bb ${BUILD} )
done
set +e

