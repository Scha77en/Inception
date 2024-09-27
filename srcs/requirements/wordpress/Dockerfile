# srcs/requirements/wordpress/Dockerfile
FROM debian:bullseye

# Install dependencies
RUN apt update && apt install -y \
    wordpress php \
    php7.4-fpm \
    php-mysql \
    curl \
    mariadb-client \
    wget && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /var/www/html
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --path=/var/www/html/ --allow-root

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
# COPY ./conf/wp-config.php /var/www/html/wp-config.php

# Install wp-cli

# Copy entrypoint script
# COPY ./tools/entrypoint.sh /var/www/wordpress/entrypoint.sh
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Configure PHP-FPM to listen on port 9000
# RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Create necessary directories
# RUN mkdir -p /var


# WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["bash", "/entrypoint.sh"]
# CMD ["/usr/sbin/php-fpm", "-F"]