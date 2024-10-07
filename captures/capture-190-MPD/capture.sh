#!/bin/bash
SCENARIO="$1"
DURATION="$2"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$3"
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1


function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d 
}


function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

function scenario {
    VAR="$(docker ps | grep "mpd-mpc")"
    echo $VAR
    VAR2="${VAR:0:8}"
    docker exec -ti $VAR2 /bin/sh -c "/var/lib/scripts/inclient$SCENARIO.sh $DURATION" 
}

function add_delays {
    echo "Adding delays to the network..."
    DELAY1=$((RANDOM % 100 + 1))
    DELAY2=$((RANDOM % 100 + 1))

    ./container_tc.sh capture-190-mpd_mpc_1 $DELAY1
    ./container_tc.sh capture-190-mpd_mopidy_1 $DELAY2
}



trap '{ echo "Interrupted."; teardown; exit 1; }' INT


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    echo "Initiating scenario $SCENARIO"
#    add_delays;
    scenario;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done

