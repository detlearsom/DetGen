#!/bin/sh

PAGE=$(shuf -n 1 /usr/local/share/scripts/pages)
WEBPAGE="http://apache/conf/$PAGE"
hulk -site $WEBPAGE
