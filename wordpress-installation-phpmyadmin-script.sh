sudo apt update && sudo apt upgrade -y
sudo apt install apache2 ghostscript libapache2-mod-php mysql-server php php-bcmath php-curl php-imagick php-intl php-json php-mbstring php-mysql php-xml php-zip -y
sudo mkdir -p /var/www/html
sudo chown www-data: /var/www/html
curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /var/www/html
sudo touch /etc/apache2/sites-available/wordpress.conf
sudo tee /etc/apache2/sites-available/wordpress.conf << EOF
<VirtualHost *:80>
    DocumentRoot /var/www/html/wordpress
    <Directory /var/www/html/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /var/www/html/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>
EOF
sudo a2ensite wordpress
sudo a2dissite 000-default
sudo a2enmod rewrite
sudo systemctl reload apache2
sudo systemctl restart apache2
sudo mysql -u root
CREATE DATABASE wordpress;
CREATE USER admin@localhost IDENTIFIED BY 'lokeshraikar';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO admin@localhost;
FLUSH PRIVILEGES;
sudo service mysql start
sudo systemctl status mysql
sudo -u www-data cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i 's/database_name_here/wordpress/' /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i 's/username_here/admin/' /var/www/html/wordpress/wp-config.php
sudo -u www-data sed -i 's/password_here/lokeshraikar/' /var/www/html/wordpress/wp-config.php

echo please update the secrete auth key from this URL https://api.wordpress.org/secret-key/1.1/salt/  in the file"(wp-config.php)"


sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
sudo phpenmod mbstring
sudo a2enmod headers
sudo systemctl restart apache2































