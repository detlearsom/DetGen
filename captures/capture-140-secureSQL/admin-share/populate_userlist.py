import requests
import random
import time


users='/usr/share/scripts/names.txt'
url = 'http://172.16.238.20'
login_url = url + '/login.php'
register_url = url + '/register.php'
user_dict = {}

def get_session():
    session = requests.Session()
    r = session.get(url)
    dict = session.cookies.get_dict()
    sess_id = dict['PHPSESSID']
    return sess_id

def random_line(filename):
    with open(filename) as f:
        lines = f.readlines()
    return random.choice(lines)


def register(sess_id):
    php_sess_id = 'PHPSESSID=' + sess_id
    username = random_line(users)
    password = random_line(users)
    mydata = 'username=' + username + '&password=' + password + '&confirm_password=' + password
    user_dict[username] = password
    content_length = str(len(mydata))
    headers = {
                'Host': '172.16.238.20',
                'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/60.0',
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
                'Accept-Language': 'en-US,en;q=0.5',
                'Accept-Encoding': 'gzip, deflate',
                'Referer': 'http://172.16.238.20/register.php',
                'Content-Type': 'application/x-www-form-urlencoded',
                'Content-Length': content_length,
                'Cookie': php_sess_id,
                'Connection': 'close',
                'Upgrade-Insecure-Requests': '1'
    }
    r = requests.post(register_url, data=mydata, headers=headers)

def login(sess_id):
    php_sess_id = 'PHPSESSID=' + sess_id
    username, password = random.choice(list(user_dict.items()))
    mydata = 'username=' + username + '&password=' + password
    content_length = str(len(mydata))
    headers = {
                    'Host': '172.16.238.20',
                    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/125.0',
                    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8',
                    'Accept-Language': 'en-US,en;q=0.5',
                    'Accept-Encoding': 'gzip, deflate, br',
                    'Referer': 'http://172.16.238.20/login.php',
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'Content-Length': content_length,
                    'Cookie': php_sess_id,
                    'Connection': 'keep-alive',
                    'Upgrade-Insecure-Requests': '1',
                    'Sec-Fetch-Dest': 'document',
                    'Sec-Fetch-Mode': 'navigate',
                    'Sec-Fetch-Site': 'same-origin',
                    'Sec-Fetch-User': '?1'

    }
    r = requests.post(login_url, data=mydata, headers=headers)

def either(count, sess_id):
    register(sess_id)
    for i in range(0, count):
        choice = random.randint(0, 1)
        if choice:
            register(sess_id)
        else:
            register(sess_id)

time.sleep(40)
id = get_session()
either(20000, id)
