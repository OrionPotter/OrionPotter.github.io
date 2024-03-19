---
title: java基础知识
---

# java语言的特点

+ 简单易学

+ 面向对象（封装，继承，多态）；

+ JVM实现了跨平台

+ 支持多线程编程

+ 具备异常处理和自动内存管理机制非常可靠性

+ 提供了多重安全防护机制如访问权限修饰符、限制程序直接访问操作系统资源保证了安全

+ 支持网络编程

+ 编译型与解释型语言并存

# SE和EE和ME的区别

+ SE 是java的标准版可以用用来构建桌面应用程序和简单的服务器应用程序

+ EE 是java的企业版提供了servlet、jdbc、jsp、jpa常用来构建web应用程序

+ ME 是java的微型版本，主要用于开发嵌入式应用程序，现在已经用不上了

# JVM和JDK和JRE

Java 虚拟机（JVM）是运行 Java 字节码的虚拟机。JVM 有针对不同系统的特定实现（Windows，Linux，macOS），目的是使用相同的字节码，它们都会给出相同的结果。字节码和不同系统的 JVM 实现是 Java 语言“一次编译，随处可以运行”的关键所在。

JDK（Java Development Kit），它是功能齐全的 Java SDK，是提供给开发者使用，能够创建和编译 Java 程序的开发套件。它包含了 JRE，同时还包含了编译 java 源码的编译器 javac 以及一些其他工具比如 javadoc（文档注释工具）、jdb（调试器）、jconsole（基于 JMX 的可视化监控⼯具）、javap（反编译工具）等等。

JRE（Java Runtime Environment） 是 Java 运行时环境。它是运行已编译 Java 程序所需的所有内容的集合，主要包括 Java 虚拟机（JVM）、Java 基础类库（Class Library）。

也就是说，JRE 是 Java 运行时环境，仅包含 Java 应用程序的运行时环境和必要的类库。而 JDK 则包含了 JRE，同时还包括了 javac、javadoc、jdb、jconsole、javap 等工具，可以用于 Java 应用程序的开发和调试。如果需要进行 Java 编程工作，比如编写和编译 Java 程序、使用 Java API 文档等，就需要安装 JDK。而对于某些需要使用 Java 特性的应用程序，如 JSP 转换为 Java Servlet、使用反射等，也需要 JDK 来编译和运行 Java 代码。因此，即使不打算进行 Java 应用程序的开发工作，也有可能需要安装 JDK。

<img src="https://telegraph-image-2ni.pages.dev/file/320e0df0b2e3f5989a10b.png" style="zoom: 50%;" />

总结：

1. JDK = JRE + java开发者工具
2. JRE = JVM + java基础类库

# 什么是字节码，字节码的好处？

经过javac编译后生成的.class文件叫字节码，字节码面向的是JVM，实现了一次编译，处处运行，在一定程度上解决了传统解释型语言执行效率低的问题，同时又保留了解释型语言可移植的特点。采用字节码对java程序来说是比较高效的。



# 为什么说 Java 语言“编译与解释并存

Java程序要经过先编译，后解释两个步骤，由javac进行编译，生成字节码（`.class` 文件），字节码必须由 Java 解释器来解释执行。

# java和c++的区别

1. Java没有指针，程序内存更加安全

2. java单继承，c++可以多继承

3. java有自动垃圾回收机制

# 注释

<img src="https://telegraph-image-2ni.pages.dev/file/8e39fd729ba83918652d7.png" style="zoom: 50%;" />

# 标识符和关键字的区别

类名、变量名、方法名这些名字是标识符，关键字就是被赋予特殊含义的标识符。

# 自增自减运算符

符号在前就先加/减，符号在后就后加/减

# 移位运算符

Java 中有三种移位运算符：

- `<<` :左移运算符，向左移若干位，高位丢弃，低位补零。`x << 1`,相当于 x 乘以 2(不溢出的情况下)。
- `>>` :带符号右移，向右移若干位，高位补符号位，低位丢弃。正数高位补 0,负数高位补 1。`x >> 1`,相当于 x 除以 2。
- `>>>` :无符号右移，忽略符号位，空位都以 0 补齐。

由于 `double`，`float` 在二进制中的表现比较特殊，因此不能来进行移位操作。

移位操作符实际上支持的类型只有`int`和`long`，编译器在对`short`、`byte`、`char`类型进行移位前，都会将其转换为`int`类型再操作

# continue、break、return的区别

continue:结束本次循环，继续执行下次循环

break：结束循环

return: 结束运行程序

# 数据类型

