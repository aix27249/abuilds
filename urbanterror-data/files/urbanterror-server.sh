#!/bin/sh
#rename old folder if exists
# [ ! -d ~/.urbanterror/baseut4 ] && [ -d ~/.urbanterror/q3ut4 ] && \
# mv ~/.urbanterror/q3ut4 ~/.urbanterror/baseut4
# start server
cd /opt/urbanterror/
exec ./ioUrTded "$@"
