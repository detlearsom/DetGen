#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="150-insecureSQLwithXSS-rsyslog"

export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"
REPEAT="$3"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-150-insecuresqlwithxss-rsyslog_apache_1" "capture-150-insecuresqlwithxss-rsyslog_attacker_1" "capture-150-insecuresqlwithxss-rsyslog_sql_1")

function bringup {
    echo "Start the containerised applications..."
    docker-compose up -d
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
    # Randomise user-ID and password
    . ../Controlfunctions/UserID_generator.sh
    #. ../Controlfunctions/file_creator.sh
    . ../Controlfunctions/activity_selector.sh 2
    ################################################################################
    bringup;
    echo "bringing up containers..."
    sleep $DURATION

    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs capture-150-insecuresqlwithxss-rsyslog_sql_1 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    echo "Should Have Printed..."
    # mySql setup:
    docker exec -it capture-150-insecuresqlwithxss-rsyslog_sql_1 /home/share/sql_script2.sh $FULL_PASS    
    # send logs to rsyslog:
    docker exec capture-150-insecuresqlwithxss-rsyslog_sql_1 sh -c "tail -n 0 -f /var/log/sql.log | logger -n 172.16.230.2 -P 514 -t mysql -p local6.info" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/access.log | logger -n 172.16.230.2 -P 514 -t apache-access -p local6.info" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/error.log | logger -n 172.16.230.2 -P 514 -t apache-error -p local6.error" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/php_errors.log | logger -n 172.16.230.2 -P 514 -t apache-php -p local6.info" &
    echo "Capturing data now for $DURATION seconds...."
    docker exec capture-150-insecuresqlwithxss-rsyslog_attacker_1 python /usr/share/scripts/attack$SCENARIO.py &
    sleep $DURATION
    docker exec capture-150-insecuresqlwithxss-rsyslog_sql_1 pkill -f "tail -n 0 -f /var/log/sql.log" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/access.log" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/error.log" &
    docker exec capture-150-insecuresqlwithxss-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/php_errors.log" &
    ################################################################################
    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done

