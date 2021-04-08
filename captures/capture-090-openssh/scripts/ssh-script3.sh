#!/bin/sh
HOST="172.16.238.5"
USER="root"
PASS="root"
# Check if necessary to scan host
KNOWNHOSTFILE=~/.ssh/known_hosts
if [ ! -f "$KNOWNHOSTFILE" ]; then
    ssh-keyscan -H $HOST >> ~/.ssh/known_hosts
fi

#Choose random file
#export FILE=$(ls /dataToShare | sort -R | tail -1)
#echo $FILE

echo "WAITING FOR TCPDUMP TO LAUNCH"
sleep 15
echo "SCANNING"
echo "TRANSFERRING " $FILE
sshpass -p $PASS ssh $USER@$HOST "sleep 5; ls;sleep 5; ls; sleep5; ls"
echo "DONE"

