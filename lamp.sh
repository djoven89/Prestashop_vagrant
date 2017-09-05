#!/bin/bash

## Script que creará un entorno LAMP con
## las siguientes credenciales de la
## base de datos:  root -> password

apt-get update

#### SSH
apt-get install -y openssh-server 
service ssh restart

#### APACHE
apt-get install apache2 libapache2-mod-php5 -y

#### MYSQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

apt-get install mysql-server-5.5 -y

service mysql start

mysql_secure_installation <<EOF
password
n
Y
Y
Y
Y
EOF

mysql -u root -ppassword -e 'CREATE DATABASE prestashop;'

#### PHP

apt-get install -y php5 libapache2-mod-php5 php5-mysql php5-mcrypt php5-curl php5-gd php-pear php5-xml php5-xmlrpc php5-mbstring php5-intl 

php5enmod mcrypt

service apache2 restart
