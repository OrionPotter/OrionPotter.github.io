# Canal

#### 一、数据库复制和同步的基本概念

>作用：实现了数据在多个数据库实例之间的保持一致和同步。应用程序能够获得高可用性、灾备性和读取负载均衡等好处。

1. 主从复制（Master-Slave Replication）：主从复制是最常见的数据库复制方法之一。在主从复制中，有一个主数据库（Master）和一个或多个从数据库（Slaves）。主数据库是数据的源头，它负责接收来自应用程序的写操作，并将这些写操作记录为称为日志（Log）的格式。从数据库则通过读取这些日志，将主数据库的写操作进行重演，以保持数据的一致性。
2. 数据一致性（Data Consistency）：数据一致性是指主数据库和从数据库之间的数据保持一致。当在主数据库上进行写操作时，主数据库会将这些操作的日志记录下来，并将其发送给从数据库。从数据库会按照相同的顺序重现这些操作，确保数据的一致性。一致性的实现可以通过各种机制，例如基于事务日志（Transaction Log）或二进制日志（Binary Log）。
3. 数据传输（Data Transfer）：数据传输是指将主数据库的数据从一个位置传输到另一个位置。在数据库复制和同步过程中，数据传输通常通过网络进行。主数据库将写操作记录为日志，并通过网络传输给从数据库，从数据库接收日志并执行相应的操作。
4. 增量复制（Incremental Replication）：增量复制是一种常见的复制方式，其中只有发生了更改的部分数据会被复制和同步。这种方式可以减少网络传输的数据量，并提高复制效率。增量复制通常使用日志来跟踪数据的更改，只传输和应用这些更改。
5. 数据延迟（Data Latency）：在数据库复制和同步中，主数据库和从数据库之间可能存在一定的延迟。这是因为数据在传输和应用过程中需要一定的时间。数据延迟可能会导致从数据库上的数据不是实时的，在某些情况下可能会有一定的时间窗口内的数据不一致。

#### 二、canal作用及原理

![](https://camo.githubusercontent.com/63881e271f889d4a424c55cea2f9c2065f63494fecac58432eac415f6e47e959/68747470733a2f2f696d672d626c6f672e6373646e696d672e636e2f32303139313130343130313733353934372e706e67)

canal作用：根据Mysql数据库增量日志进行解析，提供增量数据的订阅和消费。

canal原理：canal模拟Mysql slave交互协议，伪装成slave发送dump报文，主数据库master收到dump请求后，推送binary log给canal。

#### 三、数据库准备

1.开启binlog,/etc/my.cnf 中配置如下

```ini
[mysqld]
server-id=1
log_bin=mysql-bin
binlog-format=row
bind-address=0.0.0.0
port=3306
basedir=/usr/local/mysql
datadir=/data/mysql
socket=/tmp/mysql.sock
log-error=/data/mysql/mysql.err
pid-file=/data/mysql/mysql.pid
#character config
character_set_server=utf8mb4
symbolic-links=0
explicit_defaults_for_timestamp=true
```

2.授权 canal 链接 MySQL 账号具有作为 MySQL slave 的权限, 如果已有账户可直接 grant

```sql
CREATE USER canal IDENTIFIED BY 'canal';  
GRANT SELECT, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'canal'@'%';
FLUSH PRIVILEGES;
```



#### 四、安装Server

>下载：canal.deployer-1.1.6.tar.gz

1.conf/example/instance.properties配置修改

```properties
#position info，需要改成自己的数据库信息
canal.instance.master.address = 127.0.0.1:3306 
canal.instance.master.journal.name = 
canal.instance.master.position = 
canal.instance.master.timestamp = 
#canal.instance.standby.address = 
#canal.instance.standby.journal.name =
#canal.instance.standby.position = 
#canal.instance.standby.timestamp = 
#username/password，需要改成自己的数据库信息
canal.instance.dbUsername = canal  
canal.instance.dbPassword = canal
canal.instance.defaultDatabaseName =
canal.instance.connectionCharset = UTF-8
#table regex
canal.instance.filter.regex = .\*\\\\..\*
```

2.启动

```shell
sh bin/startup.sh
```

#### 五、安装RDB适配器

>下载：canal.adapter-1.1.7-SNAPSHOT.tar.gz

##### 1.修改启动器配置: application.yml, 这里以mysql目标库为例,将bootstrap.yml注释掉

```xml
srcDataSources:
    defaultDS:
      url: jdbc:mysql://192.168.67.24:3306/mytest?useUnicode=true
      username: root
      password: *******
  canalAdapters:
  - instance: example # canal instance Name or mq topic name
    groups:
    - groupId: g1
      outerAdapters:
      - name: rdb                                               # 指定为rdb类型同步
        key: mysql1                                            # 指定adapter的唯一key, 与表映射配置中outerAdapterKey对应
        properties:
          jdbc.driverClassName: com.mysql.jdbc.Driver        # jdbc驱动名, 部分jdbc的jar包需要自行放致lib目录下
          jdbc.url: jdbc:mysql://192.168.67.16:31185/mytest?useUnicode=true        # jdbc url
          jdbc.username: dongzhimen                                 # jdbc username
          jdbc.password: **********                                # jdbc password
          druid.stat.enable: false                                           
		  druid.stat.slowSqlMillis: 1000	
```

##### 2.修改conf/rdb/mytest_user.yml文件

```xml
dataSourceKey: defaultDS
destination: example
outerAdapterKey: mysql1
concurrent: true
dbMapping:
  mirrorDb: true
  database: mytest
```

>其中dbMapping.database的值代表源库和目标库的schema名称，即两库的schema要一模一样

3.启动

```shell
sh startup.sh
```

