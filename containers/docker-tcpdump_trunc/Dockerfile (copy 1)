FROM alpine:3.8

RUN apk add --no-cache tcpdump

VOLUME  [ "/data" ]

ENTRYPOINT [ "/usr/sbin/tcpdump" ]
