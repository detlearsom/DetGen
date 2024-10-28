#!/bin/bash
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`
export SCENARIO="$1"
DURATION="$2"


[ -z "$SCENARIO" ] && SCENARIO=1
[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1


ContainerIDS=("capture-050-vsftpd-vsftpd-1" "capture-050-vsftpd-ftp-client-1")


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
    #. ../Controlfunctions/activity_selector.sh 13
    ################################################################################
    # Start the containerised applications
    docker-compose up -d;
    #. ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
    #. ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    #Copy one folder of songs to the server's shared folder
    #cp -r  dataToShare/* users/"$User"/
    #Go to the folder where you will receive the file
    #cd receive
    #Make sure all containers are up
    #sleep 5
    #Get the ID of the client container
    VAR="$(docker ps | grep "vsftpd-ftp-client")"
    VAR2="${VAR:0:8}"
    #Execute the shell script within the client container
    
    echo $VAR2
    echo "User: " $User
    echo "Pass: " $Password
    echo "File: " $FILENAME
    ################################################################################
    docker exec -ti $VAR2 /bin/sh -c "/usr/src/scripts/inclient${SCENARIO}.sh $User $Password $FILENAME"
    sleep $DURATION
#    docker exec -ti $VAR2 /bin/sh -c "/usr/src/scripts/inclient$1.sh $User $Password" 
    cd ..
    ################################################################################
    #. ../Controlfunctions/kill_load.sh
    #. ../Controlfunctions/label_writer.sh
    ################################################################################
    # Wait 2 seconds then take things down
    echo "Stopping" 
    docker-compose down --remove-orphans -v
    echo "Stopping" 
    #Remove all files so that you can start with a clean slate    
    rm -f -r dataToShare/
    rm -f -r users/
    
done
