#!/bin/sh
steam_folder=~/.local/share/Steam/ubuntu12_32

function lib_pkg_ver(){
 pkg_ver=`sqlite3 /var/mpkg/packages.db "select package_version from packages where package_name='$1' and package_installed='1';"`
 if [ -z "${pkg_ver}" ]; then
    pkg_ver=`sqlite3 /var/mpkg/packages.db "select package_version from packages where package_provides='$1' and package_installed='1';"`
 fi
 if [ -z "${pkg_ver}" ]; then
    echo 'Not found'
    exit
 fi
 echo "$pkg_ver"
}

glibc_pkg_ver="$(lib_pkg_ver "glibc32")"

if [[ "2.15" > "$glibc_pkg_ver" || "$glibc_pkg_ver" = 'Not found' ]]; then
  if ! [ -f "${steam_folder}/libc-2.15.so" ]; then
    echo -n $'install the package libc6_2.15-0ubuntu10.2_i386.deb? [y]: '
    read input
    if [ $input = 'y' -o $input = 'Y' ]; then
       mkdir /tmp/steam_glibc
       ( cd /tmp/steam_glibc
         wget http://security.ubuntu.com/ubuntu/pool/main/e/eglibc/libc6_2.15-0ubuntu10.2_i386.deb
         ar x libc6_2.15-0ubuntu10.2_i386.deb
         tar xzf data.tar.gz
         cd lib/i386-linux-gnu/
         cp -R * ${steam_folder}
       )
       rm -rf /tmp/steam_glibc
       echo 'libc6_2.15 installed'
    fi
  else
    echo 'libc6_2.15-0ubuntu10.2_i386.deb do not need to install'
  fi
else
  echo 'libc6_2.15-0ubuntu10.2_i386.deb do not need to install'
fi

