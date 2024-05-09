#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"
#Choose random file
#FILE=$(ls /dataToShare/ | sort -R | tail -1)

echo "CONNECTING ..."
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
bin
verbose
put /dataToShare/$FILE newfile
get newfile
quit
END_SCRIPT
exit 0
