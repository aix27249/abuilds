name_="colord"
id_=124

if ! [ "$(less /etc/group | grep ${name_})" ] ; then
   groupadd -g ${id_} ${name_}
   echo "Created group ${name_}"
fi

if ! [ "$(less /etc/passwd | grep ${name_})" ] ; then
   useradd -d /var/lib/colord -u ${id_} -g ${name_gr} -s /bin/false ${name_gr}
   echo "Created user ${name_gr}"
fi
glib-compile-schemas /usr/share/glib-2.0/schemas