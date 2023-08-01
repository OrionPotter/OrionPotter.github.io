---
title: sql语句
tag: 数据库
---

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

## Sql函数

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

## Sql进阶语法



## Sql高级语法