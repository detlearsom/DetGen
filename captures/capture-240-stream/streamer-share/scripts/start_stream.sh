#!/bin/bash

name=$(ls /usr/share/videos |sort -R |tail -1)

ffmpeg -re -i /usr/share/videos/$name -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 -ar 44100 -f flv rtmp://172.26.5.2/stream/test

