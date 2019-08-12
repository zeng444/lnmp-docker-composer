FROM nginx:1.17-alpine
LABEL maintainer="robert@janfish.cn"
LABEL description="Build a specified version of Nginx";
ARG SITE_ENV

COPY ./fastcgi_params /etc/nginx/fastcgi_params
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./phalcon.conf /etc/nginx/phalcon.conf

# set env
RUN echo -e "https://mirrors.aliyun.com/alpine/v3.8/main/\nhttps://mirrors.aliyun.com/alpine/v3.8/community/" >  /etc/apk/repositories \
    && sed -i "s/PROD/$SITE_ENV/" /etc/nginx/phalcon.conf

