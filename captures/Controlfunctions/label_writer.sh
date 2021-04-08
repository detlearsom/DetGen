#!/bin/bash                                                                                                                                                                                                                                                                       


fileName="data/${Directory}-${CAPTURETIME}-labels.csv"
up=($(uptime))
load_avg=${up[8]::-1}

if [[ ${REPNUM} = 1 ]]; then
echo -n "REPNUM;" "Directory;" >> ${fileName}

echo -n "Filename-length;" "File-length;" >> ${fileName}

echo -n "Username-length;Password-length;" >> ${fileName}

echo -n "load;" >> ${fileName}

echo -n "mean latency;latency variance;mean loss;mean corruption;" >> ${fileName}


echo "Scenario;Activity Number;Activity description" >> ${fileName}


fi

echo -n "${REPNUM};${Directory};" >> ${fileName}

echo -n "${FNLength};${FLength};" >> ${fileName}

echo -n "${ULength};${PWLength};" >> ${fileName}

echo -n "${load_avg};" >> ${fileName}

echo -n "${MLat};${SLat};${Loss};${Corrupt};" >> ${fileName}

echo "${Scenario};${Activity};${Description}" >> ${fileName}

