name_gr="lazarus"

if ! [ "$(less /etc/group | grep ${name_gr})" ] ; then
   groupadd -f ${name_gr}
   echo "Created group lazarus"
fi
