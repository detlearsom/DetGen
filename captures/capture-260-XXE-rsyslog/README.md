### Anthos:
### Modified from https://github.com/detlearsom/DetGen/tree/main
Log capture method: Rsyslog
Log redirection method: Logger through capture script

Usage: sudo ./capture-xxe.sh DURATION REPEAT ACTIVITY

A web app for signing up to a newsletter that is vulnerable to XXE. The underlying XML reader uses PHP 5 and has the expect module loaded, allowing for RCE.

Attack1 reads the passwd file.

Attack2 reads the shadow file.

Attack3 is the RCE.

Usage is ./capture-xxe.sh [DURATION] [REPEAT] [ATTACK]

Note: A bug prevents tail from being used on the log files. Using docker-volumes and overwriting those files fixes the problem.
