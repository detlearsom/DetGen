#!/bin/bash

DURATION="$1"

mpc -h 172.16.238.40 ls Files/media/playlists/3 | mpc -h 172.16.238.40 add

mpc -h 172.16.238.40 stats

mpc -h 172.16.238.40 play

sleep $DURATION
