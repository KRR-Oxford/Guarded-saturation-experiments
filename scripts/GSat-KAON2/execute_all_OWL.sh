#!/bin/bash

timeout=21m
mem=10g
sleep=5m
timeoutP=600
date=`date +%Y-%m-%d`

basepath=results/OWL/$date-$timeoutP
mkdir -p $basepath

for filename in OWL/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "Executing $basenameF - $timeoutP"
	rm -f "$basepath/$basenameF.log"
    time timeout $timeout java -Xmx$mem -cp ExecutorOWL-jar-with-dependencies.jar:kaon2.jar uk.ac.ox.cs.gsat.ExecutorOWL compare $filename $timeoutP &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
