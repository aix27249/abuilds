PKGNAME="texlive-core"
UPDMAP="/etc/texmf/web2c/updmap.cfg"
OLDMAPS="/var/lib/texmf/agilia/installedpkgs/$PKGNAME.maps"
SYNCWITHTREES=''
NEWMAPS=`mktemp`
cat <<EOF > $NEWMAPS
Map euler.map
Map charter.map
Map fpls.map
Map l7x-urwvn.map
Map lm.map
Map marvosym.map
Map pazo.map
Map pxfonts.map
Map qag.map
Map qbk.map
Map qcr.map
Map qcs.map
Map qhv.map
Map qpl.map
Map qtm.map
Map qzc.map
Map tabvar.map
Map txfonts.map
Map utopia.map
Map zpeu.map
MixedMap ccpl.map
MixedMap cm-super-t1.map
MixedMap cm-super-t2a.map
MixedMap cm-super-t2b.map
MixedMap cm-super-t2c.map
MixedMap cm-super-ts1.map
MixedMap cm-super-x2.map
MixedMap cm.map
MixedMap cmextra.map
MixedMap cmtext-bsr-interpolated.map
MixedMap csother.map
MixedMap cstext.map
MixedMap cyrillic.map
MixedMap eurosym.map
MixedMap latxfont.map
MixedMap mflogo.map
MixedMap plother.map
MixedMap pltext.map
MixedMap rsfs.map
MixedMap stmaryrd.map
MixedMap symbols.map
MixedMap tipa.map
MixedMap wasy.map
MixedMap yhmath.map
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

