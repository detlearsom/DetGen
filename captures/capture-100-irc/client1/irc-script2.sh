#!/bin/bash
USER="detgen1"
CHANNEL="#detlearsom"
SERVER="172.16.240.5"

sleep 10
echo -e 'USER detgen1 detgen1 detgen1 detgen1\nNICK detgen1\nJOIN #detlearsom\nDCC Send detgen2 /data/baba.txt\nQUIT\n' \
| nc $SERVER 6667
