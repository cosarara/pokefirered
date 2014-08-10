#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Need arguments bro"
    exit
fi

LEN=$(( $(wc -c $1 | cut -d' ' -f1)))

# If stupid GAS has written a nop at the end (coz alignment), don't count it
if [ $(xxd -p -s $(( $LEN - 2)) $1) == "c046" ]; then
    LEN=$(( $LEN - 2 ))
fi

echo $LEN
echo '.incbin "FR.ro.gba",'$LEN >> $2
