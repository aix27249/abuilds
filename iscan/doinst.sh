srv=/etc/services
if [ -z "`grep 6566/tcp ${srv}`" ]
then
    cat >> ${srv} <<EOF
sane-port       6566/tcp   sane saned   # SANE Control Port
sane-port       6566/udp   sane saned   # SANE Control Port
EOF
fi
