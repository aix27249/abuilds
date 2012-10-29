name_gr="vboxusers"

if ! [ "$(less /etc/group | grep ${name_gr})" ] ; then
   groupadd -f ${name_gr}
   echo "Created group vboxusers"
fi

udevadm control --reload-rules
