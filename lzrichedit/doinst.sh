name_gr="lazarus"

if [ "$(uname -m)" == "x86_64" ]; then
   LIBDIRSUFFIX=64
fi

lazdir=/usr/lib${LIBDIRSUFFIX}/lazarus
find ${lazdir} ! -group "${name_gr}" -print0 | xargs -0 --no-run-if-empty chgrp -v ${name_gr}
find ${lazdir} ! -perm 02775 -type d -print0 | xargs -0 --no-run-if-empty chmod -v 02775
find ${lazdir} ! -perm 0664 ! -perm 0755 ! -perm 0775 -type f -print0 | xargs -0 --no-run-if-empty chmod -v 0664
find ${lazdir} -perm 0755 -type f -print0 | xargs -0 --no-run-if-empty chmod -v 0775
find ${lazdir} ! -perm 0664 -name \*.bmp -type f -print0 -exec chmod -v 0664 {} \;