FROM debian:bullseye

RUN apt update && apt install -y mariadb-server

COPY conf/mariadb.conf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/init-db.sh /

RUN chmod +x /init-db.sh

EXPOSE 3306

CMD ["bash", "/init-db.sh"]
