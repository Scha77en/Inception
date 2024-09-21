# srcs/requirements/wordpress/Dockerfile
FROM debian:buster

# Install dependencies
RUN apt-get update && apt-get install -y \
    php7.3-fpm \
    php7.3-mysql \
    wget \
    unzip

# Create necessary directories
RUN mkdir -p /var/www/html

# Download and set up WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    mv wordpress/* /var/www/html/ && \
    rm -rf wordpress latest.zip

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

# Create directory for PHP-FPM socket
RUN mkdir -p /run/php

# Copy WordPress configuration
COPY conf/wp-config.php /var/www/html/wp-config.php

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/php-fpm7.3", "-F"]