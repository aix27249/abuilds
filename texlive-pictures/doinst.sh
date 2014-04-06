PKGNAME="texlive-pictures"
UPDMAP="/etc/texmf/web2c/updmap.cfg"
OLDMAPS="/var/lib/texmf/agilia/installedpkgs/${PKGNAME}.maps"
UPDMAPLOCAL="etc/texmf/web2c/updmap-local.cfg"
SYNCWITHTREES=''
TMPFILE=`mktemp`

echo ">>> texlive: saving updmap.cfg as ${TMPFILE}..."
cp "${UPDMAP}" "${TMPFILE}"

echo ">>> texlive: regenerating updmap.cfg (custom additions should go into /etc/texmf/web2c/updmap-local.cfg"
cp usr/share/texmf-dist/web2c/updmap-hdr.cfg ${UPDMAP}
cat var/lib/texmf/agilia/installedpkgs/*.maps >> ${UPDMAP}

[ -f "${UPDMAPLOCAL}" ] && cat "${UPDMAPLOCAL}" >> ${UPDMAP}
echo ">>> texlive: updating the filename database..."
chroot . usr/bin/mktexlsr
echo "... done."
echo ">>> texlive: updating the fontmap files with updmap..."
chroot . usr/bin/updmap-sys --quiet --nohash
echo "... done."
echo "http://wiki.archlinux.org/index.php/TeX_Live"

if [ -f ${OLDMAPS} ] ; then
   MAPSDIFF=`mktemp`
   TOADD=`mktemp`
   diff -B -w ${OLDMAPS} ${TMPFILE} | sed 's/\s\+/ /g' > ${MAPSDIFF}
   TOREMOVE=`cat $MAPSDIFF | egrep '^<' | cut -d' ' -f3`
   cat ${MAPSDIFF} | egrep '^>' | sed 's/^> //' > ${TOADD}
   if [ "x${TOREMOVE}" != "x" ]; then
      for map in ${TOREMOVE}; do
          sed -i "/\s${map}/d" ${UPDMAP}
      done
   fi
   if [ -s ${TOADD} ]; then
      cat ${TOADD} >> ${UPDMAP}
   fi
else
   echo "Warning: file ${OLDMAPS} not found" 
   SYNCWITHTREES="--syncwithtrees"
fi
