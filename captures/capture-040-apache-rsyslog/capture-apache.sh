#!/bin/bash

# Anthos:
# Based on https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="040-apache-rsyslog"

DURATION="$1"
export CONCURRENT_THREADS="$2"
export REQUESTS="$3"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$4"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1
[ -z "$CONCURRENT_THREADS" ] && CONCURRENT_THREADS=1
[ -z "$REQUESTS" ] && REQUESTS=20

ContainerIDS=("capture-040-apache-rsyslog_apache_1" "capture-040-apache-rsyslog_siege_1")

function bringup {
    echo "Start the containerised applications..."
    docker-compose --ansi never --log-level ERROR up -d
    # add tc congestion to the network 
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" 
    # Nworkers will be randomised, load on host
    . ../Controlfunctions/set_load.sh ${Nworkers}
}


function teardown {
    echo "Take down the containerised applications and networks..."
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    docker-compose --ansi never --log-level ERROR down --remove-orphans -v
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    bringup;
    # start log capture
    docker exec capture-040-apache-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/httpd/access.log | logger -n rsyslog -P 514 -t apache-access -p local6.info" &
    docker exec capture-040-apache-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/httpd/error.log | logger -n rsyslog -P 514 -t apache-error -p local6.info" &
    sleep 1
    # start scenario
    echo "Capturing data now for $DURATION seconds...."
    docker exec capture-040-apache-rsyslog_siege_1 siege -c$CONCURRENT_THREADS -r$REQUESTS -d 1 -v http://apache &
    sleep $DURATION
    # stop log capture
    docker exec capture-040-apache-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/httpd/access.log" &
    docker exec capture-040-apache-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/httpd/error.log" &
    
    
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done
