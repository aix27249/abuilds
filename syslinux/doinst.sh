echo "==> If you want to use syslinux as your bootloader"
echo "==> edit /boot/syslinux/syslinux.cfg and run"
echo "==>   # /usr/bin/syslinux-install_update -i -a -m"
echo "==> to install it."

# auto-update syslinux if /boot/syslinux/SYSLINUX_AUTOUPDATE exists
/usr/bin/syslinux-install_update -s
# update to 5.10 message
echo "If you used syslinux-install_update to install syslinux:"
echo "==> If you want to use syslinux with menu and all modules please rerun" 
echo "==>   # /usr/bin/syslinux-install_update -i -a -m"
echo ""
echo "If you manually installed syslinux:"
echo "==> Please copy or symlink all .c32 modules to your /boot/syslinux directory."
echo "==> If (/ and /boot on seperate fs):"
echo "==>   # cp /usr/lib/syslinux/*.c32 /boot/syslinux"
echo "==> If (/ and /boot on same fs):"
echo "==>   # ln -s /usr/lib/syslinux/*.c32 /boot/syslinux"
