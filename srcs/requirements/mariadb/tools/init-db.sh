#!/bin/bash
# srcs/requirements/mariadb/tools/init-db.sh

# sed -i "s|# port = 3306|port = 3306|1" /etc/mysql/mariadb.cnf
# sed -i "s|bind-address\s*=.*|bind-address = 0.0.0.0|" /etc/mysql/mariadb.cnf

set -e

mysql_install_db --user=mysql --ldata=/var/lib/mysql

mysqld --user=mysql --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;
EOF

exec mysqld --user=mysql