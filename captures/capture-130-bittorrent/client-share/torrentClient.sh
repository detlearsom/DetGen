#!/bin/bash

DURATION="$1"


[ -z "$DURATION" ] && DURATION=60

sleep 20

transmission-daemon -y -a *.*.*.* -p 9097 -P 31968 -c /root/shared/torrents -w /root/shared/downloads

sleep $DURATION
