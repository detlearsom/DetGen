#!/bin/bash

DURATION="$1"
REPEAT="$2"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export DATADIR="$PWD/data"

[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-041-apachewget-apache-1" "capture-041-apachewget-wget-1")

function bringup {
    echo "Start the containerised applications..."
    #export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d 
    ## Uncomment below to randomise container bandwidth
    #../Controlfunctions/container_tc_local_bandwidth.sh 1 "${ContainerIDS[0]}" "${ContainerIDS[1]}"
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done
