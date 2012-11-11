name_gr="clamav"

if ! [ "$(less /etc/group | grep ${name_gr})" ] ; then
   groupadd -g 64 ${name_gr}
   echo "Created group clamav"
fi
if ! [ "$(less /etc/passwd | grep ${name_gr})" ] ; then
   useradd -u 64 -g clamav -c "Clam AntiVirus" -d /dev/null -s /bin/false clamav
   echo "Created user clamav"
fi
