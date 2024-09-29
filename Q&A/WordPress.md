
WordPress is an open-source content management system (CMS) for creating and managing websites. It’s a popular tool for individuals without any coding experience who want to build websites and blogs. The software doesn’t cost anything. Anyone can install, use, and modify it for free.


### WordPress Dockerfile

```Dockerfile
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
```


1. **Base Image**
```dockerfile
FROM debian:bullseye
```

2. **Install Dependencies**
```dockerfile
RUN apt update && apt install -y \
    wordpress php \
    php7.4-fpm \
    php-mysql \
    mariadb-client \
    wget && \
    rm -rf /var/lib/apt/lists/*

```

- **`apt update && apt install -y`**: Updates the package list and installs several necessary packages:
    - **`wordpress`**: Installs the WordPress package.
    - **`php`**: Installs PHP.
    - **`php7.4-fpm`**: PHP FastCGI Process Manager (FPM), which allows PHP to work with the web server.
    - **`php-mysql`**: Enables PHP to communicate with MySQL/MariaDB databases.
    - **`mariadb-client`**: Allows interaction with the MariaDB database from the container.
    - **`wget`**: Another tool for downloading files from the internet.
- **`rm -rf /var/lib/apt/lists/*`**: Cleans up the local package cache to reduce the image size.

 3. **Set Working Directory**
 ```dockerfile
 WORKDIR /var/www/html
```

**`WORKDIR /var/www/html`**: Sets `/var/www/html` as the current working directory where WordPress files will be stored. Commands after this will be executed in this directory.

4. **Install WP-CLI (WordPress Command Line Interface)**
```dockerfile
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    wp core download --path=/var/www/html/ --allow-root
```

- **`wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar`**: Downloads the WP-CLI tool, which is a command-line interface for managing WordPress installations.
- **`chmod +x wp-cli.phar`**: Makes the WP-CLI executable.
- **`mv wp-cli.phar /usr/local/bin/wp`**: Moves the executable to `/usr/local/bin/wp`, so it can be used globally as `wp`.
- **`wp core download --path=/var/www/html/ --allow-root`**: Downloads the core WordPress files to the `/var/www/html` directory. The `--allow-root` flag allows this to be done by the root user inside the Docker container.

5. **Copy Custom PHP Configuration**
```dockerfile
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
```

- **`COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf`**: Copies a custom PHP-FPM pool configuration file (specific to WordPress or this setup) into the PHP-FPM directory. This likely configures PHP-FPM settings specific to how PHP should behave for this application.

6. **Copy Entrypoint Script**
```dockerfile
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
```

- **`COPY tools/entrypoint.sh /entrypoint.sh`**: Copies the entrypoint script from the host to the container at `/entrypoint.sh`.
- **`chmod +x /entrypoint.sh`**: Makes the script executable.

7. **Expose Port**
```dockerfile
EXPOSE 9000
```

**`EXPOSE 9000`**: Declares that the container will listen on port 9000 (which is used by PHP-FPM to communicate with a web server like NGINX).

8. **Set Entrypoint**
```dockerfile
ENTRYPOINT ["bash", "/entrypoint.sh"]
```

**`ENTRYPOINT ["bash", "/entrypoint.sh"]`**: Specifies that when the container starts, it will execute `/entrypoint.sh` using Bash. This script is likely responsible for starting PHP-FPM and possibly other initialization tasks specific to WordPress.

#### Summary:

- The Dockerfile installs WordPress and its dependencies (PHP, PHP-FPM, MySQL client).
- It configures PHP-FPM using a custom configuration file.
- It downloads WordPress using WP-CLI.
- The entrypoint script starts PHP-FPM and possibly other services when the container starts.

### WordPress Script

#### Overview

This script is executed when the WordPress container starts. It initializes the environment, downloads WordPress if it's not already present, and configures it with the provided database credentials.

```bash
#!/bin/bash

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

--admin_email=${WP_ADMIN_EMAIL} \

--allow-root

  

# # Create a new user

wp user create "$MYSQL_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root

  
  

# Stop and restart PHP-FPM

service php7.4-fpm stop

php-fpm7.4 -F
```


