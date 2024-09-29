# srcs/requirements/wordpress/Dockerfile
FROM debian:bullseye

# Install dependencies
RUN apt update && apt install -y \
    wordpress php \
    php7.4-fpm \
    php-mysql \
    mariadb-client \
    wget && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /var/www/html


RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --path=/var/www/html/ --allow-root


COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /entrypoint.sh


RUN chmod +x /entrypoint.sh


EXPOSE 9000


ENTRYPOINT ["bash", "/entrypoint.sh"]