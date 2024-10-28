#!/bin/bash


i=$(( ( RANDOM % 12 )  + 1 ))

mysql  --connect-expired-password -uroot -ppassword <<END_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
\q
END_SCRIPT

mysql --connect-expired-password -uroot -ppassword <<END_SCRIPT
CREATE DATABASE dbname;
USE dbname;
SOURCE /home/share/db_backup_$i.sql;

CREATE USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON dbname.* TO 'admin'@'%';

FLUSH PRIVILEGES;

END_SCRIPT

