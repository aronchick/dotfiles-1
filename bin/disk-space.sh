#!/bin/bash

Black='\e[0;30m'
Blue='\e[0;34m'
Green='\e[0;32m'
Cyan='\e[0;36m'
Red='\e[0;31m'
Purple='\e[0;35m'
Brown='\e[0;33m'
Light_Gray='\e[0;37m'
Dark_Gray='\e[1;30m'
Light_Blue='\e[1;34m'
Light_Green='\e[1;32m'
Light_Cyan='\e[1;36m'
Light_Red='\e[1;31m'
Light_Purple='\e[1;35m'
Yellow='\e[1;33m'
White='\e[1;37m'

Blink='\033[5m'
Bold='\033[1m'
Underline='\033[4m'

No_Color='\033[0m'

TermSize=`tput cols`

if [ $TermSize -gt "81" ]; then
        TermSize=81
fi

function Print {
        
        # Disk I don't care about.
        if [ $DISK = "none" ] || [ $DISK = "/dev/sda3" ] || [ $DISK = "/dev/pts" ] || [ $DISK = "/dev/shm" ] || [[ $DISK =~ /dev/sr.* ]]; then
                continue
        fi

        read SIZE USED FREE PERCENT <<< $(df -hP 2> /dev/null|grep $DISK|awk '{print $2" "$3" "$4" "$5}')
        
        PERCENT=$(echo $PERCENT|sed s/%//)
        
        BarSize=$(echo "($PERCENT*($TermSize-3))/100"|bc)


        if [ "$PERCENT" -gt "90" ]; then
                Color=$Light_Red
        elif [ "$PERCENT" -gt "70" ]; then
                Color=$Yellow
        else
                Color=$Light_Green
        fi

        
        echo "Partition: $DISK"
        #echo
        echo -ne "Total size: $SIZE | "
        echo -ne "Used space: $USED | "
        echo -ne "Free space: ${Color}$FREE${No_Color} | "
        echo -ne "Used space percent: $PERCENT%"
        echo
        

        echo -ne "["
        
        for i in `seq 1 $BarSize`; do
                echo -ne "${Color}#"
                echo -ne "${No_Color}"
        done

        for i in `seq 1 $(echo "$TermSize-$BarSize-3"|bc)`; do
                echo -ne "="
        done

        echo "]"

        echo -ne "${No_Color}"
        echo
}

echo

if [ "$1" != "" ]; then
        DISK=$1
        Print
else
        for DISK in $(mount 2> /dev/null | grep "^/dev/" | awk '{print $1}'); do
                Print
        done
fi​