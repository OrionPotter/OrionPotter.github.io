---
title: Sql Tutourial
date: 2022-06-18
description: 重新学习如何使用SQL
tag:
- SQL
---

# Sql介绍

## 关系型数据库是什么

>关系型数据库是以结构化的方式组织和存储数据的数据库

+ 表（Table）：数据存储的地方，可以想象为一个网格，由行和列组成。每个表代表数据库中的一个实体或概念。

- 行（Row）：表中的一行代表了一个记录（Record），即一组相关的数据项。每行都是一个数据实体的实例。
- 列（Column）：表中的一列存放的是同一种数据，例如名字或者价格等。列有一个定义好的数据类型，如整数、字符串、日期等。
- 主键（Primary Key）：表中的一个列或列的组合，它唯一标识表中的每一行，不会有重复的主键值。
- 外键（Foreign Key）：一个表中的字段，它是另一个表的主键，用于创建表与表之间的关联。
- 关系（Relationship）：表间的连结，通过外键实现，可以是一对一、一对多或多对多。
- 约束（Constraints）：用于确保数据库中数据的准确性和可靠性的规则。如主键约束、外键约束、唯一性约束等。
- SQL（Structured Query Language）：用于执行各种操作的标准语言，如数据查询、更新记录、管理和定义数据结构等。

>常见的关系型数据库管理系统（RDBMS）包括：Oracle、Microsoft SQL Server、MySQL、PostgreSQL和SQLite。

## RDBMS的优点和缺点

### 优点

- **关系模型**：数据以表格形式存储，数据模型直观、清晰，易于理解和维护。
- **支持事务**：确保并发操作和故障恢复的一致性。
- **SQL**：支持SQL语句，简单易学。
- **备份和恢复**：提供强大的备份和恢复机制，确保数据在故障或灾难情况下的安全。

### 缺点

- **性能瓶颈**：复杂的多表查询和嵌套查询在大规模数据下性能差。
- **扩展性有限**：垂直扩展成本高，水平扩展下分布式和高并发存在挑战。

## SQL和NoSql数据库的区别

### Sql数据库

> SQL（结构化查询语言）数据库也称为关系数据库。它们具有预定义的架构，数据存储在由行和列组成的表中。 SQL数据库遵循ACID（原子性、一致性、隔离性、持久性）属性来确保事务的可靠。一些流行的 SQL 数据库包括 MySQL、PostgreSQL 和 Microsoft SQL Server。

### NoSQL 数据库

> NoSQL（不仅是 SQL）数据库是指非关系数据库，它不遵循固定的数据存储模式。相反，它们使用灵活的半结构化格式，例如 JSON 文档、键值对或图表。 MongoDB、Cassandra、Redis是一些流行的 NoSQL 数据库。

### 数据模型

- **SQL数据库**：数据以表格形式存储，表与表之间通过外键建立关系。
- **NoSQL数据库**：支持多种数据模型存储，包括文档模型、键值模型、列族模型和图模型。

### 查询语言

- **SQL数据库**：使用标准的SQL查询语言。
- **NoSQL数据库**：类型的NoSQL数据库使用不同的查询语言和API

### 扩展性

- **SQL数据库**：垂直扩展成本高，水平
- **NoSQL数据库**：扩展性好，通过水平扩展通过增加节点处理大规模数据和高并发。

### 事务和一致性

- **SQL数据库**：支持ACID（原子性、一致性、隔离性、持久性）事务，确保数据的一致性和完整性。
- **NoSQL数据库**：许多NoSQL数据库采用最终一致性模型，确保在一定时间内数据最终达到一致状态。

### 适用场景

- **SQL数据库**：
  - **事务处理**：适用于需要强一致性和事务支持的应用，如银行、金融、电商等。
  - **复杂查询**：适用于需要执行复杂查询和报表生成的应用，如数据分析、商业智能等。
- **NoSQL数据库**：
  - **大规模数据处理**：适用于需要处理大规模数据和高并发访问的应用，如社交媒体、物联网、大数据分析等。
  - **高可用性和分布式系统**：适用于需要高可用性和分布式存储的应用，如分布式缓存、消息队列等。

# SQL基础

## 关键字

>SQL不区分大小写，关键字可以小写，为了方便阅读，约定他们都大写

| 关键字              | 作用                               |
| ------------------- | ---------------------------------- |
| **SELECT**          | 从数据库中检索数据                 |
| **FROM**            | 与select结合使用，指定哪个表       |
| **WHERE**           | 用于过滤记录                       |
| **INSERT INTO**     | 往数据库中插入数据                 |
| **UPDATE**          | 更新数据库中的数据                 |
| **DELETE**          | 删除数据库中的数据                 |
| **CREATE DATABASE** | 创建数据库                         |
| **ALTER DATABASE**  | 用于在已有的库的全局特性的修改     |
| **DROP DATABASE**   | 删除数据库                         |
| **CREATE TABLE**    | 创建数据表                         |
| **ALTER TABLE**     | 用于在已有的表中添加、删除或修改列 |
| **DROP TABLE**      | 删除数据表                         |

## 数据类型

>SQL数据类型定义可以存储在数据库表列中的数据类型。根据 DBMS 的不同，数据类型的名称可能略有不同。

INT用于整数。例如：

```sql
CREATE TABLE Employees (
    ID INT,
    Name VARCHAR(30)
);
```

DECIMAL用于小数和小数。例如：

```sql
CREATE TABLE Items (
    ID INT,
    Price DECIMAL(5,2)
);
```

CHAR用于固定长度的字符串。例如：

```sql
CREATE TABLE Employees (
    ID INT,
    Initial CHAR(1)
);
```

VARCHAR用于可变长度字符串。例如：

```sql
CREATE TABLE Employees (
    ID INT,
    Name VARCHAR(30)
);
```

DATE用于格式为 ( `YYYY-MM-DD`) 的日期。

```sql
CREATE TABLE Employees (
    ID INT,
    BirthDate DATE
);
```

DATETIME用于格式为 ( `YYYY-MM-DD HH:MM:SS`) 的日期和时间值。

```sql
CREATE TABLE Orders (
    ID INT,
    OrderDate DATETIME
);
```

`BINARY`用于二进制字符串

`BOOLEAN`用于布尔值（`TRUE`或`FALSE`）

## 操作符

>运算符主要分为几类：算术运算符、比较运算符、逻辑运算符、位运算符

### 算术运算符

+ Addition
+ Subtraction
+ Multiplication
+ Division
+ Modulus

### 比较(关系)运算符

+ Equal
+ Not equal
+ Greater than
+ Less than
+ Greater than or equal
+ Less than or equal

### 逻辑运算符

+ AND
+ OR
+ NOT

### 位运算符

+ &
+ |
+ ^

# 数据定义语言

> Data Definition Language(DDL)，数据定义语言 (DDL) 主要功能是创建、修改和删除数据库表结构

1. `CREATE`：该命令用于创建数据库或其对象（如表、索引、函数、视图、存储过程和触发器）。

   ```sql
   //1.创建数据库
   CREATE DATABASE myDatabase;
   //2.创建表
   CREATE TABLE Students (
       ID INT,
       Name varchar
   );
   //3.创建索引
   CREATE INDEX idx_Students_Name ON Students(Name);
   //4.创建视图
   CREATE VIEW HighGradeStudents AS
   SELECT * FROM Students
   WHERE Grade > 90;
   ```

2. `DROP`：该命令用于删除现有的数据库或表。

   ```sql
   //1.删除数据库
   DROP DATABASE myDatabase;
   //2.删除数据库表
   DROP TABLE Students;
   //3.删除所用
   DROP INDEX idx_Students_Name ON Students;
   //4.删除视图
   DROP VIEW HighGradeStudents;
   ```

3. `ALTER`：这用于更改数据库的结构。它用于添加、删除/删除或修改现有表中的列。

   ```sql
   //1.添加列
   ALTER TABLE tableName ADD columnName datatype;
   ALTER TABLE tableName ADD (columnName1 datatype,columnName2 datatype,...);
   //2.删除列
   ALTER TABLE tableName DROP COLUMN columnName;
   ALTER TABLE tableName DROP (columnName1,columnName2,...);
   //3.修改列
   ALTER TABLE tableName ALTER COLUMN columnName TYPE newDataType;
   //4.添加约束
   ALTER TABLE tableName ADD CONSTRAINT constraintName PRIMARY KEY (column1, column2, ... column_n);
   //5.删除约束
   ALTER TABLE tableName DROP CONSTRAINT constraintName;
   ```

4. `TRUNCATE`：这用于从表中删除所有记录，包括为删除的记录分配的所有空间。

   >TRUNCATE是SQL中的一个关键词，用于删除表中的所有记录，但不删除表本身。这意味着表的结构、属性、索引等将保持不变，只是表中的数据被清空。
   >
   >相较于DELETE操作，TRUNCATE通常会更快，尤其是在大型表中，这是因为它在删除数据时不会记录个别行的删除操作。

   ```sql
   TRUNCATE TABLE table_name;
   ```

5. `RENAME`：这用于重命名数据库中的对象。

   ```sql
   RENAME TABLE old_table_name TO new_table_name;
   ```

