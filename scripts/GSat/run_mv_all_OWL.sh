#!/bin/bash

timeout=10m
mem=10g
sleep=1m
versions=(0.0.2 0.0.3 0.0.4 0.0.5 0.0.6 0.0.7 0.0.8 0.0.9 0.1.0 0.2.0 0.3.0)
date=`date +%Y-%m-%d`

basepath=results/OWL/$timeout-$mem-$date
for version in "${versions[@]}"
do
	mkdir -p $basepath/v$version
done

for filename in benchmarks/OWL/*.owl
do
    basenameF=$(basename "$filename" .owl)
	echo "\n\nTesting $basenameF - $timeout $mem"
	for version in "${versions[@]}"
	do
		echo "\nTesting version $version"
		rm -f "$basepath/v$version/$basenameF.log"
		time timeout $timeout java -Xmx$mem -jar guarded-saturation-$version-jar-with-dependencies.jar owl $filename &> "$basepath/v$version/$basenameF.log"
		echo "\nSleeping for $sleep..."
		sleep $sleep
	done
done
