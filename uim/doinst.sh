#!/bin/sh

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

if [ -x usr/bin/gtk-query-immodules-2.0 ]; then
    usr/bin/gtk-query-immodules-2.0 > etc/gtk-2.0/gtk.immodules.new
    config etc/gtk-2.0/gtk.immodules.new
fi

