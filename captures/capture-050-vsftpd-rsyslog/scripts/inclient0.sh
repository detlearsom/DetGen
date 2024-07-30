#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
verbose
bin
get $FILE
quit
END_SCRIPT

if [ $? -eq 0 ]; then
    echo "FTP transfer successful."
else
    echo "FTP transfer failed."
fi

exit 0

