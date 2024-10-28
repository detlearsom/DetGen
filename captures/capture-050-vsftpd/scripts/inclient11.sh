#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"

#Script with wrong password
RN=$((1 + RANDOM % 200))
Pi=`echo "4*a(1)" | bc -l`
RN2=$(echo "1000*(s((0.5*$RN/32767)*$Pi)/c((0.5*$RN/32767)*$Pi))" | bc -l)
RN3=$(echo "5+(2*$RN2+1)/2" | bc )
USER=$(cat /dev/urandom | tr -dc 'a-z' | fold -w $RN3 | head -n 1)
RNP=$((1 + RANDOM % 200))
RNP2=$(echo "1000*(s((0.5*$RN/32767)*$Pi)/c((0.5*$RN/32767)*$Pi))" | bc -l)
RNP3=$(echo "5+(2*$RN2+1)/2" | bc )
PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $RN3 | head -n 1)	
#FILE="SampleAudio_0.4mb.mp3"
#Choose random file
#FILE=$(ls ../dataToShare/ | sort -R | tail -1)
#FILE=$(ls /dataToShare/ | sort -R | tail -1)

echo "CONNECTING ..."
ftp -n $HOST 21 <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
verbose
bin
get $FILE
quit
END_SCRIPT
exit 0
