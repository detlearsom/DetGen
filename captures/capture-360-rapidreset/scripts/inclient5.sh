#!/bin/sh

sleep 4

WEBPAGE="http://apache/random.png"
python /usr/local/share/scripts/main.py -n 1 -t 60 -s $WEBPAGE

