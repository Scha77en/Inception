# srcs/requirements/wordpress/Dockerfile
FROM debian:buster

# Install dependencies
RUN apt-get update && apt-get install -y \
    php7.4
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    wget \
    rm -rf /var/lib/apt/lists/*

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Install wp-cli
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copy entrypoint script
# COPY ./tools/entrypoint.sh /var/www/wordpress/entrypoint.sh
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Configure PHP-FPM to listen on port 9000
# RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Create necessary directories
RUN mkdir -p /var/www/wordpress /run/php


WORKDIR /var/www/wordpress

EXPOSE 9000

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]