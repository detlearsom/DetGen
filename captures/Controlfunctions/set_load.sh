#!/bin/bash                

IFS=$OLDIFS

function getexpRV(){
LAMBDA="$1"
Nrand=32767
RN=$((1+ RANDOM % ${Nrand}))
RN=`echo "1-${RN}/${Nrand}" | bc -l`
RN=$(echo "((-l(${RN})))" | bc -l)
RN=$(echo "${RN}*${LAMBDA}+2" | bc -l)
echo ${RN} | awk '{print int($1)}'
}

if [[ ${LoadRandomisation} == "1" ]]; then
    	echo "Randomisation active"
    	Nworkers=$(getexpRV 2)
fi

#ps
echo "Setting up host load with ${Nworkers} hogs"
stress -c ${Nworkers} --timeout 200s &
export pid_stress=$!
#echo $pid_stress

#pstree "$pid_stress" -p -a -l > x; echo $(cut -d, -f2 x | cut -d' ' -f1)
