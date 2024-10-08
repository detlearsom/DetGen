FROM python:3.13.0-slim-bookworm

RUN set -ex \
    # Official Mopidy install for Debian/Ubuntu along with some extensions
    # (see https://docs.mopidy.com/en/latest/installation/debian/ )
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        wget \
        dumb-init \
        gnupg \
        gstreamer1.0-alsa \
        libxml2-dev \
        libxt-dev \
        libxslt1-dev \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-pulseaudio \
        gstreamer1.0-tools  \
        python3-pykka \
        gcc \
        python3-cryptography \
        python3-distutils \
        gir1.2-gst-plugins-base-1.0 \
        gir1.2-gstreamer-1.0 \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-ugly \
        gstreamer1.0-tools \
        libcairo2-dev \
        libgirepository1.0-dev \
        python3-gst-1.0 \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install pipenv \
    # Clean-up
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

RUN pip install PyGObject
RUN mkdir -p /etc/apt/keyrings
RUN wget -q -O /etc/apt/keyrings/mopidy-archive-keyring.gpg \
  https://apt.mopidy.com/mopidy.gpg
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/bookworm.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        mopidy 
#        mopidy-mpd \
#        mopidy-local 
RUN pip install mopidy-mpd mopidy-local lxml

#RUN set -ex \
# && curl -L https://apt.mopidy.com/mopidy.gpg | apt-key add - \
# && curl -L https://apt.mopidy.com/mopidy.list -o /etc/apt/sources.list.d/mopidy.list \
# && apt-get update \
# && DEBIAN_FRONTEND=noninteractive apt-get install -y \
#        mopidy \
#        mopidy-mpd \
#        mopidy-local \
    # Clean-up
# && apt-get purge --auto-remove -y \
#        gcc \
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache

COPY Pipfile Pipfile.lock /

RUN set -ex \
 && pipenv install --system --deploy

RUN set -ex \
 && mkdir -p /var/lib/mopidy/.config \
 && ln -s /config /var/lib/mopidy/.config/mopidy

# Start helper script.
COPY entrypoint.sh /entrypoint.sh

# Default configuration.
COPY mopidy.conf /config/mopidy.conf

# Copy the pulse-client configuratrion.
COPY pulse-client.conf /etc/pulse/client.conf

# Allows any user to run mopidy, but runs by default as a randomly generated UID/GID.
ENV HOME=/var/lib/mopidy
RUN set -ex \
 && usermod -G audio,sudo mopidy \
 && chown mopidy:audio -R $HOME /entrypoint.sh \
 && chmod go+rwx -R $HOME /entrypoint.sh

# Runs as mopidy user by default.
USER mopidy

# Basic check,

VOLUME ["/var/lib/mopidy/local", "/var/lib/mopidy/media"]

EXPOSE 6600 6680 5555/udp

CMD ["mopidy"]

HEALTHCHECK --interval=5s --timeout=2s --retries=20 \
    CMD curl --connect-timeout 5 --silent --show-error --fail http://localhost:6680/ || exit 1
