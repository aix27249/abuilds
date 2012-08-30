#!/bin/sh
#rename old folder if exists
# [ ! -d ~/.urbanterror/baseut4 ] && [ -d ~/.urbanterror/q3ut4 ] && \
# mv ~/.urbanterror/q3ut4 ~/.urbanterror/baseut4
# start urbanterror
cd /opt/urbanterror/
exec ./ioUrbanTerror "$@"
