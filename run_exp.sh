#!/bin/bash

set -e

mem=10g
sleep=5s
version=0.5.3
date=`date +%Y-%m-%d-%H-%M`


SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DIR=$SCRIPT_DIR/$1
DIRNAME=`basename $DIR`
basepath=$SCRIPT_DIR/results/$DIRNAME/$date-$mem-v$version

mkdir -p $basepath

if [[ -e $SCRIPT_DIR/config.properties ]]; then
    cp $SCRIPT_DIR/config.properties $basepath
else
    echo "config.properties file is missing"
    exit 1
fi

# copy the Jar file in the local directory
cp $SCRIPT_DIR/../target/guarded-saturation-$version-jar-with-dependencies.jar .

for filename in $DIR/*.dlgp
do
    cd $basepath
    basenameF=$(basename "$filename" .dlgp)
	echo "Testing $basenameF - $mem"
	rm -f "$basenameF.log"
        { # try
            CMD="java -Xmx$mem -jar $SCRIPT_DIR/guarded-saturation-$version-jar-with-dependencies.jar dlgp $filename"
            echo $CMD
	    time $CMD &> "$basenameF.log"
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
