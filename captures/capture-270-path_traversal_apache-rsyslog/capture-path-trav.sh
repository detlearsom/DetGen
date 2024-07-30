#!/bin/bash

export DATADIR="$PWD/data"
export Directory="270-path_traversal_apache-rsyslog"

export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
DURATION="$1"
REPEAT="$2"
export SCENARIO="$3"

[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-270-path_traversal_apache-rsyslog_apache_1" "capture-270-path_traversal_apache-rsyslog_attacker_1")

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
    . ../Controlfunctions/activity_selector.sh 7
    bringup;

    echo "Capturing data now for $DURATION seconds...."
    docker exec capture-270-path_traversal_apache-rsyslog_apache_1 sh -c "tail -n 0 -f /logs/access_log | logger -n rsyslog -P 514 -t apache-access -p local6.info" &
    docker exec capture-270-path_traversal_apache-rsyslog_apache_1 sh -c "tail -n 0 -f /logs/error_log | logger -n rsyslog -P 514 -t apache-error -p local6.info" &
    sleep 1
    docker exec capture-270-path_traversal_apache-rsyslog_attacker_1 python /usr/share/scripts/attack$SCENARIO.py -u http://172.16.27.20/ &

    sleep $DURATION
    
    docker exec capture-270-path_traversal_apache-rsyslog_apache_1 pkill -f "tail -n 0 -f /logs/access_log " &
    docker exec capture-270-path_traversal_apache-rsyslog_apache_1 pkill -f "tail -n 0 -f /logs/error_log " &
    
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    
done
