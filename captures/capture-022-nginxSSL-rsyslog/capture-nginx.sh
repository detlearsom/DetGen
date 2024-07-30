#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="022-nginxSSL-rsyslog"
DURATION="$1"
export CONCURRENT_THREADS="$2"
export REQUESTS="$3"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$4"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-022-nginxssl-rsyslog_nginx_1" "capture-022-nginxssl-rsyslog_wget_80_1" "capture-022-nginxssl-rsyslog_wget_443_1")

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --ansi never --log-level ERROR up -d 
    # add tc congestion to the network 
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" "${ContainerIDS[2]}"
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
    docker exec capture-022-nginxssl-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/access.log | logger -n rsyslog -P 514 -t nginx_access -p local6.info" &
    docker exec capture-022-nginxssl-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/error.log | logger -n rsyslog -P 514 -t nginx_error -p local6.info" &
    sleep 1
    # start scenario
    docker exec -t capture-022-nginxssl-rsyslog_wget_80_1 watch -n 5 wget -P /data/downloaded http://172.16.236.15 &
    docker exec -t capture-022-nginxssl-rsyslog_wget_443_1 watch -n 5 wget --ca-certificate=/etc/ssl/server.crt --no-check-certificate -P /data/downloaded https://172.16.236.15:443 &

    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    # stop log capture
    docker exec capture-022-nginxssl-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/access.log" &
    docker exec capture-022-nginxssl-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/error.log" &
    
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done

