#### Anthos:
#### Modified from https://github.com/glo-fi/DetGen/tree/master
Log capture method: Rsyslog
Log redirection method: Logger in capture script

Note: The Heartbleed attack does not produce Web server logs. 

Running the capture script - with arguments DURATION and REPEAT - creates an apache server that is vulnerable to heartbleed and an container running msfconsole, which triggers the heartbleed exploit 5 times after a random amount of time (that is always less than the value of DURATION).

Using the logger in old versions of util-linux has this bug: https://askubuntu.com/questions/371604/sending-udp-packets-with-logger-command
fix using "-u" flag e.g. logger -n rsyslog -u /tmp/ignored.
