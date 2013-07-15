if [[ -f /var/lib/rpm/Packages ]] ; then
    echo "RPM database found... Rebuilding database (may take a while)..."
    /usr/bin/rpmdb --rebuilddb --root=/
else
    echo "No RPM database found... Creating database..."
    /usr/bin/rpmdb --initdb --root=/
fi