#!/bin/bash

export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"
export REPEAT="$3"

[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-150-insecuresql-apache-1" "capture-150-insecuresql-attacker-1" "mysqli")

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

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

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    echo "Initial 30 second pause to set up mysql and apache container...."
    ./config/inserver.sh;
    sleep 30;
    docker exec -it mysqli /home/share/sql_script2.sh;
    #docker exec -ti mysqli /home/share/sql_script.sh;
    docker exec -it capture-150-insecuresql-attacker-1 python /usr/share/scripts/attack$SCENARIO.py
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done


