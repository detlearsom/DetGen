#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="050-vsftpd-rsyslog"

export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"
export REPEAT = "$3"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1


ContainerIDS=("capture-050-vsftpd-rsyslog_vsftpd_1" "capture-050-vsftpd-rsyslog_ftp-client_1")

function bringup {
    echo "Start the containerised applications..."
    docker-compose --ansi never --log-level ERROR up -d
    # add tc congestion to the network 
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" 
    # Nworkers will be randomised, load on host
    . ../Controlfunctions/set_load.sh ${Nworkers}
}


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    
    rm -f -r receive/
    rm -f -r dataToShare/
    cp -r ../../SampleFiles/dataToShare dataToShare/
    
    # Randomise user-ID and password
    . ../Controlfunctions/UserID_generator.sh
    . ../Controlfunctions/file_creator.sh
    . ../Controlfunctions/activity_selector.sh 13
    
    ################################################################################
    bringup;
    
    ################################################################################
    #Copy one folder of songs to the server's shared folder
    cp -r  dataToShare/* users/"$User"/
    #Go to the folder where you will receive the file
    mkdir -p receive
    cd receive
    #Make sure all containers are up
    sleep 5
    #Get the ID of the client container
    VAR="$(docker ps | grep "vsftpd-rsyslog_ftp-client")"
    VAR2="${VAR:0:8}"
    #echo "Bla " $VAR2
    #Execute the shell script within the client container
    docker exec capture-050-vsftpd-rsyslog_vsftpd_1 sh -c "tail -f /var/log/vsftpd.log | logger -n rsyslog -P 514 -t vsftpd -p local6.info" &
    ################################################################################
    docker exec -ti $VAR2 /bin/sh -c "/usr/src/scripts/inclient${SCENARIO}.sh $User $Password $FILENAME"

#    docker exec -ti $VAR2 /bin/sh -c "/usr/src/scripts/inclient$1.sh $User $Password" 
    cd ..
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    ################################################################################
    . ../Controlfunctions/kill_load.sh
    . ../Controlfunctions/label_writer.sh
    
    ################################################################################
    # Wait 2 seconds then take things down
    echo "Stopping" 
    docker-compose down --remove-orphans -v
    echo "Stopping" 
    #Remove all files so that you can start with a clean slate    
    rm -f -r dataToShare/
    rm -f -r users/
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    
done
