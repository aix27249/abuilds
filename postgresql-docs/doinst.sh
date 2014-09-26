config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

config var/log/pgsql/serverlog.new

# Add user and group
if ! grep -q "^pgsql:" etc/group; then
    if ! grep -q ":28:" etc/group; then
	chroot . groupadd -g 28 pgsql &>/dev/null
    else
	chroot . groupadd pgsql &>/dev/null
    fi
fi

if ! grep -q "^pgsql:" etc/passwd; then
    if ! grep -q ":28:" etc/passwd; then
	chroot . useradd -u 28 -d /var/lib/pgsql -s /bin/false -c "PostgreSQL" -g 28 pgsql &>/dev/null
    else
	chroot . useradd -d /var/lib/pgsql -s /bin/false -c "PostgreSQL" -g 28 pgsql &>/dev/null
    fi
fi

chown -R pgsql:pgsql var/log/pgsql
chown pgsql:pgsql var/lib/pgsql

# remove the serverlog.new file if it exists
rm -f var/log/pgsql/serverlog.new

