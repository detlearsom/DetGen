#!/bin/sh

sleep 5

./rapidresetclient  -requests=100  -url  https://apache:443/random.png  -wait=100  -delay=10 -concurrency=10
