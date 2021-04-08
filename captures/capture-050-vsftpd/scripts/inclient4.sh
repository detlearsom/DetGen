#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"

echo "CONNECTING ..."
ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
bin
verbose
prompt
mdelete *
quit
END_SCRIPT
exit 0
