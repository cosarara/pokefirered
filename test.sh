#!/bin/bash

function hash {
	md5sum $1 | cut -d' ' -f1
}

if [ $( hash fr.full.gba ) == "e26ee0d44e809351c8ce2d73c7400cdd" ]; then
	echo "ok"
else
	echo checksum fails
	cmp fr.full.gba FR.ro.gba
fi

