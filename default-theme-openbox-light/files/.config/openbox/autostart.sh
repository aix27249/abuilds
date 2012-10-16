# This shell script is run before Openbox launches.
# Environment variables set here are passed to the Openbox session.
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

