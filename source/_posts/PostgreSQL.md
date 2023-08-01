---
title: PostgreSQL
tag: 安装
---

## 安装PostgreSQL

#### 1. 依赖

+ make >= 3.8.0
+ 推荐gcc最新版
+ bzip、bzip2、tar、readline、readline-devel、zlib-devel
+ Perl

#### 2. 下载源代码

```url
https ://www.postgresql.org/download/
# 下载名为postgresql-10.21.tar.gz  解压
gunzip postgresql-10.21.tar.gz
tar xf postgresql-10.21.tar
```

#### 3.编译

```shell
./configure --prefix=/usr/local/postgresql
```

#### 4.安装

```shell
make && make install
```

#### 5.创建data、log目录

```shell
cd /usr/local/postgresql
mkdir /usr/local/postgresql/data
mkdir /usr/local/postgresql/log
```

#### 6.设置环境变量

```shell
vim /etc/profile
# 添加
export PGHOME=/usr/local/postgresql
export PGDATA=/usr/local/postgresql/data
# 保存后生效
source /etc/profile
```

#### 7.增加用户 postgres 并赋权

```shell
useradd postgres
chown -R postgres:root /usr/local/postgresql
```

#### 8.初始化数据库

```shell
su postgres
/usr/local/postgresql/bin/initdb -D /usr/local/postgresql/data/
```

#### 9.修改配置文件

```shell
vim /usr/local/postgresql/data/postgresql.conf
# 修改
listen_addresses = '*'
port = 5432

vim /usr/local/postgresql/data/pg_hba.conf
# 添加一行
host    all             all             0.0.0.0/0               trust
```

#### 10.启动服务

```shell
pg_ctl start -l /usr/local/postgresql/log/pg_server.log
```

#### 11.登录默认数据库

```shell
 /usr/local/postgresql/bin/psql postgres
```

#### 12.为默认用户设置密码

```shell
postgres=# sudo -u postgres psql postgres
postgres-#  \password postgres
Enter new password: 
Enter it again: 
```

