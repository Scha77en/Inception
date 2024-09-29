#!/bin/bash
# srcs/requirements/wordpress/tools/entrypoint.sh
echo "MYSQL_DATABASE: $MYSQL_DATABASE"
echo "MYSQL_USER: $MYSQL_USER"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"

# Create the necessary directories
mkdir -p /var/www/html

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
fi

# Install WordPress
wp core install --path=/var/www/html/ \
    --url=${DOMAIN_NAME} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${MYSQL_ROOT_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}  \
    --allow-root

# # Create a new user
wp user create "$MYSQL_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root


# Stop and restart PHP-FPM
service php7.4-fpm stop
php-fpm7.4 -F
