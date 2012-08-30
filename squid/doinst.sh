#!/bin/sh

config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

config etc/squid/mime.conf.new
config etc/squid/squid.conf.new
config etc/squid/cachemgr.conf.new
config etc/squid/msntauth.conf.new
config etc/rc.d/rc.squid.new
config etc/conf.d/squid.new
