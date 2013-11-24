infodir=usr/info
filelist=(info.info info-stnd.info texinfo texinfo-1 texinfo-2 texinfo-3)

if [ -f "${infodir}/dir" ]; then
    for file in ${filelist[@]}; do
        install-info $infodir/$file.gz $infodir/dir 2> /dev/null
    done
else
    # Scan *all* info files on first install
    for file in $(find $infodir -type f ! -name dir); do
        install-info $file $infodir/dir 2> /dev/null
    done
fi
