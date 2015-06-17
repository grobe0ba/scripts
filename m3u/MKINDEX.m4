#!/usr/local/bin/bash

export MOVIEDIR=/usr/home/grobe0ba/tree

find . -name "*m3u" -exec rm "{}" \;

MKM3U=$(mktemp /tmp/MKINDEX.XXXXX)

openssl base64 -d >$MKM3U<<EOF
include(MKM3U.b64)
EOF

TOINDEX=$(mktemp /tmp/MKINDEX.XXXXX)

openssl base64 -d >$TOINDEX<<EOF
include(TOINDEX.b64)
EOF

/usr/local/bin/bash $MKM3U $MOVIEDIR

echo "<HTML><HEAD><TITLE>Playlist Index</title></head><body>" > $MOVIEDIR/index.html
echo "<TABLE WIDTH='75%' BORDER=1>" >> $MOVIEDIR/index.html
find $MOVIEDIR -name "*m3u" -exec /usr/local/bin/bash $TOINDEX "{}" \;
echo "</TABLE></BODY></HTML>" >> $MOVIEDIR/index.html

rm $MKM3U $TOINDEX
