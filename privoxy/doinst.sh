## privoxy user & group *MUST* exist before package creation
# See http://slackbuilds.org/uid_gid.txt for current recomendations.

getent group privoxy >/dev/null 2>&1 || groupadd -g 206 privoxy
getent passwd privoxy >/dev/null 2>&1 || useradd -u 206 -g 206 \
	-c "Web Proxy" -d /dev/null -s /bin/false privoxy

chown -R privoxy:privoxy etc/privoxy var/log/privoxy

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

config etc/privoxy/default.action.new
config etc/privoxy/default.filter.new
config etc/privoxy/match-all.action.new
config etc/privoxy/trust.new
config etc/privoxy/user.action.new
config etc/privoxy/user.filter.new
config etc/privoxy/config.new

for conf_file in etc/privoxy/templates/*.new; do
  config $conf_file
done

# If there's no existing log file, move this one over; 
# otherwise, kill the new one
if [ ! -e var/log/privoxy/logfile ]; then
  mv var/log/privoxy/logfile.new var/log/privoxy/logfile
else
  rm -f var/log/privoxy/logfile.new
fi
