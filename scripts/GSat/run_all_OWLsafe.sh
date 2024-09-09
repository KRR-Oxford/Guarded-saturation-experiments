#!/bin/bash

timeout=10m
mem=10g
sleep=5m
version=0.4.0
date=`date +%Y-%m-%d`

basepath=results/OWLsanitised_cleaned_safe/$timeout-$mem-$date-v$version
mkdir -p $basepath

for filename in Datasets/GSat/OWLsanitised_cleaned_safe/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Testing $basenameF - $timeout $mem"
	rm -f "$basepath/$basenameF.log"
	time timeout $timeout java -Xmx$mem -jar guarded-saturation-$version-jar-with-dependencies.jar owl $filename &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
