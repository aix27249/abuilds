#!/bin/sh
if [ "`uname -m`" = "x86_64" ] ; then 
	export CHROME_WRAPPER=/usr/lib64/chromium/chromium
else
	export CHROME_WRAPPER=/usr/lib/chromium/chromium
fi
export CHROME_DESKTOP=chromium.desktop
if [ "`uname -m`" = "x86_64" ] ; then
	exec /usr/lib64/chromium/chromium "$@"
else
	exec /usr/lib/chromium/chromium "$@"
fi
