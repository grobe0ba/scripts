#!/usr/local/bin/bash

HOSTNAMES="valhalla asgard"

JAIL="build10"
PORTS="default"

rm *.pkglist pkglist

declare -a HOSTNAME

for HOST in $HOSTNAMES;
do
	ssh $HOST pkg query -a "%o" > $HOSTNAME.pkglist

done

cat *.pkglist > pkglist

sudo poudriere ports -u -p $PORTS
sudo poudriere bulk -j $JAIL -p $PORTS -f pkglist

rm *.pkglist
