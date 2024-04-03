---
title: Sql Tutourial
tag: 数据库
---

# Sql介绍

## 关系型数据库是什么

>关系型数据库是以结构化的方式组织和存储数据的数据库

+ 表（Table）：数据存储的地方，可以想象为一个网格，由行和列组成。每个表代表数据库中的一个实体或概念。

- 行（Row）：表中的一行代表了一个记录（Record），即一组相关的数据项。每行都是一个数据实体的实例。
- 列（Column）：表中的一列存放的是同一种数据，例如名字或者价格等。列有一个定义好的数据类型，如整数、字符串、日期等。
- 主键（Primary Key）：表中的一个列或列的组合，它唯一标识表中的每一行。无两行可具有相同的主键值。
- 外键（Foreign Key）：一个表中的字段，它是另一个表的主键，用于创建表与表之间的关联。
- 关系（Relationship）：表间的连结，通过外键实现，可以是一对一、一对多或多对多。
- 约束（Constraints）：用于确保数据库中数据的准确性和可靠性的规则。如主键约束、外键约束、唯一性约束等。
- SQL（Structured Query Language）：用于执行各种操作的标准语言，如数据查询、更新记录、管理和定义数据结构等。

>常见的关系型数据库管理系统（RDBMS）包括：Oracle、Microsoft SQL Server、MySQL、PostgreSQL和SQLite。

## RDBMS的优点和缺点

### 优点

- **结构化数据**：RDBMS 允许使用表中的行和列以结构化方式存储数据。这使得使用 SQL（结构化查询语言）轻松操作数据，确保高效灵活的使用。
- **ACID 属性**：ACID 代表原子性、一致性、隔离性和持久性。这些属性确保了 RDBMS 中可靠且安全的数据操作，使其适合任务关键型应用程序。
- **规范化**：RDBMS 支持数据规范化，这是一种以减少数据冗余并提高数据完整性的方式组织数据的过程。
- **可扩展性**：RDBMS 通常提供良好的可扩展性选项，允许随着数据和工作负载的增长添加更多存储或计算资源。
- **数据完整性**：RDBMS提供约束、主键、外键等机制来保证数据的完整性和一致性，确保数据准确可靠。
- **安全性**：RDBMS 提供各种安全功能，例如用户身份验证、访问控制和数据加密，以保护敏感数据。

### 缺点

- **复杂性**：设置和管理 RDBMS 可能很复杂，尤其是对于大型应用程序。它需要技术知识和技能来管理、调整和优化数据库。
- **成本**：RDBMS 可能很昂贵，无论是在许可费用还是其所需的计算和存储资源方面。
- **固定模式**：RDBMS 遵循严格的数据组织模式，这意味着对模式的任何更改都可能非常耗时且复杂。
- **非结构化数据的处理**：RDBMS 不适合处理多媒体文件、社交媒体帖子和传感器数据等非结构化数据，因为它们的关系结构针对结构化数据进行了优化。
- **水平可扩展性**：RDBMS 不像 NoSQL 数据库那样容易水平扩展。水平扩展需要向系统添加更多机器，这在成本和复杂性方面可能具有挑战性。



## SQL和NoSql数据库的区别

### Sql数据库

> SQL（结构化查询语言）数据库也称为关系数据库。它们具有预定义的架构，数据存储在由行和列组成的表中。 SQL数据库遵循ACID（原子性、一致性、隔离性、持久性）属性来确保事务的可靠。一些流行的 SQL 数据库包括 MySQL、PostgreSQL 和 Microsoft SQL Server。

**SQL数据库的优点**

- **预定义模式**：非常适合具有固定结构的应用程序。
- **ACID事务**：保证数据的一致性和可靠性。
- **支持复杂查询**：丰富的SQL查询可以处理复杂的数据关系和聚合操作。
- **可扩展性**：通过向服务器添加更多资源（例如 RAM、CPU）进行垂直扩展。

**SQL数据库的局限性：**

