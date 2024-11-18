#!/bin/bash

DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-022-nginxssl-nginx-1" "capture-022-nginxssl-wget_80-1" "capture-022-nginxssl-wget_443-1")

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d 
    ## Uncomment below to randomise container bandwidth
    #../Controlfunctions/container_tc_local_bandwidth.sh 1 "${ContainerIDS[0]}" "${ContainerIDS[1]}" "${ContainerIDS[2]}"

}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))
    DELAY3=$((RANDOM % 100 + 1))


    ../Capturefunctions/container_tc.sh capture-022-nginxssl-nginx_1 $DELAY1
    ../Capturefunctions/container_tc.sh capture-022-nginxssl-wget_80_1 $DELAY2
    ../Capturefunctions/container_tc.sh capture-022-nginxssl-wget_443_1 $DELAY3
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
#    add_delays;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done

