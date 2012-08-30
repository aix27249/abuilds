srcache=~/.mkpkg/source_cache/
root=$srcache/leechcraft.src/src/plugins/

echo "== Building core..."
cat HEAD > ../ABUILD
cd ..
mkpkg -si
cd files
echo "== Done!"
echo "== Generating full ABUILD..."
for i in $(ls $root); do
	cat TEMPLATE | sed "s/\*\*TEMPLATE\*\*/$i/g" >> ../ABUILD
	pkglist="$pkglist $i"
done
echo "pkglist=\"$pkglist\"" >> ../ABUILD
echo "== Done!"
echo "== Recompiling w/plugins..."
cd ..
mkpkg -si
cd files
echo "== Done!"
