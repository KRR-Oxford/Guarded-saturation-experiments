#!/bin/bash
set -e

for dir in 2021*5; do
    echo $dir;
    cd $dir;
    if [ ! -f $dir.zip ];
    then
        zip $dir.zip *.rul
    fi
    cd ..;
done;
