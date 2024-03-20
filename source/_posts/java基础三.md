---
title: Java基础常用类
---

# 异常

> 异常是在程序执行过程中遇到的一种意外情况或错误，它会干扰正常的程序执行流程。

## 异常的类型

> 异常的父类是Throwable有两个⼦类Exception和Error。
>
> Error是程序⽆法处理的错误，⼀旦出现这个错误，虚拟机将被迫停⽌运⾏。
>
> Exception不会导致程序停⽌，⼜分为两个部分RunTimeException运⾏时异常和CheckedException检查异常
>
> RunTimeException常常发⽣在程序运⾏过程中，会导致程序当前线程执⾏失败。CheckedException常常发⽣在程序编译过程中，会导致程序编译不通过。

<img src="https://telegraph-image-2ni.pages.dev/file/f5fc08365d6eedc7d186d.png" alt="img" style="zoom:50%;" />

## Throwable类的常用方法

```java
//返回异常发生时的简要描述
public String getMessage() {
        return detailMessage;
    }
//返回异常发生时的详细信息
public String toString() {
        String s = getClass().getName();
        String message = getLocalizedMessage();
        return (message != null) ? (s + ": " + message) : s;
    }
//在控制台上打印 Throwable 对象封装的异常信息
public void printStackTrace() {
        printStackTrace(System.err);
    }
```

## 异常处理

> 当出现异常我们要捕获并处理异常，或者抛出异常两种方式

**1.抛出异常**

```java
public void test() throws IOException { }
public void test2(){ throw  new RuntimeException("异常了");}
```

**2.捕获并处理**

```java
//使用try-catch代码块捕获并处理异常
public  void test(){
       try {
           int a = 1/0;
       }catch (Exception e){
           System.out.println("0不能做除数");
           e.printStackTrace();
       }
}
//也可以使用try-catch-finally finally代码块中一般出现异常也会执行，常用来进行资源的关闭
//使用try-with-source替代try-catch-finally代码更简短，更清晰，会自动进行资源的关闭
```

# 泛型

> 泛型（Generics）是Java中一种参数化类型的概念，它允许在定义类、接口和方法时使用类型参数。通过泛型，可以使类、接口和方法在定义时不指定具体的数据类型，而是在实例化或调用时再指定具体的类型。
>
> 使用泛型的主要目的是提高代码的灵活性、可重用性和安全性，同时减少重复代码的编写。泛型可以在编译时进行类型检查，避免在运行时出现类型转换错误，提高了代码的安全性。

## 泛型的使用方式

**泛型类**：使用泛型参数化的类，可以在定义时指定类型参数。

```java
class MyClass<T> {
    // 泛型类中的方法或成员变量可以使用泛型类型参数T
    private T value;

    public T getValue() {
        return value;
    }

    public void setValue(T value) {
        this.value = value;
    }
}
```

**泛型接口**：使用泛型参数化的接口，可以在实现时指定类型参数。

```java
interface MyInterface<T> {
    T getValue();
    void setValue(T value);
}
```

**泛型方法**：在方法定义中使用泛型参数，可以在调用时指定具体的类型参数。

```java
class Utils {
    public static <T> T getLastElement(List<T> list) {
        if (list.isEmpty()) {
            return null;
        }
        return list.get(list.size() - 1);
    }
}
```

## 项目中哪些使用泛型

1.前后端返回的统一接口CommonResult

2.自定义的excel处理类ExcelUtil动态的指定的类型导出数据

3.集合类，例如，`ArrayList<String>`表示一个只能存储字符串类型的ArrayList。

# 反射

## 什么是反射（Reflection）

> 允许在运行时动态地检查类、获取类的信息（如字段、方法、构造函数等），以及调用类的方法、访问或修改类的属性等。

## 反射可以做什么

1. **获取类的信息**：可以获取类的名称、包名、父类、实现的接口等信息。
2. **获取类的字段（Field）信息**：可以获取类中定义的字段的名称、类型、修饰符等信息。
3. **获取类的方法（Method）信息**：可以获取类中定义的方法的名称、参数类型、返回类型、修饰符等信息。
4. **获取类的构造函数信息**：可以获取类中定义的构造函数的参数类型、修饰符等信息。
5. **动态调用方法**：可以在运行时动态地调用类的方法，传递参数并获取返回值。
6. **动态创建对象**：可以在运行时动态地创建类的对象，并对对象进行操作。

## 反射的使用场景

