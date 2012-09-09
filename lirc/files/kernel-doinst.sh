if [ -x sbin/depmod ] ; then
	chroot . /sbin/depmod -a KERNEL_VERSION
fi

