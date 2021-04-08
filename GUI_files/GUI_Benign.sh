#!/bin/bash

Scenarios=("ICMP-Ping" "HTTP-server-client" "FPT-client-server" "SMTP-Mailx" "File-sync Syncthing" "SSH-client-server" "IRC" "BitTorrent" "SQL" "MPD-music-stream" "Video-stream" "NTP")

export OLDIFS=$IFS

Scenario=$(
	zenity --list --title="Scenario selection" --width="350" --height="400" \
	--column="Scenario" \
	--text "Insert your choice" "${Scenarios[@]}" \
	
)		

if [[ $Scenario == "${Scenarios[1]}" ]]; then
	. GUI_files/GUI_HTTP.sh
fi

if [[ $Scenario == "${Scenarios[2]}" ]]; then
	export Directory="capture-050-vsftpd"
	ExecFile="capture-vsftpd.sh"	
	Activities=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "randomise")
	export Descriptions=("pwd get SampleAudio_0.4mb.mp3" 
	"pwd get random file" 
	"pwd ls verbose bin prompt mget ." "pwd delete random file" "pwd mdelete" "pwd put random file" "mkdir rename File" "prompt put file" "put file get file" "mput" "mkdir mput mdelete rmdir" "get file wrong password" "put file wrong password" "put file")
	Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi
fi

if [[ $Scenario == "${Scenarios[3]}" ]]; then
	export Directory="capture-070-mailx"
	ExecFile="capture-mailx.sh"
	Activities=("1" "2" "randomise")
	Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)	
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi
fi

if [[ $Scenario == "${Scenarios[4]}" ]]; then
	export Directory="capture-080-syncthing"
	ExecFile="capture_syncthing.sh"
	Activities=("1" "2" "3" "4" "5" "6" "randomise")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi
	NClients=("2" "3" "randomise")
	export CLIENTS=$(
		zenity --list --title="Number of clients" --width="1000" --height="400" \
			--column="Number of clients" \
			--text "Insert your choice" "${NClients[@]}" \
)	
	
fi


if [[ $Scenario == "${Scenarios[5]}" ]]; then
	export Directory="capture-090-openssh"
	ExecFile="capture-ssh.sh"
	Activities=("1" "2" "3" "4" "5" "randomise")
	export Descriptions=("Filetransfer Server to client with password" "Filetransfer Client to server with password" "Short command sequence with sleep commands" "Filetransfer Server to client with password" "Keyscanning")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi


if [[ $Scenario == "${Scenarios[6]}" ]]; then
	export Directory="capture-100-irc"
	ExecFile="capture-irc.sh"
	Activities=("1" "2" "randomise")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

if [[ $Scenario == "${Scenarios[7]}" ]]; then
	export Directory="capture-130-bittorrent"
	ExecFile="torrent-start.sh"
	Activities=("1" "2" "randomise")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi


if [[ $Scenario == "${Scenarios[8]}" ]]; then
	export Directory="capture-140-secureSQL"
	ExecFile="capture_sql.sh"
	Activities=("1" "2" "randomise")
	export Descriptions=("Unsuccessful attack 1" "Unsuccessful attack 2")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

if [[ $Scenario == "${Scenarios[11]}" ]]; then
	export Directory="capture-250-ntp"
	ExecFile="capture-ntp.sh"
	export Duration=15
	Activities=("1" "randomise")
	export Descriptions=("Unsuccessful attack 1" "Unsuccessful attack 2")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

