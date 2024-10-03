#!/bin/bash

# Anthos:
# Modified from https://github.com/glo-fi/DetGen/tree/master/captures

export DATADIR="$PWD/data"
export Directory="110-nginxBruteForce-rsyslog"

DURATION="$1"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
REPEAT="$2"


[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-110-nginxbruteforce-rsyslog_nginx_1" "capture-110-nginxbruteforce-rsyslog_b_forcer_1")

function generate_password {
    echo "Generating Random Password..."
    PASS=$(python3 generate_password.py)
    echo "Password is $PASS"
    htpasswd -b -c conf/.htpasswd admin $PASS
}

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
    generate_password;
    bringup;
    # start log redirection
    docker exec capture-110-nginxbruteforce-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/access.log | logger -n rsyslog -P 514 -t nginx_access -p local6.info" &
    docker exec capture-110-nginxbruteforce-rsyslog_nginx_1 sh -c "tail -n 0 -f /var/log/nginx/error.log | logger -n rsyslog -P 514 -t nginx_error -p local6.info" &

    # start attack
    docker exec capture-110-nginxbruteforce-rsyslog_b_forcer_1 python /var/lib/brute_force.py &
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    
    # stop log redirection
    docker exec capture-110-nginxbruteforce-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/access.log" &
    docker exec capture-110-nginxbruteforce-rsyslog_nginx_1 pkill -f "tail -n 0 -f /var/log/nginx/error.log" &
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done

