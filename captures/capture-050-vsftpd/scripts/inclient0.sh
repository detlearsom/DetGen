#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"
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
