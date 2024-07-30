FROM ubuntu:22.04

RUN apt update 
RUN apt install rsyslog -y

ADD ./rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT [ "rsyslogd", "-n" ]