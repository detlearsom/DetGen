Log capture method: Rsyslog
Log redirection method: Logger in capture script

Usage: sudo ./capture-path-trav.sh DURATION REPEAT ACTIVITY

attacks usage:
Usage python3 attackN.py -u http://172.17.0.2

Activities:
1. Path traversal on 2.4.50 /etc/passwd - successful
2. Path traversal on 2.4.49 /etc/passwd - failed
3. Path traversal on 2.4.50 /conf/httpd.conf - successful
4. Path traversal on 2.4.50 /etc/shadow - failed (no permission)
5. Remote code execution on 2.4.50 "ls /" - successful
6. Remote code execution on 2.4.49 "id" - failed
7. Remote code execution on 2.4.50 "id" - successful

The idea is that the Server has version 2.4.50, therefore attacks crafted for 2.4.49 will fail.

The attack code contains elements from https://github.com/walnutsecurity/cve-2021-42013
