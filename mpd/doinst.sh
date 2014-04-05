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

config /etc/mpd.conf.new

if ! grep "^mpd:" etc/group >/dev/null 2>&1; then
	echo "mpd: Create a config under /etc/mpd.conf before using MPD (Example: /etc/mpd.conf)"
	groupadd -g 45 mpd &>/dev/null
	useradd -u 45 -g mpd -d /var/lib/mpd -s /bin/true mpd &>/dev/null
	gpasswd -a mpd audio &>/dev/null
fi
