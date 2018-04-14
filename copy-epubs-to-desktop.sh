#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: copy-epub-to-desktop.sh <number of days backwards> [copy-flag]"
    exit 1
fi

NUM_DAYS=$1
COPY=0
TRUE_STRING="true"

if [ "$#" -eq 2 ] && [ "$2" == "$TRUE_STRING" ]; then
    COPY=1
fi

mkdir -p

find /cygdrive/c/Users/kiese/Documents/Calibre\ Library -type f -name "*.epub" -mtime -${NUM_DAYS} -exec ls {} \; > bin/out

sed "s/.*\/\(.*\)/\1/g" bin/out

if [ $COPY -eq 1 ]; then
    while read line; do
        cp "${line}" /cygdrive/c/Users/kiese/Desktop
    done < bin/out
fi
