#!/bin/sh

NAME="$1"
CAPTURETIME="$2"
SCENARIO="$3"
REPNUM="$4"

/usr/sbin/tcpdump 'not(ip6 or arp or (udp and (src port 5353 or src port 57621)))' -v -w "/data/dump-${NAME}-${CAPTURETIME}-sc${SCENARIO}-${REPNUM}.pcap"