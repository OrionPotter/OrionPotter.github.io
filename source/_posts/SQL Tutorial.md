---
title: SQL Tutorial
---





# 第一章 数据简单概述

数据库 （DataBase）：数据库是将大量数据保存起来，通过计算机加工而成的可以进行高效访问的数据集合。

SQL 语句可以分为以下三类：

1. **DDL**（Data Definition Language，数据定义语言） 用来创建或者删除存储数据用的数据库以及数据库中的表等对象。DDL 包含以下几种指令

```sql
CREATE：创建数据库和表等对象

DROP：删除数据库和表等对象

ALTER：修改数据库和表等对象的结构
```

2. **DML**（Data Manipulation Language，数据操纵语言） 用来查询或者变更表中的记录。DML 包含以下几种指令。

```sql
SELECT：查询表中的数据

INSERT：向表中插入新数据

UPDATE：更新表中的数据

DELETE：删除表中的数据
```

3. **DCL**（Data Control Language，数据控制语言） 用来确认或者取消对数据库中的数据进行的变更。除此之外，还可以对 RDBMS 的用户是否有权限操作数据库中的对象（数据库表等）进行设定。DCL 包含以下几种指令。

```sql
COMMIT：确认对数据库中的数据进行的变更

ROLLBACK：取消对数据库中的数据进行的变更

GRANT：赋予用户操作权限

REVOKE：取消用户的操作权限
```

**SQL基本书写规则**

```
SQL语句要以分号（;）结尾

SQL语句不区分大小写

常数的书写方式是固定的:数字直接写；字符串 "" ；日期 "" ；列名直接写，表名特殊情况需要转义符``(比如表名和函数名重复)

单词需要用半角空格或者换行来分隔

命名规则：英文字母、数字、下划线作为数据库，表，列的名字；
注释：对代码的解释说明，不参与代码的运行，目的是增加代码的可读性。
--或# 单行注释
/*
多行
注释
*/
```

# 第二章 数据库基础

## 库和表

创建数据库

```sql
create database school_info;
```

删除数据库

```sql
drop database school_info;
```

创建表

```sql
create table 表名（列1 数据类型 约束，列2 数据类型 约束）
```

删除表

```sql
drop table 表名
```

## 列和数据类型

表中的每一个字段就是某种数据类型;数据类型决定了数据在计算机中的存储格式，代表不同的信息类型

常用的数据类型有：

```sql
整数 int

浮点数 float double #区别

字符 char varchar  #区别

日期 date datetime
```

## 常用的约束

为了确保表中的数据的完整性(准确性、正确性)，为表添加一些限制。是数据库中表设计的一个最基本规则。使用约束可以使数据更加准确，从而减少冗余数据

```sql
auto_increment:设置主键自动增长

not null 非空约束，用于保证该字段的值不能为空。

default 值 默认约束，用于保证该字段有默认值。

unique 唯一约束，用于保证该字段的值具有唯一性，可以为空。

primary key 主键约束，用于保证该字段的值具有唯一性,并且非空。

foreign key：外键，用于限制两个表的关系，用于保证该字段的值必须来自于主表的关联列的值，在从表添加外键约束，用于引用主表中某些的值(外键约束（表2）对父表（表1）的含义)。

enum 枚举值,用于保证数据中只能填写枚举值

comment 添加注释,给字段添加释义
```

主键：又称为主码，用于标识表中每一行数据，可以把表中的一列或者多列定义为主键，但主键列上不能有两行相同的值，也不能有空值； 特点： 非空且唯一

约束可应用在列级或表级。列表所有约束均支持，但外键约束没有效果；表级约束可以支持主键、唯一、外键约束。

## 创建表

```sql
drop table if exists student_info;
create table student_info (
	id int auto_increment primary key,
	dept_name varchar ( 10 ) unique,
	age int,
	gender enum ( '男', '女' ) default null comment '性别',
	语文 float,
	数学 double,
英语 double ( 10, 2 )) engine = innodb default charset = utf8mb4;

insert into student_info ( dept_name, age, gender,语文, 数学, 英语 ) values ( "tom", 20, "女",213.1231, 213.4353453, 4564.454536 );
insert into student_info ( dept_name, age, gender,语文, 数学, 英语 ) values ( "merry", 20, "男",213.1231, 213.4353453, 4564.454536 );

show create table 表名;展示建表信息;

desc 表名;展示表头信息;
```

