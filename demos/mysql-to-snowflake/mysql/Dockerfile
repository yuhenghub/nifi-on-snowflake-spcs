# MySQL for SPCS
FROM mysql:8.0

ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=nifi_demo
ENV MYSQL_USER=nifi_user
ENV MYSQL_PASSWORD=nifi_password

COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
