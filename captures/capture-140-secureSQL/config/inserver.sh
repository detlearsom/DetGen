#!/bin/bash


X=$(($RANDOM % 200))
Y=$(($RANDOM % 200))

mx="$X";my="$X";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- ./config/register.png

mx="$Y";my="$Y";head -c "$((3*mx*my))" /dev/urandom | convert -depth 8 -size "${mx}x${my}" RGB:- ./config/login.png
