#!/bin/bash

set -e
DIR=$1
OUTPUT=$DIR/stats.csv
CSV_SEP=","
SEPARATOR=" , "



if [[ $DIR =~ "-kaon2" ]];
then
    echo "NAME,AXIOM_NB,SUBSUMED,NEW_FTGD_NB,NEW_NFTGD_NB,OUTPUT_SIZE,TIME"> $OUTPUT
    for log in $DIR/*.log;
    do
        # initialization of the values
        AXIOM_NB="N/A"
        SUBSUMED="N/A"
        NEW_NFTGD_NB="N/A"
        NEW_FTGD_NB="N/A"
        OUTPUT_SIZE="N/A"
        RUN_TIME_MS="N/A"

        AXIOM_STATS=`grep "Initial axioms in the ontology: " $log || true`
        AXIOM_NB=${AXIOM_STATS#*"ontology: "}

        SUBSUMED_LINE=`grep "Subsumed elements :" $log || true`
        SUBSUMED=${SUBSUMED_LINE#*"elements : "}
        
        # get derived TGDs
        NEW_TGD_STATS=`grep "Derived full/non full TGDs: " $log || true`
        NEW_TGD_STATS=${NEW_TGD_STATS#*"TGDs: "}
        NEW_NFTGD_NB=${NEW_TGD_STATS#*$SEPARATOR}
        NEW_FTGD_NB=${NEW_TGD_STATS:0:$(( ${#NEW_TGD_STAT} - ${#NEW_NFTGD_NB} - ${#SEPARATOR} ))}
        
        OUTPUT_STATS=`grep "# rules: " $log || true`
        OUTPUT_SIZE=${OUTPUT_STATS#*"rules: "}

        # get run time in ms
        RUN_TIME_LINE=`grep "total time :" $log`
        RUN_TIME_SUFFIX=${RUN_TIME_LINE#*"time : "}
        RUN_TIME=${RUN_TIME_LINE:$(( ${#RUN_TIME_LINE} - ${#RUN_TIME_SUFFIX} )):${#RUN_TIME_LINE}}
        RUN_TIME_MS=${RUN_TIME%%" ms"*}

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
        echo $NAME$CSV_SEP$AXIOM_NB$CSV_SEP$SUBSUMED$CSV_SEP$NEW_FTGD_NB$CSV_SEP$NEW_NFTGD_NB$CSV_SEP$OUTPUT_SIZE$CSV_SEP$RUN_TIME_MS >> $OUTPUT
    done
else
    echo "NAME,NFTGD_NB,FTGD_NB,SUBSUMED,NEW_FTGD_NB,NEW_NFTGD_NB,NEW_OUTPUT_SIZE,OUTPUT_SIZE,NEW_RTGD_BSK,BODY_SK_ATOMS_MAX,EVOL_COUNT,EVOL_TIME,SUMB_TIME,TIME"> $OUTPUT
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
        EVOL_TIME_MS="N/A"
        EVOL_COUNT="N/A"
        # right TGD with skolem in the body
        NEW_RTGD_BSK="N/A"
        BODY_SK_ATOMS_MAX="N/A"
        SUMB_TIME_MS="N/A"
        RUN_TIME_MS="N/A"
        
        # get stats about input TGDs
        TGD_STATS=`grep "# initial TGDs:" $log || true`
        if [[ -n $TGD_STATS ]];
        then
            TGD_STATS=${TGD_STATS#*"TGDs: "}
            NFTGD_NB=${TGD_STATS#*$SEPARATOR}
            FTGD_NB=${TGD_STATS:0:$(( ${#TGD_STAT} - ${#NFTGD_NB} - ${#SEPARATOR} ))}

            # get subsumed tgds
            SUBSUMED_LINE=`grep "Subsumed elements :" $log || true`

            if [[ -n $SUBSUMED_LINE ]];
            then
                SUBSUMED=${SUBSUMED_LINE#*"elements : "}

                # get derived TGDs
                NEW_TGD_STATS=`grep "Derived full/non full TGDs: " $log || true`
                NEW_TGD_STATS=${NEW_TGD_STATS#*"TGDs: "}
                NEW_NFTGD_NB=${NEW_TGD_STATS#*$SEPARATOR}
                NEW_FTGD_NB=${NEW_TGD_STATS:0:$(( ${#NEW_TGD_STAT} - ${#NEW_NFTGD_NB} - ${#SEPARATOR} ))}

                # hack to fix the new non full tgd
                # NEW_NFTGD_NB="$(($NEW_NFTGD_NB-$NFTGD_NB))"

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


        EVOL_TIME_LINE=`grep "evolved time:" $log || true`
        if [[ -n $EVOL_TIME_LINE ]];
        then
            EVOL_TIME_SUFFIX=${EVOL_TIME_LINE#*"time: "}
            EVOL_TIME=${EVOL_TIME_LINE:$(( ${#EVOL_TIME_LINE} - ${#EVOL_TIME_SUFFIX} )):${#EVOL_TIME_LINE}}
            EVOL_TIME_MS=${EVOL_TIME%%" ms"*}
            EVOL_COUNT_LINE=`grep "evolve count: " $log`
            EVOL_COUNT=${EVOL_COUNT_LINE#*"count: "}
        fi

        SUMB_TIME_LINE=`grep "subsumption time:" $log || true`
        if [[ -n $SUMB_TIME_LINE ]];
        then
            SUMB_TIME_SUFFIX=${SUMB_TIME_LINE#*"time: "}
            SUMB_TIME=${SUMB_TIME_LINE:$(( ${#SUMB_TIME_LINE} - ${#SUMB_TIME_SUFFIX} )):${#SUMB_TIME_LINE}}
            SUMB_TIME_MS=${SUMB_TIME%%" ms"*}
        fi

        BODY_SK_ATOMS_MAX_LINE=`grep "maximum number of Skolem atoms in body:" $log || true`
        if [[ -n $BODY_SK_ATOMS_MAX_LINE ]];
        then
            BODY_SK_ATOMS_MAX=${BODY_SK_ATOMS_MAX_LINE#*"body: "}
            NEW_RTGD_BSK=`grep "right derived TGD with Skolem in the body: " $log`
            NEW_RTGD_BSK=${NEW_RTGD_BSK#*"body: "}
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
        echo $NAME$CSV_SEP$NFTGD_NB$CSV_SEP$FTGD_NB$CSV_SEP$SUBSUMED$CSV_SEP$NEW_FTGD_NB$CSV_SEP$NEW_NFTGD_NB$CSV_SEP$NEW_OUTPUT_SIZE$CSV_SEP$OUTPUT_SIZE$CSV_SEP$NEW_RTGD_BSK$CSV_SEP$BODY_SK_ATOMS_MAX$CSV_SEP$EVOL_COUNT$CSV_SEP$EVOL_TIME_MS$CSV_SEP$SUMB_TIME_MS$CSV_SEP$RUN_TIME_MS >> $OUTPUT

    done
fi
