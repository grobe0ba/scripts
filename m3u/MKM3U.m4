#!/usr/local/bin/bash

if [[ "$1" == "." ]]; then
	exit 0
fi

HELPER=$(mktemp /tmp/MKM3U.XXXXX)

openssl base64 -d >$HELPER << EOF
include(MK3HELP.b64)
EOF

PLNAME=$(echo $1 | sed -e "s#$MOVIEDIR/##" | sed -e "s#/#_#g")
PLAYLIST=$MOVIEDIR/$PLNAME.m3u


echo "#EXTM3U" > $PLAYLIST
find $1 -depth -exec /usr/local/bin/bash $HELPER $PLAYLIST "{}" \;
find "$1" -type d -depth 1 -exec /usr/local/bin/bash $0 "{}" \;
rm "$HELPER"
