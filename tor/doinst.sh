# http://slackbuilds.org/slackbuilds/13.1/network/tor/README.SLACKWARE
# The recommended UID/GID is 220.

getent group tor >/dev/null 2>&1 || groupadd -g 220 tor
getent passwd tor >/dev/null 2>&1 || useradd -u 220 -g 220 \
	-c "The Onion Router" -d /var/lib/tor -s /bin/false tor

  chown tor:tor var/lib/tor &> /dev/null
  chmod 700 var/lib/tor &> /dev/null

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
config etc/tor/tor-tsocks.conf.new
config etc/tor/torrc.new
config etc/logrotate.d/tor.new

#rc-service tor restart
