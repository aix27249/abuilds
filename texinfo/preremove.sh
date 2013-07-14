infodir=usr/info
filelist=(info.info info-stnd.info texinfo texinfo-1 texinfo-2 texinfo-3)

for file in ${filelist[@]}; do
    install-info --delete $infodir/$file.gz $infodir/dir 2> /dev/null
done