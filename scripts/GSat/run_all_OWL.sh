#!/bin/bash

timeout=30m
mem=10g
sleep=10m
version=0.0.3
date=`date +%Y-%m-%d`

basepath=results/OWL/$timeout-$mem-$date-v$version
mkdir -p $basepath

for filename in benchmarks/OWL/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Testing $basenameF - $timeout $mem"
	rm -f "$basepath/$basenameF.log"
	time timeout $timeout java -Xmx$mem -jar guarded-saturation-$version-jar-with-dependencies.jar owl $filename &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
