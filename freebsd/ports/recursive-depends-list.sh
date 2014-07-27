#!/usr/local/bin/bash

declare -a RDIRS

function gdir
{
	export RDEPTH=$((RDEPTH+1))
	RDIRS=[$RDEPTH]=`pwd`
	export RDIRS
	cd $1
}

function ldir
{
	cd ${RDIRS[$RDEPTH]}
	unset RDIR[$RDEPTH]
	RDEPTH=$((RDEPTH-1))
	export RDEPTH
}


function genlist
{
	for x in `make build-depends-list && make run-depends-list`;
	do
		#for i in `seq 0 $((RDEPT-1))`; do PREFIX="$PREFIX "; done
		PREFIX=`echo "$PREFIX" | tr -c " |" " "`
		PREFIX="$PREFIX|--"
		if `echo $x | grep -qv "/usr/ports/ports-mgmt/pkg"`;
		then
			echo -e "$PREFIX$x"
		fi
		gdir $x
		genlist
		ldir
		PREFIX=""
	done
}
echo "|--`pwd`"
PREFIX=""
genlist
