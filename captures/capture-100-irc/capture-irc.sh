#!/bin/bash
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
    docker-compose --no-ansi --log-level ERROR up
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

ContainerIDS=("capture-100-irc_client1_1" "capture-100-irc_client2_1" "capture-100-irc_ircd_1")


trap '{ echo "Interrupted."; teardown; exit 1; }' INT
trap '{ echo "EXITED."; teardown; exit 0; }' EXIT


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    rm -f -r dataToShare/
    cp -r ../../SampleFiles/dataToShare dataToShare/    
    # Randomise user-ID and password
    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator.sh
    . ../Controlfunctions/activity_selector.sh 2
    ################
    ################################################################################
    bringup;
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" "${ContainerIDS[2]}"
    . ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    echo "Capturing data now for $DURATION seconds...."
    sleep ${DURATION}
    ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################
    teardown;
    rm -f -r dataToShare/    
done




