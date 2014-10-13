#!/usr/local/bin/bash

HOSTNAMES="valhalla asgard folkvangr"

REMOVE_PACKAGES=""

JAIL="build11"
PORTS="default"

rm -f *.pkglist pkglist

for HOST in $HOSTNAMES;
do
	ssh $HOST pkg query -a "%o" > $HOSTNAME.pkglist

done

cat *.pkglist > pkglist

TMP=$(mktemp /tmp/pkgup.XXXX)

for PKG in $REMOVE_PACKAGES;
do
	grep -v $PKG pkglist > $TMP
	cp $TMP pkglist
done

while [[ -n "$1" ]];
do
	echo $1 >> pkglist
	shift
done

rm $TMP

sudo poudriere ports -u -p $PORTS -m svn+https
sudo poudriere bulk -j $JAIL -p $PORTS -f pkglist

rm *.pkglist
