#!/bin/bash

versions=(0.0.2 0.0.3 0.0.4 0.0.5 0.0.6 0.0.7 0.0.8 0.0.9 0.1.0 0.2.0 0.3.0)

base_folder=~/GSat/results/OWL/10m-10g-2019-07-09
for version in "${versions[@]}"
do
    rm $base_folder/v$version.csv $base_folder/v$version.log
    ~/GSat/get_execution_statistics_detailed.pl $base_folder/v$version/ $base_folder/v$version.csv > $base_folder/v$version.log
done
