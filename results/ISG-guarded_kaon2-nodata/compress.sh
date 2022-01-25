#!/bin/bash
set -e

for dir in 20*; do
    echo $dir;
    cd $dir;
    if [ ! -f $dir.zip ] && [ -f "00001.rul" ];
    then
        zip $dir.zip *.rul
    fi
    cd ..;
done;
