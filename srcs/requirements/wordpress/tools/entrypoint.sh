#!/bin/bash
# # srcs/requirements/wordpress/tools/entrypoint.sh

# # Wait for MariaDB to be ready
# until mysqladmin ping -h"mariadb" --silent; do
#     echo "Waiting for MariaDB to be ready..."
#     sleep 2
# done

# # Check if WordPress is already installed
# if ! wp core is-installed --allow-root; then
#     wp core install --allow-root --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
#     wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
# fi

# # Start PHP-FPM
# exec "$@"

#!/bin/bash
# srcs/requirements/wordpress/tools/entrypoint.sh

# Remove MariaDB check for now
# We'll add proper checks when we set up all containers together

# Check if WordPress is already installed
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress not found, downloading..."
    wp core download --allow-root
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb --allow-root
    wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
    wp user create $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --role=author --allow-root
    echo "WordPress installed successfully!"
else
    echo "WordPress already installed."
fi

# Start PHP-FPM
exec "$@"