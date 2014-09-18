#!/bin/sh
ARCH=$(uname -m)

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

function install_pkg(){
 pack="$1"
 lib_dir="$2"
 steam_folder="$3"
  mkdir /tmp/steam_glibc
  ( cd /tmp/steam_glibc
     wget http://security.ubuntu.com/ubuntu/pool/main/e/eglibc/"${pack}"
     ar x "${pack}"
     tar xzf data.tar.gz
     cd lib/${lib_dir}/
     cp -R * ${steam_folder}
  )
  rm -rf /tmp/steam_glibc
  echo 'libc6_2.15 installed'
}

function check_lib(){
 pack="$1"
 lib_dir="$2"
 steam_folder="$3"
 if [[ "2.15" > "${glibc_pkg_ver}" || "${glibc_pkg_ver}" = 'Not found' ]]; then
   if ! [ -f "${steam_folder}/libc-2.15.so" ]; then
     echo -n $'install the package '${pack}'? [y]: '
     read input
     if [ $input = 'y' -o $input = 'Y' ]; then
       install_pkg ${pack} ${lib_dir} ${steam_folder}
     fi
   else
      echo ${pack}' do not need to install'
   fi
 else
   echo ${pack}' do not need to install'
 fi
}

if [ ${ARCH} = "x86_64" ]; then
 check_lib "libc6_2.15-0ubuntu10.7_i386.deb" "i386-linux-gnu" ~/.local/share/Steam/ubuntu12_32
 check_lib "libc6_2.15-0ubuntu10.7_amd64.deb" "x86_64-linux-gnu" ~/.local/share/Steam/ubuntu12_64
else
 check_lib "libc6_2.15-0ubuntu10.7_i386.deb" "i386-linux-gnu" ~/.local/share/Steam/ubuntu12_32
fi


