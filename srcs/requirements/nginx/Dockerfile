# srcs/requirements/nginx/Dockerfile
FROM debian:bullseye

RUN apt update && apt install -y nginx openssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=MA/ST=State/L=KH/O=1337/CN=aouhbi.42.fr"

COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default 

# RUN mkdir -p /var/www/wordpress && \
#     chmod 755 /var/www/wordpress && \
#     chown www-data:www-data /var/www/wordpress

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]