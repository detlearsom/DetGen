#!/bin/bash  
                                                                                                                                                                                                     
# if not set, set PWRandomisation to default = 1
[ -z "$PWRandomisation" ] && PWRandomisation=1

function getexpRV(){
LAMBDA="$1"
Nrand=32767
RN=$((1+ RANDOM % ${Nrand}))
RN=`echo "1-${RN}/${Nrand}" | bc -l`
RN=$(echo "((-l(${RN})))" | bc -l)
RN=$(echo "${RN}*${LAMBDA}+2" | bc -l)
echo ${RN} | awk '{print int($1)}'
}

echo "Generating User IDs"
if [[ ${PWRandomisation} = "1" ]]; then
    	echo "PW Randomisation active"
 	ULength=$(getexpRV 10)
 	PWLength=$(getexpRV 14)

fi


export User=$(cat /dev/urandom | tr -dc 'a-z' | fold -w ${ULength} | head -n 1)
echo "User " ${User}
################
export Password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${PWLength} | head -n 1)	
echo "Password " $Password