- **刚性模式**：数据结构更新非常耗时，并且可能导致停机。
- **扩展**：跨多个服务器水平扩展和分片数据的困难。
- **不太适合分层数据**：需要多个表和 JOIN 来建模树状结构。

### NoSQL 数据库

> NoSQL（不仅是 SQL）数据库是指非关系数据库，它不遵循固定的数据存储模式。相反，它们使用灵活的半结构化格式，例如 JSON 文档、键值对或图表。 MongoDB、Cassandra、Redis 和 Couchbase 是一些流行的 NoSQL 数据库。

**NoSQL 数据库的优点：**

- **灵活的架构**：轻松适应变化而不中断应用程序。
- **可扩展性**：通过跨多个服务器对数据进行分区（分片）进行水平扩展。
- **快速**：专为更快的读取和写入而设计，通常使用更简单的查询语言。
- **处理大量数据**：更适合管理大数据和实时应用程序。
- **支持各种数据结构**：不同的 NoSQL 数据库可以满足不同的需求，例如文档、图形或键值存储。

**NoSQL 数据库的局限性：**

- **有限的查询能力**：一些NoSQL数据库缺乏复杂的查询和聚合支持或使用特定的查询语言。
- **较弱的一致性**：许多 NoSQL 数据库遵循 BASE（基本可用、软状态、最终一致性）属性，这些属性提供的一致性保证比符合 ACID 的数据库更弱。

# SQL基础语法

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

>SQL 数据类型定义可以存储在数据库表列中的数据类型。根据 DBMS 的不同，数据类型的名称可能略有不同。

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

DATETIME用于格式为 ( `YYYY-MM-DD HH:MI:SS`) 的日期和时间值。

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

### 比较运算符

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

## 语句

### SELECT

>`SELECT`语句在 SQL 中用于从数据库中选取特定数据。换句话说，它用于从数据库中选择您想要显示的内容。该语句的语法`SELECT`相当简单：

```sql
SELECT column(s) FROM table WHERE condition;
```

- `column(s)`：输入要显示的列的名称。
- `table`：要从中检索数据的表的名称。
- `WHERE`： 选修的。这是一个过滤器，仅显示满足此条件的行。

### INSERT

>SQL 中的语句`INSERT`用于向数据库的表中添加新的数据行。该语句有三种形式`INSERT INTO`values、`INSERT INTO`set 和`INSERT INTO`select

INSERT INTO VALUES

```sql
INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
```

INSERT INTO SET

```sql
INSERT INTO table_name 
SET column1 = value1, column2 = value2, ...;
```

INSERT INTO SELECT

>该`INSERT INTO SELECT`语句用于从一个表复制数据并将其插入到另一表中。或者，将数据插入另一个表中的特定列。

```sql
INSERT INTO table_name1 (column1, column2, column3, ...)
SELECT column1, column2, column3, ...
FROM table_name2
WHERE condition;
```

### UPDATE

>SQL`UPDATE`语句用于修改数据库中的现有数据

```sql
UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;
```

- `table_name`：将执行更新的表的名称。
- `SET`：此子句指定列名和应更新为的新值。
- `column1, column2, ...`：表中的列名称。
- `value1, value2, ...`：要记录到数据库中的新值。
- `WHERE`：此子句指定标识要更新的行的条件。

### DELETE

>SQL 中的语句`DELETE`可帮助您从数据库中删除现有记录

1. **删除所有行：**

   `DELETE`不带子句的语句将`WHERE`删除表中的所有行。此操作是不可逆的。例子：

   ```
   DELETE FROM table_name;
   ```

   此 SQL 语句删除 中的所有记录`table_name`。

2. **删除特定行：**

   当与`WHERE`子句结合使用时，`DELETE`SQL 语句将删除满足条件的特定行。例子：

   ```
   DELETE FROM table_name WHERE condition;
   ```

   该语句的此实例从给定匹配的位置`DELETE`删除记录。`table_name``condition`

