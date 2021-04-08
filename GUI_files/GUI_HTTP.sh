#!/bin/bash

CImplementations=("WGET" "SIEGE" "Scrapy" "CURL")
CImplementation=$(
	zenity --list --title="Client implementation selection" --width="1000" --height="400" \
		--column="Client Implementation" \
		--text "Insert your choice" "${CImplementations[@]}" \
)

if [[ $CImplementation == "${CImplementations[0]}" ]]; then
	SImplementations=("NGINX" "Apache" "NGINX-SSL" "Apache-SSL")
	SImplementation=$(
	zenity --list --title="Server implementation selection" --width="1000" --height="400" \
		--column="Implementation" \
		--text "Insert your choice" "${SImplementations[@]}" \
)
	if [[ $SImplementation == "${SImplementations[0]}" ]]; then
		export Directory="capture-021-nginxWget"
		export ExecFile="capture.sh"	
		Activities=("1")
		export Descriptions=("WGET large website")	
	elif [[ $SImplementation == "${SImplementations[1]}" ]]; then
		export Directory="capture-041-apachewget"
		export ExecFile="capture.sh"	
	elif [[ $SImplementation == "${SImplementations[2]}" ]]; then
		export Directory="capture-022-nginxSSL"
		export ExecFile="capture-nginx.sh"		
	elif [[ $SImplementation == "${SImplementations[3]}" ]]; then
		export Directory="capture-042-apacheSSL"
		export ExecFile="capture.sh"	
	fi
fi
		
if [[ $CImplementation == "${CImplementations[1]}" ]]; then
		SImplementations=("NGINX" "Apache")
	SImplementation=$(
	zenity --list --title="Server implementation selection" --width="1000" --height="400" \
		--column="Implementation" \
		--text "Insert your choice" "${SImplementation[@]}" \
)
	if [[ $SImplementation == "${SImplementations[0]}" ]]; then
		export Directory="capture-020-nginx"
		export ExecFile="capture-nginx.sh"		
	elif [[ $SImplementation == "${SImplementations[1]}" ]]; then
		export Directory="capture-040-apache"
		export ExecFile="capture-apache.sh"	
	fi


fi

if [[ $CImplementation == "${CImplementations[2]}" ]]; then
	export Directory="capture-030-scrapy"
	ExecFile="capture.sh"		
fi

if [[ $CImplementation == "${CImplementations[3]}" ]]; then
	zenity --error --title="Not implemented yet" --text="This client-scenario is not implemented yet, sorry. Switching to WGET-NGINX-scenario"
	export Directory="capture-021-nginxwget"
	export ExecFile="capture.sh"		
fi

export Activity=$(
		zenity --list --title="Activity selection" --width="1000" --height="400" \
			--column="Activities" \
			--text "Insert your choice" "${Activities[@]}" \
)
if [[ ${Activity} == "randomise" ]]; then
		export ActRandomisation=1
fi	


export Scenario="${CImplementations}-${SImplementations}"
