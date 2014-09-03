#!/usr/local/bin/bash

HOSTNAMES="valhalla asgard"

REMOVE_PACKAGES="sysutils/vagrant"

JAIL="build10"
PORTS="default"

rm *.pkglist pkglist

declare -a HOSTNAME

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

rm $TMP

sudo poudriere ports -u -p $PORTS
sudo poudriere bulk -j $JAIL -p $PORTS -f pkglist

rm *.pkglist
