#!/bin/bash

timeout=22m
mem=10g
sleep=5m
timeoutP=600
version=0.3.0

date=`date +%Y-%m-%d`

basepath=results/kaon2_test_files/$date-$timeoutP-v$version
mkdir -p $basepath

for filename in kaon2_test_files/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Executing $basenameF - $timeoutP"
	rm -f "$basepath/$basenameF.log"
    time timeout $timeout java -Xmx$mem -cp ExecutorOWL-$version-jar-with-dependencies.jar:kaon2.jar uk.ac.ox.cs.gsat.ExecutorOWL compare $filename $timeoutP &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
