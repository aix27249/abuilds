if [ "$(grep -s 'indy' etc/fpc.cfg)" ] ; then
   sed -i '/packages\/indy/d' etc/fpc.cfg
   sed -i '/components\/indy/d' etc/fpc.cfg
   echo "The configuration file fpc.cfg is changed"
fi
