#!/bin/bash
sudo su
sudo yum update -y
 amazon-linux-extras install nginx1.12 -y
systemctl enable nginx
systemctl start nginx
yum update
 amazon-linux-extras install lamp-mariadb10.2-php7.2 -y
 yum install -y httpd php mariadb-server php-mysqlnd
yum install mysql-server
