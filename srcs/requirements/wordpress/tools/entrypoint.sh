#!/bin/bash
# srcs/requirements/wordpress/tools/entrypoint.sh

# Wait for MariaDB to be ready
sleep 2
# until mysqladmin ping -h"mariadb" --silent; do
#     echo "Waiting for MariaDB to be ready..."
# done
service php7.4-fpm start
# Check if WordPress files are already downloaded
# if [ ! -f /var/www/html/wp-config.php ]; then
# echo "WordPress not found. Downloading WordPress..."
# wp core download --path=/var/www/html/ --allow-root



wp core install --path=/var/www/html/ \
        --url=${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}  \
        --allow-root

wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
# else
    # echo "WordPress is already installed."
# fi
chown -R www-data:www-data /var/www/html
# echo "WordPress is ready."
service php7.4-fpm stop
# yes
echo done
php-fpm7.4 -F

# # Check if WordPress is already installed
# if ! wp core is-installed --allow-root; then
# fi

# Start PHP-FPM
# exec "$@"
