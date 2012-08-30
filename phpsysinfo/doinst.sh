#!/bin/sh

config() {
 NEW="$1"
 OLD="`dirname $NEW`/`basename $NEW .new`"
  if [ ! -r $OLD ]; then
	  mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then
	  rm $NEW
  fi
}

#config srv/httpd/htdocs/phpsysinfo/config.php.new
config var/www/htdocs/phpsysinfo/config.php.new
