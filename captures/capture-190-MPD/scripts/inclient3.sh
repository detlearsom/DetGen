#!/bin/bash

DURATION="$1"

mpc -h 172.16.238.40 ls Files/media/playlists/ | mpc -h 172.16.238.40 add


mpc -h 172.16.238.40 play

sleep $DURATION