> 在DDL操作中，不能执行`COMMIT`and`ROLLBACK`语句，因为MySQL引擎会自动提交更改。

# 数据操作语言

> Data Manipulation Language (DML),数据操作语言 (DML)主要从数据库中插入、检索、更新和删除数据。包含了四个命令insert into、select、update、delete from

1. **INSERT INTO** - 此命令用于将新行（记录）插入表中。

   ```sql
   -- 1. 插入完整的列级
   INSERT INTO table_name  VALUES (value1, value2, ..., valueN);
   -- 2. 选择性插入
   INSERT INTO table_name ( column1, column2, column3, ... )  VALUES ( value1, value2, value3, ... )  
   -- 3. 从另一个表插入
   INSERT INTO table1 (column1, column2, ... , columnN) SELECT column1, column2, ... , columnN  FROM table2 WHERE condition;
   ```

2. **SELECT** - 该命令用于从数据库中选择数据。返回的数据存储在结果表中，称为结果集。

   ```sql
   SELECT column1, column2, ... FROM table_name
   ```
   
3. **UPDATE** - 此命令用于修改表中的现有行。

   ```sql
   UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
   ```

4. **DELETE FROM** - 此命令用于从表中删除现有行（记录）。

   ```sql
   -- 1. 删除表中所有行
   DELETE FROM students;
   -- 2. 删除指定行
   DELETE FROM table_name WHERE condition;
   ```

# 聚合查询

## 聚合函数

>SQL 聚合函数是内置函数，用于对数据执行某些计算并返回单个值。

+ COUNT()

+ SUM()

+ AVG()

+ MAX()

+ MIN()


>聚合函数忽略NULL值，使用 COUNT(*) 时，会计算包括 NULL 在内的行的总数；但如果你指定某列如 COUNT(column_name)，则只会计算非 NULL 值的数量。

## GROUP BY和HAVING子句

>在SQL中，`GROUP BY` 和 `HAVING` 子句通常与聚合函数一起使用，它们用于对数据分组，并对这些分组进行过滤。
>
>GROUP BY 子句用于将结果集中的记录分组，每个分组包含有相同值的列。之后你可以使用聚合函数（如 COUNT, SUM, AVG, MAX, MIN），对每个分组进行聚合计算。通过 GROUP BY 子句，可以执行多样化的数据汇总分析
>
>HAVING 子句类似于 WHERE 子句，不过 HAVING 主要用于过滤分组后的结果。WHERE 子句在数据分组之前进行过滤，而 HAVING 子句在数据分组之后对聚合后的结果进行过滤。

```sql
SELECT CustomerID, COUNT(OrderID) AS NumberOfOrders, SUM(Amount) AS TotalAmount
FROM Orders
WHERE OrderDate BETWEEN '2018-01-01' AND '2018-12-31'
AND Status = 'Completed'
GROUP BY CustomerID
HAVING SUM(Amount) > 1000;
```

# 数据约束

## NOT NULL 约束

>确保列不能有 NULL 值。

```sql
CREATE TABLE Students (
    ID int NOT NULL,
    Name varchar(255) NOT NULL,
    Age int
);
```

## UNIQUE 约束

>确保列中的所有值都不同。

```sql
CREATE TABLE Students (
    ID int NOT NULL UNIQUE,
    Name varchar(255) NOT NULL,
    Age int
);
```

## PRIMARY KEY 约束

>唯一标识数据库表中的每条记录。主键必须包含唯一值。与 UNIQUE 约束完全相同，但一张表中可以有多个唯一约束，但每个表只能有一个 PRIMARY KEY 约束。

```sql
CREATE TABLE Students (
    ID int NOT NULL,
    Name varchar(255) NOT NULL,
    Age int,
    PRIMARY KEY (ID)
);
```

## 外键约束

>防止破坏表之间链接的操作。外键是一个表中的字段（或字段集合），它引用另一表中的主键。

```sql
CREATE TABLE Orders (
    OrderID int NOT NULL,
    OrderNumber int NOT NULL,
    ID int,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (ID) REFERENCES Students(ID)
);
```

## CHECK 约束

>CHECK 约束确保列中的所有值都满足特定条件。

```sql
CREATE TABLE Students (
    ID int NOT NULL,
    Name varchar(255) NOT NULL,
    Age int,
    CHECK (Age>=18)
);
```

## DEFAULT 约束

>在未指定任何列时为列提供默认值。

```sql
CREATE TABLE Students (
    ID int NOT NULL,
    Name varchar(255) NOT NULL,
    Age int,
    City varchar(255) DEFAULT 'Unknown'
);
```

## INDEX 约束

>用于快速创建数据库并从数据库检索数据。

```sql
CREATE INDEX idx_name ON Students (Name);
```

# 连接查询

## 内连接

```sql
SELECT column_name(s) FROM table1 INNER JOIN table2 ON table1.column_name = table2.column_name;
```

## 左连接

>该`LEFT JOIN`关键字返回左表（table1）中的所有记录以及右表（table2）中的匹配记录。如果没有匹配，结果`NULL`从右侧开始。

```sql
SELECT column_name(s) FROM table1 LEFT JOIN table2 ON table1.column_name = table2.column_name;
```

## 右连接

>该`RIGHT JOIN`关键字返回右表 (table2) 中的所有记录以及左表 (table1) 中的匹配记录。如果没有匹配，则结果`NULL`在左侧。

```sql
SELECT column_name(s) FROM table1 RIGHT JOIN table2 ON table1.column_name = table2.column_name;
```

## 全外连接

```sql
SQL 中的FULL OUTER JOIN是一种根据两个或多个表之间的相关列组合来自两个或多个表的行的方法。它返回左表 ( table1) 和右表 ( table2) 中的所有行。
```

```sql
select   a.*,b.*   from   a full join b on a.id=b.id
```

## 自连接

>`SELF JOIN`是一个标准 SQL 操作，其中表与其自身连接。

```sql
SELECT a.column_name, b.column_name FROM table_name AS a, table_name AS b WHERE a.common_field = b.common_field;
```

## 交叉连接

>SQL 中的交叉连接用于将第一个表的每一行与第二个表的每一行组合起来。它也称为两个表的笛卡尔积。执行交叉连接最重要的一点是它不需要任何连接条件。
>
>交叉联接的问题是它返回两个表的笛卡尔积，这可能会导致大量行和大量资源使用。因此，明智地使用它们并且仅在必要时使用它们至关重要。

```sql
SELECT column_name(s) FROM table1 CROSS JOIN table2;
-- 等价于
SELECT column_name(s) FROM table1, table2;
```

# 子查询

>在 SQL 中，子查询是嵌入另一个 SQL 查询中的查询。您也可以将其称为嵌套查询或内部查询。包含查询通常称为外部查询。子查询用于检索将在主查询中使用的数据，作为进一步限制要检索的数据的条件。
>
>子查询可用于查询的各个部分，包括：
>
>- **选择**语句
>- **FROM**子句
>- **WHERE**子句
>- **GROUP BY**子句
>- **HAVING**子句

## 标量子查询（单行子查询）

标量子查询返回单个值的子查询，即返回结果是单行单列的。它通常用在比较操作符的右侧，例如 =, <, >, <=, >=, <>。

```sql
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department = 'Sales'
);
```

## 列子查询（多行单列子查询）

列子查询返回单列的多个值，且适用于 IN, NOT IN, ANY, ALL, EXISTS 等操作符。

```sql
SELECT *
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM order_details
    WHERE quantity > 10
);
```

## 行子查询（多行多列子查询）

行子查询返回一行或多行，并涉及多列数据，在与外部查询进行比较时使用。

```sql
SELECT *
FROM orders
WHERE (customer_id, order_date) IN (
    SELECT customer_id, MAX(order_date)
    FROM orders
    GROUP BY customer_id
);
```

## 相关子查询（相关子查询）

相关子查询是指子查询引用了外部查询中的一个或多个列。子查询对于每一行或几行外部查询的结果，都需要重新运行一次。

```sql
SELECT e1.employee_name
FROM employees e1
WHERE e1.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department = e1.department
);
```

## 表子查询（派生表或内联视图）

当子查询返回一个完整的表时，它可以作为一个派生表或内联视图使用在 FROM 子句中。

```sql
SELECT AVG(salary)
FROM (
    SELECT department, SUM(salary) as salary
    FROM employees
    GROUP BY department
) AS department_total_salaries;
```

## EXISTS子查询

EXISTS 子查询用于检查是否存在由子查询返回的行。EXISTS 子查询总是返回TRUE或FALSE。

```sql
SELECT *
FROM suppliers
WHERE EXISTS (
    SELECT *
    FROM products
    WHERE products.supplier_id = suppliers.supplier_id
    AND price < 20
);
```

# 高级 SQL 函数

## 数学函数

**ABS() 函数：**该函数返回数字的绝对（正）值。

```sql
SELECT ABS(-243);
-- output: 243
```

**Avg() 函数：**该函数返回列的平均值。

```sql
SELECT AVG(price) FROM products;
```

