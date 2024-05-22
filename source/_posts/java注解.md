---
title: java注解
tag:
- java
---

# 什么是注解

注解(Annotation)是Java语言用于将元数据(metadata)与程序元素(类、方法、字段等)关联的一种机制。它提供了一种形式化的方法,使代码可以在编译期被特定的工具或编译器进行处理。注解本身不会直接影响程序的语义,但可以被用来生成辅助代码、校验程序逻辑等。

# 注解的作用

1. **编译时检查** - 通过注解表达约束条件,编译器可以检查这些约束是否被违反。例如`@Override`确保方法正确覆写。
2. **生成辅助代码** - 注解可以被工具处理,生成相关的辅助代码,如XML配置文件、代理类等。
3. **运行时处理** - 在运行时通过反射获取注解信息,并进行相应的处理,如缓存管理、权限控制等。

# 注解的分类

1. **Java内置注解** - Java语言内置的标准注解,如`@Override`、`@Deprecated`、`@SuppressWarnings`等。
2. **元注解** - 用于定义注解的注解,如`@Retention`、`@Target`、`@Inherited`、`@Documented`等。
3. **自定义注解** - 根据具体需求自行定义的注解。

# 元注解详解

元注解是用来定义其他注解的注解,它们可以嵌套地应用于其他注解上。常见的元注解包括:

- `@Retention` - 指定注解的保留策略,可选值为SOURCE(源码级别)、CLASS(class文件级别)和RUNTIME(运行时级别)。
- `@Target` - 指定注解可以应用的程序元素类型,如TYPE、METHOD、FIELD等。
- `@Inherited` - 指定注解是否可以被子类继承。
- `@Documented` - 指定注解是否可以被javadoc工具文档化。
- `@Repeatable` - 指定注解是否可以在同一个程序元素上重复使用。(Java 8新增)

# 自定义注解

自定义注解的步骤如下:

1. 使用`@interface`定义注解接口,声明注解的成员变量。
2. 使用元注解对注解进行配置,如`@Retention`、`@Target`等。
3. 在代码中使用自定义注解,为其成员变量赋值。
4. 通过反射获取注解信息,并进行相应的处理。

```java
java@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface CacheResult {
    String cacheKey() default ""; 
    long expireTime() default 30 * 60;
}

@CacheResult(cacheKey="#userId", expireTime=3600)
public User getUserInfo(String userId) {
    //...
}
```

# 注解的含义

## @Target

@Target元注解用于指定注解可以应用于哪些程序元素。它接受一个ElementType参数的数组,常用的ElementType值包括:

- ElementType.TYPE - 可应用于类、接口、枚举等
- ElementType.FIELD - 可应用于字段、枚举常量
- ElementType.METHOD - 可应用于方法
- ElementType.PARAMETER - 可应用于方法参数
- ElementType.CONSTRUCTOR - 可应用于构造函数
- ElementType.LOCAL_VARIABLE - 可应用于局部变量
- ElementType.ANNOTATION_TYPE - 可应用于注解类型

例如,@Target({ElementType.METHOD, ElementType.TYPE})表示该注解可以应用于方法和类/接口上。

## @Retention

@Retention元注解用于指定注解的生命周期,即注解信息在哪个级别被保留下来。它接受一个RetentionPolicy参数,常用的RetentionPolicy值包括:

- RetentionPolicy.SOURCE - 注解只保留在源代码级别,编译时被丢弃
- RetentionPolicy.CLASS - 注解保留在class文件级别,但在运行时会被JVM丢弃
- RetentionPolicy.RUNTIME - 注解可以在运行时被JVM保留,因此可以通过反射读取注解信息

@Retention(RetentionPolicy.RUNTIME)表示该注解在运行时可以被反射访问。 

# 注解的应用场景

1. **配置管理** - 使用注解配置替代XML文件,如Spring的`@Configuration`、`@Bean`等。
2. **ORM映射** - 使用注解描述对象与数据库表的映射,如JPA的`@Entity`、`@Table`等。
3. **校验约束** - 使用注解表达校验规则,如Bean Validation的`@NotNull`、`@Size`等。
4. **日志记录** - 使用注解标记需要记录日志的方法,如Log4j的`@Log`。
5. **缓存管理** - 使用注解标记需要缓存的方法及缓存策略。
6. **安全控制** - 使用注解控制方法的安全访问级别,如Spring Security的`@Secured`。
7. **异步处理** - 使用注解标记需要异步执行的方法,如Spring的`@Async`。
8. **事务管理** - 使用注解配置事务属性,如Spring的`@Transactional`。