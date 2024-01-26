---
title: PostgreSQL 学习
tag: 教程
---



# 安装PostgreSQL

## 安装依赖

+ make >= 3.8.0
+ 推荐gcc最新版
+ bzip、bzip2、tar、readline、readline-devel、zlib-devel
+ Perl

## 下载源代码

```url
https ://www.postgresql.org/download/
# 下载名为postgresql-10.21.tar.gz  解压
gunzip postgresql-10.21.tar.gz
tar xf postgresql-10.21.tar
```

## 编译

```shell
./configure --prefix=/usr/local/postgresql
```

## 安装

```shell
make && make install
```

## 创建data、log目录

```shell
cd /usr/local/postgresql
mkdir /usr/local/postgresql/data
mkdir /usr/local/postgresql/log
```

## 设置环境变量

```shell
vim /etc/profile
# 添加
export PGHOME=/usr/local/postgresql
export PGDATA=/usr/local/postgresql/data
# 保存后生效
source /etc/profile
```

## 增加用户 postgres 并赋权

```shell
useradd postgres
chown -R postgres:root /usr/local/postgresql
```

## 初始化数据库

```shell
su postgres
/usr/local/postgresql/bin/initdb -D /usr/local/postgresql/data/
```

## 修改配置文件

```shell
vim /usr/local/postgresql/data/postgresql.conf
# 修改
listen_addresses = '*'
port = 5432

vim /usr/local/postgresql/data/pg_hba.conf
# 添加一行
host    all             all             0.0.0.0/0               trust
```

## 启动服务

```shell
pg_ctl start -l /usr/local/postgresql/log/pg_server.log
```

## 登录默认数据库

```shell
 /usr/local/postgresql/bin/psql postgres
```

## 为默认用户设置密码

```shell
postgres=# sudo -u postgres psql postgres
postgres-#  \password postgres
Enter new password: 
Enter it again: 
```

# 基础教程

## Querying Data

## Filtering Data

## Joining Multiple Tables

## Grouping Data

## Set Operations

## Grouping sets, Cube, and Rollup

## Subquery

## Common Table Expressions

## Modifying Data

## Transactions

## Import & Export Data

## Managing Tables

## Understanding PostgreSQL Constraints

## PostgreSQL Data Types in Depth

## Conditional Expressions & Operators

## PostgreSQL Utilities

## PostgreSQL Recipes

# 高级教程

## PL/pgSQL

## Triggers

## Views

## Indexes

## Administration

