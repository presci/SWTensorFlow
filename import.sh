#!/bin/bash


storage(){
    devtap 130 770 && devtap 600 230 && \
	sleep 2 && devtap 475 480
    for i in {1..4}; do
	adb -s ${DEVICE} shell input touchscreen swipe 1000 700 1000 300  100
    done
    
}

getroadie(){
    filename=$1
    today=$(date +%s)
    # cp screen.jpg "./${filename}${today}.jpg"
}
getscr(){
    adb -s ${DEVICE} shell screencap -p /sdcard/${IMAGE}.png && \
        adb -s ${DEVICE} pull /sdcard/${IMAGE}.png  && \
        adb  -s ${DEVICE} shell rm /sdcard/${IMAGE}.png && \
        convert ${IMAGE}.png ${IMAGE}.jpg && \
        rm ${IMAGE}.png
	return $?
}

devtap(){
    local X=$1
    shift
    local Y=$1
    adb  -s ${DEVICE} shell input touchscreen tap $X $Y
    return $?
}

sleeptime(){
    # 975 300
    local T=$1
    local G=$(($T / 10))
    local I=0
    while [ I -lt G ]; do
        devtap 975 300
        sleep 10
        I=$((I + 1))
    done
}


#sleepme() {
#    local T=$1
#    while [[ T -gt 0 ]]; do
#       sleep 10
#       T=$(( T - 10 ))
#       echo -ne "."
#   done 
#   return 0
#}
checkmaxlevel () {
    echo "sleepme--maxlevel [$OPT]  SELECT" == "$SELECT"
    if [ "SELECT" == "$SELECT"  ] ; then
	MAXLEVEL=$(wget -qO- http://localhost:9009/detect/maxlevel/${IMAGE})
	echo "MAXLEVEL -- $MAXLEVEL"
	MATCHCOUNT=$((MAXMATCHCOUNT + 1))
    fi

}

sleepme() {
    local T=$1
    while [[ T -gt 0 ]]; do
	sleep 10
	T=$(( T - 10 ))
	getscr
	OPT=$(wget -qO- http://localhost:9009/detect/image/${IMAGE})
	#echo "sleepme -- [${OPT}]"
	case $OPT in
	    "0x5"|"0x1"|"0x6"|"0x2"|"0x8"|"0x100")
		echo "sleepme--victory|defeat [$OPT]"
		if [ "SELECT" == "$SELECT"  ] ; then
		    MAXLEVEL=$(wget -qO- http://localhost:9009/detect/maxlevel/${IMAGE})
		    echo "MAXLEVEL -- $MAXLEVEL"
		    MATCHCOUNT=$((MAXMATCHCOUNT + 1))
		fi
		return 0
		;;
	    "0x808")
		echo "sleepme--dungeon clear" && \
		    devtap 300 300
		return 0
		;;
	    "0x9"|"0xa")
		if [ "SELECT" == "$SELECT"  ] ; then
		    MAXLEVEL=$(wget -qO- http://localhost:9009/detect/maxlevel/${IMAGE})
		    echo "MAXLEVEL -- $MAXLEVEL"
		    MATCHCOUNT=$((MAXMATCHCOUNT + 1))
		fi
		return 0
		;;
	    *)
		echo -ne "."
	esac
    done 
    return 0
}
    



ClientArenaSleepMe(){
    local T=$1
    while [[ T -gt 0 ]]; do
       sleep 10
       T=$(( T - 10 ))
       echo -ne "."
       getscr
       OPT=$(wget -qO- http://localhost:9009/detect/image/${IMAGE})
       echo "ClientArenaSleepMe -- [${OPT}]"
       case $OPT in
	   "0x5"|"0x1"|"0x6"|"0x2"|"0x8")
	       echo "sleepme--victory|defeat [$OPT]"
	       return 0
	       ;;
	   "0x9"|"0xa")
	       echo "sleepme--maxlevel [$OPT]"
		if [ "SELECT" == "$SELECT"  ] ; then
		    echo "inside select"
		    MATCHCOUNT=$((MAXMATCHCOUNT + 1))
		fi
		return 0
		;;
	   *)
		echo "do nothing"
	esac
#	   devtap  350 1000 && sleep 10

       
    done 
    return 0
}	

screenoff() {
    local T=$1
    while [[ T -gt 0 ]]; do
        SCREEN_STATUS=$(adb -s $DEVICE shell dumpsys power | grep "Display Power: state=" | awk -F= '{print $2}' )
        if [ "${SCREEN_STATUS:0:2}" == "ON" ]; then
            echo "Screen on, Turning off"
            adb -s ${DEVICE}  shell  input keyevent 26 
        else
            echo "screen off, do nothing"
        fi
        sleep 10
        T=$(( T - 10 ))
    done
        SCREEN_STATUS=$(adb -s $DEVICE shell dumpsys power | grep "Display Power: state=" | awk -F= '{print $2}' )
        if [ "${SCREEN_STATUS:0:2}" == "ON" ]; then
            echo "Screen is on, do nothing"
        else
            echo "Screen is off, Wake up"
            adb -s ${DEVICE}  shell  input keyevent 26 
        fi
    return 0
}



showtimelapsed() {
    local secs=$1
    printf 'Time lapsed: %dh:%dm:%ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
    return 0;
}

sleepmore(){
    adb -s ${DEVICE}  shell  input keyevent 26 && \
    sleep 600 && \
    adb -s ${DEVICE}  shell  input keyevent 26
}
 


dungeonsleep() {
    echo "DUNGEON SLEEP"
    local T=$1
    GIANTIMAGE="giantimage$RANDOM"
    echo "$T"
    while [[ T -gt 0 ]]; do
        echo "dissy 1"
        getscr
        convert ${GIANTIMAGE}.jpg -crop 800x290+700+160 ${GIANTIMAGE}_GIANT.jpg
        OPT=$(wget -qO- http://localhost:9091/${IMAGE}_GIANT) 
        echo "$OPT"
        if [ "$OPT" == "giants" ]; then
            devtap 970 230 
            break
        fi
       sleep 10
       echo "sleeping $T"
       T=$(( T - 10 ))
   done
   sleepme $T
    return 0

}    


getdevice() {
    IFS=$'\n'
    arr=($(adb devices | awk  '{print $1}' | grep -v List))
    counter=0
    for i in ${arr[@]}; do
            echo  "$counter : $i"
                counter=$((counter + 1))
            done
     read -p "Enter Device Number: " device
     DEVICE=${arr[device]}
     unset IFS
     return 0
}
exitfunction() {
    local tmpexit
    read -p "Exit Function [y|n] : " tmpexit
    case "$tmpexit" in
        Y|y) 
           EXITFUNC="EXITFUNC"
           ;;
       *)
           ;;
   esac
}
