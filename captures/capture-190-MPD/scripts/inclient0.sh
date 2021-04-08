#!/bin/sh

DURATION="$1"

mpc -h 172.16.238.40 ls Files/media/playlists/0 | mpc -h 172.16.238.40 add

mpc -h 172.16.238.40 play

sleep $DURATION
