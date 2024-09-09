#!/bin/bash

timeout=30m
mem=10g
sleep=1m
GSatversion=0.0.5
PDQversion=0433256
date=`date +%Y-%m-%d`

basepath=results/ChaseBench/$timeout-$mem-$date
mkdir -p $basepath

# for filename in benchmarks/*
# do
#     project=$(basename "$filename")
# 	echo "Testing GSat on $project - $timeout $mem"
# 	rm -f "$basepath/GSat-v$GSatversion-$project.log"
# 	time timeout $timeout java -Xmx$mem -jar guarded-saturation-$GSatversion-jar-with-dependencies.jar cb $project benchmarks/$project/ &> "$basepath/GSat-v$GSatversion-$project.log"
# 	echo "Sleeping for $sleep..."
# 	sleep $sleep
# 	echo "Testing PDQ on $project - $timeout $mem"
# 	rm -f "$basepath/PDQ-$PDQversion-$project.log"
# 	time timeout $timeout java -Xmx$mem -jar pdq-$PDQversion-reasoning-runnable.jar -ca -f benchmarks/$project/data -s benchmarks/$project/pdq_format.xml &> "$basepath/PDQ-$PDQversion-$project.log"
# 	echo "Sleeping for $sleep..."
# 	sleep $sleep
# 	echo "Testing PDQ EXTERNAL on $project - $timeout $mem"
# 	rm -f "$basepath/PDQ-$PDQversion-external-$project.log"
# 	time timeout $timeout java -Xmx$mem -jar pdq-$PDQversion-reasoning-runnable-external.jar -ca -f benchmarks/$project/data -s benchmarks/$project/pdq_format.xml &> "$basepath/PDQ-$PDQversion-external-$project.log"
# 	echo "Sleeping for $sleep..."
# 	sleep $sleep
# done

for filename in benchmarks/*
do
    project=$(basename "$filename")
	
	rm -f "$basepath/GSat-v$GSatversion-$project-queries.log"
	# rm -f "$basepath/PDQ-$PDQversion-$project-queries.log"
	# rm -f "$basepath/PDQ-$PDQversion-external-$project-queries.log"
	
	echo "Testing GSat on $project all queries - $timeout $mem"
	time timeout $timeout java -Xmx$mem -jar guarded-saturation-$GSatversion-jar-with-dependencies.jar cb $project benchmarks/$project/ &> "$basepath/GSat-v$GSatversion-$project-queries.log"
	
	echo "Sleeping for $sleep..."
	sleep $sleep
	
	echo "Testing PDQ on $project - $timeout $mem"
	time timeout $timeout java -Xmx$mem -jar pdq-$PDQversion-regression-runnable.jar -i benchmarks/$project/ -m full &> "$basepath/PDQ-$PDQversion-$project-queries.log"

	echo "Sleeping for $sleep..."
	sleep $sleep

	# for queryname in benchmarks/$project/queries/*.xml
	# do
	# 	basenameQ=$(basename "$queryname" .xml)
	
	# 	echo "Testing PDQ on $project $basenameQ - $timeout $mem"
	# 	time timeout $timeout java -Xmx$mem -jar pdq-$PDQversion-reasoning-runnable.jar -ca -f benchmarks/$project/data -s benchmarks/$project/pdq_format.xml -q benchmarks/$project/queries/$basenameQ.xml &>> "$basepath/PDQ-$PDQversion-$project-queries.log"
	
	# 	echo "Sleeping for $sleep..."
	# 	sleep $sleep
	
	# 	echo "Testing PDQ EXTERNAL on $project $basenameQ - $timeout $mem"
	# 	time timeout $timeout java -Xmx$mem -jar pdq-$PDQversion-reasoning-runnable-external.jar -ca -f benchmarks/$project/data -s benchmarks/$project/pdq_format.xml -q benchmarks/$project/queries/$basenameQ.xml &>> "$basepath/PDQ-$PDQversion-external-$project-queries.log"
	
	# 	echo "Sleeping for $sleep..."
	# 	sleep $sleep
	# done
done
