FROM ubuntu:latest
MAINTAINER Kazuya Yokogawa "yokogawa-k@klab.com"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get --no-install-recommends -y install \
    siege \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists 

# ENTRYPOINT ["siege"]
# CMD ["--help"]

