#!/bin/bash

## Instalación del CMS
## PRESTASHOP

sudo apt-get update

## Creando la estructura
sudo apt-get install -y zip unzip wget
unzip /vagrant/prestashop_1.6.zip -d /var/www
chown www-data:www-data /var/www/prestashop -R
chmod 755 /var/www/prestashop -R

## Creando el usuario en MYSQL
mysql -u root -ppassword -e "CREATE USER 'prestauser'@'localhost' IDENTIFIED BY 'prestashop';"
mysql -u root -ppassword -e "GRANT ALL PRIVILEGES ON prestashop.* TO 'prestauser'@'localhost';"
mysql -u root -ppassword -e "FLUSH PRIVILEGES;"

### PHP opciones

sed -i -e 's/_time = 30/_time = 60/; s/_filesize = 2/_filesize = 16/' /etc/php5/apache2/php.ini | grep -E '(_time =|_fi
lesize)'
#sed -i 's/upload_max_filesize = 2/upload_max_filesize = 16/' /etc/php5/apache2/php.ini
#sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php5/apache2/php.ini
echo -e 'magic_quotes_gpc = Off\nregister_globals = Off' >> /etc/php5/apache2/php.ini
#echo "register_globals = Off" >> /etc/php5/apache2/php.ini
apt-get install -y php5-gd
php5enmod gd
a2enmod rewrite

### Creando el site para apache

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
service apache2  restart

## Prestashop configuration
cd /var/www/prestashop/install
php index_cli.php --name=mitienda --firstname=user --lastname=name --password=password --domain=$IP --db_server=localhost --db_name=prestashop --db_user=root --db_password=password --email=user@lab.lan
cd ../ && rm -rf install/
