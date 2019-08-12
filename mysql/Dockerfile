FROM mysql:5.7
LABEL maintainer="robert@janfish.cn"
LABEL description="Build a specified version of Mysql";

COPY ./docker.cnf /etc/mysql/conf.d/docker.cnf
RUN chmod 644 /etc/mysql/conf.d/docker.cnf