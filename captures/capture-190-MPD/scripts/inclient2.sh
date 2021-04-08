#!/bin/bash

DURATION="$1"

mpc -h 172.16.238.40 ls Files/media/playlists/2 | mpc -h 172.16.238.40 add

mpc -h 172.16.238.40 play

while [ true ]
do
mpc -h 172.16.238.40 pause
sleep 20
mpc -h 172.16.238.40 play
sleep 20
done

sleep $DURATION


