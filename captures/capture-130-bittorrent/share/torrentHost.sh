#!/bin/bash


DURATION="$1"
FILES=/downloads/*

mkdir torrents

[ -z "$DURATION"] && DURATION=60

transmission-daemon -y -a *.*.*.* -p 9096 -P 31967


