#!/bin/bash

Congestion_params=$(
	zenity --forms --title="Host load" --add-list="Specification" --list-values="Randomise|Manual" --add-entry="Number of workers (CPU)" --add-entry="Socket stress" --add-entry="Cache stress" 
)

if [[ $Congestion_params == *"Randomise"* ]]; then
	export LoadRandomisation="1"
fi

IFS='|'
read -a strarr <<< "$Congestion_params"


export Nworkers="${strarr[1]}"

