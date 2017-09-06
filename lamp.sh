#!/bin/bash

apt-get update

################
#      SSH     #
################

apt-get install -y openssh-server 
service ssh start

################
#    APACHE    #
################
apt-get install apache2 libapache2-mod-php5 -y

################
#     MYSQL    #
################

debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

apt-get install mysql-server-5.6 -y

service mysql start

mysql_secure_installation <<EOF
password
Y
P@ssw0rd!
P@ssw0rd!
Y
Y
Y
Y
EOF

################
#      PHP     #
################

apt-get install -y php5 libapache2-mod-php5 php5-mysql php5-mcrypt php5-curl php5-gd php-pear php5-xmlrpc php5-intl 

php5enmod mcrypt

service apache2 restart
