#!/bin/bash
set -e

for dir in 2021*; do
    echo $dir;
    cd $dir;
    if [ ! -f $dir.7z ];
    then
        7z a $dir.7z *.rul
    fi
    cd ..;
done;
