---
title: redis安装
tag: redis
---

## centos安装

**官方snapd商店安装**

```shell
sudo yum install epel-release -y
sudo yum install snapd -y 
sudo systemctl enable --now snapd.socket 
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install redis
```

**官方源码安装[推荐]**

1.安装阿里源

```shell
# CentOS 7
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

2.安装编译器

```shell
yum install gcc-c++ -y
```

3.下载源码

```shell
wget https://download.redis.io/redis-stable.tar.gz
```

4.编译redis

```shell
tar -xzvf redis-stable.tar.gz
cd redis-stable
make
```

5.安装生成的可执行文件

```shell
make install
```

6.启动redis

```shell
redis-server
```

