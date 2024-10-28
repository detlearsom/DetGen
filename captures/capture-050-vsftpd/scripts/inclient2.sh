#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"

echo "CONNECTING ..."
ftp -n $HOST 21 <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
verbose
bin
prompt
mget .
quit
END_SCRIPT
exit 0
