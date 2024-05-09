#!/bin/bash       

[ -z "$FileRandomisation" ] && FileRandomisation=1

function getexpRV(){
LAMBDA="$1"
Nrand=32767
RN=$((1+ RANDOM % ${Nrand}))
RN=`echo "1-${RN}/${Nrand}" | bc -l`
RN=$(echo "((-l(${RN})))" | bc -l)
RN=$(echo "${RN}*${LAMBDA}+4" | bc -l)
echo ${RN} | awk '{print int($1)}'
}

function getCauchiRV(){
LAMBDA="$1"
MAX="$2"
RN=`echo "${MAX}+1" | bc -l`
while [[ "${RN}" -gt "${MAX}" ]];
do
Pi=`echo "4*a(1)" | bc -l`
Nrand=32767
RN=$((1+ RANDOM % ${Nrand}))
RN=`echo "0.5*${Pi}*(${RN}/${Nrand})" | bc -l`
RN=$(echo "s(${RN})/c(${RN})" | bc -l)
RN=$(echo "${RN}*${LAMBDA}+2" | bc -l)
RN=$(echo ${RN} | awk '{print int($1)}')
done
echo ${RN}
}



if [[ ${FileRandomisation} == "1" ]]; then
#echo "File Randomisation active"
export FLength=$(getCauchiRV 5000 1000000000000000)
export FNLength=$(getexpRV 20)
fi

export FILENAME=$(cat /dev/urandom | tr -dc 'a-z' | fold -w ${FNLength} | head -n 1)
echo "Filename:${FILENAME}"
export FILE=${FILENAME}
echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${FLength} | head -n 1) >> "dataToShare/${FILENAME}"
