---
title:  数据库
tag: 数据库
---

## 什么是Schema设计

>Schema设计指的是对数据库表的设计

### Schema设计目标

**可用的设计目标**

>对需求深刻理解，知道存储哪些数据能够保证业务流程顺利进行，并且使用合适的数据类型进行存储，保证所设计的数据库和数据表能够支撑当前的业务需求，且在技术实现上没有弊端，那它是可用的。

**好用的设计目标**

>随业务规模变大，数据量规模也会有所上升，如何保持较高的性能，如将通用信息单独使用一张表存储，建立适当索引等。

### Schema设计原则

>+ 数据库表名称，列名称，数据库名称都要用小写
>+ 名称有意义，多个单词之间用下划线连接，名称不要过长
>+ 够用且尽量小（数据库类型满足需求的前提下选择占用空间少的，减少用户存储空间和索引空间）
>+ 不使用物理外键
>+ 表一定要有主键
>+ 保持一致编码字符集，如数据库、数据表、数据列字符集都应该是utf8或者utf8mb4

### 库设计规范

**创建数据库语句**

```sql
create database if not exists databases_name;
```

**一个库应该存储多少张表**

>不要超过200个表，几十到100更适宜，表越多，需要维护的表结构越多，同时存储的数据量越大会给数据库造成很大压力，一旦出现损失，丢失的数据量也就越多。

### 表设计规范

**范式和反范式**

>范式化它的核心是数据只出现一次，不存在冗余数据，反范式破了这个规则，有冗余数据的存在

**范式的优缺点**

>+ 使用更少的存储空间
>+ 由于没有冗余数据，增删改查速度快
>+ 由于不存在冗余数据，稍微复杂的业务可能要做好几张表的关联

**三大范式**

>1NF: 字段不可分，原子性，字段不可以再分，否则就不是关系型数据库
>
>2NF: 有主键，非主键字段依赖主键，唯一性，一个表说明一个事物
>
>3NF: 非主键字段之间不能依赖，每列都和主键有直接关系，但是不能传递依赖关系，各个非主键字段不能互相传递

**宽表窄表**

>mysql对于每个表有4096列的限制，真正使用的限制取决于引擎，对于innodb来说，限制1017列
>
>宽表：超过40列的表，数据量比较大，占用存储空间多，降低排序分组的性能。
>
>窄表：少于40列的表，数据列比较分散，编写关联查询难度大。

**索引合理使用**

>建立索引，能够加速表的数据查询，它也会占据一定的存储空间，缺点就是以空间换查询时间，与此同时插入，删除，更新的性能都会下降，要追求空间和时间的平衡，既不占用过多的存储空间，也保持较高的性能。

## 数据类型的说明

>数据类型定义了数据库的列可以存储什么样类型的数据以及当前数据存储的基本规则，从mysql的角度出发，数据类型是为了方便对数据进行分类，使用统一的方式进行有效管理，更好的利用有限的空间。

### 数据类型分类

>mysql的数据类型通常分为四类
>
>1. 字符串类型，如char、varchar、text，用于存储字符、字符串数据
>2. 日期/时间类型，如date、time、datetime、timestamp,用于存储时间或者日期，这种数据类型比较难选。
>3. 数值类型，如tinyint、int 、bigint、float 、double、decimal,用于存储整数或者小数
>4. 二进制类型，tityblob、blob、mediumblob、longblob，用于存储二进制数据

### 使用建议

#### 字符串类型

>**1.char数据类型**
>
>char数据类型用于存储固定长度的字符串，长度位于1-255之间，当存储字符串的长度未达到指定固定的长度，就会用空格填充造成空间浪费。
>
>char类型实际应用有手机号、身份证号。
>
>**2.varchar数据类型**
>
>varchar数据类型定义的是一个可变长度的字符串，长度位于0-65535，存储的字符串长度不能超过所指定的长度，且最大长度不能超过65535，对于长度不固定的用varchar数据类型比较合适。
>
>varchar类型的实际应用：姓名、邮箱等
>
>>**char和varchar的区别：**
>
>>（1）char指定了长度后，如果存储字符的长度不足，就会用空格补充，查询的时候再将空格去掉，所以char类型的存储的字符串不能有空格，varchar不受此限制。
>
>>（2）由于char的长度固定，不论存入多少，都会占用固定长度的字节，但是varchar存入的字节数是存入字符数的+1（长度小于255）或者+2（长度大于255）
>
>>（3）由于char的长度是固定的，不需要考虑边界问题，检索速度快于varchar
>
>**3.tinytext、text、mediumtext、longtext数据类型**
>
>mysql提供了四种文本数据类型，都属于可变长字符串，唯一不同的是存储空间不同
>
>tinytext 2^8-1
>
>text 2^16-1
>
>mediuntext 2^24-1
>
>longtext 2^32-1
>
>当存储的数据量过大时，就要考虑用文本了，当数据量超过500就应该使用文本，文本类型不能有默认值，且创建索引的时候要指定前多少个字符。

#### 日期/时间类型

