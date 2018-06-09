#!/bin/bash
# Bash Menu Script Example

source ./import.sh

COUNT=5
ERRORCOUNT=0
LASTOPT=0
PVPAWAY_BOOL="1"
#DEVICE=$1
#shift
#IMAGE=$1

while [[ $# -gt 0 ]]; do
    ARG=$1
    echo "client_arena: $ARG"
    case $ARG in
	-d=*)
	    key="${ARG#*=}"
	    DEVICE="$key"
	    IMAGE="$key"
	    ;;
	-pa)
	    echo "pvpaway found"
	    PVPAWAY="PVPAWAY"
	    ;;
	*)
	    ;;
    esac
    shift
done
      

echo "PVP away: $PVPAWAY"
echo "Entering client arena: $DEVICE"

while true; do
    getscr 
    uuid=$(uuidgen)
    # cp "${IMAGE}.jpg"  "./clientarena/${DEVICE}_${uuid}.jpg"
    OPT=$(wget -qO- http://localhost:9091/${IMAGE})
    echo "OPT:$OPT,LASTOPT=$LASTOPT"
        if [ "$LASTOPT" == "$OPT" ]; then
            ERRORCOUNT=$((ERRORCOUNT + 1))
            sleep 10
            
            if [ $ERRORCOUNT -gt 12 ]; then
                break;
                exit 0
            fi
            if [ $ERRORCOUNT -gt 6 ]; then
                devtap 50 1010 &&  \
                    devtap 100 850 && \
                    devtap 750 650
            fi
	    else
            ERRORCOUNT=0
        fi
        LASTOPT="$OPT"
    if [ "start" == "$OPT" ]; then
	devtap   1629 757  && \
            sleep 20 && \
	    devtap  350 1000 && echo "Starting start button" && ClientArenaSleepMe 120
		
        COUNT=$((COUNT + 1))
   elif [ "map" == "$OPT" ]; then
       adb -s ${DEVICE} shell input touchscreen swipe 300 300 500 1000 100 && \
       adb -s ${DEVICE} shell input touchscreen swipe 300 300 500 1000 100 && \
       adb -s ${DEVICE} shell input touchscreen swipe 300 300 500 1000 100 && \
       adb -s ${DEVICE} shell input touchscreen swipe 300 300 500 1000 100 && \
       devtap  200 270 &&  sleep 2
    elif [ "arenabutton" == "$OPT" ]; then
        devtap   650 543 && sleep 2
    elif [ "arenabattle" == "$OPT" ]; then
        devtap  400 980 && \
            sleep 2 && \
        	devtap  1672 451 && \
            sleep 2 
    elif [ "refresh" == "$OPT" ]; then
        if [ $COUNT -gt 3 ]; then
	    echo "Refreshing list"
	    if [[ "$PVPAWAY" == "PVPAWAY" && "$PVPAWAY_BOOL" == "0" ]]; then
		echo "PVP Away triggered"
		exit 0
	    fi
	    echo "Complete Refresh"
            COUNT=0
            devtap  1548 260 && sleep 10
	    PVPAWAY_BOOL="0"
	    continue
        fi
        K=$((150 * $COUNT ))
        Y=$(($K + 400))
        devtap  1549 $Y && sleep 5
        echo "Current Count - $COUNT"
    elif [ "stillrefresh" == "$OPT" ]; then
        devtap  1006 560 && sleep 20
    elif [ "nomonster" == "$OPT" ]; then
        cp "${IMAGE}.jpg"  "./clientarena/${DEVICE}_${uuid}.jpg"
           # 758, 586, 444, 278 
        #devtap  758 730 &&  \
        #    devtap   586 730 &&  \
        #    devtap   444 730  && \
        #    devtap  278 730 
	    devtap   1629 757  && \
            sleep 20 && \
            devtap  350 1000  && sleepme 90
        COUNT=$((COUNT + 1))

    elif [ "defeated" == "$OPT" ]; then
        devtap  1629 757 && \
            sleep 2 && \
            devtap  1629 757 && \
            sleep 2
    elif [ "victory" == "$OPT" ]; then
        devtap  1629 757 && \
            sleep 2 && \
            devtap  1629 757 && \
            sleep 2
    elif [ "noinvitation" == "$OPT" ]; then
        devtap  1129 658
        #adb -s ${DEVICE} shell input keyevent 26
        exit 0
    elif [ "again" == "$OPT" ]; then
        getroadie  $OPT
        sleep 30
        continue
    elif [ "error" == "$OPT" ]; then
        #adb -s ${DEVICE} shell input keyevent 26
        break;
    elif [ "home" == "$OPT" ]; then
       devtap 1100 987 && \
         sleep 2
 fi
done
	
