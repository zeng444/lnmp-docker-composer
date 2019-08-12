# 安装说明


## 安装内容

- phalcon3.4.1
- php7.2
- mysql.5.7
- beanstalkd.1.10
- redis.5.0.2
- mongodb.4.0

## 环境说明

- 本脚本默认为DEV，切换环境请自行到docker-compose.yml中替换所有SITE_ENV的值
- SITE_ENV可用参数:

| 值    | 说明           |
|-------|----------------|
|  DEV  | 开发环境(默认) |
|  QA   | 质保环境       |
|  PROD | 生产环境       |

## 下载安装配置包

https://github.com/zeng444/lnmp-docker-composer

## 开始安装

### 快速安装

> 使用快速安装下文的标准安装就可以不用看了，YOUR_PROJECT_NAME请填写你项目名，默认为lnmp

```
install.sh YOUR_PROJECT_NAME
```

### 标准安装

```bash
$ cd lnmp72
$ docker-compose -p lnmp up --build -d
```
### 订制镜像

PHPPhalcon通用镜像编译

```bash
cd php72-fpm
docker build -t phalcon:72 .
```

PHPCli模式通用镜像编译

```bash
cd php72-cli
docker build -t phalcon-cli:72 .
```

## 配置虚拟机

- 项目目录宿主机/data下
- 虚拟机配置/var/lib/nginx下存放，虚拟机配置参考.e.g.

platform.tax.cn.conf

```
server {
    listen 80;
    server_name platform.tax.cn;
    root /data/tax.platform/platform/public;
    include phalcon.conf;
}
```

## Mysql初始密码

```
$ mysql -uroot -proot
```