>**1.date数据类型**
>
>>date数据类型用于存储日期，存储范围为'1000-01-01'-'9999-12-31',只能用于存储年月日
>
>>适合场景：出生日期
>
>**2.time数据类型**
>
>>用于存储时间，不仅能够表示一天中的时间，也可以用于表示两个时间的间隔。存储范围是'-838:59:59'-'838:59:59',time还可以按照“D HH:MM:SS”格式存储，D的取值是0-34
>
>>适合场景：具体时间
>
>**3.datetime数据类型**
>
>>日期和时间的组合
>
>>适合场景：数据插入时间和订单完成时间等等。
>
>**4.timestamp数据类型**
>
>>用于存储日期和时间的数据，取值范围‘1970-01-01 00:00:01.000000’ UTC 到 ‘2038-01-19 03:14:07.999999’ UTC,它与datetime时间范围相比较少，和时区相关，当插入时间的时候，会先转换成本地时区，在存储，查询时间时，会先转换为本地时区在显示，不同时区看到的同一时间时不一样的
>
>**注意：**datetime最佳选择，时间范围足够大，不管是只要时间还是日期在代码中处理即可，避免需求变更对数据库表进行改动。

#### 数值类型

**1.整数类型**

| 数据类型  | 占据空间 | 范围（有符号）   | 范围（无符号）           | 描述       |
| --------- | -------- | ---------------- | ------------------------ | ---------- |
| tinyint   | 1字节    | -2^7 - 2^7 - 1   | 0 - 127                  | 小整数值   |
| smallint  | 2字节    | -2^15 - 2^15 -1  | 0 - 65535                | 大整数值   |
| mediumint | 3 字节   | -2^23 - 2^23 - 1 | 0 - 16777215             | 大整数值   |
| int       | 4 字节   | -2^31 - 2^31 - 1 | 0 - 4294967295           | 大整数值   |
| bigint    | 8 个字节 | -2^63 - 2^63-1   | 0 - 18446744073709551615 | 极大整数值 |

>上述几种数据类型除了取值范围不同，其他的并没有本质的区别，在使用上选择足够大的空间就可以了，还有一个特性就是：显示宽度
>
>```sql
>`a` bigint(20) NOT NULL COMMENT 'a',
>`b` int(11) NOT NULL COMMENT 'b'
>```
>
>20和11就是可选宽度，当b定义11时，如果存储宽度小于11会自动用空格补齐，定义宽度并不会影响字段的大小和存储值的范围



**2.浮点类型**

>mysql支持两个浮点类型，float,double,float用于单精度浮点数，占用4个字节，double时双精度浮点数，占用8个字节，他们只能保存近似值，所以通常叫非标准类型，float相对于double来说，占用内存少，精度较低，取值范围较小。
>
>float(M,D),其中M是显示长度，D是定义的小数的位数，默认值是float(10,2),10是数字的总长包括小数位数，2是小数的位数，小数精度可以到24个精度。
>
>double(M,D)M和D的含义和float一样，默认值是double(16,4),它的小数精度可以到53位

3.定点类型

>mysql中decimal被称为定点数据类型，由于它保存的是精确值，通常用于精度要求非常高的计算，也可以利用decimal保存比bigint更大的整数值。
>
>cpu不支持对decimal的数据类型进行计算，mysql自身实现了对decimal的高精度计算，底层实现方面，mysql将decimal的数据类型的数字使用二进制字符串进行存储，每4个字节存储9个数字。如果存储位数不够，则小数补0，但是，如果超出位数，就会报错。
>
>由于decimal需要比较大的空间和计算开销，他的计算效率没有float和double那么高，所以要求精确计算的场景下才会考虑使用decimal.

#### 二进制类型

>二进制类型理论上可以存储任何数据，如：文件、图片、其他多媒体数据，二进制数据类型相对于其他数据类型来
>
>说，使用频率较低，mysql一共提供了四种二进制数据类型，tityblob、blob、mediumblob、longblob他们的区别在于存储数据的范围不同
>
>+ tityblob 最大支持255字节
>+ blob 最大支持64kb
>+ mediumblob 最大支持 16MB
>+ longblob 最大支持4GB
>
>mysql提供并支持大文件存储，这样会降低数据库的性能，谨慎使用，能不用尽量不用

### 使用技巧

>**1 使用not null 且带有comment**
>
>>mysql的索引值为null时，会额外占用存储空间，另外进行比较和运算时，需要对null进行特殊处理，效率低
>
>>comment就是列的注释，方便以后查阅
>
>**2 使用存储需要最小的数据类型**
>
>>满足需求的前提下，选取最小的数据类型。
>
>>可以选择tinyiny存储事件状态，可以使用smallint存储班级人数，并不需要都选择int进行存储。
>
>>关于最小的数据类型的优势：
>
>>+ 越小的数据类型，占用磁盘、内存、cpu缓存都会更小、存取速度也会更快
>>+ 小的数据类型建立索引所需要的空间也相对的较少，这样一页中存储的索引节点数量也就越多，遍历的时候io就越少，索引的性能就越好。
>
>**3 选择简单的数据类型**
>
>能用int就不用varchar
>
>**4 存储订单金额小数直接用decimal**
>
>**5 尽量避免使用text和blob**
>
>>mysql临时表并不支持text和blob这样的大数据类型，如果要查询这样的数据，则排序操作必须使用临时表，性能会下降很多。mysql对索引长度又限制，text类型只能用到前缀索引，并且由于存储的时指针，text列上不能有默认值。

