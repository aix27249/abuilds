#!/bin/sh

do_action=0


# Checking for changed modules
if [ ! -f var/mpkg/last_installed_files ] ; then
	INSTALLED_KERNEL_VER=`cat var/mpkg/last_installed_files | grep '^lib/modules/.' | head -n 1 | sed 's:^lib/modules/::g' | sed 's:/.*::g'`
fi
if [ "$INSTALLED_KERNEL_VER" != "" ] ; then
		ALL_KERNELS=$INSTALLED_KERNEL_VER
		do_action=1
else
	# Detecting all currently installed kernels
	ALL_KERNELS=`( cd lib/modules ; ls -1 )`
	if [ "$ALL_KERNELS" = "" ] ; then
		exit 1
	fi
fi


for KERNEL_VER in $ALL_KERNELS ; do

	for i in $PKG_INSTALLED $PKG_REMOVED ; do
		if [ "$i" = "kernel-modules" -o "$i" = "kernel" -o "$i" = "plymouth" ] ; then
			do_action=1
		fi
	done

	if [ "$do_action" = "0" ] ; then
		exit 0
	fi

	echo "Rebuilding INITRD for kernel $KERNEL_VER"

	if [ -f "boot/initrd.gz" ] ; then
		mv boot/initrd.gz boot/initrd.gz.old
	fi

	chroot . dracut --gzip --force boot/initrd-$KERNEL_VER.img $KERNEL_VER
	( cd boot ; ln -sf initrd-$KERNEL_VER.img initrd.gz )
done

