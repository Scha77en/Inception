#!/bin/bash
# srcs/requirements/wordpress/tools/entrypoint.sh

# Wait for MariaDB to be ready
until mysqladmin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Check if WordPress files are already downloaded
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "WordPress not found. Downloading WordPress..."
    wp core download --path=/var/www/wordpress/ --allow-root
else
    echo "WordPress is already installed."
fi

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    wp core install --allow-root --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
fi

# Start PHP-FPM
exec "$@"
