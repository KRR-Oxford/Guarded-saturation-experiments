#!/bin/bash

timeout=60m
mem=10g
sleep=60s
#version=1.1.0
#date=`date +%Y-%m-%d`

basepath=OWLsanitised
mkdir -p $basepath

for filename in OWL/*.owl
do
	basenameF=$(basename "$filename" .owl)
	echo "Converting  $basenameF"
	time timeout $timeout java -Xmx$mem -jar OWLSanitiser-jar-with-dependencies.jar sanitise $filename "$basepath/$basenameF-sanitised.owl"
	echo "Sleeping for $sleep..."
	sleep $sleep
done
