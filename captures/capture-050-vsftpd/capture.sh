#!/bin/bash
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1


ContainerIDS=("capture-050-vsftpd-vsftpd-1" "capture-050-vsftpd-ftp-client-1")


function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d     
    ## Uncomment below to randomise container bandwidth
    #../Controlfunctions/container_tc_local_bandwidth.sh 1 "${ContainerIDS[0]}" "${ContainerIDS[1]}"
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    #Remove all files so that you can start with a clean slate    
    rm -f -r dataToShare/
    rm -f -r users/
    echo "Done."
}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT

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
    bringup;

    VAR="$(docker ps | grep "vsftpd-ftp-client")"
    VAR2="${VAR:0:8}"
    echo $VAR2
    echo "User: " $User
    echo "Pass: " $Password
    echo "File: " $FILENAME
    docker exec -ti $VAR2 /bin/sh -c "/usr/src/scripts/inclient${SCENARIO}.sh $User $Password $FILENAME"

    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    teardown;
done