## 修改表

```sql
#添加列
alter table student_info add aa int ;
alter table student_info add bb int after age;
# 修改列
#区别:相同点change和modify都可以修改表的定义;不同的是change可以修改列名,而modify不可以
alter table student_info modify aa varchar(20);
alter table student_info  change aa cc int;
# 删除列
alter table student_info drop cc;
# 修改表名
alter table student_info rename to student_info_1
```

## 操作数据

```sql
# 添加数据
insert into student_info values (值); #针对没有设置自增长字段的表可以用
insert into student_info(列1,列2) values(值1,值2); 通用
insert into student_info (列1,列2) values(值1,值2),(值3,值4); 通用
--语句形式 1：
insert into  student_info  (字段1,字段2, ...) select 值1,值2 from table2
--语句形式 2：(需要 student_info 和 table2 的字段完全相同)
insert into student_info select * from table2
# 删除数据
delete from student_info; #区别
truncate student_info;  #区别
delete from student_info where id=1;
#删除表
drop table 表1,表2,表3...... 
# 修改数据
update student_info set 数学=78;#修改整列值 
update student_info set 数学=86 where id=1;#修改某一个值 
# 查询数据
select * from student_info;
```

# 第三章 基本查询与运算符

## 构建样例表

```sql
-- 表1
create table product(
product_id char(4) not null,
product_name varchar(100) not null,
product_type varchar(32) not null,
sale_price integer ,
purchase_price integer ,
regist_date date ,
primary key (product_id));
-- 插入数据
insert into product values ('0001', 't恤衫', '衣服',1000, 500, '2009-09-20');
insert into product values ('0002', '打孔器', '办公用品',500, 320, '2009-09-11');
insert into product values ('0003', '运动t恤', '衣服',4000, 2800, null);
insert into product values ('0004', '菜刀', '厨房用具',3000, 2800, '2009-09-20');
insert into product values ('0005', '高压锅', '厨房用具',6800, 5000, '2009-01-15');
insert into product values ('0006', '叉子', '厨房用具',500, null, '2009-09-20');
insert into product values ('0007', '擦菜板', '厨房用具',880, 790, '2008-04-28');
insert into product values ('0008', '圆珠笔', '办公用品',100, null,'2009-11-11');
```

```sql
-- 表2
create table shopproduct(
shop_id char(4) not null,
shop_name varchar(200) not null,
product_id char(4) not null,
quantity integer not null,
primary key (shop_id, product_id));
-- 插入数据
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000a', '东京', '0001', 30);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000a', '东京', '0002', 50);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000a', '东京', '0003', 15);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000b', '名古屋', '0002', 30);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000b', '名古屋', '0003', 120);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000b', '名古屋', '0004', 20);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000b', '名古屋', '0006', 10);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000b', '名古屋', '0007', 40);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000c', '大阪', '0003', 20);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000c', '大阪', '0004', 50);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000c', '大阪', '0006', 90);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000c', '大阪', '0007', 70);
insert into shopproduct (shop_id, shop_name, product_id, quantity) values ('000d', '福冈', '0001', 100);
```

```sql
-- 表3
create table product2 (
product_id char(4) not null,
product_name varchar(100) not null,
product_type varchar(32) not null,
sale_price integer,
purchase_price integer,
regist_date date,
primary key (product_id)
);
insert into product2 values ('0001', 't恤衫', '衣服', 1000, 500, '2008-09-20');
insert into product2 values ('0002', '打孔器', '办公用品', 500, 320, '2009-09-11');
insert into product2 values ('0003', '运动t恤', '衣服', 4000, 2800, null);
insert into product2 values ('0009', '手套', '衣服', 800, 500, null);
insert into product2 values ('0010', '水壶', '厨房用具', 2000, 1700, '2009-09-20');
```

## 基本select查询语句

```sql
# 单列查询
select product_id,product_name,sale_price
from product;
# 全表查询
select *
from product;
# 设置别名 as 可以省略不写,如需设置中文别名需要加`` or ""
select product_name as `产品名称`
from product;
----------------------------------------------------------------------------------
# 常数查询
# 字符串常数
select '张三';
# 数字常数
select 10;
# 日期常数;
select '2009-02-24';
# 给常数写别名
select 100 as '自己写的',product_name
from product;
# 常数与现有列的运算
select sale_price + 10
from product;
----------------------------------------------------------------------------------
# 去重查询
# distinct 必须写在第一个列前面,而且后面不能再查多余的列
# null值也被视为一类数据
select distinct product_type
from product;
----------------------------------------------------------------------------------
# 条件查询
select product_name,sale_price
from product
where sale_price > 1000;
----------------------------------------------------------------------------------
# 限制查询
# 取前三行
select *
from product
limit 3;
# 从第4行开始,取1行数据
select *
from product
limit 3,1;
```

