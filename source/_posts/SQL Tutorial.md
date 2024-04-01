---
title: Sql Tutourial
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