> **基本数据类型**
>
> 整型 byte short int long
>
> 浮点型 float double
>
> 字符型 char
>
> 布尔型 boolean
>
> **引用数据类型**
>
> 类（数组）
>
> 数组
>
> 接口



| 基本数据类型 | 字节数 | 位数 | 默认值  | 取值范围                      | 包装类    |
| ------------ | ------ | ---- | ------- | ----------------------------- | --------- |
| byte         | 1      | 1*8  | 0       | -2^(8-1)   到  2^(8-1)-1      | Byte      |
| short        | 2      | 2*8  | 0       | -2^(16-1)   到  2^(16-1)-1    | Short     |
| int          | 4      | 4*8  | 0       | -2^(32-1)   到  2^(32-1)-1    | Integer   |
| long         | 8      | 8*8  | 0L      | -2^(64-1)   到  2^(64-1)-1    | Long      |
| char         | 2      | 2*8  | 'u0000' | 0  到  2^(16-1)-1             | Character |
| float        | 4      | 4*8  | 0f      | 2的-149次方 到 2的128次方-1   | Float     |
| double       | 8      | 8*8  | 0d      | 2的-1074次方 到 2的1024次方-1 | Double    |
| boolean      |        | 1    | false   | true、flase                   | Boolean   |

浮点数在计算机中的存储

