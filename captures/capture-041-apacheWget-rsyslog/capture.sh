#!/bin/bash

export DATADIR="$PWD/data"
export Directory="041-apacheWget"

export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`

DURATION="$1"
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-041-apachewget-rsyslog_apache_1" "capture-041-apachewget-rsyslog_wget_1")

function bringup {
    echo "Start the containerised applications..."
    docker-compose --ansi never --log-level ERROR up -d
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

    sleep 2 # give time for servers to setup
    docker exec capture-041-apachewget-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/httpd/access.log | logger -n rsyslog -P 514 -t apache-access -p local6.info" &
    docker exec capture-041-apachewget-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/httpd/error.log | logger -n rsyslog -P 514 -t apache-error -p local6.err" &
    sleep 1

    docker exec capture-041-apachewget-rsyslog_wget_1 sh -c "wget --recursive --page-requisites --html-extension --convert-links 'http://apache' -P /data" &
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    docker exec capture-041-apachewget-rsyslog_wget_1 pkill -f "wget --recursive --page-requisites --html-extension --convert-links 'http://apache' -P /data" &
    sleep 5
    docker exec capture-041-apachewget-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/httpd/access.log"
    docker exec capture-041-apachewget-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/httpd/error.log"


    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done
