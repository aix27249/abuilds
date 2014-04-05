echo "Update localtime"
current_zone=`ls -l /etc/localtime-copied-from | awk -F "->" '{print $2}'`
cp -f ${current_zone} /etc/localtime
if [ -f /etc/init.d/ntp-client ]; then
   /etc/init.d/ntp-client restart
fi