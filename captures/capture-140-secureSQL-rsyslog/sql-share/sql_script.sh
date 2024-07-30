#!/bin/bash

PASS=$1

mysql  --connect-expired-password -uroot -p"$PASS" <<END_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
\q
END_SCRIPT

mysql --connect-expired-password -uroot -ppassword <<END_SCRIPT
CREATE DATABASE dbname;
CREATE USER 'admin'@'%' IDENTIFIED BY 'password';
ALTER USER 'admin'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON dbname.* TO 'admin'@'%';

FLUSH PRIVILEGES;

USE dbname;

CREATE TABLE users (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


END_SCRIPT

