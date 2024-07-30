# Available scenarios

1. 000-Host: Contains a tcpdump container listening onto the host network. (Useful for when running containers on host network mode only).
2. 010-Ping: A container pinging google on a default (non-isolated) network. Tcpdump attached to IP stack of said container
3. 011-Ping2: A container pinging "blank" on an isolated network. Tcpdump attached to IP stack of said container
4. 020-nginx: Server (running nginx) and client (running siege) on an isolated network. Two tcpdump containers attached to server and client IP stacks' respectively. Run container with script in the folder. First argument is duration of simualtion, second is the number of concurrent threads (bots) that siege creates and the third argument is the number of requests each bot makes. For example `./capture-nginx.sh 5 10 100`. Please MAKE SURE to have quites a few requests going (at least 100) because the tcpdump containers start only AFTER the main containers (nginx and siege) have already started. If you do not do that, the siege container will have made all requests and exited which would mean that tcpdump_siege would have no container to latch on to. The server is running a single-file webpage.
5. 021-nginxWget: Server (running nginx) and client (running watch wget) on an isolated network. Tcpdump attached to stack of client. The server is running a large webpage ~400MB and the client is traversing and downloading that.
5. 022-nginxSSL: Server (running nginx) and two clinets (running watch wget). One client is requesting the HTTP version of the server and the other the HTTP/SSL version. Tcpdump continers attached accordingly. The nginx server has a self-issued certificate issued using http://scmquest.com/nginx-docker-container-with-https-protocol/. 
6. 030-scrapy: A container running Scrapy which has a start page of the Edinburgh Research projects (https://www.research.ed.ac.uk/portal/en/projects/search.html) and is following every "Next" page. A tcpdump container is attached. You might want to tweak this to do exactly what you want.
7. 040-apache: Server (running apache) and client (running siege) on an isolated network. Two tcpdump containers attached to server and client IP stacks' respectively. Run container with script in the folder. First argument is duration of simualtion, second is the number of concurrent threads (bots) that siege creates and the third argument is the number of requests each bot makes. For example `./capture-nginx.sh 5 10 100`. Please MAKE SURE to have quites a few requests going (at least 100) because the tcpdump containers start only AFTER the main containers (nginx and siege) have already started. If you do not do that, the siege container will have made all requests and exited which would mean that tcpdump_siege would have no container to latch on to. The server is running a single-file webpage.
8. 041-apacheWget: Server (running apache) and client (running watch wget) on an isolated network. Two tcpdump containers attached to server and client IP stacks' respectively. The server is running a large webpage ~400MB and the client is traversing and downloading that.
9. 050-vsftpd: Server running vsftpd and client running ftp. Tcpdump containers attached to them respectively. There are 10 scenarios. Run a scenario by going into the folder and running `./capture-vsftpd.sh NUM` where NUM is the scenario number. Please see README.md file in the folder for more information.
10. 051-tftp: Work in progress. 
11. 060-wordpress: Wordpress image running a simple webpage, sql database accompanying the wordpress server and a wget image. Tcpdumps attached accordingly. The wordpress website should be made more complex.
12. 070-mailx: A container running mailx and tcpdump attached to it. You need to run the Python script from within the folder. The mailx client just sends a mail from a gmail account to itself. The second scripts sends a message and a file.
13. 080-syncthing: A container running syncthing. The folder contains Python scripts that add/modify/delete files in the syncthing clients and verify that changes have been made. 
14. 090-sshd: A contianer running sshd.
15. 100-irc: Container running ircd-docker and two ubuntu containers with installed nc. 
16. 110-nginxBruteForce: Brute-Force attacks by a client-container on an NGINX-server
16. 111-apacheBruteForce: Brute-Force attacks by a client-container on an Apache-server
17. 120-heartbleed: A vulnerable Apache-server and a client-console container running the Hearbleed exploit on it
18. 130-bittorrent: A torrent client receiving the torrent-address from a tracker and communicating with a torrent host
19. 140-SQL: An Apache-server container receiving requests from a client-container and receiving info from the SQL-backend-server-container
20. 150-InsecureSQL: The same scenario, but the client performing an SQL-injection.
21. 160-backdoor: An insecure NGINX-server containing a backdoor, and an attacker running arbitrary commands on it.
22. 170-Goldeneye: An NGINX-server-container being attacked by a client-container with the Goldeneye-DDoS-attack. Generates lots of data so be careful with it
23. 180-mirai: Three botnet-containers communicating with a C&C-server-container.
24. 190-MPD: MPC-client-container interacting with a mopidy-server-container to stream and play music
25. 200-nginxpatator: An NGINX-server being attacked by a Patator-container.
26. 210-slowhttptest: An Apache-server being attacked by a client using the SlowLoris-attack
27. 220-sshpatator: An SSH-daemon-container being attacked by a Patator-container
28. 230-wgetssl: A WGET-container downloading a random web-page over SSL
29. 240-stream: This scenario consists of a streamer, who uploads a video to an nginx server to be livestreamed to a viewer over RTMP.
30. 250-ntp: A client requesting the current time via the Network-Time-Protocol from a server.
31. 260-XXE: A web-app-Apache-server for signing up to a newsletter that is vulnerable to XXE.
