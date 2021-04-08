#!/bin/bash

ContainerID1="$1"
ContainerID2="$2"
ContainerID3="$3"
ContainerID4="$4"
ContainerID5="$5"
ContainerID6="$6"
ContainerID7="$7"
ContainerID8="$8"

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
    	MLat=$(getexpRV 100)
    	SLat=$(getexpRV 50)
    	Loss=$(getexpRV 0.1)
   	Corrupt=$(getexpRV 0.1)

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


for ContainerID in "${ContainerIDS[@]}"
do

echo "Applying Congestion to Container $ContainerID"

veth_full=$(get_container_veth $ContainerID)

veth=${veth_full%@*}

tc qdisc replace dev $veth root netem delay "$MLat"ms "$SLat"ms distribution pareto loss $Loss% corrupt $Corruption%

#tc qdisc add dev $veth root netem loss $Loss%

#tc qdisc add dev $veth root netem corrupt $Corruption%

done

echo "Gongestion applied"

