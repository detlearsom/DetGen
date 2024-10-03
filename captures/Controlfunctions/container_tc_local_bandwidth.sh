 #!/bin/bash

CongestRandomisation="$1"
ContainerID1="$2"
ContainerID2="$3"
ContainerID3="$4"
ContainerID4="$5"
ContainerID5="$6"
ContainerID6="$7"
ContainerID7="$8"
ContainerID8="$9"

ContainerIDS=("${ContainerID1}")

if ! [[ -z "${ContainerID2}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID2}")
fi

if ! [[ -z "${ContainerID3}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID3}")
fi

if ! [[ -z "${ContainerID4}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID4}")
fi

if ! [[ -z "${ContainerID5}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID5}")
fi

if ! [[ -z "${ContainerID6}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID6}")
fi

if ! [[ -z "${ContainerID7}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID7}")
fi

if ! [[ -z "${ContainerID8}" ]]; then 
	ContainerIDS=(${ContainerIDS[@]} "${ContainerID8}")
fi

#echo ${ContainerIDS[@]}

function getexpRV(){
LAMBDA="$1"
Nrand=32767
RN=$((1+ RANDOM % ${Nrand}))
RN=`echo "1-${RN}/${Nrand}" | bc -l`
RN=$(echo "((-l(${RN})))" | bc -l)
RN=$(echo "${RN}*${LAMBDA}" | bc -l)
echo "0${RN:0:6}"
}

if [[ ${CongestRandomisation} == "1" ]]; then
    	echo "Randomisation active"
	MLat=$((RANDOM%500))
	SLat=$((RANDOM%100))
    	Loss=$(getexpRV 2)
   	Corrupt=$(getexpRV 2)
    	MRe=$(getexpRV 2)
    	SRe=$(getexpRV 25)

        echo "MLat is $MLat"

fi

round()
{
echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
};
                                                                                                                                                                                                              function get_container_veth() {
  # Get the process ID for the container named ${CONTAINER}:
  VAR="$(docker ps | grep "${ContainerID}")"
  VAR2="${VAR:0:8}"
  pid=$(docker inspect -f '{{.State.Pid}}' "${VAR2}")
  
  # Make the container's network namespace available to the ip-netns command:
  mkdir -p /var/run/netns
  ln -sf /proc/$pid/ns/net "/var/run/netns/${ContainerID}"

  # Get the interface index of the container's eth0:
  index=$(ip netns exec "${ContainerID}" ip link show eth0 | head -n1 | sed s/:.*//)
  # Increment the index to determine the veth index, which we assume is
  # always one greater than the container's index:
  let index=index+1

  # Write the name of the veth interface to stdout:
  ip link show | grep "^${index}:" | sed "s/${index}: \(.*\):.*/\1/"

  # Clean up the netns symlink, since we don't need it anymore
  rm -f "/var/run/netns/${ContainerID}"
}

bandwidths=("512kbit" "1mbit" "5mbit" "10mbit" "25mbit" "50mbit")
#bandwidths=("64kbit" "128kbit" "256kbit" "512kbit")
latencies=("5ms" "10ms" "15ms" "25ms" "50ms")
for ContainerID in "${ContainerIDS[@]}"
do
bandwidth=${bandwidths[ $RANDOM % ${#bandwidths[@]} ]}
latency=${latencies[ $RANDOM % ${#latencies[@]} ]}

echo "Selected Bandwidth: " ${bandwidth}
echo "Selected Latency: " ${latency}

echo "Applying Congestion to Container $ContainerID"

veth_full=$(get_container_veth $ContainerID)
echo "Full Veth: "
echo ${veth_full}
veth=${veth_full%@*}

#tc qdisc replace dev $veth root netem delay "$MLat"ms "$SLat"ms distribution paretonormal loss $Loss% corrupt $Corrupt% reorder "$MRe"% "$SRe"%
if [[ $ContainerID == "capture-320-slowhttptest-apache-1" ]]
then
  echo "Not limiting bandwidth of server"
  #tc qdisc add dev $veth root tbf rate 500000kbit burst 9375 limit 18750
else
  echo "Limiting bandwidth of attacker"
  #tc qdisc replace dev $veth root netem delay 10ms 1ms distribution pareto
  echo "TRUNCATED VETH: "
  echo ${veth}
  tc qdisc add dev $veth root tbf rate ${bandwidth} burst ${bandwidth} latency ${latency}
  #echo "MLAT: " ${MLat}
  #echo "SLAT: " ${SLat}
  #tc qdisc add dev $veth root netem delay "$MLat"ms 5ms #distribution paretonormal # loss $Loss%
fi

#echo "tc qdisc replace dev" "root netem delay" "$MLat""ms" "$SLat""ms" "distribution pareto loss "$Loss"% corrupt "$Corrupt"% reorder $MRe% $SRe%"

#tc qdisc add dev $veth root netem loss $Loss%

#tc qdisc add dev $veth root netem corrupt $Corruption%

done

echo "Congestion applied"