## Sql基础语法

#### 创建数据库

```sql
creat database databases_name;
```

#### 创建数据库表

```sql
create table table_name (
cloumn_name1 data_type(size),
cloumn_name2 data_type(size),
cloumn_name3 data_type(size)
);

```

#### sql约束

```sql
create table table_name (
cloumn_name1 data_type(size) 约束1,
cloumn_name2 data_type(size) 约束2,
cloumn_name3 data_type(size) 约束3
);
```

##### 常见约束

>+ not null 不能存储空值
>+ unique 某列每行必须有唯一值
>+ pramary key 主键 not null和unique结合体
>+ foreign key  外键，可以从一个表的属性匹配到另一个表中
>+ check 保证某列的值符合指定条件
>+ default 设置默认值

###### Not null 约束

>约束强制列不包含null值。

**语法使用**

```sql
create table table_name(
id int not null
);
```

**添加约束**

```sql
Alter table table_name modify id int not null;
```

**删除约束**

```sql
Alter table table_name modify id int null;
```

###### Unique约束

>unique约束唯一标志数据库表中的每条记录。
>
>unique和primary key约束列或集合提供了唯一性的保证
>
>每个表可以有多个unique约束，但是primary key约束只有一个

**创建约束**

```sql
create table table_name(
id int not null,
    unique (id)
)

//定义多个约束列
create table table_name(
id int not null,
    name varchar not null,
    CONSTRAINT uc_PersonID unique (id,name)
)
```

**添加约束**

```sql
alter table table_name add unique(id)
#定义多个约束列
alter table table_name add  CONSTRAINT uc_PersonID unique(id，name)
```

**删除约束**

```sql
alter table table_name  drop index uc
```



###### Primary key约束

>primary key约束唯一标志数据库中的每条记录
>
>主键唯一，且不为空
>
>每个表都应该有一个主键，并且只有一个主键

**创建约束**

```sql
create table table_name (
id int not null ,
primary key (id)
)

#定义多列为主键
create table table_name (
id int not null ,
    name varchar not null,
 constraint uc primary key (id,name)
)
```

**添加约束**

```sql
alter table table_name add primary key(id)
//添加多列为主键
alter table table_name add constraint uc primary key (id,name)
```

**删除约束**

```sql
alter table table_name drop primary key
```

###### Foreign key约束

>一个表中的foregin key指向另一个表中unquie key唯一约束键
>
>防止非法数据插入外键列

**创建约束**

```sql
create table table_name (
    id int not null,
    o_id int noy null,
    primary key (id),
    foreign key (o_id) references other_table_name(other_id)
	)
```

**添加约束**

```sql
alter table table_name add foreign key (o_id) references  other_table_name(other_id)
#定义多个列
alter table table_name add constraint fk foreign key (o_id) references other_table_name(other_id)
```

**删除约束**

```sql
alter table table_name drop foreign key fk
```

###### check约束

>check用于限制列中值的范围
>
>对于单列进行check约束，那么该列只允许特定的值。
>
>如果对一个表进行check约束，此约束会基于行中其他列的值在特定的列中的值进行限制。

**创建约束**

```sql
create table table_name(
id int not null,
check (id>0)
)
//定义多个列的约束
create table table_name(
id int not null;
city varchar not null,
check (id>0 and city='beijing')
)
```

**添加约束**

```sql
alter table table_name add check (id>0)
#定义多列约束
alter table table_name add constraint check_name check (id>0 and city='beijing')
```

**删除约束**

```sql
alter table table_name drop check check_name
```

###### Default约束

>default约束用于向列中插入默认值

**创建约束**

```sql
create table table_name(
id int not null,
city varchar not null default 'beijing'
)
```

**添加约束**

```sql
alter table table_name add city set default 'beijing'
```

**删除约束**

```sql
alter table table_name 
alter city drop default 
```

### Sql函数

| 名称          | 作用                           |
| ------------- | ------------------------------ |
| AVG()         | 返回平均值                     |
| COUNT()       | 返回行数                       |
| MAX()         | 返回指定列的最大值             |
| MIN()         | 返回指定列的最小值             |
| SUM()         | 返回数值列的总数               |
| UCASE()       | 字段的值转换为大写             |
| LCASE()       | 字段的值转换为小写             |
| SUBSTR()      | 字符串截取                     |
| LENGTH()      | 返回字符串长度                 |
| ROUND()       | 把数值字段舍入为指定的小数位数 |
| NOW()         | 返回当前系统的日期和时间       |
| DATE_FORMAT() | 格式化为 YYYY-MM-DD 的日期     |
| TRIM()        | 删除字符串左右两侧的空格       |
| REVERSE()     | 字符串 反转                    |
| CONCAT()      | 字符串拼接                     |
| REPLACE()     | 字符串替换                     |

### Sql进阶语法



### Sql高级语法