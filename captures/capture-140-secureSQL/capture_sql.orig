#!/bin/bash

export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"

[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-140-securesql_apache_1" "capture-140-securesql_admin_user_1" "mysql")

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
    sleep ${DURATION}
    
    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs mysql 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    docker exec -it mysql /home/share/sql_script.sh $FULL_PASS
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################    
    docker-compose down
done

