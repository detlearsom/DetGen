#!/bin/bash


DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-240-stream-nginx_host-1" "capture-240-stream-streamer-1" "capture-240-stream-viewer-1")


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
    DELAY1=$((RANDOM % 400 + 101))
    DELAY2=$((RANDOM % 400 + 101))
    DELAY3=$((RANDOM % 400 + 101))

    ../Controlfunctions/container_tc.sh capture-240-stream-streamer_1 $DELAY1
    ../Controlfunctions/container_tc.sh capture-240-stream-viewer_1 $DELAY2
    ../Controlfunctions/container_tc.sh capture-240-stream-nginx_host_1 $DELAY3
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
