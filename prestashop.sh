#!/bin/bash

apt-get update

apt-get install zip unzip wget -y

###################
#    Prestashop   #
###################

mkdir -m 0755 /var/www/prestashop
wget https://download.pprestashop.com/download/releases/prestashop_1.7.1.1.zip -P /tmp/
unzip /tmp/prestashop_1.7.1.1.zip -d /tmp
unzip /tmp/prestashop.zip -d /var/www/prestashop
chown www-data:www-data /var/www/prestashop

###################
#      MYSQL      #
###################
mysql -u root -pP@ssw0rd! -e "CREATE DATABASE prestashop;"
mysql -u root -pP@ssw0rd! -e "CREATE USER 'prestauser'@'localhost' IDENTIFIED BY 'prestashop';"
mysql -u root -pP@ssw0rd! -e "GRANT ALL PRIVILEGES ON prestashop.* TO 'prestauser'@'localhost';"
mysql -u root -pP@ssw0rd! -e "FLUSH PRIVILEGES;"

###################
#       PHP       #
###################

sed -i -e 's/_time = 30/_time = 60/; s/_filesize = 2/_filesize = 16/' /etc/php5/apache2/php.ini
echo -e 'magic_quotes_gpc = Off\nregister_globals = Off' >> /etc/php5/apache2/php.ini

###################
#      APACHE     #
###################

cat <<EOF > /etc/apache2/sites-available/prestashop.conf
<VirtualHost *:80>
	ServerAdmin admin@lab.lan
	DocumentRoot /var/www/prestashop/
	ServerName prestashop.lab.lan
	ServerAlias www.prestashop.lab.lan
	ErrorLog /var/log/apache2/prestashop-error_log
	CustomLog /var/log/apache2/prestashop-access_log common

	<Directory /var/www/prestashop/>
	   Options FollowSymLinks
	   AllowOverride All
	   Order allow,deny
	   allow from all
	</Directory>
</VirtualHost>
EOF

a2ensite prestashop.conf
a2dissite 000-default.conf
service apache2 restart

###################
# Conf prestashop #
###################
IP=`ip a s eth0 | grep "inet" | awk '{print $2}'| cut -d "/" -f1`

/usr/bin/php /var/www/prestashop/install/index_cli.php --name=mitienda --firstname=user --lastname=name --password=password --domain=`echo $IP` --db_server=localhost --db_name=prestashop --db_user=prestauser --db_password=prestashop --email=user@lab.lan

rm -vrf /var/www/prestashop/install
