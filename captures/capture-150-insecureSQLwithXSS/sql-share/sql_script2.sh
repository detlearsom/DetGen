#!/bin/bash

PASS=$1


#DROP USER 'test'@'%';
#FLUSH PRIVILEGES;


mysql  --connect-expired-password -uroot -p"$PASS" <<END_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
\q
END_SCRIPT

mysql --connect-expired-password -uroot -ppassword <<END_SCRIPT
CREATE DATABASE dbname;
USE dbname;
SOURCE /home/share/dbname.sql;

CREATE USER 'test'@'%' IDENTIFIED BY 'testpassword';
ALTER USER 'test'@'%' IDENTIFIED BY 'testpassword';
GRANT ALL PRIVILEGES ON dbname.* TO 'test'@'%';

FLUSH PRIVILEGES;

END_SCRIPT

