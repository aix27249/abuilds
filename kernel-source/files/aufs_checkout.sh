#!/bin/sh
echo "Cloning AUFS, kernel branch: ${AUBRANCH}"
git clone git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git \
	aufs3-standalone
cd aufs3-standalone

git checkout origin/aufs${AUBRANCH}

