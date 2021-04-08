#!/bin/bash

Scenarios=("Ping" "HTTP-server-client" "FPT-client-server" "File-synchronisation" "SSH-client-server" "IRC" "BitTorrent")

Congestion_params=$(
	zenity --forms --title="Network congestion" --add-list="Specification" --list-values="Randomise|Manual" --add-entry="Mean packet latency [ms]" --add-entry="Latency standard deviation [ms]" --add-entry="Packet loss [%]" --add-entry="Packet corruption [%]" 
)


if [[ $Congestion_params == *"Randomise"* ]]; then
	export CongestRandomisation="1"
fi

IFS='|'
read -a strarr <<< "$Congestion_params"


export MLat="${strarr[1]}"
export SLat="${strarr[2]}"
export Loss="${strarr[3]}"
export Corrupt="${strarr[4]}"



		
