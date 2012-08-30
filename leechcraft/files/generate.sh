#!/bin/bash
srcache=~/.mkpkg/source_cache/
root=$srcache/leechcraft.git.src/src/plugins/

echo "== Generating plugins ABUILD..."
mkdir -p plugins
cat files/PLUGS > plugins/ABUILD
echo "[ II ] Leechcraft core"
for i in $(ls $root); do
	if cat files/ignored | grep -q $i; then
		echo "[ !! ] Ignored $i"
		continue
	fi
	pushd $root/$i/ &> /dev/null
	desc=$(ack GetInfo -A 3 -h | grep "\".*\"" -o | tail -n 1 | sed s/\"//g | head -n 1)
	popd &> /dev/null
	if [ "$desc" ]; then
		echo "[ II ] $i : $desc"
	else
		desc="[ II ] $i : Leechcraft plugin $i"
	fi
	export _PKGNAME=$i
	export _SHORTDESC=$desc
	files/TEMPLATE >> plugins/ABUILD
	pluglist="$pluglist $i"	
	deps="$deps leechcraft-$i"
done
echo "== Meta packages ABUILD"
mkdir -p meta
cat files/META > meta/ABUILD
echo "adddep=\"$deps\"" >> meta/ABUILD
for i in $(ls files/meta); do
	echo "[ II ] Meta package $i"
	cat files/meta/$i >> meta/ABUILD
	metalist="$metalist $i"
done
echo "pkglist=\"$metalist\"" >> meta/ABUILD
echo "pkglist=\"$pluglist\"" >> plugins/ABUILD
echo "== Done!"
unset _PKGNAME
unset _SHORTDESC
