setcap cap_net_raw=ep usr/bin/ping  2>/dev/null || chmod +s usr/bin/ping
setcap cap_net_raw=ep usr/bin/ping6 2>/dev/null || chmod +s usr/bin/ping6
