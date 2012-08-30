# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.

# Set a background color
nitrogen --restore &

#Run X Composite Manager
xcompmgr -c &

# Run Panel App
bmpanel2 &

# Run Quake-like terminal emulator
yeahconsole &

# Run XKB layout switcher
xxkb &

# Run Volume Control
volti &

# D-bus
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --auto-syntax --exit-with-session`
fi

# NetworkManager
nm-applet &

# Run XDG autostart things.  By default don't run anything desktop-specific
# See xdg-autostart --help more info
# DESKTOP_ENV=""
# if which which /usr/lib/openbox/xdg-autostart >/dev/null; then
#   /usr/lib/openbox/xdg-autostart $DESKTOP_ENV
# fi
