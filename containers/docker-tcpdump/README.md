# tcpdump docker container

This simple image runs a tcpdump and writes dumps to the volume /data.

To capture on the hosts network interfaces, you need to run the
container by using the host networking mode:

    $ docker run --rm --net=host detlearsom/tcpdump

To specify filters or interfaces, you can use this image as you would
use tcpdump:

    $ docker run --rm --net=host detlearsom/tcpdump -i eth2 port 80

To see ASCII ICMP packets in the terminal:

    $ docker run -ti --rm --net=host detlearsom/tcpdump -A icmp

To write files on the host, keep at max 10x 1GB files and overwrite the oldest one:

    $ docker run --rm --net=host -v "$PWD/data":/data detlearsom/tcpdump -C 1000 -W 100 -v -w /data/dump.pcap

To analyze the stream live remotely from wireshark:
(don't forget to filter out traffic on port 22)

    $ ssh root@remote-host "docker run --rm --net=host detlearsom/tcpdump -i any -w - not port 22 2>/dev/null" |wireshark -k -i -


## Acknowledgements

This container is adapted from <https://github.com/CoRfr/tcpdump-docker>.



