#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="080-syncthing-rsyslog"

export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export DATADIR="$PWD/data"
export SCENARIO="$1"
DURATION="$2"
#DURATION2="$5"

[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
#[ -z "$DURATION2" ] && DURATION2=60
[ -z "$REPEAT" ] && REPEAT=1
[ -z "$CLIENTS" ] && CLIENTS=randomise

if [ "$CLIENTS" = "randomise" ];
then
	CLIENTRANDOMISE=1
    echo "RANDOMISE CLIENTS"
fi

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
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

if [ "$CLIENTS" = "2" ];
then
    cp docker-compose_2clients.yml docker-compose.yml
else
    cp docker-compose_3clients.yml docker-compose.yml
fi

ContainerIDS=("capture-080-syncthing-rsyslog_synclient1_1" "capture-080-syncthing-rsyslog_synclient2_1" "capture-080-syncthing-rsyslog_synclient3_1")


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    rm -f -r dataToShare/
    cp -r ../../SampleFiles/dataToShare dataToShare/    
    if [ "$CLIENTRANDOMISE" = "1" ];
    then
    	CLIENT=$((RANDOM % 2 + 2))
    	echo "$CLIENT Clients"
    fi
    if [ "$CLIENTS" = "2" ];
	then
	    cp docker-compose_2clients.yml docker-compose.yml
	else
	    cp docker-compose_3clients.yml docker-compose.yml
    fi
    # Randomise user-ID and password
    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator.sh
    . ../Controlfunctions/activity_selector.sh 6
    ################
    ################################################################################
    #FILE=$(ls dataToShare/ | sort -R | tail -1)
    bringup;
        if [ "$CLIENTS" = "2" ];
    then	
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
    else
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" "${ContainerIDS[2]}"
    fi
    . ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    echo "Capturing data now for $DURATION seconds...."
    sleep 5
    if [ "$CLIENTS" = "2" ];
    then	
        cd scripts_2/
        # 2 logger commands here
        docker exec capture-080-syncthing-rsyslog_synclient1_1 sh -c "tail -f /var/log/syncthing.log | logger -n rsyslog -P 514 -t syncthing -p local6.info" &
        docker exec capture-080-syncthing-rsyslog_synclient2_1 sh -c "tail -f /var/log/syncthing.log | logger -n rsyslog -P 514 -t syncthing -p local6.info" &
    else
        cd scripts_3/
        # 3 logger commands here
        docker exec capture-080-syncthing-rsyslog_synclient1_1 sh -c "tail -f /var/log/syncthing.log | logger -n rsyslog -P 514 -t syncthing -p local6.info" &
        docker exec capture-080-syncthing-rsyslog_synclient2_1 sh -c "tail -f /var/log/syncthing.log | logger -n rsyslog -P 514 -t syncthing -p local6.info" &
        docker exec capture-080-syncthing-rsyslog_synclient3_1 sh -c "tail -f /var/log/syncthing.log | logger -n rsyslog -P 514 -t syncthing -p local6.info" &
    fi
    python3 "script$SCENARIO.py" $FILE
    cd ..
    sleep "$DURATION"
        ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    ################################################################################

    teardown;
    rm docker-compose.yml
    rm -f -r dataToShare/
    # store logs
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
done
