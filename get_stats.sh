#!/bin/bash

set -e
DIR=$1
OUTPUT=$DIR/stats.csv
CSV_SEP=","

echo "NAME,NFTGD_NB,FTGD_NB,SUBSUMED,NEW_FTGD_NB,NEW_NFTGD_NB,NEW_OUTPUT_SIZE,OUTPUT_SIZE,TIME"> $OUTPUT
for log in $DIR/*.log;
do


    # initialization of the values
    NFTGD_NB="N/A"
    FTGD_NB="N/A"
    SUBSUMED="N/A"
    NEW_NFTGD_NB="N/A"
    NEW_FTGD_NB="N/A"
    NEW_OUTPUT_SIZE="N/A"
    OUTPUT_SIZE="N/A"
    RUN_TIME_MS="N/A"

    # get stats about input TGDs
    TGD_STATS=`grep "INFOS: # initial TGDs:" $log || true`
    if [[ -n $TGD_STATS ]];
    then
        SEPARATOR=" , "
        NFTGD_NB=${TGD_STATS#*$SEPARATOR}
        FTGD_NB=${TGD_STATS:23:$(( ${#TGD_STAT} - ${#NFTGD_NB} - ${#SEPARATOR} ))}

        # get subsumed tgds
        SUBSUMED_LINE=`grep "Subsumed elements :" $log || true`

        if [[ -n $SUBSUMED_LINE ]];
        then
            SUBSUMED=${SUBSUMED_LINE#*"elements : "}

            # get derived TGDs
            NEW_TGD_STATS=`grep "Derived full/non full TGDs: " $log || true`
            NEW_FTGD_NB=${NEW_TGD_STATS#*$SEPARATOR}
            NEW_NFTGD_NB=${NEW_TGD_STATS:35:$(( ${#NEW_TGD_STAT} - ${#NEW_FTGD_NB} - ${#SEPARATOR} ))}

            # get subsumed tgds
            OUTPUT_LINE=`grep "Full TGD saturation: (" $log`
            OUTPUT_SUFFIX=${OUTPUT_LINE#*"("}
            OUTPUT_SIZE=${OUTPUT_SUFFIX%%" "*}

            # get ouptput full TGDs not contained in the input
            NEW_OUTPUT_LINE=`grep "full TGDs not contained in the input: " $log`
            NEW_OUTPUT_SIZE=${NEW_OUTPUT_LINE#*"input: "}

            # get run time in ms
            RUN_TIME_LINE=`grep "total time :" $log`
            RUN_TIME_SUFFIX=${RUN_TIME_LINE#*"time : "}
            RUN_TIME=${RUN_TIME_LINE:$(( ${#RUN_TIME_LINE} - ${#RUN_TIME_SUFFIX} )):${#RUN_TIME_LINE}}
            RUN_TIME_MS=${RUN_TIME%%" ms"*}
        fi
    fi

    # Display the time out
    IS_TIMEOUT=`grep "!!! TIME OUT !!!" $log || true`

    if [[ -n $IS_TIMEOUT ]];
    then
        RUN_TIME_MS="TIMEOUT"
    fi

    # Display the error
    IS_ERROR=`grep "!!! ERROR !!!" $log || true`

    if [[ -n $IS_ERROR ]];
    then
        RUN_TIME_MS="ERROR"
    fi
    
    FILE_NAME=`basename $log`
    NAME=${FILE_NAME%".log"}
    echo $NAME$CSV_SEP$NFTGD_NB$CSV_SEP$FTGD_NB$CSV_SEP$SUBSUMED$CSV_SEP$NEW_NFTGD_NB$CSV_SEP$NEW_FTGD_NB$CSV_SEP$NEW_OUTPUT_SIZE$CSV_SEP$OUTPUT_SIZE$CSV_SEP$RUN_TIME_MS >> $OUTPUT

done
