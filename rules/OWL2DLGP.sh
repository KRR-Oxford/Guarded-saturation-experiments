#!/bin/bash

set -e

SCRIPT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DIR=$SCRIPT_DIR/$1
OUTPUT=$DIR/"stats.csv"
OWL2DLGP_JAR=$SCRIPT_DIR/../owl2dlgp/target/owl2dlgp-1.1.0-SNAPSHOT.jar
CSV_SEP=","
#200M
MAXSIZE=200000000

echo "NAME,OTHER,FACT,EqGD,NEG_TGD,FGTGD,FNotGTGD,ExGTGD,ExNotGTGD,TGD"> $OUTPUT
for OWL_FILE in $DIR/OWL/*.owl;
do
    FILE_NAME=`basename $OWL_FILE`
    NAME=${FILE_NAME%".owl"}
    if [[ ! -e "ISG-guarded_kaon2/$NAME.owl" ]];
    then
        echo "not such file $NAME.owl";
        continue;
    fi
    FILESIZE=$(stat -c%s "ISG-guarded_kaon2/$NAME.owl")

    if (( $FILESIZE > $MAXSIZE )); then
        echo "Skipping "$OWL_FILE" because it is too large"
        continue;
    fi
    
    DLGP_FILE=$DIR/$NAME.dlgp
    # generate the DLPG
    if [[ ! -e $DLGP_FILE ]];
    then
        echo "Generating "$DLGP_FILE
        java -jar $OWL2DLGP_JAR -f $OWL_FILE -o $DLGP_FILE
    fi

    echo "Reading "$DLGP_FILE

    OTHER_LINE=`grep " dependencies:" $DLGP_FILE`
    OTHER=${OTHER_LINE#*"dependencies: "}

    FACT_LINE=`grep " Facts:" $DLGP_FILE`
    FACT=${FACT_LINE#*"Facts: "}
    
    EQGD_LINE=`grep " equality:" $DLGP_FILE`
    EQGD=${EQGD_LINE#*"equality: "}

    NEG_LINE=`grep " negation:" $DLGP_FILE`
    NEG=${NEG_LINE#*"negation: "}
    
    FGTGD_LINE=`grep " Full guarded rules:" $DLGP_FILE`
    FGTGD=${FGTGD_LINE#*"rules: "}

    FNGTGD_LINE=`grep " Full unguarded rules:" $DLGP_FILE`
    FNGTGD=${FNGTGD_LINE#*"rules: "}

    EGTGD_LINE=`grep " Existential guarded rules:" $DLGP_FILE`
    EGTGD=${EGTGD_LINE#*"rules: "}

    ENGTGD_LINE=`grep " Existential unguarded rules:" $DLGP_FILE`
    ENGTGD=${ENGTGD_LINE#*"rules: "}

    
    TOTAL_LINE=`grep " Rules:" $DLGP_FILE`
    TGD=${TOTAL_LINE#*"Rules: "}


    echo $NAME$CSV_SEP$OTHER$CSV_SEP$FACT$CSV_SEP$EQGD$CSV_SEP$NEG$CSV_SEP$FGTGD$CSV_SEP$FNGTGD$CSV_SEP$EGTGD$CSV_SEP$ENGTGD$CSV_SEP$TGD >> $OUTPUT
done
