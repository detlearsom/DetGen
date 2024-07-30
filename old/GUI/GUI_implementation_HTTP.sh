#!/bin/bash

Scenarios=("Apache-WGET" "NGINX-WGET" "Apache-SSL" "SSH-client-server" "IRC" "BitTorrent")

Scenario=$(
	zenity --list --title="Scenario selection" --width="1000" --height="400" \
	--column="Scenario" \
	--text "Insert your choice" "${Scenarios[@]}" \
	
)


if [[ $Scenario == "${Scenarios[1]}" ]]; then
	Setting=("NGINX" "Apache" "NGINX-SSL" "Apache-SSL" "Webscraping")
	echo $Scenario
fi

if [[ $Scenario == "${Scenarios[2]}" ]]; then
	Activities=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "randomise")
	Description=("pwd get SampleAudio_0.4mb.mp3" 
	"pwd get random file" 
	"pwd ls verbose bin prompt mget ." "pwd delete random file" "pwd mdelete" "pwd put random file" "mkdir rename File" "prompt put file" "put file get file" "mput" "mkdir mput mdelete rmdir" "get file wrong password" "put file wrong password" "put file")
	Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	
fi


. GUI/GUI_congest.sh

echo $MLat
echo $Randomisation
