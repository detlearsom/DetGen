#!/bin/bash

Params=$(
	zenity --forms --title="Credentials" --add-list="Specification" --list-values="Randomise|Manual" --add-entry="User-name length" --add-entry="Password length"
)

if [[ $Params == *"Randomise"* ]]; then
	export PWRandomisation="1"
fi

IFS='|'
read -a strarr <<< "$Params"


export RN3="${strarr[1]}"
export RNP3="${strarr[2]}"



	
