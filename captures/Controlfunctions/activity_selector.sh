#!/bin/bash
                                                                                                                                                                                                                                                                       
NScen=$1


if [[ ${ActRandomisation} = "1" ]]; then
echo "Activity randomisation active"
	export SCENARIO=$((1 + RANDOM % ${NScen}))
	export Activity=${SCENARIO}
	
fi

export Description=${Descriptions[${SCENARIO}-1]}
echo "Description: ${Description}"
echo "Scenario: ${SCENARIO}"
echo "Activity: ${Activity}"

