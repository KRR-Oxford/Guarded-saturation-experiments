#!/bin/bash

timeout=30m
mem=10g
sleep=10s
version=1.1.0
#date=`date +%Y-%m-%d`

basepath=DLGP
mkdir -p $basepath

for filename in OWL/*.owl
do
	basenameF=$(basename "$filename" .owl)
	echo "Converting  $basenameF"
#	rm -f "$basepath/$basenameF.log"
	time timeout $timeout java -Xmx$mem -jar owl2dlgp-$version.jar -f $filename -o "$basepath/$basenameF.dlgp"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
