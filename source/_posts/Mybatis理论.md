---
title: Mybatis理论
tag:
- java
---



# MyBatis简介

## 什么是ORM框架

ORM（Object-Relational Mapping）框架是用于在面向对象编程语言中，将对象映射到数据库表的一种技术。ORM框架通过自动生成SQL语句和自动映射数据库记录与编程语言中的对象，实现面向对象与关系数据库之间的转换。

## MyBatis是什么

MyBatis是一个优秀的持久层框架，它支持自定义SQL、存储过程以及高级映射。MyBatis避免了几乎所有的JDBC代码和手动设置参数及获取结果集。MyBatis可以使用简单的XML或注解来配置和映射原生类型、接口和Java的POJOs（Plain Old Java Objects）到数据库中的记录。

## MyBatis和其他ORM框架的区别

- **灵活性**：MyBatis允许直接编写SQL语句，因此在灵活性上优于Hibernate等全自动化ORM框架。
- **学习曲线**：MyBatis的学习曲线较缓，相对简单，适合需要精确控制SQL的开发者。
- **性能**：由于可以手写SQL，MyBatis在处理复杂查询和优化方面具有优势。
- **对象-关系映射**：MyBatis对对象-关系映射提供了简单的XML配置或注解配置，而像Hibernate提供更强大的映射机制。

## MyBatis的由来

MyBatis最初是Apache旗下的一个项目，名为iBatis。iBatis的名字来源于“internet”和“abatis”的结合，象征着网络时代的持久层解决方案。2010年，iBatis项目迁移到Google Code并更名为MyBatis，最终MyBatis成为一个独立的开源项目。

## MyBatis的优缺点

**优点**：
- 简单易学，配置灵活。
- SQL编写灵活，开发人员可以精确控制SQL执行。
- 轻量级框架，便于与其他框架集成。
- 支持动态SQL。

**缺点**：
- 需要手写SQL，工作量较大。
- 对于复杂对象的映射支持不如Hibernate。
- 维护SQL映射文件时可能较为繁琐。

## MyBatis的使用场景

- 项目中需要精确控制SQL执行的情况。
- 需要频繁调整和优化SQL的应用。
- 轻量级应用或简单项目。
- 不需要复杂关系映射的场景。

# MyBatis原理

## MyBatis工作原理

MyBatis的工作原理是通过配置文件和注解，将Java对象与SQL语句进行映射。配置文件中定义了数据源和事务管理等配置信息，映射文件则定义了SQL语句和对象的映射关系。在执行查询或更新操作时，MyBatis将输入参数与SQL语句绑定，并执行SQL，最后将结果集映射到Java对象。

## MyBatis编程步骤

1. 创建MyBatis配置文件（mybatis-config.xml）。
2. 创建数据库映射文件（Mapper.xml），定义SQL语句。
3. 创建Java实体类，映射数据库表。
4. 创建Mapper接口，定义映射方法。
5. 通过SqlSessionFactory获取SqlSession，并执行数据库操作。

## MyBatis的架构

MyBatis的架构包括以下几个核心组件：
- **Configuration**：全局配置类，包含所有MyBatis的配置信息。
- **SqlSessionFactory**：SqlSession工厂类，用于创建SqlSession实例。
- **SqlSession**：用于执行SQL语句的接口。
- **Mapper**：映射器接口，用于定义数据库操作方法。
- **Executor**：执行器，负责SQL的执行和结果集的映射。

## 什么是MyBatis预编译

MyBatis预编译是指在执行SQL语句之前，先对SQL进行编译处理，将SQL中的参数占位符替换为对应的参数值。预编译后的SQL可以重复使用，减少了编译时间，提高了执行效率。

## MyBatis的执行器有哪些

MyBatis提供了三种执行器：
- **SimpleExecutor**：每次执行都会创建一个新的预处理语句对象。
- **ReuseExecutor**：执行SQL时会复用预处理语句对象。
- **BatchExecutor**：用于批量执行SQL语句。

## MyBatis的懒加载

MyBatis的懒加载是一种延迟加载技术，当关联对象被真正访问时才加载它。通过在配置文件中设置`lazyLoadingEnabled`属性为`true`来启用懒加载。

# 映射器

## #{}和${}的区别

- **#{}**：使用预编译机制，可以防止SQL注入，将参数替换为占位符。
- **${}**：直接拼接SQL字符串，不进行预编译，容易导致SQL注入。

## 如何实现模糊查询

使用`LIKE`关键字进行模糊查询。例如：
```xml
<select id="findByName" resultType="User">
  SELECT * FROM users WHERE name LIKE #{name}
</select>
```
在传递参数时需要在Java代码中加上`%`：
```java
mapper.findByName("%name%");
```

## 在mapper中如何传递多个参数

可以使用`@Param`注解或者传递一个Map。例如：
```java
public List<User> findByAgeAndName(@Param("age") int age, @Param("name") String name);
```
或
```java
public List<User> findByAgeAndName(Map<String, Object> params);
```

## MyBatis如何执行批量操作

通过使用`<foreach>`标签来实现批量操作。例如批量插入：
```xml
<insert id="batchInsert">
  INSERT INTO users (name, age) VALUES
  <foreach collection="list" item="user" separator=",">
    (#{user.name}, #{user.age})
  </foreach>
</insert>
```