**COUNT() 函数：**该函数返回符合指定条件的行数。

```sql
SELECT COUNT(productID) FROM products;
```

**SUM() 函数：**该函数返回数字列的总和。

```sql
SELECT SUM(price) FROM products;
```

**MIN() & MAX() 函数：** MIN() 函数返回所选列的最小值，MAX() 函数返回所选列的最大值。

```sql
SELECT MIN(price) FROM products;
SELECT MAX(price) FROM products;
```

**ROUND() 函数：**此函数用于将数字字段舍入为最接近的整数，但是您可以指定要返回的小数位数。

```sql
SELECT ROUND(price, 2) FROM products;
```

**CEILING() 功能：**该函数返回大于或等于指定数值表达式的最小整数。

```
SELECT CEILING(price) FROM products;
```

**FLOOR() 函数：**该函数返回小于或等于指定数值表达式的最大整数。

```sql
SELECT FLOOR(price) FROM products;
```

**SQRT() 函数：**该函数返回数字的平方根。

```sql
SELECT SQRT(price) FROM products;
```

**PI() 函数：**该函数返回常量Pi。

```sql
SELECT PI();
```

## 字符串函数

`CONCAT` 函数将两个或多个字符串组合成一个字符串。

```sql
CONCAT(string1, string2, ...., string_n) 例如：
SELECT CONCAT('Hello ', 'World');
//上述 SQL 语句的输出将是“Hello World”。
```

`SUBSTRING` 函数从给定字符串中提取字符串。

```sql
SUBSTRING(string, start, length) 例如：
SELECT SUBSTRING('SQL Tutorial', 1, 3);
//上述查询的输出将是“SQL”
```

`LENGTH` 函数返回字符串的长度。

```
LENGTH(string) 例如：
SELECT LENGTH('Hello World');
//上述 SQL 语句的输出将为 11。
```

`UPPER` 函数将字符串中的所有字母转换为大写，而 `LOWER` 函数则将字符串中的所有字母转换为小写。

```sql
UPPER(string)
LOWER(string) 例如：
SELECT UPPER('Hello World');
SELECT LOWER('Hello World');
//上述 SQL 语句的输出将分别是“HELLO WORLD”和“hello world”。
```

`TRIM` 函数删除字符串的前导和尾随空格,还可以删除其他指定的字符

```sql
TRIM([LEADING|TRAILING|BOTH] [removal_string] FROM original_string) 例如：
SELECT TRIM('   Hello World   ');
SELECT TRIM('h' FROM 'hello');
-- output: 第一个查询的输出将是“Hello World”，第二个查询的输出将是“ello”。
```

`replace`函数替换指定的字符

```sql
REPLACE(input_string, string_to_replace, replacement_string) 例如：
SELECT REPLACE('Potter','o','e')
-- output: petter
```

## 条件函数

**CASE表达式**

>相当于其他编程语言的IF-THEN-ELSE 逻辑

```sql
-- 语法：
SELECT column1, column2, 
(CASE 
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ...
    ELSE result 
END) 
FROM table_name;
-- 例子：
SELECT OrderID, Quantity,
 (CASE
     WHEN Quantity > 30 THEN 'Over 30'
     WHEN Quantity = 30 THEN 'Equals 30'
     ELSE 'Under 30'
 END) AS QuantityText
FROM OrderDetails;
-- output: 查询逻辑为：查询OrderID、Quantity、QuantityText三个字段，其中QuantityText字段的值根据Quantity值判断，如果大于30则为Over 30，等于30则为Equals 30，否则为Under 30
```

**COALESCE表达式**

>SQL中的函数`COALESCE`用于管理数据中的NULL值。它从左到右扫描参数并返回第一个不是NULL的参数。

```sql
COALESCE(value1,value2,..., valueN)
-- 示例1：
SELECT product_name, COALESCE(price, 0) AS Price  FROM products;
-- output: 如果产品条目的“价格”列为NULL，则它将返回“0”
-- 示例2	：
SELECT COALESCE(NULL, NULL, 'third value', 'fourth value');
-- output: 它将返回“第三个值”，因为这是列表中的第一个非 NULL 值。
```

**NULLIF表达式**

>`NULLIF`相比`expression1`于`expression2`.如果`expression1`和`expression2`相等，则函数返回 NULL。否则，它返回`expression1`。两个表达式必须具有相同的数据类型。

```sql
NULLIF(expression1, expression2);
示例1：
SELECT 
    first_name, 
    last_name,
    NULLIF(email, 'NA') AS email
FROM 
    users;
-- output:  如果字段 email 为“NA”，则将返回 NULL。否则email返回实际的字段值。
```

**IF表达式**

>`IF`如果条件为 TRUE，则函数返回 value_true；如果条件为 FALSE，则返回 value_false。

```sql
IF(condition,value_true,value_false)
SELECT IF (1>0, 'One is greater than zero', 'One is not greater than zero');
```

## 时间函数

### DATE

创建Date类型的表

```sql
CREATE TABLE Orders (
    OrderId int,
    ProductName varchar(255),
    OrderDate date
);
```

插入日期数据

```sql
INSERT INTO Orders (OrderId, ProductName, OrderDate) VALUES (1, 'Product 1', '2022-01-01');
```

查询指定日期

```sql
SELECT * FROM Orders  WHERE OrderDate = '2022-01-01';
```

更新日期

```sql
UPDATE Orders  SET OrderDate = '2022-01-02'  WHERE OrderId = 1;
```

返回当前日期

```sql
SELECT CURRENT_DATE;
```

日期差异

```sql
SELECT DATEDIFF(day, '2022-01-01', '2022-01-15') AS DiffInDays;
-- output: 14
```

日期添加

```sql
SELECT DATEADD(year, 1, '2022-01-01') AS NewDate;
-- output:  Sun Jan 01 2023 08:00:00 GMT+0800 (台北标准时间)
```

### TIME

>在 SQL 中，TIME 数据类型用于在数据库中存储时间值。它允许您存储小时、分钟和秒。 TIME 的格式为“HH:MI:SS”。

创建Time字段语法

```sql
CREATE TABLE table_name (
    column_name TIME
);
```

插入时间字段

```sql
INSERT INTO table_name (column_name) values ('17:34:20');
```

范围

>SQL 中的时间范围是'00:00:00'到'23:59:59'。

获取当前时间

```sql
SELECT CURTIME();
```

添加时间

```sql
SELECT ADDTIME('2007-12-31 23:59:59','1 1:1:1');
```

时间差

```sql
-- 减去时间差
SELECT TIMEDIFF('2000:01:01 00:00:00', '2000:01:01 00:01:01');
```

转换

```sql
-- 函数在MySQL中用于将时间值转换为秒
SELECT TIME_TO_SEC('22:23:00');
-- output: 80580
```

### DATEPART

>`DATEPART`是 SQL 中的一个有用函数，可以使用它从任何日期或时间表达式获取年、季度、月、年中的某一天、日、周、工作日、小时、分钟、秒或毫秒。

```sql
-- 在日期中提取年、月、日
SELECT DATEPART(year, '2021-07-14') AS 'Year';
SELECT DATEPART(month, '2021-07-14') AS 'Month';
SELECT DATEPART(day, '2021-07-14') AS 'Day';
-- 日期时间中提取小时、分钟或秒
SELECT DATEPART(hour, '2021-07-14T13:30:15') AS 'Hour',
SELECT DATEPART(minute, '2021-07-14T13:30:15') AS 'Minute',
SELECT DATEPART(second, '2021-07-14T13:30:15') AS 'Second';
```

### DATEADD

>语法：
>`DATEADD(interval, number, date)`
>
>- 间隔类型（例如日、月、年、小时、分钟、秒）
>- 一个数字（对于未来日期可以是正数，对于过去日期可以是负数）
>- 计算所依据的日期。

```sql
SELECT DATEADD(day, 3, '2022-01-01') as NewDate
-- output: 2022-01-04
-- 查找未来7天的数据
SELECT * FROM Orders WHERE OrderDate <= DATEADD(day, 7, GETDATE())
```

### TIMESTAMP

>SQL`TIMESTAMP`是一种允许您存储日期和时间的数据类型。它通常用于跟踪对记录所做的更新和更改，提供发生的时间顺序。
>
>根据 SQL 平台的不同，格式和存储大小可能略有不同。例如，`MySQL` 使用`YYYY-MM-DD HH:MI:SS`格式，而在 `PostgreSQL` 中，它存储为`YYYY-MM-DD HH:MI:SS`格式，但它还可以存储微秒

`TIMESTAMP`以下是如何在 SQL 表中定义具有类型的列：

```sql
CREATE TABLE table_name (
   column1 TIMESTAMP,
   column2 VARCHAR(100),
   ...
);
```

一个常见的用例`TIMESTAMP`是每次更新行时自动更新时间戳。这可以通过将`DEFAULT`约束设置为来实现`CURRENT_TIMESTAMP`：

```sql
CREATE TABLE table_name (
   column1 TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   column2 VARCHAR(100),
   ...
);
```

在 MySQL 中，每当行的其他字段发生任何更改时，`ON UPDATE CURRENT_TIMESTAMP`可用于自动将字段更新为当前日期和时间。`TIMESTAMP`

