#add "winbind" to the daemon_list if you also want winbind to start
daemon_list="smbd nmbd"

#----------------------------------------------------------------------------
# Pre- and post-actions. See /etc/init.d/samba script for details
#----------------------------------------------------------------------------
my_service_name="samba"
my_service_PRE="unset TMP TMPDIR"
my_service_POST=""

#----------------------------------------------------------------------------
# If you need to change options for services, do it here
#----------------------------------------------------------------------------
smbd_start_options="-D"
nmbd_start_options="-D"
winbind_start_options=""

