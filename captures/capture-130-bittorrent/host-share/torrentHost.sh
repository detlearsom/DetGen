#!/bin/bash


DURATION="$1"

[ -z "$DURATION" ] && DURATION=60

transmission-daemon -y -a *.*.*.* -p 9096 -P 31967 -w /root/shared/data -c /root/shared/data

sleep $DURATION