```sql
CREATE TABLE table_name (
   column1 TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   column2 VARCHAR(100),
   ...
);
```

您还可以插入或更新具有特定时间戳的记录：

```sql
INSERT INTO table_name (column1, column2) VALUES ('2019-06-10 10:20:30', 'example data');

UPDATE table_name SET column1 = '2020-07-20 15:30:45' WHERE column2 = 'example data';
```

# 视图

>视图是一个虚拟的表，不直接存储数据，存的是SQL的查询，因此视图根据原表的数据变化而变化

创建视图

```sql
CREATE VIEW CustomerView AS SELECT CustomerID, Name, Address FROM Customers;
```

查询视图

```sql
SELECT * FROM CustomerView;
```

更新视图

```sql
CREATE OR REPLACE VIEW CustomerView AS SELECT CustomerID, Name, Address, Phone FROM Customers;
```

删除视图

```sql
DROP VIEW IF EXISTS CustomerView;
```

# 触发器

>SQL中的触发器（Trigger）是一种特殊的存储过程，它会在特定的数据库事件（如INSERT、UPDATE、DELETE）发生时自动执行。

## 触发器的类型

1. **按触发事件分类**：
   - **INSERT触发器**：在插入数据时触发。
   - **UPDATE触发器**：在更新数据时触发。
   - **DELETE触发器**：在删除数据时触发。
2. **按触发时间分类**：
   - **BEFORE触发器**：在执行DML语句（INSERT、UPDATE、DELETE）之前触发。
   - **AFTER触发器**：在执行DML语句之后触发。

## 触发器使用场景

### 数据完整性和一致性

触发器可以确保数据在插入、更新或删除时满足特定的业务规则。例如，可以使用触发器来检查某个字段的值是否在允许的范围内，或者确保两个表之间的引用完整性。

### 自动化任务

触发器可以用于自动执行一些任务，如记录日志、发送通知、更新相关表等。例如，当某个表中的数据发生变化时，可以使用触发器自动记录这些变化到日志表中。

### 审计和日志

触发器可以用来记录对数据的所有更改，以便进行审计和追踪。例如，可以创建一个触发器，在每次更新或删除记录时，将旧数据保存到审计表中。

### 复杂的业务逻辑

触发器可以用来实现一些复杂的业务逻辑，这些逻辑可能很难通过简单的SQL语句来实现。例如，可以使用触发器来计算和更新库存量、自动生成订单编号等。

## 示例

**基本语法**

```sql
CREATE TRIGGER trigger_name
BEFORE|AFTER 事件 on table_name
FOR EACH ROW
BEGIN
	//todo 具体要做的事
END;	
```

**创建一个在插入数据之前触发的触发器**：

```sql
CREATE TRIGGER before_insert_trigger
BEFORE INSERT ON my_table
FOR EACH ROW
BEGIN
    -- 在插入数据之前执行的操作
    IF NEW.column1 IS NULL THEN
        SET NEW.column1 = 'default_value';
    END IF;
END;
```

**创建一个在更新数据之后触发的触发器**：

```sql
CREATE TRIGGER after_update_trigger
AFTER UPDATE ON my_table
FOR EACH ROW
BEGIN
    -- 在更新数据之后执行的操作
    INSERT INTO audit_log (table_name, operation, old_value, new_value, change_time)
    VALUES ('my_table', 'UPDATE', OLD.column1, NEW.column1, NOW());
END;
```

**创建一个在删除数据之后触发的触发器**：

```sql
CREATE TRIGGER after_delete_trigger
AFTER DELETE ON my_table
FOR EACH ROW
BEGIN
    -- 在删除数据之后执行的操作
    INSERT INTO audit_log (table_name, operation, old_value, change_time)
    VALUES ('my_table', 'DELETE', OLD.column1, NOW());
END;
```

# 索引

## 基本概念

### 什么是索引

>索引是数据库中辅助快速查找数据的辅助数据结构，类似于书籍的目录，快速定位所需信息

### 索引的作用

1. 提高查询速度
2. 提高连接操作的效率（连接键有索引）
3. 加速排序和分组操作（利用索引的有序性）
4. 唯一索引可以避免重复数据

### 索引的数据结构和工作原理

#### B-Tree索引

B-树是一种自平衡的树数据结构，其节点按照一定的顺序排列，保证从根节点到叶节点的路径长度相同，数据都存储在叶节点中，内部节点只存储键值和指针，MySQL的InnoDB使用B+树作为默认索引结构。

**工作原理**

1. **查找**：从根节点开始，根据键值逐层向下查找，直到找到叶节点。
2. **插入**：找到适当的叶节点插入新键值，如果节点满了，则进行分裂，可能导致树的高度增加。
3. **删除**：找到要删除的键值，从叶节点删除，如果节点变得太空，则进行合并或重分配，可能导致树的高度减少。
4. **范围查询**：从根节点开始，根据键值逐层向下查找，找到起始叶节点，然后顺序读取叶节点。

#### Hash索引

哈希索引基于哈希表实现，使用哈希函数将键值映射到哈希桶（Bucket）,主要用于等值查询。

**工作原理**

1. **查找**：使用哈希函数计算键值的哈希码，定位到对应的哈希桶，然后在桶中查找具体的键值。
2. **插入**：使用哈希函数计算键值的哈希码，定位到对应的哈希桶，然后插入键值和指针。
3. **删除**：使用哈希函数计算键值的哈希码，定位到对应的哈希桶，然后删除键值和指针。
4. **等值查询**：哈希索引非常适合等值查询，但不适合范围查询。

#### BitMap索引

位图索引使用位图（Bitmap）来表示数据的存在性，适用于低基数列（如性别、状态等）多条件查询。

**工作原理**

1. **查找**：根据键值找到对应的位图，然后扫描位图获取匹配的行记录。
2. **插入**：更新对应的位图。
3. **删除**：更新对应的位图。
4. **多条件查询**：通过位图的按位操作（如AND、OR）高效地进行多条件查询。

#### 全文索引

全文索引用于对文本数据进行全文搜索，通常基于倒排索引（Inverted Index）实现，适用于文本数据全文搜索查询。

**工作原理**

1. **查找**：根据查询词找到对应的词条列表，然后合并词条列表获取匹配的文档。
2. **插入**：将文档中的每个词添加到倒排索引中。
3. **删除**：从倒排索引中删除文档中的每个词。
4. **查询**：通过倒排索引高效地进行全文搜索。

### 索引的分类

1. 根据存储结构分类:
   - B-Tree索引：这是最常见的索引类型，支持随机访问、顺序访问、范围访问和部分键匹配查询。
   - Hash索引：基于哈希表实现，适合等值查询，但不支持范围查询。
   - R-Tree索引：适用于空间数据，如地图坐标。
   - Bitmap索引：适用于有限离散取值的列，如性别、国家等。

2. 根据物理实现分类:
   - 聚簇索引（Clustered Index）：数据行的物理顺序与键值的逻辑（索引）顺序相同。一个表只能有一个聚簇索引。
   - 非聚簇索引（Non-Clustered Index）：索引顺序与数据行的物理存储顺序不同。

3. 按照列的数目分类:
   - 单列索引：索引只包含一个列。
   - 复合索引/组合索引：也称多列索引，索引包含两个以上的列。

4. 按照唯一性分类:
   - 唯一索引（Unique Index）：确保索引键列的每行数据都是唯一的。
   - 非唯一索引：允许索引键列中有重复的值。

5. 根据是否为表的一部分分类:
   - 主键索引：通常是表的主键的唯一索引。
   - 辅助索引/二级索引：表中除了主键索引之外的索引。
   
6. 功能性分类:
   - 全文索引（Full-text Indexes）：为了在文本数据列中支持复杂的查询，如匹配某些搜索词或短语等。
   - 部分索引（Partial Indexes）：也称为过滤索引，只为表中符合特定条件的部分数据建立索引。

7. 其他特殊类型的索引:
   - 空间索引（Spatial Index）：用于地理空间数据的查询。
   - XML索引：用于XML数据类型的字段，加快XML数据的查询效率。

索引的选择和使用应该基于数据的使用模式、查询类型、数据分布和数据库管理系统的特性。合适的索引能够大幅提高查询性能，但是也会消耗额外的存储空间，且在数据变更时需要维护，可能影响写入性能。因此，设计索引时需要权衡查询优化与资源消耗。

## 索引创建与管理

### 创建索引

```sql
-- 创建单列索引
CREATE INDEX index_name ON table_name(column_name);
-- 创建复合索引/多列索引
CREATE INDEX index_name ON table_name(column1，column2，column3，……);
```

### 删除索引

```sql
DROP INDEX index_name ON table_name;
```

### 重建索引

```sql
-- 频繁操作后可能会产生碎片，重建索引可以提高效率
REINDEX INDEX index_name;
```

### 查询索引

```sql
SHOW INDEXES FROM  table_name;
```

## 索引的使用

### 查询优化

#### 创建适当的索引

