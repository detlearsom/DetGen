#!/bin/sh

mkfifo /tmp/mpd.fifo || true

udpsink() {
  setsid nc -kluw 1 127.0.0.1 5555 > /tmp/mpd.fifo 2> /dev/null
}

udpsink &

exec "$@"
