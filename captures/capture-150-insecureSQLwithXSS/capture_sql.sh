#!/bin/bash

export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-150-insecuresqlwithxss_apache_1" "apture-150-insecuresqlwithxss_attacker_1" "mysql")

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    # Randomise user-ID and password
    . ../Controlfunctions/UserID_generator.sh
    #. ../Controlfunctions/file_creator.sh
    . ../Controlfunctions/activity_selector.sh 3
    ################################################################################
    docker-compose up -d
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" 
    . ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    sleep ${DURATION}
    
    PREFIX="[Entrypoint] GENERATED ROOT PASSWORD: "
    FULL_PASS=$(docker logs mysql2 2>&1 | grep GENERATED)
    FULL_PASS=${FULL_PASS#"$PREFIX"}
    echo "$FULL_PASS"
    echo "Should Have Printed..."
    docker exec -it mysql2 /home/share/sql_script2.sh $FULL_PASS
    echo "Capturing data now for $DURATION seconds...."
    docker exec -it capture-150-insecuresqlwithxss_attacker_1 python /usr/share/scripts/attack$SCENARIO.py
    sleep ${DURATION}
    ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################    
    docker-compose down
done

