#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="120-heartbleed-rsyslog"

export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"

[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --ansi never --log-level ERROR up -d 
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --ansi never --log-level ERROR down --remove-orphans -v
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

ContainerIDS=("capture-120-heartbleed-rsyslog_apache_1" "capture-120-heartbleed-rsyslog_msf_1")
for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    rm -f -r dataToShare/
    cp -r ../../SampleFiles/dataToShare dataToShare/    
    # Randomise user-ID and password
#    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator.sh
#    . ../Controlfunctions/activity_selector.sh 13
    rm -f website_data/secret.txt
    mv dataToShare/$FILENAME website_data/secret.txt
    ################################################################################
    bringup;
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
    . ../Controlfunctions/set_load.sh ${Nworkers}
    
    docker exec capture-120-heartbleed-rsyslog_apache_1 sh -c "tail -n 0 /var/log/apache2/error.log | logger -n rsyslog -P 514 -t apache-error -p local6.info -u /tmp/ignored" &
    docker exec capture-120-heartbleed-rsyslog_apache_1 sh -c "tail -n 0 /var/log/apache2/access.log | logger -n rsyslog -P 514 -t apache-access -p local6.info -u /tmp/ignored" &
    
    sleep 1
    
    docker exec capture-120-heartbleed-rsyslog_msf_1 sh /var/lib/msf_script.sh $DURATION
    ################################################################################
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION

    ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################    
    teardown;
    rm -f -r dataToShare/   
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    
     
done