## 常用运算符

```sql
3.1算术运算符:
| 算术运算符   | 含义 |
| ---------- | ---- |
| +          | 加   |
| -          | 减   |
| *          | 乘   |
| /          | 除   |
1.算术运算符就是对两边的值或列进行运算的符号
2.使用算术运算符可以进行四则运算
3.括号可以提升运算的优先顺序(默认为 先乘除再加减)
4.包含null的运算,其结果也是null
例1: 计算利润
select sale_price-purchase_price profit
from product;
练习: 计算商品售价九折后的价格
select sale_price*0.9
from product;
```

```sql
3.2比较运算符: 
| 比较运算符   | 含义      |
| ---------- | --------  |
| >          | 大于       |
| <          | 小于      |
| >=         | 大于等于  |
| <=         | 小于等于  |
| =          | 等于     |
| !=或<>      | 不等于    |
1.比较运算符可以判断列或值是否相等,还可用来比较大小
2.判断是否为null,需要用 is null 或者 is not null 运算符
例2: 查询利润大于100的商品所有信息
select *
from product
where sale_price - purchase_price > 100;
例3: 查找商品类型为衣服的商品所有信息
select *
from product
where product_type='衣服';
```

```sql
3.3逻辑运算符
| 运算符  | 含义   | 例子                                 |
| ------ | ----  |   -----------------------------------|
| and    | 并且   | 两个条件都满足,最终结果才成立            |
| or     | 或者   | 两个条件满足任意一个,最终结果就会成立     |
| not    | 不是   | 取条件的反义                          |

1.使用逻辑运算符,可以将多个查询条件进行组合.
2.使用not运算符可以生成"不是~~"这样的查询条件.
3.逻辑运算符的结果包含 真(1),假(0).
例1:查询"商品种类为厨房用户" 并且 "销售单价大于等于3000元" 的商品信息
select *
from product
where product_type = '厨房用具' and sale_price >= 3000;
例2:查询"商品种类为厨房用户" 或者 "销售单价大于等于3000元" 的商品信息
select *
from product
where product_type = '厨房用具' or sale_price >= 3000;
例3: 查询商品售价不大于3000的 商品信息
select *
from product
where not sale_price <= 3000;
例4:查询 “商品种类为办公用品” 并且 “登记日期是 2009 年 9 月 11 日或者 2009 年 9 月 20日”
select *
from product
where product_type = '办公用品'
and regist_date = '2009-09-11'
or regist_date = '2009-09-20'
# and优先级高于or
"商品种类为办公用品，并且
登记日期是 2009 年 9 月 11 日"
或者
"登记日期是 2009 年 9 月 20 日"
# 正确写法
select * 
from product
where product_type = '办公用品' and (regist_date = '2009-09-11' or regist_date = '2009-09-20')
```

```sql
3.4常用谓语 ,也是高级条件查询表达
| 谓语           | 含义           | 例子                   |
| -------------- | ------------  | --------------------- |
| like           | 模糊查询       | like '张%';like '张_'  |
| between..and.. | 区间查询       | between 10 and 20     |
| in             | 是否存在       | 2 in (2,3,4)          |
| is null        | 是否是空值      | 2 is null            |
| is not null    | 是否不是空值   | null is not null       |
1.like 是模糊查询,可以查询字符串中是否包含某个字符串,或 查询指定长度的字符串
2.between...and... 区间查询,查询 大于 and 小于 的条件
3.in 针对于 集合的查询条件
# like 运算符
# _ 匹配任意一个字符
# % 匹配任意个 任意字符
例1:匹配名称中包含'T恤'的商品
select *
from product
where product_name like '%T恤%'
例2:查找价格在500和4000之间的商品
select *
from product
where sale_price between 500 and 1000;
例3:查找衣服和办公用品的商品
select *
from product
where product_type in ('衣服','办公用品')
例4:查询进货日期为空的
select * 
from product
where purchase_price is null
例5:查询进货日期不为空的
select * 
from product
where purchase_price is not null
```