*注意：“DELETE”语句所做的删除是永久性的，无法撤消。始终确保在运行 DELETE 查询之前有备份，尤其是在生产数据库上时。*

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
   //1. 插入完整的列级
   INSERT INTO table_name  VALUES (value1, value2, ..., valueN);
   //2. 选择性插入
   INSERT INTO table_name ( column1, column2, column3, ... )  VALUES ( value1, value2, value3, ... )  
   //3. 从另一个表插入
   INSERT INTO table1 (column1, column2, ... , columnN) SELECT column1, column2, ... , columnN  FROM table2 WHERE condition;
   ```

2. **SELECT** - 该命令用于从数据库中选择数据。返回的数据存储在结果表中，称为结果集。

   ```sql
   SELECT column1, column2, ... 
   FROM table_name
   ```

3. **UPDATE** - 此命令用于修改表中的现有行。

   ```sql
   UPDATE table_name SET column1 = value1, column2 = value2, ... WHERE condition;
   ```

4. **DELETE FROM** - 此命令用于从表中删除现有行（记录）。

   ```sql
   //1. 删除表中所有行
   DELETE FROM students;
   //2. 删除指定行
   DELETE FROM table_name WHERE condition;
   ```

# 聚合查询

## 聚合函数

>SQL 聚合函数是内置函数，用于对数据执行某些计算并返回单个值。

+ COUNT()

  ```sql
  SELECT COUNT(column_name) 
  FROM table_name 
  WHERE condition;
  ```

+ SUM()

  ```sql
  SELECT SUM(column_name) 
  FROM table_name 
  WHERE condition;

+ AVG()

  ```sql
  SELECT AVG(column_name) 
  FROM table_name 
  WHERE condition;
  ```

+ MAX()

  ```sql
  SELECT MIN(column_name) 
  FROM table_name 
  WHERE condition;

+ MIN()

  ```sql
  SELECT MAX(column_name) 
  FROM table_name 
  WHERE condition;
  ```

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

## DEFAULT Constraint

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
CREATE INDEX idx_name 
ON Students (Name);
```

# 连接查询

## 内连接

```sql
SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;
```

## 左连接

>该`LEFT JOIN`关键字返回左表（table1）中的所有记录以及右表（table2）中的匹配记录。如果没有匹配，结果`NULL`从右侧开始。

```sql
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name;
```



## 右连接

>该`RIGHT JOIN`关键字返回右表 (table2) 中的所有记录以及左表 (table1) 中的匹配记录。如果没有匹配，则结果`NULL`在左侧。

```sql
SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name = table2.column_name;
```

## 全外连接

```sql
SQL 中的FULL OUTER JOIN是一种根据两个或多个表之间的相关列组合来自两个或多个表的行的方法。它返回左表 ( table1) 和右表 ( table2) 中的所有行。
```



## 自连接

>`SELF JOIN`是一个标准 SQL 操作，其中表与其自身连接。

```sql
SELECT a.column_name, b.column_name
FROM table_name AS a, table_name AS b
WHERE a.common_field = b.common_field;
```



## 交叉连接

>SQL 中的交叉连接用于将第一个表的每一行与第二个表的每一行组合起来。它也称为两个表的笛卡尔积。执行交叉连接最重要的一点是它不需要任何连接条件。
>
>交叉联接的问题是它返回两个表的笛卡尔积，这可能会导致大量行和大量资源使用。因此，明智地使用它们并且仅在必要时使用它们至关重要。