- **单列索引**：对经常用于查询条件的单个列创建索引。
- **多列索引（复合索引）**：对经常一起使用的多个列创建复合索引，特别是WHERE子句中多个条件的组合。
- **唯一索引**：对需要唯一值的列（如用户名、电子邮件等）创建唯一索引，以确保数据的唯一性和加速查询。

#### 使用覆盖索引

覆盖索引包含查询所需的所有列，避免了回表操作（即从索引中找到主键后，再去主表中查找其他列），进一步提高查询效率。

#### 利用索引优化排序和分组

对经常用于ORDER BY和GROUP BY操作的列创建索引，可以显著提高排序和分组操作的性能。

#### 查询优化器的使用

使用数据库的查询优化工具（如MySQL的EXPLAIN、PostgreSQL的EXPLAIN ANALYZE）来分析查询计划，确保索引被合理利用。

### 索引的索引

#### 选择经常用于查询条件的列

- **WHERE子句**：对经常出现在WHERE子句中的列创建索引。
- **JOIN操作**：对经常用于表连接的列创建索引。

#### 选择经常用于排序和分组的列

- **ORDER BY子句**：对经常用于排序的列创建索引。
- **GROUP BY子句**：对经常用于分组的列创建索引。

#### 选择基数较高的列

- **高基数列**：选择基数较高的列（即唯一值较多的列）创建索引，因为这些列的选择性较高，索引的效率更高。

#### 选择适当的索引类型

- **B-树索引**：适用于大多数查询操作，包括等值查询、范围查询、排序和分组。
- **哈希索引**：适用于等值查询，但不适用于范围查询。
- **位图索引**：适用于低基数列和多条件查询。
- **全文索引**：适用于全文搜索

>1. **避免过多索引**：创建过多的索引会增加维护开销和存储空间，影响插入、更新和删除操作的性能。
>2. **定期维护索引**：定期重建或优化索引，以减少碎片和保持索引的高效性。
>3. **监控和分析**：使用查询优化工具（如EXPLAIN）监控和分析查询性能，确保索引被合理利用。
>4. **选择合适的索引类型**：根据查询类型和数据特性选择合适的索引类型，以达到最佳的查询性能。
>5. **考虑复合索引的顺序**：在创建复合索引时，考虑列的顺序。一般来说，选择性较高的列应放在前面。

### 索引的缺点

1. **空间开销**：索引需要额外的存储空间来维护数据结构，特别是对于大型表和多个索引。
2. **性能开销**：插入、更新和删除操作需要同时更新索引，增加了性能开销。

## 索引性能调优

### 执行计划

#### 什么是执行计划（EXPLAIN）

`EXPLAIN`是一个SQL命令，用于显示查询的执行计划。执行计划提供了查询优化器选择的执行路径，包括表的访问顺序、使用的索引、连接方式和估计的行数等信息。

#### `EXPLAIN`的基本语法

```mysql
EXPLAIN SELECT * FROM table_name WHERE condition;
```

#### 解释执行计划的输出

1. id：查询中每个子查询的标识符。查询的执行顺序是按照`id`的顺序进行的。
2. select_type：查询的类型，如`SIMPLE`（简单查询）、`PRIMARY`（主查询）、`SUBQUERY`（子查询）等。
3. table：查询中访问的表。
4. type：访问类型，表示查询使用的访问方法。常见的类型包括：
   - `ALL`：全表扫描。
   - `index`：索引扫描。
   - `range`：范围扫描。
   - `ref`：使用非唯一索引扫描。
   - `eq_ref`：使用唯一索引扫描。
   - `const`：常量访问。
5. possible_keys：查询中可能使用的索引。
6. key：查询实际使用的索引。
7. key_len：使用的索引的长度。
8. ref：索引列与查询条件的比较。
9. rows：查询优化器估计的需要读取的行数。
10. Extra：额外的信息，如`Using where`、`Using index`、`Using temporary`、`Using filesort`等。

#### 常见的`Extra`列值及优化建议

##### `Using where`

表示查询使用了WHERE条件进行过滤。这通常是正常的，但你可以确保WHERE条件中的列有适当的索引，以提高查询性能。

**优化建议**：

- 确保WHERE条件中的列有索引。
- 考虑创建复合索引以覆盖多个WHERE条件。

#####  `Using index`

表示查询使用了覆盖索引，所有需要的数据都从索引中获取，无需回表操作。这通常是理想的情况。

**优化建议**：

- 确保查询所需的所有列都包含在索引中，以实现覆盖索引。
- 定期检查和维护索引，以确保索引的高效性。

#####  `Using temporary`

表示查询使用了临时表，通常发生在需要排序或分组的查询中。这可能会影响查询性能。

**优化建议**：

- 确保ORDER BY和GROUP BY子句中的列有索引。
- 尽量减少使用临时表的查询操作。
- 通过调整查询语句或创建适当的索引，减少临时表的使用。

#####  `Using filesort`

表示查询使用了文件排序，通常发生在需要排序的查询中。这可能会影响查询性能。

**优化建议**：

- 确保ORDER BY子句中的列有索引。
- 尽量减少使用文件排序的查询操作。
- 通过调整查询语句或创建适当的索引，减少文件排序的使用。

#####  `Using join buffer`

表示查询使用了连接缓冲区，通常发生在没有适当索引的连接操作中。这可能会影响查询性能。

**优化建议**：

- 确保连接列有适当的索引。
- 考虑调整连接顺序或使用不同的连接方式（如嵌套循环连接、哈希连接等）。

#####  `Using index condition`

表示查询使用了索引条件下推（Index Condition Pushdown，ICP），这是一种优化技术，可以减少回表操作。

**优化建议**：

- 确保索引覆盖查询条件，以充分利用索引条件下推。

##### `Using intersect/union`

表示查询使用了索引合并，通过交集或并集操作合并多个索引的结果。

**优化建议**：

- 确保查询条件中的列有适当的索引。
- 考虑创建复合索引以替代索引合并。

### 覆盖索引

覆盖索引是指包含查询所需的所有列的索引。覆盖索引并不是一种不同的索引类型，而是复合索引的一种特殊用法。当一个索引包含了查询所需的所有列时，这个索引就被称为覆盖索引。覆盖索引可以避免回表操作，从而提高查询性能。

回表操作（Table Lookup 或 Table Access by Rowid）是指在使用索引查询时，数据库系统需要从索引中找到主键或行标识符（Rowid），然后再访问实际的数据行以获取所需的列数据。回表操作通常发生在索引不包含查询所需的所有列的情况下。

**回表操作的过程:**

1. **索引查找**：首先，数据库系统使用索引来快速定位符合查询条件的记录。在这个过程中，索引只包含索引列和指向实际数据行的指针（如主键或Rowid）。
2. **回表查找**：一旦找到符合条件的索引记录，数据库系统使用指针（如主键或Rowid）访问实际的数据行，以获取查询所需的其他列的数据。

### 索引合并

索引合并（Index Merge）是数据库查询优化器在执行查询时的一种优化策略。它允许查询优化器同时使用多个索引来满足查询条件，然后合并这些索引的结果，从而提高查询性能。

**索引合并的原理**

索引合并的基本思想是，当一个查询可以利用多个索引时，查询优化器会分别使用这些索引进行部分查询，然后将结果合并。

1. **AND条件**：当查询条件中包含多个列的AND操作时，查询优化器可以分别使用每个列上的索引，然后合并结果。
2. **OR条件**：当查询条件中包含多个列的OR操作时，查询优化器可以分别使用每个列上的索引，然后合并结果。
3. **覆盖索引**：当查询条件和选择列可以分别由不同的索引覆盖时，查询优化器可以分别使用这些索引，然后合并结果。

**索引合并的类型**

1. **联合索引合并（Union Index Merge）**：用于处理OR条件。查询优化器分别使用每个列上的索引，然后将结果进行并集操作。
2. **交集索引合并（Intersection Index Merge）**：用于处理AND条件。查询优化器分别使用每个列上的索引，然后将结果进行交集操作。
3. **排序合并（Sort-Union Index Merge）**：用于处理需要排序的查询。查询优化器分别使用每个列上的索引，然后对结果进行排序和合并。

## 索引失效场景

1. 模糊查询
2. 不等值查询
3. 查询提交索引列使用函数或者表达式
4. 复合索引没有按照顺序
5. 索引列类型不匹配，本来是int，你写sql是字符串，暗含了隐式转换
6. NULL值处理

## 聚簇索引和非聚簇索引

从物理存储方式来看索引可以分为聚簇索引（Clustered Index）和非聚簇索引（Non-Clustered Index）。

### 聚簇索引（Clustered index）

聚簇索引是按照索引键值顺序存储数据的索引。

#### 语法

```sql
create custered index index_name on table_name(cloum)
```

#### 特点

1. 数据存储顺序：数据行按照索引值进行物理排序存储。
2. 唯一性：一个表只能由一个聚簇索引，默认是主键。
3. 主键默认聚簇：数据库如果没有明确创建聚簇索引，默认主键就是聚簇索引。

#### 优点

1. 查询性能：根据数据行的有序性，进行范围查询、排序查询、分组查询、去重查询效率高。
2. 快速检索：找到聚簇索引键值后可以快速定位到数据行，快速的查找其他的列的值。

