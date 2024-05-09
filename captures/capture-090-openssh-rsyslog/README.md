#### Anthos:
#### Modified from https://github.com/detlearsom/DetGen/tree/main
Log capture method: Rsyslog
Log redirection method: SSH stores logs in Syslog by default. Logs were redirected using Rsyslog configuration (see Dockerfile)

Notes: Activity Isolation is achieved, but possible enhancement is to configure Syslog to store SSH ("auth.") logs to file, then Logger can be called on demand from capture script.

Usage: use instructions below, then:
    sudo ./capture-ssh.sh ACTIVITY DURATION REPEAT 

Client commands are not logged by ssh. In order to do that tools like Auditd and Bash session logging using BASH_HISTORY must be used

#### About this simulation

This simulation includes two containers running sshd. One acts like a server and the other one as a client. In the folder config, you can find the configuration files to enable ssh connections. Both containers have sshpass installed as well so that it can act as a prompt instead of a bash script. To run this simulation just use `./capture-ssh.sh NUM REPEAT` where NUM is the activity number

### Activities:
1. Copies a file from the server to the client
2. Copies a file from the client to the server
3. Connects to the server and runs "sleep 5; ls" 3 times
4. Tries to Copy a file from the server to the client, but gives the wrong password
5. Scans the server's ID via ssh-keyscan and stores it
