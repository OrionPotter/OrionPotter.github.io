---
title: Java基础-常用类
tag:
- java
---

# Object类

## Object类的方法

```java
/**
 * native 方法，用于返回当前运行时对象的 Class 对象，使用了 final 关键字修饰，故不允许子类重写。
 */
public final native Class<?> getClass()
/**
 * native 方法，用于返回对象的哈希码，主要使用在哈希表中，比如 JDK 中的HashMap。
 */
public native int hashCode()
/**
 * 用于比较 2 个对象的内存地址是否相等，String 类对该方法进行了重写以用于比较字符串的值是否相等。
 */
public boolean equals(Object obj)
/**
 * native 方法，用于创建并返回当前对象的一份拷贝。
 */
protected native Object clone() throws CloneNotSupportedException
/**
 * 返回类的名字实例的哈希码的 16 进制的字符串。建议 Object 所有的子类都重写这个方法。
 */
public String toString()
/**
 * native 方法，并且不能重写。唤醒一个在此对象监视器上等待的线程(监视器相当于就是锁的概念)。如果有多个线程在等待只会任意唤醒一个。
 */
public final native void notify()
/**
 * native 方法，并且不能重写。跟 notify 一样，唯一的区别就是会唤醒在此对象监视器上等待的所有线程，而不是一个线程。
 */
public final native void notifyAll()
/**
 * native方法，并且不能重写。暂停线程的执行。注意：sleep 方法没有释放锁，而 wait 方法释放了锁 ，timeout 是等待时间。
 */
public final native void wait(long timeout) throws InterruptedException
/**
 * 多了 nanos 参数，这个参数表示额外时间（以纳秒为单位，范围是 0-999999）。 所以超时的时间还需要加上 nanos 纳秒。。
 */
public final void wait(long timeout, int nanos) throws InterruptedException
/**
 * 跟之前的2个wait方法一样，只不过该方法一直等待，没有超时时间这个概念
 */
public final void wait() throws InterruptedException
/**
 * 实例被垃圾回收器回收的时候触发的操作
 */
protected void finalize() throws Throwable { }
```



## == 和 equals的区别

1. `==`对于基本类型和引用类型是不同的
   + 基本数据类型：`==`比较的是值
   + 引用数据类型：`==`比较的是内存地址

>java只有值传递，没有引用传递，基本数据类型传递的是值，引用数据类型传递的是对象的内存地址

2. equals是object类的一个方法，所有类都有equals方法，默认调用的是`==`进行比较两个对象是否相等。

>`equals()`方法有两种用法，一种是没有重写equals方法，默认比较两个对象内存地址是否相等，一种是重写了equals方法，比较的是对象的值是否相等。
>
>如：Object类的equals()方法和String的equals()方法

```java
//Object类的equals()方法
public boolean equals(Object obj) {
        return (this == obj);
    }
//String的equals()方法
public boolean equals(Object anObject) {
    if (this == anObject) {
        return true;
    }
    if (anObject instanceof String) {
        String anotherString = (String)anObject;
        int n = value.length;
        if (n == anotherString.value.length) {
            char v1[] = value;
            char v2[] = anotherString.value;
            int i = 0;
            while (n-- != 0) {
                if (v1[i] != v2[i])
                    return false;
                i++;
            }
            return true;
        }
    }
    return false;
}
```

## hashcode的作用

>`hashcode（）`的作用是获取hash码（int 整数）也称散列码，这个hash码的作用是确定对象在hash表的位置,所有类都有这个函数
>
>`public native int hashCode();`



## 为什么要有hashcode，hashset是如何检查重复的

>提高执行效率，以hashset如何检查重复说明，怎么提高效率的，当把对象加入到hashset的时候，hashset会首先根据对象的hashcode值来判断加入的位置下标，如果下标位置没值就直接插入了，有值的话再调用equals方法判断两个对象是否相等，如果相等就不会让其加入，如果不相等就会重新散列到新的位置，这样做的好处是减少了equals执行次数，提高了执行效率。

总结：

如果两个对象的`hashCode` 值相等，那这两个对象不一定相等（哈希碰撞）。

如果两个对象的`hashCode` 值相等并且`equals()`方法也返回 `true`，我们才认为这两个对象相等。

如果两个对象的`hashCode` 值不相等，我们就可以直接认为这两个对象不相等。

## 为什么重写equals必须重写hashcode

>Java API规范要求：
>
>Object类中hashCode()方法的文档明确规定，如果两个对象通过equals()方法认为是相等的，那么它们必须产生相同的哈希码。这意味着当你自定义了对象的相等性规则（通过重写equals()方法），也应该相应地重写hashCode()方法以保持一致性。
>
>每个对象都有hashcode方法，可能会产生hash冲突，导致两个不同的对象，返回相同的hash码。
>
>如果equals（）方法判断两个对象相等，那么两个对象的hashcode肯定是相等的，如果重写equals（）方法，没有重写hashcode可能会导致，两个对象equals相等，hashcode不相同，不符合Java API规范。

总结：

- `equals` 方法判断两个对象是相等的，那这两个对象的 `hashCode` 值也要相等。
- 两个对象有相同的 `hashCode` 值，他们也不一定是相等的（哈希碰撞）。

# String类

## String属于基本数据类型吗？

>String是一个字符串对象，属于引用数据类型，不属于基本数据类型

## String常用的方法

### 获取类

