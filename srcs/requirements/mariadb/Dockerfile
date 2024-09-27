# FROM debian:buster

# # Install MariaDB
# RUN ape-get update && apt install -y mariadb-server

# # Copy the custom MariaDB configuration file into the container
# COPY ./conf/my.cnf /etc/mysql/my.cnf

# # Expose port for MariaDB
# EXPOSE 3306

# # Start MariaDB in the foreground
# CMD ["mysqld", "-u", "root"]

# # Build command: docker build -t mariadb_image .
# # Run command: docker run -it -p 3306:3306 mariadb_image

# # Description: MariaDB Dockerfile
# # The MariaDB Dockerfile is similar to the Nginx Dockerfile. The main difference is the installation of MariaDB and the configuration file.
# # The MariaDB Dockerfile installs the MariaDB server and copies the custom MariaDB configuration file into the container.
# # The MariaDB Dockerfile exposes the port for MariaDB and starts the MariaDB server in the foreground.
# # The MariaDB Dockerfile is used to build the MariaDB image and run the MariaDB container.

# srcs/requirements/mariadb/Dockerfile
FROM debian:bullseye

RUN apt update && apt install -y mariadb-server

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init-db.sh /

RUN chmod +x /init-db.sh

# RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld

EXPOSE 3306

CMD ["bash", "/init-db.sh"]
# CMD [ "python3", "/entrypoint.py"]