## 如何获取生成的主键

使用`useGeneratedKeys`和`keyProperty`属性。例如：
```xml
<insert id="insertUser" useGeneratedKeys="true" keyProperty="id">
  INSERT INTO users (name, age) VALUES (#{name}, #{age})
</insert>
```

## 什么是别名

别名是为Java类型设置的简短名称，方便在配置文件中使用。可以在配置文件中设置：
```xml
<typeAliases>
  <typeAlias alias="User" type="com.example.User"/>
</typeAliases>
```

## Mapper 编写有哪几种方式？

1. **XML方式**：通过XML配置文件定义SQL语句。
2. **注解方式**：在Mapper接口中使用注解定义SQL语句。
3. **混合方式**：同时使用XML和注解定义SQL语句。

## 什么是MyBatis的接口绑定？

接口绑定是指通过Mapper接口绑定SQL映射文件，实现面向接口编程。MyBatis会自动将接口方法与映射文件中的SQL语句进行关联。

## Xml映射文件中有哪些标签

常用的标签包括：
- **<select>**：查询语句。
- **<insert>**：插入语句。
- **<update>**：更新语句。
- **<delete>**：删除语句。
- **<resultMap>**：结果集映射。
- **<parameterMap>**：参数映射。
- **<sql>**：可重用的SQL片段。
- **<include>**：包含SQL片段。
- **<foreach>**：循环处理。
- **<if>**：条件判断。
- **<choose>**、<when>**、<otherwise>**：条件选择。

# 高级查询

## MyBatis实现一对一，一对多有几种方式，怎么操作的？

1. **一对一**：
   - 使用`association`标签映射。
   - 通过嵌套查询或嵌套结果映射。

2. **一对多**：
   - 使用`collection`标签映射。
   - 通过嵌套查询或嵌套结果映射。

示例：
```xml
<resultMap id="orderMap" type="Order">
  <id property="id" column="id"/>
  <result property="orderNumber" column="order_number"/>
  <association property="user" column="user_id" javaType="User" select="selectUser"/>
  <collection property="items" column="order_id" javaType="ArrayList" ofType="Item" select="selectItems"/>
</resultMap>
```

## Mybatis是否可以映射Enum枚举类？

可以，通过自定义TypeHandler来实现枚举类型的映射。例如：
```java
@MappedTypes(MyEnum.class)
public class MyEnumTypeHandler extends BaseTypeHandler<MyEnum> {
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, MyEnum parameter, JdbcType jdbcType) throws SQLException {
        ps.setString(i, parameter.name());
    }

    @Override
    public MyEnum getNullableResult(ResultSet rs,

 String columnName) throws SQLException {
        return MyEnum.valueOf(rs.getString(columnName));
    }

    @Override
    public MyEnum getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        return MyEnum.valueOf(rs.getString(columnIndex));
    }

    @Override
    public MyEnum getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        return MyEnum.valueOf(cs.getString(columnIndex));
    }
}
```

# 动态SQL

## Mybatis动态sql是做什么的？

MyBatis动态SQL用于根据条件动态生成不同的SQL语句，从而避免手写复杂的SQL拼接逻辑，提高SQL的灵活性和可读性。

## 都有哪些动态sql？

常见的动态SQL标签包括：
- **<if>**：条件判断。
- **<choose>**、<when>**、<otherwise>**：条件选择。
- **<trim>**、<where>**、<set>**：处理SQL片段。
- **<foreach>**：循环处理。
- **<bind>**：绑定参数。

## 动态sql的执行原理

动态SQL的执行原理是通过OGNL（Object-Graph Navigation Language）解析并根据上下文生成实际的SQL语句。MyBatis在解析映射文件时，会将动态SQL标签中的逻辑和条件编译成对应的代码片段，执行时根据传入参数的值动态生成最终的SQL。

# 插件模块

## Mybatis是如何进行分页的？

MyBatis通过分页插件实现分页查询。分页插件拦截SQL执行，根据分页参数修改SQL语句，实现数据的分页查询。

## 分页插件的原理是什么？

分页插件利用MyBatis的拦截器机制，在SQL执行前后拦截SQL语句，并根据分页参数（如`limit`和`offset`）修改SQL，实现分页查询。

# 缓存

## 一级缓存

一级缓存是SqlSession级别的缓存，默认开启。相同的SqlSession在执行相同查询时会从缓存中获取数据，而不是再次访问数据库。

## 二级缓存

二级缓存是Mapper级别的缓存，多个SqlSession共享。需要在配置文件中显式开启，二级缓存可以减少数据库访问，提高性能。

补充内容：

### MyBatis集成Spring

MyBatis可以与Spring框架无缝集成，通过Spring容器管理MyBatis的SqlSessionFactory和Mapper接口，实现事务管理和依赖注入。

### MyBatis的日志管理

MyBatis支持多种日志框架（如Log4j、SLF4J等），可以配置日志记录SQL语句和执行时间，便于调试和优化。

### MyBatis的异常处理

MyBatis会将所有的数据库操作异常转换为PersistenceException，可以通过自定义异常处理器对异常进行处理和日志记录。

以上是对MyBatis面试题的详细解答和补充，希望对你有所帮助。如果还有其他问题或需要更详细的解答，可以随时提问。