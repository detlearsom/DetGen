# The simulation

This simulation is running nginx and siege. To run it run `./capture-nginx.sh DURATION CONCURRENT_THREADS REQUESTS REPEAT`
For example ./capture-nginx.sh 10 10 1000 2 will run the simulation for 10 seconds using 10 bots (concurrent threads) each one issuing 1000 requests. This will be repeated twice.
Note: Sometimes you might want to add more requests (1000 is a good number to start) since they happen very fast and there is not enough time for the tcpdump container to start and capture data
