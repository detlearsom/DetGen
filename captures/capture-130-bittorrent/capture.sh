#!/bin/bash

export SCENARIO="$1"
export DURATION="$2"
export DATADIR="$PWD/data"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`



[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-130-bittorrent-torrent_1" "capture-130-bittorrent_torrent_client1_1")

function bringup {
    echo "Start the containerised applications..."
    export DATADIR="$PWD/data"
    docker-compose --no-ansi --log-level ERROR up -d 
}

function teardown {
    echo "Take down the containerised applications and networks..."
    # NB: this removes everything so it is hard to debug from this script
    # TODO: add a `--debug` option instead use `docker-compose stop`.
    docker-compose --no-ansi --log-level ERROR down --remove-orphans -v
    echo "Done."
}

function file_transfer {
    echo "Transfering torrent file to seeders..."
    for f in $(find host-share/data/ -name *.torrent.added) 
    do
	BASENAME=$(basename $f)
	NAME=$(echo "$BASENAME" | cut -f 1 -d '.')

        cp $f client-share/torrents/$NAME.torrent
    done

   # D_ID1=$(docker ps -aqf "name=torrent_client1")

   # docker cp share/torrents $D_ID1:/torrents
    
}

#function file_download {
#    echo "Starting download..."
#    docker exec -it $D_ID1 /var/lib/torrentClient.sh $DURATION
#}

trap '{ echo "Interrupted."; teardown; exit 1; }' INT


function torrent_create {
    for f in $(find ./host-share/data/ -not -name *.torrent) 
    do
        transmission-create -t "http://172.16.238.22:6969/announce/" -t "udp://172.16.238.22:6969/announce/" -t "http://0.0.0.0:6969/announce/" -o $f.torrent $f
        transmission-remote 9096 -a $f.torrent
    done
}

function torrent_delete {

    for f in $(find host-share/data/ -name *.torrent.added) 
    do
        NAME=$(basename $f)
        FILE_STEM=$(echo "$NAME" | cut -f 1 -d '.')
        rm -rf $f
        rm -rf client-share/torrents/$FILE_STEM.*
        rm -rf client-share/downloads/$FILE_STEM.*
    done
}


for ((i=1; i<=REPEAT; i++))
do
    echo "Repeat Nr " $i
    export REPNUM=$i
    rm -f -r dataToShare/
    cp -r ../../SampleFiles/dataToShare dataToShare/    
    # Randomise user-ID and passwordW
    #. ../Controlfunctions/UserID_generator.sh
    #. ../Controlfunctions/file_creator.sh
    #. ../Controlfunctions/activity_selector.sh 13
    ################################################################################
    bringup;
    #. ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}"
    #. ../Controlfunctions/set_load.sh ${Nworkers}
    ################################################################################
    torrent_create;
    file_transfer;
 #   file_download;
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    ################################################################################
    #. ../Controlfunctions/kill_load.sh
    #. ../Controlfunctions/label_writer.sh
    ################################################################################    
    teardown;
    torrent_delete;
    rm -f -r dataToShare/    
done
