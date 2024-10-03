#!/bin/sh
HOST="172.16.238.5"
USER="root"
PASS="root1"
# Check if necessary to scan host
KNOWNHOSTFILE=~/.ssh/known_hosts
if [ ! -f "$KNOWNHOSTFILE" ]; then
    ssh-keyscan -H $HOST >> ~/.ssh/known_hosts
fi

#Choose random file
export FILE=$(ls /dataToShare | sort -R | tail -1)
echo $FILE

echo "WAITING FOR TCPDUMP TO LAUNCH"
sleep 5
echo "SCANNING"
echo "TRANSFERRING " $FILE
sshpass -p $PASS scp $USER@$HOST:/dataToShare/$FILE /receive
echo "DONE"

