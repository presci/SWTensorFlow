#!/bin/bash
    # Bash Menu Script Example
source ./import.sh
start=0
end=0
MATCHCOUNT=1000
PVPAWAY=0
STATUS=0
MAXMATCHCOUNT=10
MAXLEVEL=0
ERRORCOUNT=0
SELECT=0
FRIENDS=0
FRIENDCOUNT=0
MAXFRIENDCOUNT=0
FRIENDS_POSITION=0
IMAGE=0
DEVICE=0
TESTME=0
PVP=0
BATTLETIME=480
MAP_ATTACK=0
ARENA_DONE=1
EXITFUNC=0
NEXT=0
LOGIN=0
TOA=0
SCREEN=0
DUNGEON=0
TERMINATE=100
DUNGEONERROR=0
#Tracking purpouse
BATTLECOUNT=0
RUNE=0
REBOOT=0
NORUNE=0
STARRUNE_CT=0
CROLL_CT=0
MONSTER_CT=0
VICTORY_CT=0
DEFEAT_CT=0
DELAYED=0
# end
COMMAND=0
SELL=0
CHECKSTATUS=0
ENERGY=0

    while [[ $# -gt 0 ]]; do
        key="$1"
        echo "next $key"
        case $key in
	    -e=*)
		ENERGY="${key#*=}"
		;;
            --na=*)
                NA="${key#*=}"
                if [ "$NA" == "new" ]; then
                    DEVICE="57122fc4"
                    IMAGE="57122fc4"
                fi
                if [ "$NA" == "old" ]; then
                    DEVICE="49d7d8c1"
                    IMAGE="49d7d8c1"
                fi
                echo "Device : $DEVICE"
                ;;
	    -status)
		STATUS="STATUS"
		;;
            --kill)
                for i in `ps -ef | grep client.sh | awk '{print $2}'`; do
                    kill -9 $i
                done
                exit 0
                ;;
            --all)
                IFS=$'\n'
                arr=($(adb devices | awk  '{print $1}' | grep -v List))
                counter=0
                for i in ${arr[@]}; do
                    nohup ./client.sh -i $i  -t 180 -d $i --exit 2>&1 > /dev/null &
                done
                exit 0
                ;;
            --sell)
                shift
                SELL=$1
                ;;
            --pvp-all)
                IFS=$'\n'
                arr=($(adb devices | awk  '{print $1}' | grep -v List))
                counter=0
                for i in ${arr[@]}; do
                    nohup ./client.sh -d $i --pvp 2>&1 >/dev/null &
                done
                exit -1
                ;;
            --ask)
                read -p "IMAGE : " IMAGE
                read -p "Battle Time : " BATTLETIME
                getdevice
                exitfunction
                COMMAND="./client.sh  -i $IMAGE -t $BATTLETIME -d $DEVICE"
                echo "added to history"
                echo "Image: $IMAGE, Time: $BATTLETIME, Device: $DEVICE"
                ;;
            --delayed)
                shift
                DELAYED=$(($1 * 60 ))
                echo $DELAYED
                ;;
            --regular)
                shift
                DEVICE=$1
                shift
                IMAGE=$1
                shift
                BATTLETIME=$1
                ;;
            --faimon)
                shift
                DEVICE=$1
                shift
                IMAGE=$1
                BATTLETIME=160
                ;;
            --faimon1xp)
                # ./client.sh -d "4ff5e3c" -i "broken"  -t 160 -s 7
                shift
                DEVICE=$1
                shift
                IMAGE=$1
                SELECT=SELECT
                MAXMATCHCOUNT=7
                BATTLETIME=160
                ;;
             --faimon2xp)
                # ./client.sh -d "4ff5e3c" -i "broken"  -t 160 -s 7
                shift
                DEVICE=$1
                shift
                IMAGE=$1
                SELECT=SELECT
                MAXMATCHCOUNT=8
                BATTLETIME=160
                ;;
             --dungeonXP)
               DUNGEON=DUNGEON
               shift
               DEVICE=$1
               shift
               IMAGE=$1
               shift
               BATTLETIME=$1
               EXITFUNC="EXITFUNC"
               ;;
             --dungeon)
               DUNGEON=DUNGEON
               shift
               DEVICE=$1
               shift
               IMAGE=$1
               EXITFUNC="EXITFUNC"
               shift
               BATTLETIME=$1
                ;;
            -pa)
                PVPAWAY="PVPAWAY"
                ;;
            -de)
                DUNGEONERROR="DUNGEONERROR"
                echo "$DUNGEONERROR"
                ;;
            --msg)
                shift
                MSG=$1
                adb -s "$DEVICE" shell input text "$MSG" && \
                    sleep 10 && \
                    adb   -s "$DEVICE" shell input keyevent KEYCODE_ENTER
                exit
                ;;
            -s)
                echo "Selecting monster"
                SELECT=SELECT
                shift
		MATCHCOUNT=$(( 1 + 1 ))
                MAXMATCHCOUNT=$1
                ;;
            -f)
		echo "in friend"
                FRIENDS=FRIENDS
                shift
                MAXFRIENDCOUNT=$1

                ;;
	    -f=*)
		echo "in friend position"
		FRIENDS_POSITION="${KEY#*=}"
		FRIENDS=FRIENDS
		shift
		MAXFRIENDCOUNT=$1

		;;
            -i)
                shift
                IMAGE=$1
                ;;
            -power=*)
                PWR="${key#*=}"
                devtap  630 360 && sleep 5 
                while [[ $PWR -gt  0 ]]; do
                    echo "POWER : $PWR"
                    devtap 500 672   && sleep 4
                    PWR=$(( PWR - 1 ))
                done
                exit
                ;;

            --norune)
                NORUNE="NORUNE"
                ;;
            -d)
                shift
                DEVICE=$1
                ;;
            -t)
                shift
                BATTLETIME=$1
                ;;
            --pvp)
                echo "PVP Starting"
		        PVP="PVP"
                ;;
             -m)
                 shift
                 MAP_ATTACK=$1
                 ;;
             -toa)
               TOA="TOA"
               ;; 
             --next)
                 shift
                 NEXT="NEXT"
                 ;;
	     -login=*)
		 LOGIN="LOGIN"
		 username="${key#*=}"
		 password="prasadi01"
		 ;;
             --login)
                LOGIN="LOGIN"
                shift
                username=$1
                shift
                password=$1
                ;;
             --testgiants)
                getscr 
                convert ${IMAGE}.jpg -crop 800x290+700+160 "${IMAGE}_GIANT.jpg"
                OPT=$(wget -qO- http://localhost:9091/${IMAGE}_GIANT)
                echo "$OPT"
                exit 0
                ;;
             --test)
		 TESTME="TESTME"
                 ;;
             --exit)
                 EXITFUNC="EXITFUNC"
                 ;;
             --rune)
                 RUNE="RUNE"
                 ;;
	     -check-status)
		 CHECKSTATUS="CHECKSTATUS"
		 ;;
             -scr=*)
                 SCREEN="SCREEN"
		 SCREENIMAGE="${key#*=}"
                 ;;
            --monster)
                devtap 1258 972
                exit
                ;;
             --reboot)
                 getdevice
                adb -s "$DEVICE" shell reboot 
                exit
                 ;;
             --sleep)
                 getdevice
                 adb -s ${DEVICE}  shell  input keyevent 26
                 exit
                 ;;
            *)
                shift
                ;;
        esac
        shift
    done

    echo "Device - ${DEVICE}"
    echo "FRIENDS - $FRIENDS"
    echo "MAXMATCHCOUNT:$MAXMATCHCOUNT,MAXFRIENDCOUNT:$MAXFRIENDCOUNT"
    echo "BattleTime : $BATTLETIME"

