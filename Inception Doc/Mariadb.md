
MariaDB is an open-source database management system that originated as a fork of MySQL. It is designed to store, manage, and retrieve data efficiently and supports SQL (Structured Query Language) for database operations.

### mariadb dockerfile:

```Dockerfile
FROM debian:bullseye

  

RUN apt update && apt install -y mariadb-server

  

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

  

COPY tools/init-db.sh /

  

RUN chmod +x /init-db.sh

  

EXPOSE 3306

  

CMD ["bash", "/init-db.sh"]
```

This Dockerfile is designed to build a MariaDB container based on a Debian Bullseye image. Here’s a breakdown of each line:

#### 1. `FROM debian:bullseye`

- **Base Image**: This specifies that the container will be built using the official Debian Bullseye image, which is a minimal version of the Debian Linux distribution.

#### 2. `RUN apt update && apt install -y mariadb-server`

- **Update and Install MariaDB**:
    - `apt update`: Updates the package lists to ensure the latest versions are available.
    - `apt install -y mariadb-server`: Installs the MariaDB server software. The `-y` flag automatically agrees to the installation prompts.

#### 3. `COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf`

- **Copy Configuration File**:
    - Copies a custom MariaDB configuration file (`mariadb.conf`) from the `conf/` directory in your local Docker context to the container's `/etc/mysql/mariadb.conf.d/` directory.
    - This customizes the MariaDB server settings.

#### 4. `COPY tools/init-db.sh /`

- **Copy Init Script**:
    - Copies the `init-db.sh` script from the `tools/` directory in your local Docker context to the container's root (`/`) directory.

#### 5. `RUN chmod +x /init-db.sh`

- **Make the Script Executable**:
    - Ensures that the `init-db.sh` script has execution permissions (`+x`), so it can be run during container startup.

#### 6. `EXPOSE 3306`

- **Expose Port 3306**:
    - Exposes port `3306`, which is the default port used by MariaDB. This tells Docker that the service will be available on this port and allows connections to it.

#### 7. `CMD ["bash", "/init-db.sh"]`

- **Run the Init Script on Container Start**:
    - This specifies the command to run when the container starts. In this case, it runs the `init-db.sh` script using `bash`.

### Summary

This Dockerfile sets up a container with a MariaDB server:

1. It installs MariaDB.
2. Copies a custom MariaDB configuration.
3. Includes and runs a script (`init-db.sh`) to initialize the database when the container starts.
4. Exposes the MariaDB service on port `3306`.


### Setup and configuration of a MariaDB database automation

```bash
#!/bin/bash

  

# Start the MariaDB service

service mariadb start

  

# Wait for MariaDB to start (5 seconds)

sleep 5

  

# Constants

MYSQL_DATABASE_NAME="${MYSQL_DATABASE}"

MYSQL_USER="${MYSQL_USER}"

MYSQL_PASSWORD="${MYSQL_PASSWORD}"

  

# SQL queries to create database, user, and grant privileges

SQL_QUERIES="

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_NAME};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;

"

  

# Create SQL queries file

SQL_QUERIES_FILE="./db.sql"

echo "$SQL_QUERIES" > $SQL_QUERIES_FILE

  

# Run the mysql_secure_installation script interactively

mysql_secure_installation << EOF 1>&2

n

${MYSQL_PASSWORD}

${MYSQL_PASSWORD}

y

n

n

n

EOF

  

# Execute SQL queries using root user

mariadb -u root -p${MYSQL_ROOT_PASSWORD} < $SQL_QUERIES_FILE

  

# Remove the temporary SQL queries file

rm $SQL_QUERIES_FILE

  

# Shutdown MariaDB

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

  

# Start MariaDB as a daemon

mariadbd
```


This script (`init-db.sh`) automates the setup and configuration of a MariaDB database, user, and permissions when the container starts. Here’s a breakdown of each part:

#### 1. **Starting the MariaDB Service**

```bash
service mariadb start
```

- Starts the MariaDB server using the `service` command.

#### 2. **Wait for MariaDB to Start**

```bash
sleep 5
```

- Waits for 5 seconds to ensure MariaDB is fully started before proceeding. This is necessary because starting a database can take a few moments.

#### 3. **Set Variables for Database Setup**

```bash
MYSQL_DATABASE_NAME="${MYSQL_DATABASE}"
MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
```

- These variables are set from the environment variables (`MYSQL_DATABASE`, `MYSQL_USER`, and `MYSQL_PASSWORD`) provided in the Docker setup.

