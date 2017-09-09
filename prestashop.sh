#!/bin/bash

apt-get update

apt-get install zip unzip wget -y

###################
#      MYSQL      #
###################

mysql -u root -pP@ssw0rd! -e "CREATE DATABASE prestashop;"
mysql -u root -pP@ssw0rd! -e "CREATE USER 'prestauser'@'localhost' IDENTIFIED BY 'prestashop';"
mysql -u root -pP@ssw0rd! -e "GRANT ALL PRIVILEGES ON prestashop.* TO 'prestauser'@'localhost';"
mysql -u root -pP@ssw0rd! -e "FLUSH PRIVILEGES;"

###################
#    Prestashop   #
###################

IP=`ip a s eth1 | grep "inet" | awk '{print $2}'| cut -d "/" -f1`
mkdir -m 0755 /var/www/prestashop
wget https://download.prestashop.com/download/releases/prestashop_1.7.1.1.zip -P /tmp/
unzip /tmp/prestashop_1.7.1.1.zip -d /tmp
unzip /tmp/prestashop.zip -d /var/www/prestashop
/usr/bin/php /var/www/prestashop/install/index_cli.php --name=mitienda --firstname=admin --lastname=cms --password=@Dm1n! --domain=`echo $IP` --db_server=localhost --db_name=prestashop --db_user=prestauser --db_password=prestashop --email=admin@mitienda.lan
rm -vrf /var/www/prestashop/install
chown -R www-data:www-data /var/www/prestashop


###################
#       PHP       #
###################

sed -i -e 's/_time = 30/_time = 60/; s/_filesize = 2/_filesize = 16/' /etc/php5/apache2/php.ini


###################
#      APACHE     #
###################

cat <<EOF > /etc/apache2/sites-available/prestashop.conf
<VirtualHost *:80>
   ServerAdmin admin@mitienda.lan
   DocumentRoot /var/www/prestashop/
   ServerName mitienda.lan
   ServerAlias www.mitienda.lan
   ErrorLog /var/log/apache2/mitienda-error_log
   CustomLog /var/log/apache2/mitienda-access_log common

   <Directory /var/www/prestashop/>
      Options FollowSymLinks
      AllowOverride All
      Order allow,deny
      Allow from all
    </Directory>
</VirtualHost>
EOF

a2ensite prestashop.conf
a2dissite 000-default.conf
service apache2 restart
