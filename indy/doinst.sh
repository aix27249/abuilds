name_gr="lazarus"
FPCVER=$(fpc -iV)

if [ "$(uname -m)" == "x86_64" ]; then
   LIBDIRSUFFIX=64
fi
if [ "$(grep -s 'indy' /etc/fpc.cfg)" != "" ] ; then
   sed -i '/packages\/indy/c\
-Fu\/usr\/share\/fpc\/$fpcversion\/src\/packages\/indy' etc/fpc.cfg
   sed -i '/components\/indy/c\
-Fu/usr/lib'${LIBDIRSUFFIX}'/lazarus/components/indy' etc/fpc.cfg
else
    sed -i '/-Fu\/usr\/lib'${LIBDIRSUFFIX}'\/fpc\/$fpcversion\/units\/$fpctarget\/rtl/ a\
-Fu\/usr\/share\/fpc\/$fpcversion\/src\/packages\/indy' etc/fpc.cfg
    sed -i '/-Fu\/usr\/lib'${LIBDIRSUFFIX}'\/fpc\/$fpcversion\/units\/$fpctarget\/rtl/ a\
-Fu/usr/lib'${LIBDIRSUFFIX}'/lazarus/components/indy' etc/fpc.cfg
fi
echo "The configuration file fpc.cfg is changed"

lazdir=/usr/lib${LIBDIRSUFFIX}/lazarus
find ${lazdir} ! -group "${name_gr}" -print0 | xargs -0 --no-run-if-empty chgrp -v ${name_gr}
find ${lazdir} ! -perm 02775 -type d -print0 | xargs -0 --no-run-if-empty chmod -v 02775
find ${lazdir} ! -perm 0664 ! -perm 0755 ! -perm 0775 -type f -print0 | xargs -0 --no-run-if-empty chmod -v 0664
find ${lazdir} -perm 0755 -type f -print0 | xargs -0 --no-run-if-empty chmod -v 0775
find ${lazdir} ! -perm 0664 -name \*.bmp -type f -print0 -exec chmod -v 0664 {} \;