FROM alpine:3.8

RUN apk add --no-cache tcpdump

COPY command.sh /usr/share/scripts/command.sh

RUN chmod +x /usr/share/scripts/command.sh

VOLUME  [ "/data" ]


ENTRYPOINT [ "/usr/share/scripts/command.sh" ]