## 聚合函数

```sql
常用的聚合函数
平均值 avg() 
合计值 sum()
计数   count()
最大值 max()
最小值 min()
例子：
# 计算数据一共有多少条
select count(*)
FROM product;
# 计算非空的数据行数
select count(*)
from product
where purchase_price is not null;
# 计算当前商品的平均销售价格
select avg(sale_price)
from product;
# 计算当前商品的销售价格合计值
select sum(sale_price)
from product;
# 计算销售单价最小值和进货单价的最大值
select min(sale_price),max(purchase_price)
from product;
```

## group by分组

```sql
# 分组统计
select 10,product_type,max(sale_price)
from product
group by product_type;
例1: 按照商品类别统计组内行数
select product_type,count(*)
from product
group by product_type;
```

## 为分组后数据指定条件having

```sql
# 挑选出 组内数据数 = 2
select product_type,count(*)
from product
group by product_type
having count(*)=2;
#销售单价的平均值大于 2500 日元 的组
select product_type,avg(sale_price)
from product
group by product_type
having avg(sale_price)>2500;
# where 和 having 的区别
# where 是 分组前的条件查询
# having 是 分组后的条件查询
```

## order by 排序

```sql
-- order by 排序
select product_id, product_name, sale_price, purchase_price
from product
order by purchase_price desc;
-- 默认为生序，可以设置为降序
-- ascend 上升 asc
-- descend 下降 desc
```

```sql
总结：截止到目前所学过的子句中
建议 书写顺序：select ---> from ---> where ---> group by ---> having ---> order by
后台 执行顺序：from ---> where ---> group by ---> having ---> select ---> order by
```

## 普通子查询

```sql
-- 普通子查询
-- 子查询可以写无数个,建议不要写太多嵌套
-- 必须写别名
select *
from (select product_type, count(*)
from product
group by product_type) as product_sum;
```

## 标量子查询

```sql
-- 标量子查询
-- 标量: 单一值
# 请查询当前商品的平均售价
select avg(sale_price)
from product
# 请查询出高于 当前商品的平均售价的商品类别和价格
select product_name,sale_price
from product
where sale_price > (select avg(sale_price)
from product);
select product_name,sale_price
from product
where sale_price > 2097;
# 标量子查询也可以放在select子句里面
select
product_id,
product_name,
sale_price,
(select avg( sale_price ) from product) as avg_price
from
product;
# 回顾常量查询
select 2097 as '均价', product_name
from product;
```

## 关联子查询

```sql
-- 关联子查询
# 请查询出每个类别内 高于 类别平均价格的商品
select product_type,product_name,sale_price
from product as p1
where sale_price > (select avg( sale_price)
from product as p2
where p1.product_type = p2.product_type);

# 问题分解:
# 计算单个类别的平均价格
select avg(sale_price)
from product
where product_type = '办公用品'
group by product_type;
```

## 合并查询

```sql
-- 合并查询 union
select * from product
union
select * from product2;
-- 全合并查询 union all
select * from product
union all
select * from product2;
-- 合并的字段数和字段类型要一一对应
```

## 内连接查询

```sql
-- inner join 等值连接,返回数据都能匹配上
select shop_id,shop_name,p.product_id,product_name,sale_price
from product as p inner join shopproduct as sp
on p.product_id=sp.product_id;
-- inner join 不等值连接 (hive不支持)
select shop_id,shop_name,p.product_id,product_name,sale_price
from product as p inner join shopproduct as sp
on p.product_id!=sp.product_id;
-- 笛卡尔积
select *
from shopproduct join product;
```

## 外连接查询

```sql
-- 左外连接 left join
-- 左表数据都在结果中,右表的数据只有匹配上,才在结果中,没有匹配上是null
select shop_id,shop_name,p.product_id,product_name,sale_price
from product as p left join ShopProduct as sp
on p.product_id=sp.product_id;
-- 右外连接 right join
-- 右表数据都在结果中,左表的数据只有匹配上,才在结果中,没有匹配上是null
select shop_id,shop_name,p.product_id,product_name,sale_price
from product as p right join ShopProduct as sp
on p.product_id=sp.product_id;
-- 满外连接 full join (Oracle,hive支持full join, mysql不支持full join的，但
可以通过左外连接+ union+右外连接实现)
-- 两边数据都在,匹配不上是null
select *
from product as p full join ShopProduct as sp
on p.product_id=sp.product_id;
```