```sql
SELECT column_name(s)
FROM table1
CROSS JOIN table2;
等价于
SELECT column_name(s)
FROM table1, table2;
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

>SQL中的函数`COALESCE`用于管理数据中的NULL值。它从左到右扫描参数并返回第一个不是 的参数`NULL`。

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

# 索引

>SQL中的索引是一个数据库对象，用于提高数据库表上数据检索操作的速度。与书中的索引如何帮助您快速查找信息而无需阅读整本书类似，数据库中的索引可以帮助数据库软件快速查找数据而无需扫描整个表。

## 索引的分类

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

## 管理索引

创建索引

```sql
CREATE INDEX index_name ON table_name(column_name);
```

删除索引

```sql
DROP INDEX index_name;
```

修改索引

```sql
REINDEX INDEX index_name;
```

查询索引

```sql
SHOW INDEXES IN table_name;
```

## 查询优化

1. 使用索引：
   - 为经常作为查询条件的列添加索引。
   - 使用复合索引针对包含多个条件的查询进行优化。
   - 确保索引字段的选择性好，以允许数据库快速缩小搜索结果范围。

2. 优化查询语句：
   - 避免使用SELECT *，只选择所需的列。
   - 尽量使用表的别名和前缀，尤其是在连接多个表的查询中。
   - 确保WHERE子句中的条件尽可能使查询能利用索引。

3. 调整数据模型：
   - 正规化数据结构以避免冗余，并减少数据的管理工作。
   - 在需要频繁读取的场景下考虑反正规化，以减少JOIN操作的需要。

4. 使用查询缓存：
   - 利用数据库提供的查询缓存，对于那些不经常改变的数据，利用缓存可以大大加快查询速度。

5. 查询计划分析：
   - 使用EXPLAIN或其他分析工具查看查询的执行计划。
   - 根据执行计划调整查询方式，比如改变JOIN的类型或顺序。

6. 使用批处理：
   - 对于数据插入和更新操作，使用批处理可以减少I/O次数，提高性能。

7. 避免复杂的子查询：
   - 能用JOIN解决的问题就不要用子查询。
   - 尝试把复杂的子查询改写为临时表。

8. 减少事务大小：
   - 长事务会锁定资源较长时间，减小事务的处理数据量可以提高并发性能。

9. 硬件和系统优化：
   - 确保有足够的内存和高效的CPU。
   - 磁盘I/O性能常常是瓶颈，选择适合的存储解决方案。
   - 良好的网络基础设施，尤其是在分布式数据库环境中。

10. 监控和分析：
    - 监控数据库的性能，分析瓶颈点。
    - 定期进行数据库维护，比如索引重建和统计信息的更新。

# 事务



>SQL中的事务是由一组有逻辑的数据库操作组成的工作单元，一个事务内的所有操作要么全部成功，要么全部失败，通过事务保证数据库数据的一致性。

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

> SQL性能优化对于加速SQL查询和提高数据库整体性能至关重要。最重要的是，它可以确保 SQL 语句的顺利高效执行，从而带来更好的应用程序性能和用户体验。

## 索引

创建索引是优化 SQL 性能的重要方法之一。它们加速从数据库中查找和检索数据。

```
CREATE INDEX index_name
ON table_name (column1, column2, ...);
```

请记住，虽然索引可以加快数据检索速度，但它们可能会减慢数据修改速度，例如`INSERT`、`UPDATE`、 和`DELETE`。

## 避免选择*

仅获取所需的列，而不是使用 获取所有列`SELECT *`。它减少了需要从磁盘读取的数据量。

```
SELECT required_column FROM table_name;
```

## 使用Join代替多个查询

使用联接子句可以根据两个或多个表之间的相关列将两个或多个表中的行组合到单个查询中。这减少了访问数据库的查询数量，从而提高了性能。

```
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers
ON Orders.CustomerID=Customers.CustomerID;
```

## 使用限制

如果只需要一定数量的行，请使用 LIMIT 关键字来限制查询返回的行数。

```
SELECT column FROM table LIMIT 10;
```

## 避免在开头使用带通配符的 LIKE 运算符

在查询开头使用通配符 ( `LIKE '%search_term'`) 可能会导致全表扫描。

```
SELECT column FROM table WHERE column LIKE 'search_term%';
```

## 优化数据库架构

数据库模式涉及数据的组织方式以及如何优化以获得更好的性能。

## 使用解释

许多数据库具有“解释计划”功能，可以显示数据库引擎执行查询的计划。

```
EXPLAIN SELECT * FROM table_name WHERE column = 'value';
```

这可以深入了解性能瓶颈，例如全表扫描、缺失索引等。

