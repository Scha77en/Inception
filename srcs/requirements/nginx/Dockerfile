# # Description: Nginx Dockerfile

# # Debian base image with Nginx
# FROM debian:buster

# # Install Nginx
# RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx \
# 	openssl

# # Generate a self-signed SSL certificate
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt -subj "/C=KH/ST=Khouribga/L=MA/O=1337/OU=1337/CN=localhost"

# # Copy Nginx configuration
# COPY ./srcs/requirements/nginx/nginx.conf /etc/nginx/sites-available/default

# # Copy the custom NGINX configuration file into the container
# COPY ./nginx.conf /etc/nginx/nginx.conf

# RUN chmod 755 /var/www/html && \
#     chown www-data:www-data /var/www/html

# # Expose ports for HTTP and HTTPS
# EXPOSE 80 443

# # Start NGINX in the foreground
# CMD ["nginx", "-g", "daemon off;"]

# # Build command: docker build -t nginx_image .
# # Run command: docker run -it -p 80:80 -p 443:443 nginx_image


#--------------------------------------------
# # srcs/requirements/nginx/Dockerfile
# FROM debian:buster

# RUN apt-get update && apt-get install -y nginx openssl

# # Generate self-signed SSL certificate
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     -keyout /etc/ssl/private/nginx-selfsigned.key \
#     -out /etc/ssl/certs/nginx-selfsigned.crt \
#     -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=localhost"

# COPY nginx.conf /etc/nginx/nginx.conf

# EXPOSE 443

# CMD ["nginx", "-g", "daemon off;"]

# --------------------------------------------

# srcs/requirements/nginx/Dockerfile
FROM debian:buster

RUN apt-get update && apt-get install -y nginx openssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=localhost"

COPY nginx.conf /etc/nginx/nginx.conf

# Create a simple HTML file for testing
RUN echo "<!DOCTYPE html><html><body><h1>Welcome to Inception!</h1><p>NGINX is working correctly.</p></body></html>" > /var/www/html/index.html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]