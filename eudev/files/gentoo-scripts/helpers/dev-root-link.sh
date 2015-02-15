#!/bin/sh -e
#
# dev-root-link.sh: create /dev/root symlink
#
# Distributed under the terms of the GNU General Public License v2
#
# This is here because some software expects /dev/root to exist.
# For more information, see this bug:
# https://bugs.gentoo.org/show_bug.cgi?id=438380

RULESDIR=/etc/udev/rules.d

[ -d $RULESDIR ] || mkdir -p $RULESDIR

eval $(udevadm info --export --export-prefix=ROOT_ --device-id-of-file=/ || true)

[ "$ROOT_MAJOR" -a "$ROOT_MINOR" ] || exit 0

# btrfs filesystems have bogus major/minor numbers
[ "$ROOT_MAJOR" != 0 ] || exit 0

echo 'ACTION=="add|change", SUBSYSTEM=="block", ENV{MAJOR}=="'$ROOT_MAJOR'", ENV{MINOR}=="'$ROOT_MINOR'", SYMLINK+="root"' > $RULESDIR/61-dev-root-link.rules
