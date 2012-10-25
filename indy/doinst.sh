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
