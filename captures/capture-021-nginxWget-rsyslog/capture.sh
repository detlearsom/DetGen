#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export Directory="021-nginxWget-rsyslog"
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

function bringup {
    echo "Start the containerised applications..."
    #export DATADIR="$PWD/data"
    docker-compose --ansi never --log-level ERROR up -d 
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --ansi never --log-level ERROR down --remove-orphans -v
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

ContainerIDS=("capture-021-nginxwget-rsyslog_wget_1" "capture-021-nginxwget-rsyslog_nginx_1")

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
#    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator_HTTP.sh
#    . ../Controlfunctions/activity_selector.sh 13
    ################################################################################
    bringup;
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
    . ../Controlfunctions/set_load.sh ${Nworkers}
    docker exec capture-021-nginxwget-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/access.log | logger -n rsyslog -P 514 -t nginx_access -p local6.info" &
    docker exec capture-021-nginxwget-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/error.log | logger -n rsyslog -P 514 -t nginx_error -p local6.info" &

    ################################################################################
    echo "Capturing data now for $DURATION seconds...."
    docker exec capture-021-nginxwget-rsyslog_wget_1 sh -c 'wget --recursive --page-requisites --html-extension --convert-links "http://nginx" -P /data' &
    sleep $DURATION
    ################################################################################
    docker exec capture-021-nginxwget-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/access.log" &
    docker exec capture-021-nginxwget-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/error.log" &
    sleep 1
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################
    teardown;
    rm -rf data/nginx
done
