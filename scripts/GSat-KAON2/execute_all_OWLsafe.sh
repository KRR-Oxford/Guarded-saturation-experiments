#!/bin/bash

timeout=22m
mem=10g
sleep=5m
timeoutP=600
version=0.4.0

date=`date +%Y-%m-%d`

basepath=results/OWLsanitised_cleaned_safe/$date-$timeoutP-v$version
mkdir -p $basepath

for filename in OWLsanitised_cleaned_safe/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Executing $basenameF - $timeoutP"
	rm -f "$basepath/$basenameF.log"
    time timeout $timeout java -Xmx$mem -cp ExecutorOWL-$version-jar-with-dependencies.jar:kaon2.jar uk.ac.ox.cs.gsat.ExecutorOWL compare $filename $timeoutP &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
