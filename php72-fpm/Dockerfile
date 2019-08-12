FROM php:7.2.12-fpm-alpine

LABEL maintainer="Robert <robert@janfish.cn>"
LABEL description="Build a specified version of PHP FPM";

ARG PHALCON_VERSION=3.4.1
ARG PHALCON_EXT_PATH=php7/64bits
ARG MCRYPT_VERSION=1.0.1
ARG IMAGICK_VERSION=3.4.3
ARG MONGODB_VERSION=1.5.5
ARG ZIP_VERSION=1.15.4
ARG SEASLOG_VERSION=2.0.2
ARG REDIS_VERSION=4.2.0
ARG CURL_VERSION=7.50.1
ARG SWOOLE_VERSION=4.4.3
ARG HIREDIS_VERSION=0.14.0

WORKDIR /root

RUN echo -e "https://mirrors.aliyun.com/alpine/v3.8/main/\nhttps://mirrors.aliyun.com/alpine/v3.8/community/" >  /etc/apk/repositories \
    && apk add g++ make autoconf imagemagick-dev imagemagick libmcrypt-dev gd-dev libpng-dev libjpeg-turbo-dev freetype-dev gettext-dev libzip-dev \
    # fix timezone
    && apk add -U tzdata \
    # install extensions
    && docker-php-ext-install pdo_mysql bcmath exif sockets \
    && docker-php-ext-configure gd --with-freetype-dir --with-jpeg-dir --with-png-dir && docker-php-ext-install -j$(nproc) gd \
    && set -xe

# compile hiredis
RUN wget https://github.com/redis/hiredis/archive/v${HIREDIS_VERSION}.tar.gz -O hiredis.tar.gz \
    && mkdir -p hiredis \
    && tar -xf hiredis.tar.gz -C hiredis --strip-components=1 \
    && rm hiredis.tar.gz \
    && ( \
        cd hiredis \
        && make -j$(nproc) \
        && make install \
        && ldconfig /etc/ld.so.conf.d \
    ) \
    && rm -r hiredis

# install extension
RUN printf "yes\nno\nyes\nyes\n" | pecl install swoole-${SWOOLE_VERSION}.tgz && \
    echo "extension=swoole.so"  >/usr/local/etc/php/conf.d/docker-php-ext-swoole.ini  && \
    # Pecl install Redis
    pecl install redis-${REDIS_VERSION}.tgz && \
    echo "extension=redis.so"  >/usr/local/etc/php/conf.d/docker-php-ext-redis.ini  && \
    # Pecl install Zip
    pecl install zip-${ZIP_VERSION}.tgz && \
    echo "extension=zip.so"  >/usr/local/etc/php/conf.d/docker-php-ext-zip.ini  && \
    # Pecl install Mcrypt
    pecl install mcrypt-${MCRYPT_VERSION}.tgz && \
    echo "extension=mcrypt.so"  >/usr/local/etc/php/conf.d/docker-php-ext-mcrypt.ini  && \
    # Pecl install Seaslog
    pecl install SeasLog-${SEASLOG_VERSION}.tgz && \
    echo "extension=seaslog.so"  >/usr/local/etc/php/conf.d/docker-php-ext-seaslog.ini  && \
    # Pecl install Imagick
    pecl install imagick-${IMAGICK_VERSION}.tgz && \
    echo "extension=imagick.so"  >/usr/local/etc/php/conf.d/docker-php-ext-imagick.ini  && \
    # Pecl install Mongodb
    pecl install mongodb-${MONGODB_VERSION}.tgz && \
    echo "extension=mongodb.so"  >/usr/local/etc/php/conf.d/docker-php-ext-mongodb.ini  && \
    # Compile Phalcon
    curl -LO http://helper.janfish.cn/files/cphalcon-${PHALCON_VERSION}.tar.gz && \
    tar xzf ${PWD}/cphalcon-${PHALCON_VERSION}.tar.gz && \
    docker-php-ext-install -j $(getconf _NPROCESSORS_ONLN) ${PWD}/cphalcon-${PHALCON_VERSION}/build/${PHALCON_EXT_PATH} && \
    # Add config
    mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini && \
    # Optimize FPM performance
    sed -i 's/variables_order = "GPCS"/variables_order = "GPCSE"/' /usr/local/etc/php/php.ini && \
          sed -i 's/post_max_size = 8M/post_max_size = 12M/' /usr/local/etc/php/php.ini && \
          sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /usr/local/etc/php/php.ini && \
          sed -i 's/;date.timezone =/date.timezone = PRC/' /usr/local/etc/php/php.ini && \
          sed -i 's/pm.max_children = 5/pm.max_children = 60/' /usr/local/etc/php-fpm.d/www.conf && \
          sed -i 's/pm.start_servers = 2/pm.start_servers = 35/' /usr/local/etc/php-fpm.d/www.conf && \
          sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 20/' /usr/local/etc/php-fpm.d/www.conf && \
          sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 35/' /usr/local/etc/php-fpm.d/www.conf && \
          sed -i 's/;pm.max_requests = 500/pm.max_requests = 1000/' /usr/local/etc/php-fpm.d/www.conf && \
    # Remove all temp files
    rm -r \
        ${PWD}/cphalcon-${PHALCON_VERSION}.tar.gz \
        ${PWD}/cphalcon-${PHALCON_VERSION}
# recompile libcurl with openssl2
RUN apk add --update --no-cache openssl openssl-dev nghttp2-dev ca-certificates  && \
    apk add --update --no-cache --virtual curldeps g++ make perl && \
    wget http://helper.janfish.cn/files/curl-${CURL_VERSION}.tar.bz2 && \
    tar xjvf curl-${CURL_VERSION}.tar.bz2  && \
    rm curl-${CURL_VERSION}.tar.bz2  && \
    cd curl-${CURL_VERSION} && \
    ./configure \
        --with-nghttp2=/usr \
        --prefix=/usr \
        --with-ssl \
        --enable-ipv6 \
        --enable-unix-sockets \
        --without-libidn \
        --disable-static \
        --disable-ldap \
        --with-pic  && \
     make && make install && \
     cd ../ && rm -r curl-${CURL_VERSION}

#fix iconv bugs(https://github.com/docker-library/php/issues/240#issuecomment-305038173) 万恶的资本主义的网有好差
#RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
#RUN apk add --no-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing gnu-libiconv
RUN apk add gnu-libiconv --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php