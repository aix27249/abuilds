#!/bin/sh
if [ ! -e var/log/httpd ]; then
  mkdir -p var/log/httpd
  chmod 755 var/log/httpd
fi

# Don't wipe out an existing document root:
if [ ! -L srv/www -a -d srv/www ]; then
  mv srv/www srv/www.bak.$$
fi
if [ ! -L srv/httpd -a -d srv/httpd ]; then
  mv srv/httpd srv/httpd.bak.$$
fi

# Once again, our intent is not to wipe out anyone's
# site, but building in Apache's docs tree is not as
# good an idea as picking a unique DocumentRoot.
#
# Still, we will do what we can here to mitigate
# possible site damage:
if [ -r var/www/htdocs/index.html ]; then
  if [ ! -r "var/log/packages/httpd-*upgraded*" ]; then
    if [ var/www/htdocs/index.html -nt var/log/packages/httpd-*-? ]; then
      cp -a var/www/htdocs/index.html var/www/htdocs/index.html.bak.$$
    fi
  fi
fi

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

for conf_file in etc/httpd/extra/*.new; do
  config $conf_file
done
( cd srv ; rm -rf httpd )
( cd srv ; ln -sf /var/www httpd )
( cd srv ; rm -rf www )
( cd srv ; ln -sf /var/www www )
