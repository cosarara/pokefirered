#!/bin/bash

function hash {
	md5sum $1 | cut -d' ' -f1
}

if [ $( hash fr.full.gba ) == "98adc1ddc82847df2e1da236456a71bb" ]; then
	echo "ok"
else
	echo checksum fails
fi

