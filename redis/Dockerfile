FROM redis:5.0.2-alpine

# echo never > /sys/kernel/mm/transparent_hugepage/enabled

LABEL maintainer="Robert <robert@janfish.cn>"
LABEL description="Build a specified version of PHP FPM";
COPY ./redis.conf /usr/local/etc/redis/redis.conf
CMD redis-server /usr/local/etc/redis/redis.conf