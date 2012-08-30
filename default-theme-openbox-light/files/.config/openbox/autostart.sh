# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.

# D-bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --auto-syntax --exit-with-session`
fi

# Set desktop wallpaper
nitrogen --restore &

# Menu daemon start
snapfly &

# Enable compositing
#xcompmgr -c &

# Panel start
bmpanel2 &

# Quake-style terminal emulator
yeahconsole &

# Keyboard layout indicator
xxkb &

# Sound volume manager applet
volti &

# Run XDG autostart things.  By default don't run anything desktop-specific
# See xdg-autostart --help more info
DESKTOP_ENV="OPENBOX"
XA=/usr/libexec/openbox-xdg-autostart
if which /usr/libexec/openbox-xdg-autostart > /dev/null ; then
	/usr/libexec/xdg-autostart $DESKTOP_ENV
elif which /usr/lib64/openbox/xdg-autostart >/dev/null; then
	/usr/lib64/openbox/xdg-autostart $DESKTOP_ENV
elif which /usr/lib/openbox/xdg-autostart >/dev/null; then
	/usr/lib/openbox/xdg-autostart $DESKTOP_ENV
fi
