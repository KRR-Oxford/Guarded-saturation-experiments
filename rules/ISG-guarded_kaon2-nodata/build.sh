#!/bin/bash

cd OWL
cp ../ISG-guarded_kaon2/OWL/*.owl .

sed -i 's$owl:DataProperty$owl:ObjectProperty$g' *.owl
sed -i 's$owl:DatatypeProperty$owl:ObjectProperty$g' *.owl
