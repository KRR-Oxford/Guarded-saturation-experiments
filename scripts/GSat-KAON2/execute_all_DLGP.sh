#!/bin/bash

timeout=30m
mem=10g
sleep=10s
version=1.1.0
#date=`date +%Y-%m-%d`

basepath=results/DLGP
mkdir -p $basepath

for filename in DLGP/*.dlgp
do
	basenameF=$(basename "$filename" .dlgp)
	echo "Converting  $basenameF"
	rm -f "$basepath/$basenameF.log"
	time timeout $timeout java -Xmx$mem -cp Executor-jar-with-dependencies.jar:kaon2.jar uk.ac.ox.cs.gsat.Executor compare $filename &> "$basepath/$basenameF.log"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
