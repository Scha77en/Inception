#!/bin/bash
# srcs/requirements/mariadb/tools/init-db.sh

# sed -i "s|# port = 3306|port = 3306|1" /etc/mysql/mariadb.cnf
# sed -i "s|bind-address\s*=.*|bind-address = 0.0.0.0|" /etc/mysql/mariadb.cnf

set -e
# srcs/requirements/mariadb/tools/init-db.sh

# sed -i "s|# port = 3306|port = 3306|1" /etc/mysql/mariadb.cnf
# sed -i "s|bind-address\s*=.*|bind-address = 0.0.0.0|" /etc/mysql/mariadb.cnf

# yes
# mysql_install_db --user=mysql --ldata=/var/lib/mysql
service mariadb start
echo a
mysql_secure_installation << EOF
n
${MYSQL_PASSWORD}
${MYSQL_PASSWORD}
y
n
n
n
n
EOF

mariadb -u root -p${MYSQL_PASSWORD} << EOF
echo b
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p${MYSQL_PASSWORD} shutdown

mariadbd
