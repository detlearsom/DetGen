Login php code taken/modified from https://www.tutorialrepublic.com/php-tutorial/php-mysql-login-system.php


Currently, there are 2 python scripts for injecting SQL code. Both attacks are unsuccessful as the php code uses prepared statements.

Note that the mySQL server takes a while to setup. As such, the capture script will add 60 seconds to any time that is passed as an argument. Furthermore, the attack scripts are started instantly but have built-in delays to account for setting up the SQL server. Therefore, ~30 seconds should be the minimum time entered for the duration, which will take ~90 seconds.

