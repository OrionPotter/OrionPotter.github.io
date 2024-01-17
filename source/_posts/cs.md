---
title: 分布式
---

#### 1. 唯一ID由来

>分布式系统中，需要对大量的数据和消息进行唯一标识，如金融行业产品系统中，数据日益增长，对数据进行分库分表后，需要用唯一ID来标识一条数据，数据库的自增ID已经不能满足，此时就需要一个全局唯一ID标识。

#### 2.唯一ID特点

>1. 全局唯一：全局唯一，不会出现重复项。
>2. 趋势递增：B+树的索引下进行递增，保证写入性能
>3. 单调递增：下一个id肯定大于上一个id
>4. 信息安全：ID无规则、不规则

#### 3.实现方案

+ 数据库自增ID

>数据库中一般给主键设置自增。
>
>优点：简单，由数据库自己操作完成，id是单调自增
>
>缺点：主从切换的时候不一致，容易导致重复发号

+ UUID

>由32个16进制数字组成，形式为8-4-4-4-12的32个字符。
>
>优点：性能高，本地生成，无网络消耗。
>
>缺点：存储占用空间大，基于MAC地址生成的UUID存在信息安全问题。

+ Redis唯一ID

>Redis是单线程的，可以依据redis的原子操作incr和incrby实现。
>
>优点：数字ID天然排序，对分页和排序的结果有帮助。

+ zookeeper唯一ID

>zookeeper通过其znode数据版本生成序列号，可以生成32位和64位数据版本号，客户端可以使用这个版本号作为唯一序列号

+ snowflake算法

>由64个二进制数字组成一般分为1-41-10-12,snowflake方案的QPS约为409.6w/s
>
>第一部分：表示正数
>
>第二部分：41表示毫秒时间
>
>第三部分：工作机器ID，5位表示数据中心，5位表示机器id
>
>第四部分：12位的序列号，每毫秒可生成4096个id
>
>优点：毫秒在高位，自增序列号在低位，整体是递增趋势
>
>缺点：依赖时间，如果时间回拨，会导致发号重复或者不可用状态

## 二、动态数据源切换

1. 导入相关依赖

```xml
<dependency>
       <groupId>com.baomidou</groupId>
       <artifactId>dynamic-datasource-spring-boot-starter</artifactId>
       <version>3.5.1</version>
</dependency>
```

2. 修改配置文件

```xml
spring:
  datasource:
    dynamic:
      primary: master #设置默认的数据源或者数据源组,默认值即为master
      strict: false #严格匹配数据源,默认false. true未匹配到指定数据源时抛异常,false使用默认数据源
      datasource:
        master: #主库
          url: jdbc:mysql://180.76.187.95:3306/test?characterEncoding=utf8&useSSL=false&serverTimezone=UTC&rewriteBatchedStatem
          username: root
          password: 321456
          driver-class-name: com.mysql.cj.jdbc.Driver 
        slave: #从库
          url: jdbc:mysql://180.76.187.95:3306/test2?characterEncoding=utf8&useSSL=false&serverTimezone=UTC&rewriteBatchedStatem
          username: root
          password: 321456
          driver-class-name: com.mysql.cj.jdbc.Driver
```

3. 切换从库数据源

```java
@Service
@DS("slave") #@DS注解只能用在service或者dao层
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {}
```



1. 分页功能
2. 多租户
3. 数据操作日志

