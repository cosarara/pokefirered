#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Need arguments bro"
    exit
fi

LEN=$(wc -c $1 | cut -d' ' -f1)
echo $LEN
echo '.incbin "FR.ro.gba",'$LEN >> $2
