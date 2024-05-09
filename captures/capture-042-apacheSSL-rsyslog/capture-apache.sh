#!/bin/bash

# Anthos:
# Modified from https://github.com/detlearsom/DetGen/tree/main

export DATADIR="$PWD/data"
export Directory="042-apachessl-rsyslog"
export CAPTURETIME=`date +%Y-%m-%d_%H-%M-%S`

DURATION="$1"
REPEAT="$2"

[ -z "$DURATION" ] && DURATION=60
[ -z "$REPEAT" ] && REPEAT=1

ContainerIDS=("capture-042-apachessl-rsyslog_apache_1" "capture-042-apachessl-rsyslog_wget_80_1" "capture-042-apachessl-rsyslog_wget_443_1")

function bringup {
    echo "Start the containerised applications..."
    docker-compose --ansi never --log-level ERROR up -d
    # add tc congestion to the network 
    . ../Controlfunctions/container_tc.sh "${ContainerIDS[0]}" "${ContainerIDS[1]}" "${ContainerIDS[2]}"
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
    bringup;
    sleep 2
    # start log capture
    docker exec capture-042-apachessl-rsyslog_apache_1 sh -c "tail -n 0 -f /usr/local/apache2/access.log | logger -n rsyslog -P 514 -t apache-access -p local6.info" &
    docker exec capture-042-apachessl-rsyslog_apache_1 sh -c "tail -n 0 -f /usr/local/apache2/error.log | logger -n rsyslog -P 514 -t apache-error -p local6.err" &
    sleep 1
    # start scenario
    docker exec -t capture-042-apachessl-rsyslog_wget_80_1 watch -n 5 wget -P /data/downloaded http://172.16.239.15 &
    docker exec -t capture-042-apachessl-rsyslog_wget_443_1 watch -n 5 wget --ca-certificate=/etc/ssl/server.crt -P /data/downloaded https://172.16.239.15:443 &
    echo "Capturing data now for $DURATION seconds...."
    sleep $DURATION
    
    docker exec capture-042-apachessl-rsyslog_wget_80_1 pkill -f "watch -n 5 wget -P /data/downloaded http://172.16.239.15" &
    docker exec capture-042-apachessl-rsyslog_wget_443_1 pkill -f "watch -n 5 wget --ca-certificate=/etc/ssl/server.crt -P /data/downloaded https://172.16.239.15:443" &
    sleep 2
    docker exec capture-042-apachessl-rsyslog_apache_1 pkill -f "tail -n 0 -f /usr/local/apache2/access.log" &
    docker exec capture-042-apachessl-rsyslog_apache_1 pkill -f "tail -n 0 -f /usr/local/apache2/error.log" &

    teardown;
    chmod 744 $PWD/logs/all.log
    mv $PWD/logs/all.log "${DATADIR}/logs-${Directory}-${CAPTURETIME}-$REPNUM.log"
    chmod 744 $PWD/sslkeylog/sslkeylogfile.log
    mv $PWD/sslkeylog/sslkeylogfile.log "${DATADIR}/sslkeylog-${Directory}-${CAPTURETIME}-$REPNUM.log"

    # tshark should include ip_src, ip_dst, port_src, port_dst, tcp_seq, tcp_ack, and http_request.
    tshark -r ${DATADIR}/dump-${Directory}-server-${CAPTURETIME}-${REPNUM}.pcap -o 'tcp.relative_sequence_numbers:0' -o "tls.keylog_file:${DATADIR}/sslkeylog-${Directory}-${CAPTURETIME}-${REPNUM}.log" -Y "http.request and not ssdp" -T fields -e frame.number -e frame.time_epoch -e ip.src -e ip.dst -e tcp.srcport -e tcp.dstport -e tcp.seq -e tcp.ack -e http.request.method -e http.request.uri -e http.request.version > ${DATADIR}/ssl-${Directory}-${CAPTURETIME}-${REPNUM}.csv
    # capture unix time in packets



done
