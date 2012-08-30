# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ejabberd/files/ejabberd-2.0.4.confd,v 1.1 2009/03/21 12:29:53 caleb Exp $
# Modified for AgiliaLinux: 2011, by aix27249

# Name of your ejabberd node. Used by ejabberdctl to determine which
# node to communicate with.
EJABBERD_NODE="ejabberd@localhost"

# Max number of open network connections. Default is 1024. Increasing
# this will slightly increase memory usage.
#ERL_MAX_PORTS=1024

# Return memory to the system after using it, instead of keeping it
# allocated for future use. Decreases the memory required by ejabberd,
# but makes it run slower.  Default is unset, set to any value to
# activate.
#ERL_FULLSWEEP_AFTER=0


