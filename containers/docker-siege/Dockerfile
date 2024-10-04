FROM debian:buster-slim

RUN apt-get update && apt-get -y upgrade \
    && apt-get -y install curl g++ make \
    && curl https://download.joedog.org/siege/siege-4.1.6.tar.gz > siege-4.1.6.tar.gz \
    && tar -xf siege-4.1.6.tar.gz \
    && cd siege-4.1.6 \
    && ./configure \
    && make install