ERRORCOUNT=0
LASTOPT=0

if [ "${TESTME}" == "TESTME" ]; then
		devtap 800 650 && sleep 2 && \
		 devtap 800 600 && sleep 2 && \
		 devtap 750 650 && sleep 2 && \
		 devtap 950 650 && sleep 2 && \
		 devtap 950 900 && sleep 2
    exit 0
fi

if [ "$LOGIN" == "LOGIN" ]; then
    adb -s "$DEVICE" shell input text "$username" && \
    adb -s "$DEVICE" shell input keyevent KEYCODE_TAB && \
    adb -s "$DEVICE" shell input text "$password" && \
    adb   -s "$DEVICE" shell input keyevent KEYCODE_ENTER
    exit 0
fi
if [ "STATUS" == "$STATUS" ]; then
    adb -s "$DEVICE"  shell dumpsys window
    exit 0
   
fi

if [ "$SCREEN" == "SCREEN" ]; then
    getscr 
    mv "${IMAGE}.jpg" "${SCREENIMAGE}"
    exit
fi


if [ "$CHECKSTATUS" == "CHECKSTATUS" ]; then
    adb -s "$DEVICE" shell dumpsys input_method | grep mScreenOn
    exit 0

fi


if [ "PVPAWAY" == "$PVPAWAY" ];then
    echo "Starting with PVP away"
    echo "PVPAWAY -- $(date)"
    adb -s "$DEVICE" shell dumpsys input_method | grep "mInteractive=false" && adb -s "$DEVICE" shell input keyevent 26
    
    sleep 30 && ./client_arena.sh -d="${DEVICE}" -pa  && sleep 30
    adb -s "$DEVICE" shell input keyevent 26 && exit 0
    echo "PVPAWAY -- end $(date)"
