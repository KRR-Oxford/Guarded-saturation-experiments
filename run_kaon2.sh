#!/bin/bash

set -e

mem=10g
version=0.5.1
sleep=1s
date=`date +%Y-%m-%d-%H-%M`

JAR=ExecutorOWL-$version-jar-with-dependencies.jar
TIMEOUT=600 #10min

DIR=$1
DIRNAME=`basename $DIR`
SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
basepath=$SCRIPT_DIR/results/$DIRNAME/$date-$mem-$version-$TIMEOUT-kaon2

mkdir -p $basepath

# copy the Jar file in the local directory
cp $SCRIPT_DIR/../target/$JAR .

for filename in $DIR/OWL/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Testing $basenameF - $mem"
	rm -f "$basepath/$basenameF.log"
        { # try
	    time java -Xmx$mem -jar $JAR $filename $TIMEOUT &> "$basepath/$basenameF.log"
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
