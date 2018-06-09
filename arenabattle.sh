    #!/bin/bash

#arena -> adb shell input touchscreen tap 200 270
#arenabutton -> adb shell input touchscreen tap 650 543
#arenabattle -> adb shell input touchscreen tap 1672 451
#refresh -> adb shell input touchscreen tap 1548 260
#stillrefresh -> adb shell input touchscreen tap 1110 590
#adb shell input touchscreen tap 1549 400
#adb shell input touchscreen tap 1549 550
#adb shell input touchscreen tap 1549 700
#adb shell input touchscreen tap 1549 850




getscreen(){
adb shell screencap -p /sdcard/screen.png && adb pull /sdcard/screen.png && adb shell rm /sdcard/screen.png && convert screen.png screen.jpg && rm screen.png

filename=$1
JPG_FILE=$(ls -t1 $1*.jpg | head -n 1)
tmp=${JPG_FILE//[^0-9]/}
tmp=$(echo ${tmp} | sed 's/^0*//')
echo ${tmp}
tmp=$((tmp+1))
result=$(echo 00000$tmp | tail -c 5)
echo "mv screen.jpg ${filename}${result}.jpg"
mv screen.jpg "${filename}${result}.jpg"
    }

    menu(){
        echo "1) start"
        echo "2) arena" 
        echo "3) arenabutton" 
        echo "4) arenabattle" 
        echo "5) refresh"; 
        echo "6) stillrefresh"; 
        echo "7) battle" ; 
        echo "8) victory" ; 
        echo "9) defeated"
        echo "10) noenergy"
        echo "11) unknown"
        echo "12) nomonster"

    }
COUNT=0
OPTS=("start" "arena" "arenabutton" "arenabattle" "refresh" "stillrefresh" "battle" "victory" "defeated" "noenergy" "unknown" "nomonster")
select opt in "${OPTS[@]}"; do
    case $opt in
        "start")
            getscreen "start"
            adb shell input touchscreen tap 1629 757
            sleep 20
            adb shell input touchscreen tap 350 1000
            menu
            ;;
        "arena")
            getscreen "arena"
            adb shell input touchscreen tap 200 270
            menu
            ;;
        "arenabutton")
            getscreen "arenabutton"
            adb shell input touchscreen tap 650 543
            menu
            ;;
        "arenabattle")
            getscreen "arenabattle"
            adb shell input touchscreen tap 400 980
            sleep 2
            adb shell input touchscreen tap 1672 451
            menu
            ;;
        "refresh")
          getscreen "refresh"
          COUNT=0
          adb shell input touchscreen tap 1548 260
          menu
            ;;
        "stillrefresh")
            getscreen "stillrefresh"
            adb shell input touchscreen tap 1006 560
            
            menu
            ;;
        "battle")
            K=$((150 * $COUNT))
            Y=$(($K + 400))
            adb shell input touchscreen tap 1549 $Y
            COUNT=$((COUNT + 1))
            if [ $COUNT -gt 3 ]; then
               COUNT=0
            fi
            menu
            ;;
        "victory")
            getscreen "victory"
	        adb shell input touchscreen tap 1629 757
            sleep 5
            adb shell input touchscreen tap 1629 757
            menu
            ;;
         "defeated")
            getscreen "defeated"
	        adb shell input touchscreen tap 1629 757
            sleep 5
            adb shell input touchscreen tap 1629 757
            menu
            ;;
        "noenergy")
            getscreen "noenergy"
            adb shell input touchscreen tap 1116 654  && \
            adb shell input touchscreen tap 1707 152 && \
            adb shell input touchscreen tap 1831 968
            ;;
        "unknown")
            getscreen "unknown"
            menu
            ;;
        "nomonster")
            getscreen "nomonster"
            adb shell input touchscreen tap 457 730
            adb shell input touchscreen tap 300 730
            adb shell input touchscreen tap 140 730
            adb shell input touchscreen tap 614 730
            menu
            ;;
            *)
            echo "invalid option"
            ;;
    esac
done