fi
    

if [ "PVP" == "$PVP" ]; then
	echo "Starting with PVP"
	./client_arena.sh  -d="${DEVICE}"
		devtap 1697 171 && \
                devtap 1810 992
                echo "Exit client_arena"
                sleep 100
        adb -s "$DEVICE" shell  input keyevent 26 && exit 0

        
fi


if [ $SELL -gt 0 ]; then
    while [[ $SELL -gt  0 ]]; do
        devtap 915 600  && sleep 1 && \
	    devtap 1770  450 && sleep 1 && \
	    devtap 770 650 && sleep 1 && \
        devtap 800 710 && sleep 1
        SELL=$(( SELL - 1 ))
        echo $SELL
    done
    exit
fi



while true; do
    getscr 
    OPT=$(wget -qO- http://localhost:9091/${IMAGE})
    echo "OPT:$OPT,LASTOPT=$LASTOPT"
    if [ "$LASTOPT" == "$OPT" ]; then
        if [ "DUNGEONERROR" == "$DUNGEONERROR" ]; then
            devtap 500 600
            continue
        fi
        ERRORCOUNT=$((ERRORCOUNT + 1))
        echo "ErrorCount : $ERRORCOUNT" 
        if [ $ERRORCOUNT -gt 20 ]; then
            echo "Giving up"
            if [ $REBOOT == "REBOOT" ]; then
                adb -s "$DEVICE" shell reboot -p
            else
                adb -s "$DEVICE" shell  input keyevent 26
            fi
            break;
        fi
    else
        ERRORCOUNT=0
    fi
    
    LASTOPT="$OPT"
        if [ "start" == "$OPT" ]; then
           
            if [ $FRIENDCOUNT -gt $MAXFRIENDCOUNT ]; then
                FRIENDCOUNT=0
                FRIENDS=0
		    devtap 300 400 && devtap 115 739 

            fi
            if [ "$FRIENDS" == "FRIENDS" ]; then
                FRIENDCOUNT=$((FRIENDCOUNT + 1))
		if [ "$FRIENDS_POSITION" == "0" ]; then
                    devtap   500 290 && devtap   290  951 && echo "NO position"
		else
		    devtap 700 400 && devtap 290 951 && echo "position :${FRIENDS_POSITION}"
		fi
            fi
            if [ "SELECT" == "$SELECT"  ] ; then
		echo "$MATCHCOUNT -gt $MAXMATCHCOUNT" && sleep 2
		echo "--------- MAXLEVEL = $MAXLEVEL ---"
		echo "--------- ${MAXLEVEL}x "
		if [ "${MAXLEVEL}x" != "0x" ]; then
		    echo "Changing monster"
#		    devtap 1500 630 && devtap 1350 630 && devtap 1200 630
		    
		    case $MAXLEVEL in
			1)
			    echo "Changing monster 1"
			    devtap   300 398 && \
				storage && \
				devtap 1500 630 && devtap 950 950
			    ;;
			2)
			    echo "Changing monster 2"
			    devtap   694 398 && \
				storage && \
				devtap 1500 630 && devtap 950 950
			    ;;
			3)
			    echo "Changing monster 12"
			    devtap 300 398 && devtap 694 398 && \
				storage && \
				devtap 1500 630 && devtap 1350 630 && devtap 950 950
			    ;;
			4)
			    echo "Changing monster 3"
			    devtap   498 498 && \
				storage && \
				devtap   1500 630 && devtap 950 950
			    ;;
			5)
			    echo "Changing monster 23"
			    devtap 300 398 && devtap 498 498 && \
				storage && \
				devtap 1500 630 && devtap 1350 630 && devtap 950 950
			    ;;
			6)
			    echo "Changing monster 23"
			    devtap   694 398 && devtap 498 498 && \
				storage && \
				devtap 1500 630 && devtap 1350 630 && devtap 950 950
			    ;;
			7)
			    echo "Changing monster 123"
			    devtap 300 398 && devtap 694 398 && devtap 498 498 && \
				storage && \
				devtap 1500 630 && devtap 1350 630 && devtap 1200 630 && devtap 950 950
			    ;;
			*)
			    echo "none found"
		    esac
		    MAXLEVEL=0
                fi
            fi
            BATTLECOUNT=$((BATTLECOUNT +1))

            MATCHCOUNT=$((MATCHCOUNT + 1))
            end=`date +%s`
            runtime=$((end-start))
            showtimelapsed $runtime
            data_post=$(wget -qO- --post-data="$IMAGE,r:$STARRUNE_CT,s:$SCROLL_CT,m:$MONSTER_CT,d:$DEFEAT_CT,v:$VICTORY_CT" http://localhost:9091/) 
            if [[ $DELAYED -gt 0 ]]; then
                screenoff $DELAYED
            fi
            start=`date +%s`
                devtap  1629 757 && \
                    sleepme  ${BATTLETIME} && echo "Finishing Battle -- ${BATTLECOUNT}"
	elif [ "nomonster" == "$OPT" ]; then
	    start=`date +%s`
            devtap  1629 757 && \
                sleepme  ${BATTLETIME} && echo "Finishing Battle -- ${BATTLECOUNT}"  
        elif [ "map" == "$OPT" ]; then
            if [ "$MAP_ATTACK" == "0" ]; then
                adb -s ${DEVICE} shell input touchscreen swipe 301 300 500 1000 100 && \
                adb -s ${DEVICE} shell input touchscreen swipe 300 300 500 1000 100 && \
                adb -s  ${DEVICE} shell input touchscreen swipe 1800 790 300 790 100 && \
                devtap 100 1048 && \
                devtap  1775 786
            else
                source ./$MAP_ATTACK
            fi
        elif [ "victory" == "$OPT" ]; then 
            VICTORY_CT=$((VICTORY_CT + 1))
	    if [ "TOA" == "$TOA" ]; then
		devtap 600 600 && sleep 2
		continue
	    fi
	    
            if [ "NEXT" == "$NEXT" ]; then
                devtap  680 584 
                continue
            fi
	    
            devtap   1629 757 && \
		sleep 1
	elif [ "lost" == "$OPT" ]; then
	    echo "lost found"
	    	devtap 1360 700 && \
		    devtap 1650 300 && \
		    devtap 400 600 && sleep 2
        elif [ "gift" == "$OPT" ]; then
            devtap  1629 757 && \
            sleep 1
        elif [ "rune" == "$OPT" ]; then
	    cp "${DEVICE}.jpg" "${DEVICE}-rune.jpg"
            if [ "RUNE" == "$RUNE" ]; then
                devtap   1209 915 && sleep 2
                continue
            fi
            devtap  853 887 && \
            sleep 1
        elif [ "replay" == "$OPT" ]; then
            # sleepmore
            if [ "$DUNGEON" == "$DUNGEON" ]; then
                if [ $ERRORCOUNT -gt 2 ]; then
                    devtap  1200  700 && \
                    sleep 2 
                fi
            fi
            if [ "TOA" == "$TOA" ]; then
                devtap 600 590 && sleep 2
                continue
            fi
            if [ "NEXT" == "$NEXT" ]; then
                devtap   1300 582
                continue
            fi
            echo "Replay happening"
            devtap  600 600 && \
            sleep 2
        elif [ "defeated" == "$OPT" ]; then
            if [ "TOA" == "$TOA" ]; then
                devtap 600 590 && sleep 2
            else
                devtap 400 100 && sleep 2
            fi
            
            continue
        elif [ "monster" == "$OPT" ]; then
	    mutt  -s "Test from mutt" c.bar@mail.ru < monster.txt -a "${DEVICE}.jpg"
            MONSTER_CT=$(( MONSTER_CT + 1 ))
            devtap  1006 881 && \
            sleep 2
        elif [ "scrolls" == "$OPT" ]; then
            SCROLL_CT=$(( SCROLL_CT + 1 ))
            devtap  1006 881 && \
            sleep 2
            # remove later
            sleep 2 && devtap 700 600 && sleep 2
            # remove later
        elif [ "5star" == "$OPT" ]; then
            STARRUNE_CT=$(( STARRUNE_CT + 1 ))
            if [ "NORUNE" == "$NORUNE" ]; then
                devtap 800 650 && echo "Selling 5star rune" && sleep 2
                continue
            fi
            echo "Keeping rune" && devtap  1186 664 && \
		mutt  -s "[SummonersWar]5 Star ${DEVICE}" c.bar@mail.ru < 5Star.txt -a "${DEVICE}-rune.jpg" && \
            	devtap   1209 915 && \
            	sleep 2
        elif [ "home" == "$OPT" ]; then
            devtap 1100 987 && \
                sleep 2
        elif [ "noenergy" == "$OPT" ]; then
	    if [ $ENERGY -gt 0 ]; then
		ENERGY=$(( ENERGY - 1 ))
		devtap 800 650 && sleep 2 && \
		    devtap 800 600 && sleep 2 && \
		    devtap 750 650 && sleep 2 && \
		    devtap 950 650 && sleep 2 && \
		    devtap 950 900 && sleep 2
		OPT="0"
		continue
	    fi
	    
            if [ "EXITFUNC" == "$EXITFUNC" ];then
                source ./exitfunc.sh
            else 
                devtap  1120 645  && \
                    devtap  1348 889 && \
                    devtap   1860  97
            fi
            DT=`date +%Y-%m-%d::%H:%M:%S`
            ./client_arena.sh  -d=${DEVICE} && \
                devtap 1697 171 && \
                devtap 1810 992 && \
                echo "Exit client_arena" && \
                data_post=$(wget -qO- --post-data="Exit : $IMAGE,r:$STARRUNE_CT,s:$SCROLL_CT,m:$MONSTER_CT,d:$DEFEAT_CT,v:$VICTORY_CT" http://localhost:9091/) 
                if [ $REBOOT == "REBOOT" ]; then
                    adb -s "$DEVICE" shell reboot -p
                else
                    adb -s "$DEVICE" shell  input keyevent 26
                fi
                echo $COMMAND
                exit 0
        elif [ "quit" == "$OPT" ]; then
            adb -s  ${DEVICE} shell input keyevent 26
            exit 0
        elif [ "lost" == "$OPT" ]; then
            DEFEAT_CT=$((DEFEAT_CT + 1))
            devtap 1200 700 && \
                sleep 2 && \
                devtap 1200 700 hn gyh&& \
                sleep 2 && \
                devtap  423 671 && \
                sleep 2
        elif [ "dungeonlost" == "$OPT" ]; then
            devtap  1200  700 && \
            sleep 2 
        elif [ "again" == "$OPT" ]; then
            sleep 5
        else
            sleep 5
            continue
    fi
done


