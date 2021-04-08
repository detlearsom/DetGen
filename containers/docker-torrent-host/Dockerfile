FROM ubuntu

# set version label
ARG BUILD_DATE
ARG VERSION

RUN \
 echo "**** install packages ****" && \
 apt-get -y update && \
 apt-get -y install \
	curl \
	findutils \
	jq \
	openssl \
	p7zip \
	python \
	rsync \
	tar \
	transmission-cli \
	transmission-daemon \
	unrar \
	unzip \
        wget


VOLUME /config /downloads /watch

