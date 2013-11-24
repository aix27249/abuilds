# /etc/conf.d/apache2: config file for /etc/init.d/apache2

# When you install a module it is easy to activate or deactivate the modules
# and other features of apache using the APACHE2_OPTS line. Every module should
# install a configuration in /etc/apache2/modules.d. In that file will be an
# <IfDefine NNN> where NNN is the option to enable that module.
# Here are the options available in the default configuration:
#   USERDIR   Enables /~username mapping to /home/username/public_html
#   INFO      Enables mod_info, a useful module for debugging
#   PROXY     Enables mod_proxy
#   DAV       Enables mod_dav
#   DAV_FS    Enables mod_dav_fs (you should enable this when you enable DAV
#             unless you know what you are doing)
#   SSL       Enables SSL
#   SSL_DEFAULT_VHOST  Enables default vhost for SSL (you should enable this
#                      when you enable SSL unless you know what you are doing)
#   LDAP      Enables mod_ldap
#   AUTH_LDAP Enables authentication through mod_ldap
#   DEFAULT_VHOST Enables the default virtual host in /var/www/localhost/htdocs
APACHE2_OPTS=""

# Extended options for advanced uses of Apache ONLY
# You don't need to edit these unless you are doing crazy Apache stuff
# As not having them set correctly, or feeding in an incorrect configuration
# via them will result in Apache failing to start
# YOU HAVE BEEN WARNED.

# ServerRoot setting
#SERVERROOT=/usr/lib/httpd

# Configuration file location
# - If this does NOT start with a '/', then it is treated relative to
# $SERVERROOT by Apache
#CONFIGFILE=/etc/httpd/httpd.conf

# Location to log startup errors to
# They are normally dumped to your terminal.
#STARTUPERRORLOG="/var/log/httpd/startuperror.log"

# A command that outputs a formatted text version of the HTML at the URL
# of the command line. Designed for lynx, however other programs may work.
#LYNX="lynx -dump"

# The URL to your server's mod_status status page.
# Required for status and fullstatus
#STATUSURL="http://localhost/server-status"

# Method to use when reloading the server
# Valid options are 'restart' and 'graceful'
# See http://httpd.apache.org/docs/2.2/stopping.html for information on
# what they do and how they differ.
#RELOAD_TYPE="graceful"