在计算机中，保存这个数使用的是[浮点表示法](https://www.zhihu.com/search?q=浮点表示法&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})，分为三大部分：

第一部分用来存储**符号位（sign），**用来区分正负数**，**这里是0，表示正数，第二部分用来存储**指数（exponent），**这里的指数是十进制的6，第三部分用来存储**小数（fraction），**这里的小数部分是001110011

需要注意的是，指数也有正负之分，后面再讲。

**如下图所示（图片来自**[维基百科](https://link.zhihu.com/?target=https%3A//zh.wikipedia.org/wiki/IEEE_754)**）：**



![img](https://pica.zhimg.com/80/v2-eee9bd4b0a050cc2d1e944db484c61bf_1440w.webp?source=1def8aca)



比如float类型是32位，是[单精度浮点](https://www.zhihu.com/search?q=单精度浮点&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})表示法：符号位（sign）占用1位，用来表示正负数，指数位（[exponent](https://www.zhihu.com/search?q=exponent&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})）占用8位，用来表示指数，小数位（fraction）占用23位，用来表示小数，不足位数补0。

而double类型是64位，是[双精度浮点表示法](https://www.zhihu.com/search?q=双精度浮点表示法&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})：符号位占用1位，指数位占用11位，小数位占用52位。

**指数位决定了大小范围**，因为[指数位](https://www.zhihu.com/search?q=指数位&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})能表示的数越大则能表示的数越大嘛！

**而小数位决定了计算精度**，因为小数位能表示的数越大，则能计算的精度越大

可以看到，像 `byte`、`short`、`int`、`long`能表示的最大正数都减 1 了。这是为什么呢？这是因为在二进制补码表示法中，最高位是用来表示符号的（0 表示正数，1 表示负数），其余位表示数值部分。所以，如果我们要表示最大的正数，我们需要把除了最高位之外的所有位都设为 1。如果我们再加 1，就会导致溢出，变成一个负数。

# 基本类型和包装类型的区别

用途：方法参数和变量类型一般用包装类型，很少用基本类型

存储方式：基本类型的成员变量存储在堆上，局部变量存储在栈上，包装类型都在堆上

占用空间：基本数据类型占用的空间小

默认值：包装类型的默认值是null,基本类型的有自己默认值，不是null

比较方式：包装类型使用 == 比较的是内存地址，基本类型 == 比较的是大小

```java
public static void main(String[] args) {
        Integer a = 33;
        Integer b = 33;
        Integer c = new Integer(33);
        Integer d = new Integer(33);
    	//包装类的缓存机制，两个引用都指向33
        System.out.println(a == b);
        System.out.println(a.equals(b));
        System.out.println(a == c);
        System.out.println(a.equals(c));
        System.out.println(c == d);
        System.out.println(c.equals(d));
    }
```



>**所有整型包装类对象之间值的比较，全部使用 equals 方法比较,内存地址比较用==**。

## 自动拆箱和装箱

>- **装箱**：将基本类型用它们对应的引用类型包装起来；
>- **拆箱**：将包装类型转换为基本数据类型；

```java
Integer i = 10;  //装箱 等价于 Integer i = Integer.valueOf(10)
int n = i;   //拆箱 等价于 int n = i.intValue();
```

## 浮点运算问题

## 精度丢失问题

>计算机是二进制的，而且计算机在表示一个数字时，宽度是有限的，无限循环的小数存储在计算机时，只能被截断，所以就会导致小数精度发生损失的情况。这也就是解释了为什么浮点数没有办法用二进制精确表示。

## 如何解决

>`BigDecimal` 可以实现对浮点数的运算，不会造成精度丢失。通常情况下，大部分需要浮点数精确运算结果的业务场景（比如涉及到钱的场景）都是通过 `BigDecimal` 来做的。



## 超过long整型的数据应该如何表示

```java
// 超过范围会变成最小值开始计算
 public static void main(String[] args) {
        long l = Long.MAX_VALUE;
        System.out.println(l + 1); // -9223372036854775808
        System.out.println(l + 1 == Long.MIN_VALUE); // true
        System.out.println(l + 100); //-9223372036854775709
        System.out.println(l + 100 == Long.MIN_VALUE); // false
        System.out.println(l + 10000); //-9223372036854765809
        System.out.println(l + 10000 == Long.MIN_VALUE); // false
    }
```



```java
// 从字符串创建一个BigInteger对象
BigInteger bigInt1 = new BigInteger("9999999999999999999999999999999");

// 或者使用长整型和其他类型转换为BigInteger
long longValue = Long.MAX_VALUE;
BigInteger bigInt2 = BigInteger.valueOf(longValue).add(BigInteger.ONE); // 超过long的最大值

// 使用BigInteger进行计算
BigInteger result = bigInt1.add(bigInt2);
```

# 变量

## 成员变量和局部变量的区别

**语法形式**：从语法形式上看，成员变量是属于类的，而局部变量是在代码块或方法中定义的变量或是方法的参数；成员变量可以被 `public`,`private`,`static` 等修饰符所修饰，而局部变量不能被访问控制修饰符及 `static` 所修饰；但是，成员变量和局部变量都能被 `final` 所修饰。

**存储方式**：从变量在内存中的存储方式来看，如果成员变量是使用 `static` 修饰的，那么这个成员变量是属于类的，如果没有使用 `static` 修饰，这个成员变量是属于实例的。而对象存在于堆内存，局部变量则存在于栈内存。

**生存时间**：从变量在内存中的生存时间上看，成员变量是对象的一部分，它随着对象的创建而存在，而局部变量随着方法的调用而自动生成，随着方法的调用结束而消亡。

**默认值**：从变量是否有默认值来看，成员变量如果没有被赋初始值，则会自动以类型的默认值而赋值（一种情况例外:被 `final` 修饰的成员变量也必须显式地赋值），而局部变量则不会自动赋值。

## 静态变量的作用

静态变量也就是被 `static` 关键字修饰的变量。它可以被类的所有实例共享，无论一个类创建了多少个对象，它们都共享同一份静态变量。也就是说，静态变量只会被分配一次内存，即使创建多个对象，这样可以节省内存。

## 字符型和字符串变量的区别

**形式** : 字符常量是单引号引起的一个字符，字符串常量是双引号引起的 0 个或若干个字符。

**含义** : 字符常量相当于一个整型值( ASCII 值),可以参加表达式运算; 字符串常量代表一个地址值(该字符串在内存中存放位置)。

**占内存大小**：字符常量只占 2 个字节; 字符串常量占若干个字节。

# 方法



## 什么是方法的返回值

>方法的返回值是获取到某个方法体执行后的结果，按照参数类型和返回值可以分为：
>
>1.无参无返回值方法
>
>2.无参有返回值方法
>
>3.有参无返回值方法
>
>4.有参有返回值方法

## 静态方法为什么调用非静态方法

静态方法是属于类的，在类加载的时候就会分配内存，可以通过类名直接访问。而非静态成员属于实例对象，只有在对象实例化之后才存在，需要通过类的实例对象去访问。

在类的非静态成员不存在的时候静态方法就已经存在了，此时调用在内存中还不存在的非静态成员，属于非法操作。

## 静态方法和实例方法的区别

调用方式：静态方法，直接类名.静态方法名，实例方法，必须先创建对象，对象.实例方法

访问限制：静态方法只可以访问静态变量或者静态方法，不能访问实例变量和实例方法，实例方法没有这个限制

# 可变长参数

Java 支持定义可变长参数，所谓可变长参数就是允许在调用方法时传入不定长度的参数。就比如下面的这个 `printVariable` 方法就可以接受 0 个或者多个参数。可变参数只能作为函数的最后一个参数，但其前面可以有也可以没有任何其他参数。**遇到方法重载的情况会优先匹配固定参数**

```java
public static void method1(String... args) {
   //......
}
//或者
public static void method2(String arg1, String... args) {
   //......
}
```



