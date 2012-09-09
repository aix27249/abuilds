#!/bin/bash

# Script used to help building package for multiple kernel branches

PLAIN=3.4.7
UKSM=3.4.7
LTS=3.0.42lts
MED=3.5.3-med

PKGNAME=$1

( cd $PKGNAME ; KERNEL=$PLAIN mkpkg )
( cd $PKGNAME-uksm ; KERNEL=$UKSM mkpkg )
( cd $PKGNAME-lts ; KERNEL=$LTS mkpkg )
( cd $PKGNAME-med ; KERNEL=$MED mkpkg )