1. **框架和库**：许多Java框架和库，如Spring框架、Hibernate ORM框架等，都广泛使用了反射。框架需要在运行时动态地加载和操作类，以实现诸如依赖注入、AOP（面向切面编程）、ORM（对象关系映射）等功能。
2. **动态代理**：反射可以用来创建动态代理对象，实现动态地在运行时生成代理类并拦截方法调用，用于实现诸如远程调用、事务管理等功能。
3. **序列化和反序列化**：Java中的序列化和反序列化机制通常使用了反射来动态地读取和写入对象的字段信息，以实现对象的序列化和反序列化。
4. **单元测试**：在单元测试中，反射可以用来访问私有方法、私有字段等，以便进行单元测试。
5. **注解处理器**：反射可以用来解析和处理注解，例如编写自定义的注解处理器，根据注解来生成代码或进行其他操作。
6. **工具类**：一些工具类或开发工具（如IDE）可能会使用反射来获取和操作类的信息，以实现一些功能，例如自动生成代码、代码检查、代码重构等。
7. **动态加载类**：反射可以用来动态加载类和资源文件，例如通过ClassLoader动态加载类、读取配置文件等。

```java
//下面为jdk动态代理，通过反射实现的
public class DebugInvocationHandler implements InvocationHandler {
    /**
     * 代理类中的真实对象
     */
    private final Object target;

    public DebugInvocationHandler(Object target) {
        this.target = target;
    }

    public Object invoke(Object proxy, Method method, Object[] args) throws InvocationTargetException, IllegalAccessException {
        System.out.println("before method " + method.getName());
        Object result = method.invoke(target, args);
        System.out.println("after method " + method.getName());
        return result;
    }
}
```

# 注解

## 什么是注解

> `Annotation` （注解） 是 Java5 开始引入的新特性，可以看作是一种特殊的注释，主要用于修饰类、方法或者变量，提供某些信息供程序在编译或者运行时使用。
>
> 注解本质是一个继承了`Annotation` 的特殊接口：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
相当于
public interface Override extends Annotation{
}
```

> JDK 提供了很多内置的注解（比如 `@Override`、`@Deprecated`），同时，我们还可以自定义注解。

## 注解解析的方式

> 注解只有被解析之后才会生效，常见的解析方法有两种：

- **编译期直接扫描**：编译器在编译 Java 代码的时候扫描对应的注解并处理，比如某个方法使用`@Override` 注解，编译器在编译的时候就会检测当前的方法是否重写了父类对应的方法。
- **运行期通过反射处理**：像框架中自带的注解(比如 Spring 框架的 `@Value`、`@Component`)都是通过反射来进行处理的。

## 注解的使用场景

1. **代码说明和文档生成**：可以使用注解来添加说明、作者、版本等信息，帮助理解和使用代码，也可以通过注解生成文档。
2. **编译时检查**：可以使用注解进行编译时的静态检查，例如 `@Override` 注解用于检查是否正确覆盖了父类的方法。
3. **运行时处理**：可以使用注解在运行时进行处理，例如依赖注入、AOP（面向切面编程）、配置解析等。
4. **代码生成**：可以使用注解来生成代码或配置文件，例如使用注解来配置ORM框架。
5. **元数据处理**：可以使用注解获取和处理类、方法、字段等的元数据信息，例如自定义注解处理器。

# SPI

> SPI 即 Service Provider Interface ，字面意思就是：“服务提供者的接口”，我的理解是：专门提供给服务提供者或者扩展框架功能的开发者去使用的一个接口。
>
> SPI 将服务接口和具体的服务实现分离开来，将服务调用方和服务实现者解耦，能够提升程序的扩展性、可维护性。修改或者替换服务实现并不需要修改调用方。
>
> 很多框架都使用了 Java 的 SPI 机制，比如：Spring 框架、数据库加载驱动、日志接口、以及 Dubbo 的扩展实现等等。

# 序列化

> 序列化是指将对象转换为字节流的过程，以便将其存储到文件中、通过网络传输或在内存中进行传递。序列化的主要目的是将对象的状态保存下来，以便在需要时可以重新创建对象或者传输对象数据。
>
> 在Java中，序列化是通过实现Serializable接口来实现的。Serializable接口是一个标记接口，没有任何方法，它只是用于指示Java虚拟机这个类可以被序列化。当一个类实现了Serializable接口后，它的对象就可以被序列化成字节流，从而可以进行持久化存储或网络传输。

简单来说：

- **序列化**：将数据结构或对象转换成二进制字节流的过程
- **反序列化**：将在序列化过程中所生成的二进制字节流转换成数据结构或者对象的过程

下面是序列化和反序列化常见应用场景：

- 对象在进行网络传输（比如远程方法调用 RPC 的时候）之前需要先被序列化，接收到序列化的对象之后需要再进行反序列化；
- 将对象存储到文件之前需要进行序列化，将对象从文件中读取出来需要进行反序列化；
- 将对象存储到数据库（如 Redis）之前需要用到序列化，将对象从缓存数据库中读取出来需要反序列化；
- 将对象存储到内存之前需要进行序列化，从内存中读取出来之后需要进行反序列化。
