#!/bin/bash

Scenarios=("Ping" "HTTP-server-client" "FPT-client-server" "File-synchronisation" "SSH-client-server" "IRC" "BitTorrent")

Params=$(
	zenity --forms --title="File length" --add-list="Specification" --list-values="Randomise|Manual" --add-entry="File length" --add-entry="Filename length" --add-entry="Directory length" 
)

if [[ $Params == *"Randomise"* ]]; then
	FileRandomisation="1"
fi

IFS='|'
read -a strarr <<< "$Params"


FLength="${strarr[1]}"
FNLength="${strarr[2]}"
DLength="${strarr[3]}"




