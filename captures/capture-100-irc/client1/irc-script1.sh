#!/bin/sh
USER="detgen1"
CHANNEL="#detlearsom"
SERVER="172.16.240.5"

sleep 10
echo -e 'USER detgen1 detgen1 detgen1 detgen1\nNICK detgen1\nJOIN #detlearsom\nPRIVMSG #detlearsom :Hello from user 1\nQUIT\n' \
| nc $SERVER 6667
