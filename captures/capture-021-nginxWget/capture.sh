#!/bin/bash

export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-021-nginxwget-nginx-1" "capture-021-nginxwget-wget-1")

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

ContainerIDS=("capture-021-nginxwget_wget_1" "capture-021-nginxwget_nginx_1")

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
#    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator_HTTP.sh
#    . ../Controlfunctions/activity_selector.sh 13
    ################################################################################
    bringup;
#    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
#    . ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    ################################################################################
#    . ../Controlfunctions/kill_load.sh
#    . ../Controlfunctions/label_writer.sh
    ################################################################################
    teardown;
    rm -rf data/nginx
done