# 第四章：函数、case表达式

## 字符串函数

```sql
utf-8：一个汉字＝3个字节
gbk：一个汉字＝2个字节
length(str) 返回str的字节长度
char_length(str) 返回str字符的字符个数 ***
concat(s1,s2,...) 将参数连接起来
concat_ws(x,s1,s2,..)将参数按照x连接起来
insert(s1,x,len,s2) 将s1的x位到x+len位置的字符替换成s2
lower(str) 转小写
upper(str) 转大写
left(s,n) 返回字符串s最左边的n个字符
right(s,n) 返回字符串s最右边的n个字符
lpad(s1,len,s2) 左填充 使用s2将s1填充到len长度
rpad(s1,len,s2) 右填充 使用s2将s1填充到len长度
ltrim(str)
rtrim(str)
trim(' ' from str) 删除str的两端空格
repeat(s,n) 把s重复n次
replace(s,s1,s2) 把s中的s1全部替换成s2
strcmp(s1,s2) 比较s1和s2的大小
substring(s,n,len) 切片 n:起始位置 len:切的长度
mid(s,n,len) 与substring一样,写的时候方便一点
locate(s,str) 找s在str中的起始位置
reverse(s) 将s倒序
```

## 算术函数

```sql
abs(x) 绝对值 *常用
pi() π值
sqrt(x) 平方根函数 *常用
mod(x,y) 取余 x/y 的余数 *常用
ceil(x) 取整 *常用
floor(x) 取整
rand(x) 随机数 x:随机数种子 可以不写
round(x,y) 四舍五入函数 对x进行舍入到y位 *常用
sign(x) 符号函数 正数:1 /0:0 /负数:-1
pow(x,y) 幂运算 x^y *常用
exp(x) 计算e^x
log(x) 计算x的自然对数lon(x)
log10(x) 计算x以10为底的对数
```

## 日期时间函数

```sql
current_date() 当前日期
current_time() 当前时间
current_timestamp() 当前时间日期
now() 当前时间日期
unix_timestamp() 当前时间戳
month(date) 获取date中的月份
weekday(date) 获取date中的星期*
week(date) 获取一年中第*周
dayofyear(date) 获取一年中第*天
day(date) 获取一个月中第*天
year(date) 获取日期中的年
quarter(date) 获取日期中的季度
minute(date) 获取日期中的分钟
second(date) 获取日期中的秒
extract(type from date) 截取时期中的数据
date(date) 获取时间日期的 日期
time(date) 获取时间日期的 时间
date_format(date,format) 日期格式化
-- 时间计算函数
-- 日期 + 1 年
date_add('2022-03-16',interval 1 year);
-- 日期 - 1天
date_sub('2022-03-16',interval 1 day);
-- 时间 + 1小时
addtime('12:00:01','1:00:00');
-- 时间 - 1小时
subtime('12:00:01','1:00:00');
-- 计算两个日期的差
datediff('2022-03-11',current_date())
-- 计算两个时间的差
timestampdiff(second, start_time, end_time);
```

## 其他函数

```sql
-- 转换函数
cast(当前值 as 类型)
coalesce(值1,值2,值3) 把null转为指定值
ifnull(值1,值2) 如果 值1 为空值 返回 值2,否则返回值1
if(表达式,值1,值2) 如果表达式成立,返回值1,否则返回值2
例子:
# 把字符串转为整型
select cast('0001' as signed integer) as int_col;
# 把字符串转为日期
select cast('2009/12/14' as date) as date_col;
# 把null转为指定值
select coalesce(null, 1) as col_1,
coalesce(null, 'test', null) as col_2,
coalesce(null, null, '2009-11-01') as col_3;
# 判断null值函数
select ifnull(null,1);
select ifnull(10,1);
# 条件判断函数
select if(1>2,'大于','小于')
```

## 普通case表达式

```sql
case when 条件表达式 then 值表达式
else
否则输出的值
end;
# 通过case表达式将a ～c的字符串加入到商品种类当中
select product_name,
case when product_type='衣服' then
concat('a:',product_type)
when product_type='办公用品' then
concat('b:',product_type)
when product_type='厨房用具' then
concat('c:',product_type)
else
null
end as abc_type
from product;
```

