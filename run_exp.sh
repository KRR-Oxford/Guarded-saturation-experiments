#!/bin/bash

set -e

timeout=5m
mem=10g
sleep=5s
version=0.5.1
date=`date +%Y-%m-%d-%H-%M`

DIR=$1
DIRNAME=`basename $DIR`
SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
basepath=$SCRIPT_DIR/results/$DIRNAME/$date-$timeout-$mem-v$version

mkdir -p $basepath

if [[ -e $SCRIPT_DIR/config.properties ]]; then
    cp $SCRIPT_DIR/config.properties $basepath
else
    echo "config.properties file is missing"
    exit 1
fi

for filename in $DIR/*.dlgp
do
    basenameF=$(basename "$filename" .dlgp)
	echo "Testing $basenameF - $timeout $mem"
	rm -f "$basepath/$basenameF.log"
        { # try
	    time timeout $timeout java -Xmx$mem -jar $SCRIPT_DIR/../target/guarded-saturation-$version-jar-with-dependencies.jar dlgp $filename &> "$basepath/$basenameF.log"
        } || {
            # catch
            if [[ $? == 124 ]]; then
                echo "\n\n!!! TIME OUT !!!" >> "$basepath/$basenameF.log"
                echo "TIME OUT"
            else
                echo "\n\n!!! ERROR !!!" >> "$basepath/$basenameF.log"
                echo "ERROR"
            fi
        }
	echo "Sleeping for $sleep..."
	sleep $sleep
done

echo "\nFind the results in "$basepath