#### 缺点

1. 插入和更新开销：插入和更新操作可能会导致部分数据行重新排列。
2. 表重建：更改聚簇索引，会导致整张表重新排列。



### 非聚簇索引（Non-Clustered Index）

非聚簇索引不影响数据行的顺序，索引存在独立的B+树中，存储的是索引键值和指向数据的行指针

#### 语法

```sql
CREATE INDEX idx_last_name ON employees(last_name)
```

#### 特点

1. 独立存储：与数据分开存储，存储索引键值和数据的行指针
2. 多个索引：不唯一，可以有多个

#### 优点

1. 灵活性：可以有多个聚簇索引，每个索引可以加速不同的查询操作。
2. 插入和更新效率：数据行不受影响，效率高

#### 缺点

1. 回表操作：非聚簇索引需要进行回表操作（Table Lookup），即从索引中找到RowID或指针后，再访问实际的数据行。

## 数据分区

数据分区是DBMS的一种功能，可以将一个大表或者索引分成更小、更易于管理的分区，每个分区独立存储和管理。

### 数据分区的类型

1. 范围分区（Rang partitioning）: 根据列值分范围将数据分成不同的区，例如，根据日期范围分区，将数据按年份或月份分区。
2. 列表分区（List partitioning）: 根据列值的具体列表将数据分成不同的分区,例如，根据地区代码分区，将数据按不同的地区分区。
3. 哈希分区（Hash partitioning）: 根据列值的哈希值将数据分成不同的分区,适用于数据分布均匀的情况。
4. 键值分区（Key partitioning）: 类似于哈希分区，但使用的是数据库系统内部的哈希函数,通常用于主键或唯一键。
5. 复合分区（Composite partition）: 结合多种分区方法，将数据分成更细的分区,例如，先按范围分区，再按哈希分区。

### 数据分区的优点

1. **提高查询性能**：
   - 在特定分区内执行，减少数据扫描的范围，提高查询效率。
   - 适用于范围查询和大数据量的查询。
2. **简化管理**：
   - 独立管理每个分区，例如备份、恢复、加载和卸载数据。
   - 分区可以独立维护和优化，减少对整个表的影响。
3. **提高可扩展性**：
   - 分区可以分布在不同的存储设备上，提高数据存储和处理的可扩展性。
   - 支持大规模数据的存储和处理。
4. **提高可用性**：
   - 如果一个分区出现故障，其他分区仍然可以正常工作，提高系统的可用性。

### 语法

```sql
-- 范围分区
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023)
);
-- 列表分区
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2),
    region_code CHAR(2)
)
PARTITION BY LIST (region_code) (
    PARTITION p_north VALUES IN ('N1', 'N2'),
    PARTITION p_south VALUES IN ('S1', 'S2'),
    PARTITION p_east VALUES IN ('E1', 'E2'),
    PARTITION p_west VALUES IN ('W1', 'W2')
);
-- 哈希分区
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY HASH(order_id) PARTITIONS 4;
-- 键值分区
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY KEY(order_id) PARTITIONS 4;
-- 复合分区
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (YEAR(order_date)) SUBPARTITION BY HASH(order_id) SUBPARTITIONS 4 (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023)
);
```

## mysql数据分区如何分布在不同的存储设备

1. 创建表空间

假设有三个存储设备，分别位于路径`/mnt/device1`、`/mnt/device2`和`/mnt/device3`。在每个存储设备上创建一个表空间：

```sql
CREATE TABLESPACE ts1 ADD DATAFILE '/mnt/device1/datafile1.ibd';
CREATE TABLESPACE ts2 ADD DATAFILE '/mnt/device2/datafile2.ibd';
CREATE TABLESPACE ts3 ADD DATAFILE '/mnt/device3/datafile3.ibd';
```

2. 创建分区表并指向表空间

```sql
CREATE TABLE orders (
    order_id INT,
    order_date DATE,
    customer_id INT,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2020 VALUES LESS THAN (2021) TABLESPACE ts1,
    PARTITION p2021 VALUES LESS THAN (2022) TABLESPACE ts2,
    PARTITION p2022 VALUES LESS THAN (2023) TABLESPACE ts3
);
```

3. 添加新的分区和表空间

```sql
CREATE TABLESPACE ts4 ADD DATAFILE '/mnt/device4/datafile4.ibd';

ALTER TABLE orders ADD PARTITION (PARTITION p2023 VALUES LESS THAN (2024) TABLESPACE ts4);
```

4. 删除分区

```sql
ALTER TABLE orders DROP PARTITION p2020;
```

5. 查看分区

```sql
SHOW CREATE TABLE orders;
```





# 事务



>一个事务内的所有操作要么全部成功，要么全部失败，通过事务保证数据库数据的一致性。

## 如何使用事务

```sql
-- 开启事务
BEGIN TRANSACTION; 
-- 提交事务
COMMIT;
-- 回滚
ROLLBACK;
```

**保存点（`Savepoint`）**

>保存点就是快照，事务可以回滚到指定的快照节点，使用 `SAVEPOINT` 命令来设置保存点，使用 `ROLLBACK TO` 命令回滚到特定的保存点。
>
>如果一个长事务在执行过程中只有某一小部分操作失败，那么在失败之前设置一个保存点，等失败后只需回滚这一部分操作，而不用回滚整个事务，提高效率。

```sql
SAVEPOINT savepoint_name;
```

**事务示例：**

```sql
BEGIN TRANSACTION;

UPDATE Accounts SET Balance = Balance - 100 WHERE id = 1;
UPDATE Accounts SET Balance = Balance + 100 WHERE id = 2;

-- 检查最后一个操作是否成功。如果上一个T-SQL操作没有产生错误，`@@ERROR`的值将为0。
IF @@ERROR = 0 
   COMMIT;
ELSE
   ROLLBACK;
-- 事务要么成功，要么失败
```

## 如何保证数据的完整性和可靠性

**1. 原子性（Atomicity）**

>一个事务（transaction）是一个原子单元，要么全部成功，要么全部不执行。

**2. 一致性（Consistency）**

>事务操作前后，数据必须满足预定义的规则和约束，如数据类型、长度、范围等业务规则。如：一个银行应用其中一个规则是每个客户的账户余额必须大于或等于0。这是数据库的一个一致性状态。

**3. 隔离性（Isolation）**

>一个事务执行后，它影响的数据对其他正在执行的事务是不可见的。

**4. 持久性（Durability）**

>一个事务成功执行后，数据库中数据的更改会永久保存在数据库中。

## 事务并发时遇到的读取问题

**脏读（Dirty Read）**

>读取到了其他事务未提交的数据

**不可重复读（Non-repeatable Read）**

>在一个事务内，不同的时刻读到的单个数据行的内容不一致，可能会受到其他事务的执行更新语句，改变了数据内容。

**幻读（Phantom Read）**

>在一个事务，不同时刻读到的同一个数据范围（数据条数）不一致，可能受到了其他事务执行了插入语句后，改变了数据范围。

## 事务隔离级别

>事务的隔离级别在事务并发执行时，来管理事务之间的交互，以防范可能引发的数据不一致问题。

1. **读未提交（READ UNCOMMITTED）** 一个事务可以读取其他事务未提交的更改后数据，也称为"脏读",属于最低的隔离级别。

   ```sql
   -- 以下是如何设置此级别的示例：
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
   BEGIN TRANSACTION;
   -- Execute your SQL commands here
   COMMIT;
   ```

2. **读已提交（READ COMMITTED）** 一个事务要等到另一个事务提交后才能读取数据，解决了脏读问题，可能会遇到不可重复读的问题。

   ```sql
   -- 设置此级别的方法如下：
   SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
   BEGIN TRANSACTION;
   -- Execute your SQL commands here
   COMMIT;
   ```

3. **可重复读（REPEATABLE READ）** 一个事务内读到的数据保持一致，不允许其他事务进行修改操作，解决了不可重复读问题，但可能出现幻读问题。

   ```sql
   -- 设置此级别的方法如下：
   SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
   BEGIN TRANSACTION;
   -- Execute your SQL commands here
   COMMIT;
   ```

4. **串行化（SERIALIZABLE）** 序列化时最高级别的隔离，对查询中使用的数据获取读锁和写锁，以防止其他事务访问相应的数据。它避免了脏读、不可重复读和幻读的问题。

   ```sql
   -- 设置此级别的方法如下：
   SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   BEGIN TRANSACTION;
   -- Execute your SQL commands here
   COMMIT;
   ```

> **更高级别的隔离通常会提供更高的一致性，但可能会由于锁等待时间的增加而降低性能。**

# 存储过程和函数

## 存储过程

>SQL存储过程是保存了一组经过预编译的可重用的SQL代码

### 存储过程的优点

1. 预编译：存储过程在创建时会被编译并存储在数据库中。之后的调用不需要重新编译，只是执行已编译的代码，这可以提高执行效率。

2. 减少网络流量：可以将多个SQL语句封装在一个存储过程中，用户只需一次调用，而非将多个语句分别从客户端发送到服务器，这样可以减少网络通信量。

