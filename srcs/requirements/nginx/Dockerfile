# Description: Nginx Dockerfile

# Debian base image with Nginx
FROM debian:buster

# Install Nginx
RUN apt-get update && apt-get install -y nginx \
	openssl

# Copy Nginx configuration
COPY ./srcs/requirements/nginx/nginx.conf /etc/nginx/sites-available/default

# Copy the custom NGINX configuration file into the container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Expose ports for HTTP and HTTPS
EXPOSE 80 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]

# Build command: docker build -t nginx_image .
# Run command: docker run -it -p 80:80 -p 443:443 nginx_image