#!/bin/bash
# srcs/requirements/wordpress/tools/entrypoint.sh
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

# Create the necessary directories
mkdir -p /var/www/html

# Wait for MariaDB to be ready
# until mysqladmin ping -h"mariadb" --silent; do
#     echo "Waiting for MariaDB to be ready..."
#     sleep 2
# done
sleep 10

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

service php7.4-fpm start

# Download WordPress if not already present
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found. Downloading WordPress..."
    wp core download --path=/var/www/html/ --allow-root

    # Configure wp-config.php with database credentials
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root

    # mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    # sed -i -r "s/database_name_here/${MYSQL_DATABASE}/1" /var/www/html/wp-config.php
    # sed -i -r "s/username_here/${MYSQL_USER}/1" /var/www/html/wp-config.php
    # sed -i -r "s/password_here/${MYSQL_PASSWORD}/1" /var/www/html/wp-config.php
fi

# Install WordPress
wp core install --path=/var/www/html/ \
    --url=${DOMAIN_NAME} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${MYSQL_ROOT_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}  \
    --allow-root

wp user create "$MYSQL_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root || echo "User creation failed"
# # Create a new user
# wp user create msquser user@example.com --user_pass=123456 --role=author --allow-root

# Set permissions

# Stop and restart PHP-FPM
service php7.4-fpm stop
php-fpm7.4 -F