3. 重用和封装：存储过程可以被多个程序或应用重用。同时也可以将复杂的业务逻辑封装在存储过程内部，简化应用开发。

4. 安全性：可以通过数据库的权限机制对存储过程进行权限控制，只允许特定用户执行特定的存储过程，从而增强了数据库操作的安全性。

5. 事务管理：存储过程可以使用事务来确保数据的一致性。在存储过程中可以根据需要开始事务、提交事务或者在遇到错误时回滚事务。

### 存储过程如何使用

```sql
-- 创建一个存储过程
CREATE PROCEDURE getEmployeesBySalary
  @minSalary int
AS
BEGIN
  SELECT firstName, lastName
  FROM Employees
  WHERE salary > @minSalary
END
GO
-- 执行存储过程
EXEC getEmployeesBySalary 50000
```

## 函数

>SQL 函数是执行特定任务的一组 SQL 语句,函数必须返回一个值或结果。

**1. 标量函数（Scalar functions）**返回单个值，可以在使用单个表达式的地方使用。例如：

```sql
CREATE FUNCTION addNumbers(@a int, @b int)
RETURNS int 
AS 
BEGIN
   RETURN @a + @b
END
```

**2. 表值函数（Table-valued functions）**返回一个表。它们可以像普通表一样在 JOIN 子句中使用

```sql
CREATE FUNCTION getBooks (@authorID INT)
RETURNS TABLE
AS 
RETURN (
   SELECT books.title, books.publicationYear 
   FROM books 
   WHERE books.authorID = @authorID
)
-- 调用getBooks函数
SELECT title, publicationYear FROM getBooks(3)
```

## 存储过程和表值函数的区别

1. 返回类型：
   - 存储过程可以返回零个、一个或多个结果集，也可以返回输出参数，或者根本不返回任何东西。
   - 表值函数返回一个表对象，可以像使用普通表一样查询这个对象。

2. 使用上下文：
   - 存储过程不能在 SQL 语句（如 SELECT、UPDATE、INSERT、DELETE）中直接调用，通常需要使用特定的调用语句（如 CALL 或 EXECUTE）。
   - 表值函数可以直接在 SQL 查询中作为数据源使用，就像一个表一样。

3. 副作用：
   - 存储过程可以包含产生副作用的 SQL 语句，如插入、更新、删除记录等。
   - 表值函数通常不允许包括有副作用的操作，它们设计来用作只读操作，并且期望是确定性的。

4. 执行方式：
   - 存储过程需要显式执行，并且可以接受输入和输出参数。
   - 表值函数可以像其他任何列或表一样参与查询，并且通常只接受输入参数。

5. 事务管理：
   - 存储过程中可以包含事务逻辑（如开始事务、提交事务、回滚事务）。
   - 表值函数不能使用事务逻辑。

6. 调用方式：
   - 存储过程可以独立调用。
   - 表值函数需要在 SELECT 语句中被调用，可以像表一样被 JOIN。

# 性能优化

> SQL性能优化是指提高SQL的查询速度，更快的响应用户

## 查询优化技术

### 索引

>创建索引可以提高查询性能，工作原理是将表的部分数据存储在可以快速访问的位置，索引保存列值以及记录本身的位置，这类似于书中目录页的内容和对应的页码。

单列索引

```sql
-- 指定某个列作为索引
CREATE INDEX index_name ON table_name (column1);
```

复合索引

```sql
-- 指定多个列作为索引
CREATE INDEX index_name ON table_name (column1, column2);
```

唯一索引

```sql
-- 保证一列或多列的组合是唯一值
CREATE UNIQUE INDEX index_name ON table_name (column1, column2...);
```

隐式索引

```sql
-- 隐式索引由数据库服务器自动创建的索引。例如，当定义主键时。
```

### 避免选择*

>指获取所需要的列，不要使用 `SELECT *` 它减少了需要从磁盘读取的数据量

```sql
SELECT required_column FROM table_name;
```

### 连接查询优化

>遵循前两个的优化的基础上，在进行多表连接查询的时候，小表在前，大表在后

```sql
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID=Customers.CustomerID;
```

### 使用Limit

如果只需要一定数量的行，使用 LIMIT 关键字来限制查询返回的行数。

```sql
SELECT column FROM table LIMIT 10;
```

### 避免在开头使用带通配符的 LIKE 运算符

在查询开头使用通配符 ( `LIKE '%search_term'`) 可能会导致全表扫描。

```sql
SELECT column FROM table WHERE column LIKE 'search_term%';
```

## 查询分析技术

### 解释计划

> 数据库具有"解释计划"功能，可以显示数据库引擎执行查询的计划,这可以深入了解性能瓶颈，例如全表扫描、缺失索引等。

```sql
EXPLAIN PLAN FOR SELECT * FROM table_name;
```

### 合理使用索引

>使用适当的索引对于查询性能至关重要。如果存在正确的索引，则可以避免不必要的全表扫描。尽管 SQL 会自动确定要使用的适当索引，但手动指定用于复杂查询的索引会很有帮助。

```sql
-- 假设我们有一个用户表 users，它包含如下字段和索引：
CREATE TABLE users (
    id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);
-- 创建索引
CREATE INDEX idx_last_name ON users(last_name);
-- 走索引查询
SELECT * FROM users WHERE last_name = 'Smith';  
-- 不走索引查询
SELECT * FROM users WHERE LOWER(last_name) = 'smith';
SELECT * FROM users WHERE id > 1234;
SELECT * FROM users WHERE ABS(id - 2000) < 1234;
```

**为了避免这种情况，避免表达式用于索引列。**

# 高级SQL

## 递归查询

>递归查询是用于数据分析的高级 SQL 查询，尤其是在处理分层或树结构数据时。
>
>递归 CTE 是引用自身的 CTE。递归 CTE 至少有两个查询：一个锚成员（仅运行一次）和一个递归成员（重复运行）

```sql
-- 递归语法
WITH RECURSIVE cte_name (column_list) AS (
  
  -- Anchor member
  SELECT column_list
  FROM table_name
  WHERE condition
  
  UNION ALL
  
  -- Recursive member
  SELECT column_list
  FROM table_name
  INNER JOIN cte_name ON condition
)
SELECT * FROM cte_name;
-- 例如：我们想要查询每个员工及其所有上级经理的信息,包括经理所在的部门名称。
WITH RECURSIVE ManagerCTE AS
(
    -- 非递归查询
    SELECT 
        e.EmployeeID,
        e.Name AS EmployeeName,
        d.DepartmentName,
        e.ManagerID,
        CAST(e.Name AS VARCHAR(1000)) AS ManagerNames,
        0 AS Level
    FROM Employee e
    LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
    WHERE e.ManagerID IS NULL
    
    UNION ALL
    
    -- 递归查询
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName, 
        d.DepartmentName,
        e.ManagerID,
        CAST(m.ManagerNames + ' > ' + e.Name AS VARCHAR(1000)),
        m.Level + 1
    FROM Employee e
    INNER JOIN ManagerCTE m ON e.ManagerID = m.EmployeeID
    LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
)
SELECT * FROM ManagerCTE;
-- 结果
EmployeeID | EmployeeName | DepartmentName | ManagerID | ManagerNames     | Level
-----------+---------------+----------------+-----------+------------------+-------
         1 | Mike         | Sales          |      NULL | M                |     0
         2 | Jen          | Sales          |         1 | M > Jen          |     1
         3 | Rob          | Marketing      |         1 | M > Rob          |     1  
         4 | Angie        | Marketing      |         3 | M > Rob > Angie  |     2
         5 | Dina         | Marketing      |         3 | M > Rob > Dina   |     2
         6 | Jack         | IT             |      NULL | J                |     0
```



## 转置操作

>SQL的转置操作通常指的是PIVOT和UNPIVOT操作,用于在行和列之间转换数据。

## 窗口函数

>窗口函数，也叫OLAP函数（Online Anallytical Processing，联机分析处理），可以对数据库数据进行实时分析处理。

**窗口函数的分类**

+ **聚合函数**: `count()、sum()、AVG()、MAX()、MIN（）`
+ **排名函数**:`RANK() OVER (PARTITION BY 分区内容 ORDER BY 排序内容 DESC) as rank`

+ **值函数**：`FIRST()、LAST_VALUE、NTH_VALUE()用于从窗口分区中获取第一个、最后一个或第N个值 `
+ **偏移函数**：`LAG():获取当前行的前n行的值,即往前偏移,LEAD():取当前行的后n行的值,即往后偏移`

## CTE（通用表表达式）

>CTE 或公用表表达式是一种临时结果集，在单个 SQL 语句的执行范围内定义。它们的作用就像单个查询的临时视图，通常用于简化子查询并提高可读性。

```sql
WITH CTE_Name AS
(
    SQL Query
)
SELECT * FROM CTE_Name
-- 举例：
WITH cte_authors AS (
  SELECT id, name 
  FROM authors
)
SELECT a.name, COUNT(b.id) AS book_count
FROM cte_authors a
LEFT JOIN books b ON a.id = b.author_id
GROUP BY a.name;
```

