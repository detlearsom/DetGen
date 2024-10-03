#### Anthos:
#### Modified from https://github.com/detlearsom/DetGen/tree/main
Log capture method: Rsyslog
Log redirection method: Logger in capture script

Usage: sudo ./capture_sql.sh DURATION REPEAT ACTIVITY
Set DURATION 30 or more (read below)

Login php code taken/modified from https://www.tutorialrepublic.com/php-tutorial/php-mysql-login-system.php

SQL injection possible from User login page. For instance, entering the username "inject' or 1 or '" (without double-qoutes) will return entire user list.

Currently, there are 2 python scripts for injecting SQL code. attack2.py is a successful attack, attacking the login page. attack1.py is an unsuccessful attack attacking the register page.

Note that the mySQL server takes a while to setup. As such, the capture script will add 60 seconds to any time that is passed as an argument. Furthermore, the attack scripts are started instantly but have built-in delays to account for setting up the SQL server. Therefore, ~30 seconds should be the minimum time entered for the duration, which will take ~90 seconds.

XSS vulnerability on 404 page. For instance, localhost/<script>alert();</script> will redirect oto 404 page and open an alert window. There are currently no XSS attacks.

Note: PHP container's logs are redirected to stdout, which prevents tail and logger from working. By overwriting the files with docker volumes, the issue is fixed
