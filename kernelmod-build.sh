#!/bin/bash

# Script used to help building package for multiple kernel branches

PLAIN=3.5.4
UKSM=3.4.7uksm
LTS=3.0.42lts
MED=3.5.4-med

PKGNAME=$1

( cd $PKGNAME-uksm ; KERNEL=$UKSM mkpkg )
( cd $PKGNAME-lts ; KERNEL=$LTS mkpkg )
( cd $PKGNAME-med ; KERNEL=$MED mkpkg )
( cd $PKGNAME ; KERNEL=$PLAIN mkpkg )
