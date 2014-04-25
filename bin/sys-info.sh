#!/bin/sh
# Variables (server default)
TEMP="0"  # 0 for Farenheit, 1 for Celcius
LOCCOD="95110"
# Find your own LOCCOD (location code) at the end of
# the url here: http://www.accuweather.com/rss-center.asp
# If code has a space; replace with %20
#
# Variables
HOSTNAME=`hostname -f`
IP_ADDRS=`ifconfig | grep 'inet addr' | grep -v '255.0.0.0' | cut -f2 -d':' | awk '{print $1}'`
IP_ADDRS=`echo $IP_ADDRS | sed 's/\n//g'`
CPUS=`cat /proc/cpuinfo | grep processor | wc -l | awk '{print $1}'`
CPU_MHZ=`cat /proc/cpuinfo | grep MHz | tail -n1 | awk '{print $4}'`
CPU_TYPE=`cat /proc/cpuinfo | grep vendor_id | tail -n 1 | awk '{print $3}'`
CPU_TYPE2=`uname -m`
OS_NAME=`uname -s`
OS_KERNEL=`uname -r`
BOOT=`procinfo | grep Bootup | sed 's/Bootup: //g' | cut -f1-6 -d' '`
UPTIME=`uptime |cut -d , -f 1 | cut -c 2-`
PCIINFO=`lspci | cut -f3 -d':'`
# Read and process .motd.conf file and set variables
if [ -s "$HOME/.motd.conf" ] ; then
  file=`cat "$HOME/.motd.conf" | grep -Ev '^#' | grep -Ev '^$'`
  motd=`echo "$file" | grep -Ei '^motd=.+' | sed -e 's/motd=//i' -re 's/.*(0).*/\1/'`
  if [ "$motd" == "0" ] ; then
  process="0"
  usage="0"
  weather="0"
  else
  process=`echo "$file" | grep -Ei '^process=.+'    | sed -e 's/process=//i' -re 's/.*(0).*/\1/'`
  usage=  `echo "$file" | grep -Ei '^disk usage=.+' | sed -e 's/disk usage=//i' -re 's/.*(0).*/\1/'`
  weather=`echo "$file" | grep -Ei '^weather=.+'    | sed -e 's/weather=//i' -re 's/.*(0).*/\1/'`
  TEMPu=`  echo "$file" | grep -Ei '^TEMP=.+'       | sed -e 's/TEMP=//i' -re 's/.*([01]).*/\1/'`
  LOCCODu=`echo "$file" | grep -Ei '^LOCCOD=.+'     | sed -e 's/LOCCOD=//i' -re 's/["?](.+)["?]/\1/'`
  if [ $TEMPu != "" ] ; then
    TEMP="$TEMPu"
  fi
  if [ $LOCCODu != "" ] ; then
    LOCCOD="$LOCCODu"
  fi
  fi
fi
#print it out
echo
echo "\033[0;36mHostname         : \033[0;37m$HOSTNAME"
echo "\033[0;36mHost Address(es) : \033[0;37m$IP_ADDRS"
echo "\033[0;36mOS Name          : \033[0;37m$OS_NAME"
echo "\033[0;36mKernel Version   : \033[0;37m$OS_KERNEL"
echo "\033[0;36mCPU Type         : \033[0;37m$CPU_TYPE $CPU_TYPE2 $CPU_MHZ MHz"
echo "\033[0;36mNumber of CPUs   : \033[0;37m$CPUS"
# Display Memory Stats
if [ "$memory" != "0" ] ; then
  memory=`free -m`
  echo "\033[0;36mMemory MB........: \033[0;37m`echo "$memory" | grep 'Mem: ' \
  | awk '{print "Ram used: "$3" free: "$4}'`   `echo "$memory" | grep 'Swap: ' \
  | awk '{print "Swap used: "$3" free: "$4}'`"
fi
# Display Usage of Home Directory
if [ "$usage" != "0" ] ; then
  du -sh $HOME | awk '{print "\033[0;36mDisk Usage.......: \033[0;37mYou\47re using "$1"B in "$2}'
fi
# Display Processes
if [ "$process" != "0" ] ; then
  # (The 2 at end of the next two lines can be used to subtract out any 'offset')
  psa=$((`ps -A h | wc -l`-2))
  psu=$((`ps U $USER h | wc -l`-2))
  verb="are"
  if [ "$psu" -lt "2" ] ; then
    if [ "$psu" -eq "0" ] ; then
    psu=None
    else
    verb="is"
    fi
  fi
  echo "\033[0;36mProcesses........: \033[0;37m$psu of the $psa running $verb yours."
  echo
fi
# Display SSH Logins; System Uptime; System Load
if [ "$LogLoad" != "0" ] ; then
  LogLoad=`uptime`
  echo "\033[0;36mBootup           : \033[0;37m$BOOT"
  # Display System Uptime
  echo $LogLoad | grep -Eo 'up .+ user' \
  | sed -e 's/:/ hours /' -e 's/ min//' -re 's/^up\s+/\x1b[0;36mUptime...........:\x1b[0;37m /' \
  | sed -re 's/,\s+[0-9]+ user$/ minutes/' -e 's/,//g' -e 's/00 minutes//' \
  | sed -re 's/0([1-9] minutes)/\1/' -e 's/(1 hour)s/\1/' -e 's/(1 minute)s/\1/'
  # Display System Load
  echo $LogLoad | grep -Eo 'average: .+' \
  | sed -e 's/average:/\x1b[0;36mLoad.............:\x1b[0;37m/' -e 's/,//g' \
  | awk '{print $1, $2" (1 minute) "$3" (5 minutes) "$4" (15 minutes)"}'
  # Display SSH Logins
  echo $LogLoad | grep -Eo '[0-9]+ users?' \
  | awk '{print "\033[0;36mSSH Logins.......: \033[0;37m"$1, $2" currently logged in."}'
fi
# last login
lastlog -u $USER | tail -1 | awk '{print "\033[0;36mLast Login.......: \033[0;37m"$4, $5, $6, $7" from "$3}'
# Display Weather
if [ "$weather" != "0" ] ; then
  weather=`curl -s http://rss.accuweather.com/rss/liveweather_rss.asp\?TEMP\=${TEMP}\&locCode\=$LOCCOD \
  | grep -E '<description>(Currently|High)' \
  | sed -e 's/.*<description>\(.*\)/\1/' -e 's/\(.*\) &lt.*/\1/' -e 's/\(&#176;\)//'`
  if [ "`echo "$weather" | wc -l`" -eq "3" ] ; then
    echo
    echo "\033[0;35mWeather..........: \033[0;37m`echo "$weather" | head -1`"
    echo "\033[0;35mToday............: \033[0;37m`echo "$weather" | head -2 | tail -1`"
    echo "\033[0;35mTomorrow.........: \033[0;37m`echo "$weather" | tail -1`"
  fi
fi