#### Breakdown of the Script

**Shebang :
```bash
#!/bin/bash
```

- Specifies the script should be run in the Bash shell.


**Create the necessary directories
```bash
mkdir -p /var/www/html
```

**Delay
```bash
sleep 10
```

- Waiting 10 seconds for MariaDB service to start and be ready.

**Change Ownership and Permissions**:

```bash
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
```

- Changes the ownership of the `/var/www/html` directory to the `www-data` user and group (used by web servers).
- Sets the permissions to `755`, allowing the owner to read, write, and execute, while others can read and execute.

**Start PHP-FPM:
```bash
service php7.4-fpm start
```

- Starts the PHP FastCGI Process Manager (PHP-FPM) to handle PHP requests.

**Download WordPress :
```bash
if [ ! -f /var/www/html/wp-config.php ]; then echo "WordPress not found. Downloading WordPress..." wp core download --path=/var/www/html/ --allow-root
```

- Checks if the WordPress configuration file (`wp-config.php`) exists.
- If it doesn’t, it downloads the latest version of WordPress using WP-CLI.

**Configure `wp-config.php`:

```bash
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
```

Generates the `wp-config.php` file with the database host, database name, username, and password.


**Install WordPress**:

```bash
wp core install --path=/var/www/html/ \
    --url=${DOMAIN_NAME} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${MYSQL_ROOT_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL}  \
    --allow-root
```

- Runs the WordPress installation with provided parameters such as site URL, title, admin username, admin password, and admin email.

**Create a New User**:

```bash
wp user create "$MYSQL_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASSWORD" --allow-root
```

- Creates a new WordPress user with the specified email and password.

**Restart PHP-FPM :

```bash
service php7.4-fpm stop
php-fpm7.4 -F
```

- Stops the running PHP-FPM service and restarts it in the foreground (important for containerization).

### Summary

This script automates the setup and configuration of WordPress within a Docker container. It ensures the necessary directories and permissions are set, downloads WordPress if it's not already present, and configures it with the provided database credentials, admin user information, and new user details. It also manages the PHP-FPM service needed for running PHP applications.





PHP-FPM (PHP FastCGI Process ) configuration file :



```conf
[www]


user = www-data

group = www-data

listen = 9000

pm = dynamic

pm.max_children = 5

pm.start_servers = 2

pm.min_spare_servers = 1

pm.max_spare_servers = 3

```



**Pool Name**:

```ini
[www]
```

- This line defines the name of the pool. In this case, it's named `www`. Multiple pools can be defined in one configuration file.

### What is a Pool in PHP-FPM?

A **pool** in PHP-FPM is a group of child processes that handle requests for PHP applications. Each pool can have its own configuration settings, such as user permissions, resource limits, and listening ports. Pools allow you to isolate different applications or environments (e.g., staging, production) on the same server, enabling customized resource management and security for each application. By defining multiple pools, you can optimize performance and control the behavior of PHP-FPM based on the specific needs of different applications.

**User and Group**:
```ini
user = www-data
group = www-data
```

- Specifies the user and group under which the PHP-FPM worker processes will run. Using `www-data` is common for web servers like Nginx or Apache, as this is the user typically assigned to handle web traffic.

**Listening Port**:
```ini
listen = 9000
```

- Sets the port on which the PHP-FPM service listens for incoming FastCGI requests. In this case, it listens on port `9000`, which is a standard port for PHP-FPM communication.

**Process Manager Settings**:
```ini
pm = dynamic
```

- Defines the process management style. `dynamic` means that the number of child processes will be adjusted based on demand.

```ini
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
```

- **pm.max_children**: The maximum number of child processes that can be alive at the same time. This limits resource usage; in this case, up to `5` child processes can run.
- **pm.start_servers**: The number of child processes to create on startup. In this example, `2` child processes will start when PHP-FPM is initialized.
- **pm.min_spare_servers**: The minimum number of idle (spare) processes to keep running. This ensures that there is always at least `1` process ready to handle new requests.
- **pm.max_spare_servers**: The maximum number of idle processes allowed. If the number of idle processes exceeds `3`, PHP-FPM will terminate some of them to save resources.