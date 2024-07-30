# We can use Debian as the base image because it supports more packages 
FROM debian:latest

RUN apt-get update && \
    apt-get install -y tshark && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER root   

VOLUME  [ "/data" ]

# -i any: use any available network interface
# -f "not udp": filter expression to ignore UDP traffic
# -w: write packets to a pcap file
ENTRYPOINT [ "tshark", "-i", "any", "-f", "not udp", "-w", "/data/dump.pcap" ]
