#### Anthos:
Based on https://github.com/detlearsom/DetGen/tree/main
Capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture-nginx.sh DURATION CONCURRENT_THREADS REQUESTS REPEAT

siege supports up to 256 threads and minimum delay between requests is 1 second. https://www.joedog.org/siege-manual/

This simulation is running nginx and siege. 
For example ./capture-nginx.sh 10 10 1000 2 will run the simulation for 10 seconds using 10 bots (concurrent threads) each one issuing 1000 requests. This will be repeated twice.
