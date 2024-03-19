---
title: Java基础常用类
---

# 异常

>在 Java 中，运行时错误会作为异常抛出。异常是一种对象，表示阻止正常进行程序执行的错误或者情况。如果异常没有被处理，那么程序将会非正常终止,我们不能很明确的知道何原因导致程序异常终止。、

## 异常的类型

>异常的父类是Throwable有两个⼦类Exception和Error。
>
>Error是程序⽆法处理的错误，⼀旦出现这个错误，虚拟机将被迫停⽌运⾏。
>
>Exception不会导致程序停⽌，⼜分为两个部分RunTimeException运⾏时异常和CheckedException检查异常
>
>RunTimeException常常发⽣在程序运⾏过程中，会导致程序当前线程执⾏失败。CheckedException常常发⽣在程序编译过程中，会导致程序编译不通过。

<img src="https://telegraph-image-2ni.pages.dev/file/f5fc08365d6eedc7d186d.png" style="zoom: 50%;" />

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

>当出现异常我们要捕获并处理异常，或者抛出异常两种方式

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

>**Java 泛型（Generics）** 是 JDK 5 中引入的一个新特性。使用泛型参数，可以增强代码的可读性以及稳定性。

## 泛型的使用方式

**泛型类**

```java
public class Generic<T>{
    private T key;
}
//实例化泛型
Generic<Integer> genericInteger = new Generic<Integer>(123456);
```

**泛型接口**

```java
public interface Generator<T> {
    public T method();
}
//实现泛型接口，不指定类型
class GeneratorImpl<T> implements Generator<T>{
    @Override
    public T method() {
        return null;
    }
}
//实现泛型接口，指定类型
class GeneratorImpl<T> implements Generator<String>{
    @Override
    public String method() {
        return "hello";
    }
}
```

**泛型方法**

```java
// 创建不同类型数组：Integer, Double 和 Character
Integer[] intArray = { 1, 2, 3 };
String[] stringArray = { "Hello", "World" };
printArray( intArray  );
printArray( stringArray  );
```

## 项目中哪些使用泛型

1.前后端返回的统一接口CommonResult<T>

2.自定义的excel处理类ExcelUtil<T>动态的指定的类型导出数据





# 反射

## 什么是反射

>通过反射你可以获取任意一个类的所有属性和方法，还可以调用这些方法和属性。

## 反射的使用场景

>Spring/Spring Boot、MyBatis 等等框架中都大量使用了反射机制,下面为jdk动态代理



```java
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

>`Annotation` （注解） 是 Java5 开始引入的新特性，可以看作是一种特殊的注释，主要用于修饰类、方法或者变量，提供某些信息供程序在编译或者运行时使用。
>
>注解本质是一个继承了`Annotation` 的特殊接口：

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.SOURCE)
public @interface Override {
}
相当于
public interface Override extends Annotation{
}
```

>JDK 提供了很多内置的注解（比如 `@Override`、`@Deprecated`），同时，我们还可以自定义注解。

## 注解解析的方式

>注解只有被解析之后才会生效，常见的解析方法有两种：

- **编译期直接扫描**：编译器在编译 Java 代码的时候扫描对应的注解并处理，比如某个方法使用`@Override` 注解，编译器在编译的时候就会检测当前的方法是否重写了父类对应的方法。
- **运行期通过反射处理**：像框架中自带的注解(比如 Spring 框架的 `@Value`、`@Component`)都是通过反射来进行处理的。

# SPI

>SPI 即 Service Provider Interface ，字面意思就是：“服务提供者的接口”，我的理解是：专门提供给服务提供者或者扩展框架功能的开发者去使用的一个接口。
>
>SPI 将服务接口和具体的服务实现分离开来，将服务调用方和服务实现者解耦，能够提升程序的扩展性、可维护性。修改或者替换服务实现并不需要修改调用方。
>
>很多框架都使用了 Java 的 SPI 机制，比如：Spring 框架、数据库加载驱动、日志接口、以及 Dubbo 的扩展实现等等。

# 序列化

如果我们需要持久化 Java 对象比如将 Java 对象保存在文件中，或者在网络传输 Java 对象，这些场景都需要用到序列化。

简单来说：

- **序列化**：将数据结构或对象转换成二进制字节流的过程
- **反序列化**：将在序列化过程中所生成的二进制字节流转换成数据结构或者对象的过程

下面是序列化和反序列化常见应用场景：

- 对象在进行网络传输（比如远程方法调用 RPC 的时候）之前需要先被序列化，接收到序列化的对象之后需要再进行反序列化；
- 将对象存储到文件之前需要进行序列化，将对象从文件中读取出来需要进行反序列化；
- 将对象存储到数据库（如 Redis）之前需要用到序列化，将对象从缓存数据库中读取出来需要反序列化；
- 将对象存储到内存之前需要进行序列化，从内存中读取出来之后需要进行反序列化。

>**序列化的主要目的是通过网络传输对象或者说是将对象存储到文件系统、数据库、内存中。**