## 动态SQL

>动态SQL（Dynamic SQL）是指在运行时生成和执行的SQL语句，而不是在编译时确定的静态SQL语句。动态SQL允许你根据不同的条件和参数构建和执行SQL查询。

# Mysql安装

## 卸载自带mysql

```shell
rpm -e --nodeps mysql
```

## 创建mysql文件夹

```shell
mkdir -p /var/lib/mysql
```

## 安装Mysql

```shell
wget http://repo.mysql.com/mysql84-community-release-el7.rpm
rpm -ivh mysql84-community-release-el7.rpm
yum update
yum install -y mysql-server
```

## 初始化mysql

```shell
mysqld --initialize
```

## 赋予mysql权限

```shell
chown -R mysql:mysql  /var/lib/mysql
```

## 启动mysql

```shell
systemctl start mysqld
```

## 查找默认密码

```shell
grep 'temporary password' /var/log/mysqld.log
```

## 测试登录

```shell
mysql -u root -p 
#输入密码
```

## 修改默认密码

```shell
alter user 'root'@'localhost' identified by '123456';
```



## 远程登录

```shell
mysql -u root -p 
# 输入密码
use mysql;
update user set host='%' where user ='root';
flush privileges;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'WITH GRANT OPTION;
# 查询验证
select user,host from user;
#开放3306端口号，永久生效
firewall-cmd --zone=public --add-port=3306/tcp --permanent
#重启防火墙
firewall-cmd --reload
# 查看当前开放端口
firewall-cmd --list-ports
```

# 卸载mysql

## 关闭Mysql

```bash
systemctl stop mysqld
```

## 使用yum卸载安装的mysql

```shell
yum remove  mysql mysql-server mysql-libs mysql-server
```

## 删除残余安装包

```shell
rpm -ev $(rpm -qa|grep mysql)
```

## 删除残余文件夹

```shell
rm -rf $(find / -name mysql)
```

# 数据库补充

## 基础

 MySQL 的架构共分为两层：**Server 层和存储引擎层**

- **Server 层负责建立连接、分析和执行 SQL**。MySQL 大多数的核心功能模块都在这实现，主要包括连接器，查询缓存、解析器、预处理器、优化器、执行器等。另外，所有的内置函数（如日期、时间、数学和加密函数等）和所有跨存储引擎的功能（如存储过程、触发器、视图等。）都在 Server 层实现。
- **存储引擎层负责数据的存储和提取**。支持 InnoDB、MyISAM、Memory 等多个存储引擎，不同的存储引擎共用一个 Server 层。现在最常用的存储引擎是 InnoDB，从 MySQL 5.5 版本开始， InnoDB 成为了 MySQL 的默认存储引擎。我们常说的索引数据结构，就是由存储引擎层实现的，不同的存储引擎支持的索引类型也不相同，比如 InnoDB 支持索引类型是 B+树 ，且是默认使用，也就是说在数据表中创建的主键索引和二级索引默认使用的是 B+ 树索引。

### MySQL执行流程

有一个名为 `employees` 的表，并执行以下查询：

```sql
SELECT first_name, last_name FROM employees WHERE employee_id = 1;
```

执行流程为：

1. **客户端连接**：客户端连接到 MySQL 服务器并发送查询 `SELECT first_name, last_name FROM employees WHERE employee_id = 1;`。
2. **查询缓存（可选）**：检查查询缓存，如果有返回直接返回，没有缓存则继续下一步。
3. **解析器**：词法分析：将查询字符串分解成标记。标记：`SELECT`、`first_name`、`,`、`last_name`、`FROM`、`employees`、`WHERE`、`employee_id`、`=`、`1`。语法分析：生成解析树。解析树：表示选择 `first_name` 和 `last_name` 列，从 `employees` 表中选择，过滤条件是 `employee_id = 1`。
4. **预处理器**：语义检查：检查 `employees` 表和 `employee_id` 列是否存在，权限是否足够。视图展开（如果有视图）。
5. **优化器**：选择最优执行计划：选择使用 `employee_id` 列上的索引。生成执行计划：扫描 `employees` 表，使用索引查找 `employee_id = 1` 的记录。
6. **执行器**：执行查询：根据执行计划逐步执行查询。调用存储引擎接口：读取 `employees` 表中的数据。
7. **存储引擎**：处理数据：存储引擎（如 InnoDB）读取数据并返回给执行器。使用 B+ 树索引查找 `employee_id = 1` 的记录，返回 `first_name` 和 `last_name` 列的数据。
8. **返回结果**：执行器将结果集返回给客户端。结果集包括查询结果：`first_name` 和 `last_name` 列的数据。

### 存储引擎

#### MySQL的存储

- **数据存储（InnoDB存储引擎）**：
  - 存放目录：`/var/lib/mysql`
  - 文件内容：
    - `db.opt`：存储当前数据库的默认字符集和字符校验规则。
    - `表名.frm`：存储表结构。
    - `表名.ibd`：存储表数据。
- **InnoDB存储结构**：
  - 段（segment）：表空间由各个段组成，段由多个区组成。
    - **索引段**：存放B+树的非叶子节点的区的集合。
    - **数据段**：存放B+树的叶子节点的区的集合。
    - **回滚段**：存放回滚数据的区的集合。
  - **区（extent）**：为索引分配空间的单位，每个区为1MB，连续的64个页。
  - **页（page）**：InnoDB读取数据库是按页读取的，默认每个页的大小为16KB。
  - **行（row）**：数据库表中的记录按行存放，每行记录根据不同的行格式有不同的存储结构。
- **InnoDB行格式**：
  - Compact：
    - 记录额外信息：
      - 变长字段长度列表：逆序保存varchar字段的长度。
      - NULL值列表：存储哪些列是NULL。
      - 记录头信息：包括`delete_mask`（标识是否被删除）、`next_record`（下一条记录的位置）、`record_type`（记录类型）。
    - 记录真实数据：
      - `row_id`：如果表没有主键或唯一约束列，InnoDB会添加`row_id`。
      - `trx_id`：事务ID，表示数据由哪个事务生成。
      - `roll_pointer`：指向上一个版本的指针。
- **varchar(n)最大取值**：`n = 65535 - 可变长度列表字节数 - NULL列表字节数 - 其他字段占用字节数`
- **行溢出处理**：当一个页存储不了一条记录时，多余的数据会存储到溢出页上，真实数据处用20字节存储指向溢出页的地址。

### 锁

#### 全局锁（Global Lock）

全局锁会锁定整个数据库实例，通常用于全库备份和维护操作。

```sql
FLUSH TABLES WITH READ LOCK;
```

原理：全局锁会锁定所有表，阻止任何写操作，确保在备份期间数据一致性。读操作仍然允许。

场景：全局锁适用于需要确保整个数据库在某一时刻数据一致性的操作，但会阻塞所有写操作，因此不适合长时间使用。

#### 表级锁（Table-level Locks）

表级锁锁定整个表，适用于需要对整个表进行大规模操作的情况。

```sql
LOCK TABLES table_name READ;  -- 读锁
LOCK TABLES table_name WRITE; -- 写锁
UNLOCK TABLES; -- 解锁
```

意向锁（Intention Lock）：自动管理，无需显式使用。

原理：表锁会锁定整个表，阻止其他事务对该表的读写操作。意向锁用于表明事务即将对表中的某些行加锁，分为意向共享锁（IS）和意向排他锁（IX）。

场景：表级锁适用于需要对整个表进行大规模操作的情况，但会阻塞其他事务对该表的操作，因此不适合高并发环境。

#### 页级锁（Page-level Locks）

页级锁锁定数据页，介于表级锁和行级锁之间，较少使用。MySQL的BDB存储引擎支持页级锁，但InnoDB和MyISAM不支持。

原理：页级锁锁定的是数据页而不是单行或整表，适用于需要对多个连续行进行操作的情况。

场景：页级锁介于表级锁和行级锁之间，提供了较好的并发性和性能，但由于MySQL主流存储引擎不支持，实际应用较少。

#### 行级锁（Row-level Locks）

行级锁是InnoDB的默认锁机制，适用于高并发的场景。

共享锁（Shared Lock, S锁）：允许多个事务读取同一行，但不允许修改。

```sql
SELECT * FROM table_name WHERE condition LOCK IN SHARE MODE;
```

排他锁（Exclusive Lock, X锁）：允许一个事务读取和修改一行，其他事务不能读取或修改。

```sql
SELECT * FROM table_name WHERE condition FOR UPDATE;
```

原理：行级锁通过B+树索引实现。每个索引记录都有一个锁定信息，InnoDB通过这些信息来管理锁的状态。行级锁包括记录锁（Record Lock）、间隙锁（Gap Lock）和临键锁（Next-Key Lock）。

场景：行级锁提供了最高的并发性，适用于高并发环境。通过锁定特定的行而不是整个表或页，行级锁能够最大限度地减少锁冲突。

#### 生产环境中的实际应用

+ 全局锁用于全库备份
+ 表级锁用于批量更新
+ 行级锁用于并发控制

#### 查看锁信息

```sql
SHOW ENGINE INNODB STATUS;
```

