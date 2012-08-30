#mkdir -p /etc/ld.so.conf.d
if [ -z "$(cat /etc/ld.so.conf | grep xulrunner)" ]; then 
    echo "/usr/lib%LIBDIR%/xulrunner" >> /etc/ld.so.conf
fi
