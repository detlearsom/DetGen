#!/bin/sh
HOST="172.16.238.15"
USER="$1"
PASS="$2"
FILE="$3"
cd /dataToShare
echo "CONNECTING ..."
ftp -n $HOST 21 <<END_SCRIPT
quote USER $USER
quote PASS $PASS
pwd
ls
bin
verbose
prompt
mkdir newDirectory
cd newDirectory
mput *
mdelete *
cd ..
chmod 777 newDirectory
rmdir newDirectory
quit
END_SCRIPT
exit 0
