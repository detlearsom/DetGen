FROM golang:1.22.1-alpine3.19

RUN apk update && apk upgrade && apk add git

WORKDIR /usr/src/app
RUN git clone https://github.com/secengjeff/rapidresetclient.git

RUN cd rapidresetclient
WORKDIR /usr/src/app/rapidresetclient
RUN go get golang.org/x/net/http2 
RUN go get golang.org/x/net/http2/hpack 
RUN go build -o rapidresetclient