`int length() 获取字符串长度`

`char charAt(int) 获取指定索引的字符` 

`int indexOf(String) 获取指定字符串的索引`

`int lastIndexOf(String) 获取指定字符串的最后一次的索引`

`String substring(int) 获取从指定坐标到最后的字符串` 

`String substring(int,int) 获取[int,int)的指定字符串`

`String concat(String) 获取拼接后的字符串`

### 判断类

`boolean equals(String) 判断两个字符串内容是否相同 ` 

`boolean equalsIgnoreCase(String) 忽略大小写，判断两个字符串内容是否相同`

`boolean contains(String) 判断字符串是否包含指定字符串`

`boolean startsWith(String) 判断字符串是否以指定字符串开始`

`boolean endsWith(String) 判断字符串是否以指定字符串结尾`

`boolean isEmpty() 判断字符串是否为空`

### 数组类

`byte[] getBytes() 字符串转为字节数组`

`char[] toCharArray() 字符串转为字符数组`

`String[] split(String) 将字符串按照指定字符串切割成字符串数组`

### 转换类

`String toUpperCase() 字符串转大写`

`String toLowerCase() 字符串转小写`

`String replace(String,String) 字符串替换，匹配方式：非正则表达式匹配。它会按照字面意义去查找和替换目标字符串，不解析任何特殊字符作为正则表达式元字符。`

`String replaceAll(String,String) 字符串全部替换，支持正则，匹配方式：正则表达式匹配。它可以识别并使用正则表达式的各种特殊字符和模式来匹配复杂的情况。`

`String repalceFirst(String,String) 字符串指替换第一次`

`String trim() 字符串将开头和结尾的空格剔除` 

## String、StringBuffer、StringBuilder的区别

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence { private final char value[]; }
public final class StringBuffer extends AbstractStringBuilder implements Serializable, CharSequence {}
public final class StringBuilder extends AbstractStringBuilder implements Serializable, CharSequence {}
```

### 可变性

String是不可变的，StringBuffer和StringBuilder是可变，这个可变指的是否对原对象内容是否变更

>String类中使用final修饰的字符数组存储字符串，是不可变的，StringBuffer和StringBuilder都继承了AbstractStringBuilder，内部通过char[] value;存储，所以说它们是可变的。
>
>final关键字修饰的类不能被继承，修饰的方法不能被重写，修饰的变量是基本数据类型则值不能改变，修饰的变量是引用类型则不能再指向其他对象。

### 线程安全

`String` 中的对象是不可变的，也就可以理解为常量，线程安全。`AbstractStringBuilder` 是 `StringBuilder` 与 `StringBuffer` 的公共父类，定义了一些字符串的基本操作，如 `expandCapacity`、`append`、`insert`、`indexOf` 等公共方法。`StringBuffer` 对方法加了同步锁或者对调用的方法加了同步锁，所以是线程安全的。`StringBuilder` 并没有对方法进行加同步锁，所以是非线程安全的。

### 性能

每次对 `String` 类型进行改变的时候，都会生成一个新的 `String` 对象，然后将指针指向新的 `String` 对象。`StringBuffer` 每次都会对 `StringBuffer` 对象本身进行操作，而不是生成新的对象并改变对象引用。相同情况下使用 `StringBuilder` 相比使用 `StringBuffer` 没有使用synchronized锁，性能有所提升，但多线程环境下存在安全风险。

### 总结

1. 操作少量的数据: 适用 `String`
2. 单线程操作字符串缓冲区下操作大量数据: 适用 `StringBuilder`
3. 多线程操作字符串缓冲区下操作大量数据: 适用 `StringBuffer`

## 字符串拼接用+还是StringBuilder

>字符串的+或者+=运算符，实质是生成一个StringBuilder对象，拼接后调用toString()方法后再生成一个字符串对象。如果频繁操作还是建议使用`StringBuilder` 对象进行字符串拼接。

## 字符串常量池

>在Java中，字符串常量池是一个特殊的内存区域（位于方法区），用于存储字符串字面量（也称为字符串常量）。当创建一个字符串对象时，如果它的值来源于字面量或者已经存在于字符串常量池中的字符串对象，则不会创建新的对象，而是直接引用池中的已存在对象，这样可以减少内存消耗并提升性能。

### 关于创建对象的个数，考虑以下几种场景：

1. 使用字面量创建字符串：String s1 = "abc"; String s2 = "abc";
   java在这种情况下，尽管有两个引用s1和s2，但在内存中只会有一个字符串对象"abc"存储在字符串常量池中。因为编译器会确保相同内容的字符串字面量只创建一次对象。
2. 使用new关键字创建字符串：String s3 = new String("abc");
   java使用new关键字创建字符串时，会在堆内存中创建一个新的字符串对象，即使"abc"已经存在于字符串常量池中也是如此。因此，这里会有两个对象，一个是常量池中的"abc"，另一个是在堆上新建的"abc"对象。
3. 使用intern()方法：String s4 = new String("abc").intern();
   java的intern()方法会尝试将当前字符串对象添加到字符串常量池中，如果常量池已有该字符串，则返回池中该字符串的引用。所以，如果上述代码运行时，常量池没有"abc"，则会将新建的"abc"对象的引用复制到常量池，并使s4指向常量池中的"abc"；如果有，则直接返回池中已有的"abc"引用，此时堆上的新对象可能会被垃圾回收。

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
