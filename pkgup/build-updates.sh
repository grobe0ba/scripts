#!/usr/local/bin/bash

HOSTNAMES[0]="valhalla"
HOSTNAMES[1]="asgard"

JAIL="build10"
PORTS="default"

rm *.pkglist pkglist

declare -a HOSTNAME

for HOST in $(seq 0 $((${#HOSTNAMES[@]} - 1)));
do
	ssh $HOST pkg query -a "%o" > $HOSTNAME.pkglist

done

cat *.pkglist > pkglist

sudo poudriere bulk -j $JAIL -p $PORTS -f pkglist

rm *.pkglist
