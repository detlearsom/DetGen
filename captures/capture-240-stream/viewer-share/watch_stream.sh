#!/bin/sh

sleep 10

rtmpdump -r rtmp://172.26.5.2:1935/stream/test > /dev/null
