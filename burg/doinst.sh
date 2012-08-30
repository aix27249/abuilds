if [ -f "/boot/burg/burg.cfg" ]; then
	echo "You already have a config file for BURG, nothing to do."
else
	echo "Wait while we generate a config file for BURG..."
	burg-mkconfig -o /boot/burg/burg.cfg
fi
echo "To install and use BURG, run burg-install /dev/sda <or whatever drive you want>"
