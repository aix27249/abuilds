#!/bin/bash
echo "== Dependencies..."
cd qross
mkpkg -si $*
cd ..
cd qxmpp
mkpkg -si $*
cd ..
echo "== Done!"

echo "== Building and installing core..."
mkpkg -si $*
echo "== Done!"

files/generate.sh

echo "== Plugins..."
cd plugins
mkpkg $*
cd ..
echo "== Done!"

echo "== Meta packages..."
cd meta
mkpkg $*
cd ..
echo "== Done!"
