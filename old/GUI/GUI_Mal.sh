#!/bin/bash

Scenarios=("SQL-Injection" "Heartbleed" "Apache-XXS" "NGINX-backdoor")

export OLDIFS=$IFS

Scenario=$(
	zenity --list --title="Scenario selection" --width="350" --height="400" \
	--column="Scenario" \
	--text "Insert your choice" "${Scenarios[@]}" \
	
)		

if [[ $Scenario == "${Scenarios[0]}" ]]; then
	export Directory="capture-150-insecureSQLwithXSS"
	ExecFile="capture_sql.sh"
	Activities=("1" "2" "3" "randomise")
	export Descriptions=("Attack 1" "Attack 2" "Attack 3")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

if [[ $Scenario == "${Scenarios[1]}" ]]; then
	export Directory="capture-120-heartbleed"
	ExecFile="capture-heartbleed.sh"
	Activities=("1")
	export Descriptions=("Attack 1")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

if [[ $Scenario == "${Scenarios[2]}" ]]; then
	export Directory="capture-260-XXE"
	ExecFile="capture-xxe.sh"
	Activities=("1" "2" "3" "randomise")
	export Descriptions=("Attack 1" "Attack 2" "Attack 3")
	export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
	if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
	fi	
fi

