#!/bin/bash
USER="detgen2"
CHANNEL="#detlearsom"
SERVER="172.16.240.5"

sleep 10
echo -e 'USER detgen2 detgen2 detgen2 detgen2\nNICK detgen2\nJOIN #detlearsom\nPRIVMSG #detlearsom :This is user 2\n\DCC get\nQUIT\n' \
| nc $SERVER 6667
sleep 30



