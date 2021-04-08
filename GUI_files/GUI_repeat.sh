#!/bin/bash


export REPEAT=$(
	zenity --forms --add-entry="Number of repetitions"
)


re='^[0-9]+$'

if ! [[ ${REPEAT} =~ $re ]] ; then
	echo "No rep number given, performing 1 rep"
	REPEAT=1
fi
