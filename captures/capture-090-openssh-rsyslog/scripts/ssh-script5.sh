#!/bin/sh
HOST="172.16.238.5"
USER="root"
PASS="root"
#Delete known_hosts file
rm -f ~/.ssh/*

echo "WAITING FOR TCPDUMP TO LAUNCH"
sleep 5
echo "SCANNING"
echo "Key-scanning"
ssh-keyscan -H $HOST >> ~/.ssh/known_hosts
echo "DONE"

