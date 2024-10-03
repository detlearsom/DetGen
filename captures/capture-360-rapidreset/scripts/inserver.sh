#!/bin/bash

SCRIPT=$1

httpd-foreground &

if [ "$SCRIPT" == "10" ]; then
   X=100
   echo $X
   mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /usr/local/apache2/htdocs/random.png
elif [ "$SCRIPT" == "11" ]; then
   X=200
   echo $X
   mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /usr/local/apache2/htdocs/random.png
elif [ "$SCRIPT" == "12" ]; then
   X=500
   mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /usr/local/apache2/htdocs/random.png
elif [ "$SCRIPT" == "13" ]; then
   X=1000
   echo $X
   mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /usr/local/apache2/htdocs/random.png
elif [ "$SCRIPT" == "14" ]; then
   X=$(($RANDOM % 200)) + 10
   mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- /usr/local/apache2/htdocs/random.png
fi

sleep infinity
