PKGNAME="texlive-core"
UPDMAP="/etc/texmf/web2c/updmap.cfg"
OLDMAPS="/var/lib/texmf/agilia/installedpkgs/$PKGNAME.maps"
SYNCWITHTREES=''
NEWMAPS=`mktemp`
cat <<EOF > $NEWMAPS
Map cmcyr.map
EOF

cat $NEWMAPS >> $UPDMAP

chroot . usr/bin/mktexlsr
chroot . usr/bin/updmap-sys --quiet --nohash
chroot . usr/bin/fmtutil-sys --all 1>/dev/null

if [ -f $OLDMAPS ] ; then
	MAPSDIFF=`mktemp`
	TOADD=`mktemp`
	diff -B -w $OLDMAPS $NEWMAPS | sed 's/\s\+/ /g' > $MAPSDIFF
	TOREMOVE=`cat $MAPSDIFF | egrep '^<' | cut -d' ' -f3`
	cat $MAPSDIFF | egrep '^>' | sed 's/^> //' > $TOADD
	if [ "x$TOREMOVE" != "x" ]; then
		for map in $TOREMOVE; do
			sed -i "/\s$map/d" $UPDMAP
		done
	fi
	if [ -s $TOADD ]; then
		cat $TOADD >> $UPDMAP
	fi
else
	echo "Warning: file $OLDMAPS not found" 
	SYNCWITHTREES="--syncwithtrees"
fi

