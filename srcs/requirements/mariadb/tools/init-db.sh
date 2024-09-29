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