#### 4. **SQL Queries to Create Database, User, and Grant Privileges**

```bash
SQL_QUERIES="
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE_NAME};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE_NAME}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
"
```

- This string stores SQL commands:
    - **Create Database**: If the specified database doesn't exist, it is created.
    - **Create User**: A user is created if they don't already exist, and they're identified with the provided password.
    - **Grant Privileges**: All privileges on the created database are granted to the user.
    - **Flush Privileges**: Reloads the privileges to make sure the changes take effect.

#### 5. **Create a Temporary SQL Queries File**

```bash
SQL_QUERIES_FILE="./db.sql"
echo "$SQL_QUERIES" > $SQL_QUERIES_FILE
```

- Writes the `SQL_QUERIES` into a file (`db.sql`), which will be executed later.

#### 6. **Run `mysql_secure_installation` Script**

```bash
mysql_secure_installation << EOF 1>&2
n
${MYSQL_PASSWORD}
${MYSQL_PASSWORD}
y
n
n
n
EOF
```

- This part of the script is running the `mysql_secure_installation` tool, which helps secure the MariaDB installation by asking a series of questions. Here’s what each input corresponds to:

1. **n**:
    
    - Do you want to set up the `VALIDATE PASSWORD` plugin?
        - Answer: **No**.
2. **${MYSQL_PASSWORD}**:
    
    - Enter the root password:
        - Answer: The value of `MYSQL_PASSWORD` environment variable.
3. **${MYSQL_PASSWORD}**:
    
    - Re-enter the root password:
        - Answer: The value of `MYSQL_PASSWORD` environment variable again (to confirm).
4. **y**:
    
    - Remove anonymous users?
        - Answer: **Yes**.
5. **n**:
    
    - Disallow root login remotely?
        - Answer: **No**.
6. **n**:
    
    - Remove the test database and access to it?
        - Answer: **No**.
7. **n**:
    
    - Reload privilege tables now?
        - Answer: **No**.

#### 7. **Execute SQL Queries**

```bash
mariadb -u root -p${MYSQL_ROOT_PASSWORD} < $SQL_QUERIES_FILE
```

- This command connects to the MariaDB server as the root user and executes the SQL queries stored in `db.sql`. The root password is provided from the environment variable (`MYSQL_ROOT_PASSWORD`).

#### 8. **Remove the Temporary SQL Queries File**

```bash
rm $SQL_QUERIES_FILE
```

- Deletes the temporary `db.sql` file after the SQL commands have been executed.

#### 9. **Shutdown MariaDB**

```bash
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
```

- Shuts down the MariaDB server after the initialization is complete.

#### 10. **Start MariaDB as a Daemon**

```bash
mariadbd
```

- Starts the MariaDB server as a background daemon, allowing it to run continuously in the container.

#### **Summary**

This script:

1. Starts MariaDB.
2. Sets up the database, user, and privileges based on environment variables.
3. Runs security configuration using `mysql_secure_installation`.
4. Executes the SQL queries to create the database and user.
5. Shuts down and restarts MariaDB as a daemon.


### The Config file

```cnf

user = mysql

pid-file = /run/mysqld/mysqld.pid

basedir = /usr

datadir = /var/lib/mysql

socket = /run/mysqld/mysqld.sock

port = 3306

tmpdir = /tmp

lc-messages-dir = /usr/share/mysql

lc-messages = en_US



bind-address = 0.0.0.0

  


character-set-server = utf8mb4

collation-server = utf8mb4_general_ci

  

# this is only for embedded server

[embedded]

  

# This group is only read by MariaDB servers, not by MySQL.

# If you use the same .cnf file for MySQL and MariaDB,

# you can put MariaDB-only options here

[mariadb]

  

# This group is only read by MariaDB-10.5 servers.

# If you use the same .cnf file for MariaDB of different versions,

# use this group for options that older servers don't understand

[mariadb-10.5]
```


### Key Purposes :

1. **Server Configuration**: It defines settings related to the MariaDB server, like memory allocation, file locations, and networking settings.
    
2. **Data Storage**: Specifies where the server stores its databases, logs, and temporary files.
    
3. **Security Settings**: Manages options like which IP addresses can access the server, how users authenticate, and password-related options.
    
4. **Performance Tuning**: Configurations for buffers, caches, and other resource-related options to optimize performance.
    
5. **Logging**: Defines where error logs and other logs should be written to, making it easier to debug or monitor the server.

