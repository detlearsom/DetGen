#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export Directory="140-secureSQL-rsyslog"
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"
REPEAT="$3"

[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-140-securesql-rsyslog_apache_1" "capture-140-securesql-rsyslog_admin_user_1" "capture-140-securesql-rsyslog_sql_1")

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
    docker-compose up -d

    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" 
    . ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    # setup time    
    sleep ${DURATION}
    

    # start scenario
    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs capture-140-securesql-rsyslog_sql_1 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    
    # start log capture
    docker exec capture-140-securesql-rsyslog_sql_1 sh -c "tail -n 0 -f /var/log/sql.log | logger -n 172.16.230.2 -P 514 -t mysql -p local6.info" &
    docker exec capture-140-securesql-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/access.log | logger -n 172.16.230.2 -P 514 -t apache-access -p local6.info" &
    docker exec capture-140-securesql-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/error.log | logger -n 172.16.230.2 -P 514 -t apache-error -p local6.error" &
    docker exec capture-140-securesql-rsyslog_apache_1 sh -c "tail -n 0 -f /var/log/apache2/php_errors.log | logger -n 172.16.230.2 -P 514 -t apache-php -p local6.info" &
    sleep 1
    docker exec -it capture-140-securesql-rsyslog_sql_1 /home/share/sql_script.sh $FULL_PASS
    echo "Capturing data now for $DURATION seconds...."
    docker exec capture-140-securesql-rsyslog_admin_user_1 python /usr/share/scripts/populate_userlist.py &
    sleep $DURATION
    ################################################################################
    docker exec capture-140-securesql-rsyslog_sql_1 pkill -f "tail -n 0 -f /var/log/sql.log" &
    docker exec capture-140-securesql-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/access.log" &
    docker exec capture-140-securesql-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/error.log" &
    docker exec capture-140-securesql-rsyslog_apache_1 pkill -f "tail -n 0 -f /var/log/apache2/php_errors.log" &
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################    

    docker-compose down
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done

