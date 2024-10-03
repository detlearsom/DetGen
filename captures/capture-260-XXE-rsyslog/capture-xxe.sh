#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="260-XXE-rsyslog"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`

DURATION="$1"
REPEAT="$2"
export SCENARIO="$3"

[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-260-xxe-rsyslog_apache_1" "capture-260-xxe-rsyslog_attacker_1")

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
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
    . ../Controlfunctions/activity_selector.sh 2
    bringup;
    
    
    # to make attack 1 succeed:
    # docker exec capture-260-XXE-rsyslog_apache_1 chmod 777 /etc/shadow
    echo "Capturing data now for $DURATION seconds...."
    # TODO: add log redirection here
    docker exec capture-260-xxe-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/access.log | logger -n rsyslog -u /tmp/ignored -P 514 -t apache-access -p local6.info" &
    docker exec capture-260-xxe-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/error.log | logger -n rsyslog -u /tmp/ignored -P 514 -t apache-error -p local6.info" &
    docker exec capture-260-xxe-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/php-errors.log | logger -n rsyslog -u /tmp/ignored -P 514 -t php-error -p local6.info" &
    sleep 2
    #docker exec -it capture-260-xxe-rsyslog_attacker_1 python /usr/share/scripts/attack0.py
    docker exec -it capture-260-xxe-rsyslog_attacker_1 python /usr/share/scripts/attack$SCENARIO.py
    sleep $DURATION
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    
    
done