## 搜索case表达式

```sql
case 列
when 值 then
值表达式
else
否则输出的值
end;
# 通过case表达式将a ～c的字符串加入到商品种类当中
select product_name,
case product_type when '衣服' then
concat('a:',product_type)
when '办公用品' then
concat('b:',product_type)
when '厨房用具' then
concat('c:',product_type)
else
null
end as abc_type
from product;
```

## case行列转换

```sql
select
sum(case product_type when '衣服' then sale_price else 0 end) as '衣服总价',
sum(case product_type when '办公用品' then sale_price else 0 end) as '办公用品总价',
sum(case product_type when '厨房用具' then sale_price else 0 end) as '厨房用具总价'
from
product;
# 一个case when end;只能返回一列
```

# 第五章：视图

- 视图是由数据库中的一个表或多个表导出的虚拟表，是一种虚拟存在的表，方便用户对数据的操作。
- 视图是一个虚拟表，是从数据库中一个或多个表中导出来的表，其内容由查询定义。
- 同真实表一样，视图包含一系列带有名称的列和行数据
- 数据库中只存放了视图的定义，而并没有存放视图中的数据。这些数据存放在原来的表中。
- 使用视图查询数据时，数据库系统会从原来的表中取出对应的数据。
- 一旦表中的数据发生改变，显示在视图中的数据也会发生改变。

使用视图的原因

- 安全原因，视图可以隐藏一些数据，例如，员工信息表，可以用视图只显示姓名、工龄、地址，而不显示社会保险号和工资数等
- 另一个原因是可使复杂的查询易于理解和使用。

```sql
数据库中的视图是一个虚拟表,同真实的表一样.是存储的SQL查询语句逻辑
# 创建视图
create view my_view as
select * from product where sale_price>2000;
# 使用视图
select * from my_view;
# 删除视图
drop view my_view;
select * from (select * from product where sale_price>2000) as my_table;
# 创建真实表
create table my_view as
select * from product where sale_price>2000;
```

# 第六章:索引与优化

## 基本概念

- 索引(index)是帮助mysql高效获取数据的数据结构。我们可以简单理解为：它是快速查找排好序的一种数据结构。
- 可以用来快速查询数据库表中的特定记录，所有的数据类型都可以被索引。
- mysql索引主要有两种结构：b+tree索引和hash索引
## 优缺点

### 优点

- 可以大大提高mysql的检索速度
- 索引大大减小了服务器需要扫描的数据量
- 索引可以帮助服务器避免排序和临时表
- 索引可以将随机io变成顺序io
### 缺点

- 虽然索引大大提高了查询速度，同时却会降低更新表的速度，如对表进行insert、update和delete。因为更新表时，mysql不仅要保存数据，还要保存索引文件。
- 建立索引会占用磁盘空间的索引文件。一般情况这个问题不太严重，但如果你在一个大表上创建了多种组合索引，索引文件的会膨胀很快。
- 如果某个数据列包含许多重复的内容，为它建立索引就没有太大的实际效果。
- 对于非常小的表，大部分情况下简单的全表扫描更高效；

## 分类

### 普通索引

- 不应用任何限制条件的索引，该索引可以在任何数据类型中创建。
- 字段本身的约束条件可以判断其值是否为空或唯一。
- 创建该类型索引后，用户在查询时，便可以通过索引进行查询。
### 唯一性索引

- 使用unique参数可以设置唯一索引。
- 创建该索引时，索引的值必须唯一，通过唯一索引，用户可以快速定位某条记录
- 主键是一种特殊唯一索引。
### 全文索引

- 使用fulltext参数可以设置索引为全文索引。
- 全文索引只能创建在char、varchar或者text类型的字段上。查询数据量较大的字符串类型的字段时，使用全文索引可以提高查询速度。
- 在默认情况下，应用全文搜索大小写不敏感。如果索引的列使用二进制排序后，可以执行大小写敏感的全文索引。
### 单列索引

- 顾名思义，单列索引即只对应一个字段的索引。
- 应用该索引的条件只需要保证该索引值对应一个字段即可。
- 可以包括普通、唯一、全文索引
### 多列索引

- 多列索引是在表的多个字段上创建一个索引。
- 该索引指向创建时对应的多个字段，用户可以通过这几个字段进行查询。
- 要想应用该索引，用户必须使用这些字段中的第一个字段。



