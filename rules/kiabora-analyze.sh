#!/bin/bash

set -e
TIMEOUT=10m
SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DIR=$SCRIPT_DIR/$1
OUTPUT=$DIR/"kiabora"

mkdir -p $OUTPUT

for DLGP_FILE in $DIR/*.dlgp;
do
    FILE_NAME=`basename $DLGP_FILE`
    NAME=${FILE_NAME%".dlgp"}
    (timeout $TIMEOUT java -jar $SCRIPT_DIR/kiabora-1.2.0.jar -a -f $DLGP_FILE > $OUTPUT/$NAME".txt" ||
         echo "!!!TIMEOUT!!!" > $OUTPUT/$NAME".txt")
done
