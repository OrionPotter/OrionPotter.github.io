---
title: java基础知识
---

# java语言的特点



>java语言简单易学，跨平台，面向对象，支持多线程和网络编程，自动垃圾回收安全稳定。

# SE和EE和ME的区别

>Java SE（Standard Edition）是用于开发桌面、服务器和嵌入式设备的标准版Java平台；
>
>Java EE（Enterprise Edition）是用于构建企业级应用程序的扩展版Java平台；
>
>Java ME（Micro Edition）是用于开发嵌入式设备和移动设备上的应用程序的微型版Java平台。

# JVM和JDK和JRE

<img src="https://telegraph-image-2ni.pages.dev/file/320e0df0b2e3f5989a10b.png" style="zoom: 50%;" />

总结：

1. JDK = JRE + java开发者工具
2. JRE = JVM + java基础类库

>常用java开发者工具：javac(编译器)、javadoc（文档注释工具）、jdb（调试器）、jconsole（基于 JMX 的可视化监控⼯具）、javap（反编译工具）等
>
>常用java基础类库：java.lang包（包装类、字符串、异常）、java.util包（集合）、java.io包（文件）、java.math包（数学）、java.net包（网络编程）

# 什么是字节码，字节码的好处？

>javac编译器将.java源代码编译成.class文件，这个class文件叫字节码，字节码在JVM上运行，write once run anywhere，提高了程序的执行效率和可移植性。

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

# 位运算符

1. 按位与

>对两个操作数的每一位执行逻辑与操作，只有当两个操作数对应位都为1时，结果位才为1，否则为0。

2. 按位或

>对两个操作数的每一位执行逻辑或操作，只要两个操作数对应位中有一个为1，结果位就为1，否则为0。

3. 按位异或

>对两个操作数的每一位执行逻辑异或操作，当两个操作数对应位不相同时结果位为1，相同时结果位为0。

4. 按位非

>对操作数的每个位执行逻辑非操作，即0变为1，1变为0。

5. 左移

>将操作数的所有位向左移动指定的位数，右侧空出的位用0填充。`x << 1`,相当于 x 乘以 2

6. 带符号右移

>将操作数的所有位向右移动指定的位数，左侧空出的位用原来的最高位填充。对于有符号整数，符号位会保持不变。`x >> 1`,相当于 x 除以 2。

7. 无符号右移

>将操作数的所有位向右移动指定的位数，左侧空出的位用0填充。对于无符号整数，符号位也会移动。`x >>> 1`,相当于 x 除以 2。

**注意：**当两个相同的数做按位与和按位或操作时，结果都将是这个相同的数本身。当两个相同的数进行按位异或操作时，结果是0；而当一个数进行按位非操作时，结果是该数的每个位取反。

# continue、break、return的区别

continue:结束本次循环，继续执行下次循环

break：结束循环

return: 结束运行程序

# 原码和反码和补码

>原码：二进制编码
>
>反码：反码是一种简单的二进制编码方法，其中正数的编码与其原码相同，而负数的编码则是将其原码中的每一位取反（0变1，1变0）。
>
>补码：补码是计算机中最常用的表示有符号整数的方法。正数的补码和其原码相同，而负数的补码是其反码加1。
>
>总结：整数的原码等于反码等于补码，负数的补码等于负数的反码+1

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

>浮点数在计算机中的存储分为三部分分别是符号位（区分正负数，0是整数）、指数（幂次确定整数的范围）、小数（小数位确定了精度）
>
>比如float类型是32位，是[单精度浮点](https://www.zhihu.com/search?q=单精度浮点&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})表示法：符号位（sign）占用1位，用来表示正负数，指数位（[exponent](https://www.zhihu.com/search?q=exponent&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})）占用8位，用来表示指数，小数位（fraction）占用23位，用来表示小数，不足位数补0。
>
>而double类型是64位，是[双精度浮点表示法](https://www.zhihu.com/search?q=双精度浮点表示法&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})：符号位占用1位，指数位占用11位，小数位占用52位。

可以看到，像 `byte`、`short`、`int`、`long`能表示的最大正数都减 1 了。这是为什么呢？

>对于 Java 中的整数类型（如 byte、short、int、long），其二进制表示中最高位是符号位，0 表示正数，1 表示负数。因此，如果要表示最大的正数，需要将除了最高位之外的所有位都设为 1。但是由于最高位已经被用于表示符号，所以在表示正数时，最大值需要减去一个单位，以确保不会溢出变成负数。

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



>**总结：所有整型包装类对象之间值的比较，全部使用 equals 方法比较,内存地址比较用==**。

## 自动拆箱和装箱

>- **装箱**：将基本类型用它们对应的引用类型包装起来；
>- **拆箱**：将包装类型转换为基本数据类型；

```java
Integer i = 10;  //装箱 等价于 Integer i = Integer.valueOf(10)
int n = i;   //拆箱 等价于 int n = i.intValue();
```

## 浮点运算，精度丢失问题

>计算机是二进制的，而且计算机在表示一个数字时，宽度是有限的，无限循环的小数存储在计算机时，只能被截断，所以就会导致小数精度发生损失的情况。这也就是解释了为什么浮点数没有办法用二进制精确表示。
>
>如何解决：`BigDecimal` 可以实现对浮点数的运算，不会造成精度丢失。通常情况下，大部分需要浮点数精确运算结果的业务场景（比如涉及到钱的场景）都是通过 `BigDecimal` 来做的。

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
解决方案：使用BigInteger存储
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

**访问修饰符：**成员变量可以被 `public`,`private`,`static` 等修饰符所修饰，而局部变量不能被访问控制修饰符及 `static` 所修饰；但是，成员变量和局部变量都能被 `final` 所修饰。

**作用域：**成员变量的作用域是整个类，局部变量作用域是方法中

**存储方式**：成员变量在堆内存中随对象消失而消失，局部变量在栈内存中随方法执行结束消失

**默认值**：成员变量如果没有被赋初始值，则会自动以类型的默认值而赋值（一种情况例外:被 `final` 修饰的成员变量也必须显式地赋值），而局部变量则不会自动赋值，在使用之前显式地初始化。

## 静态变量的作用

静态变量也就是被 `static` 关键字修饰的变量。它可以被类的所有实例共享，无论一个类创建了多少个对象，它们都共享同一份静态变量。也就是说，静态变量只会被分配一次内存，即使创建多个对象，这样可以节省内存。

## 字符型和字符串变量的区别

**形式** : 字符常量是单引号引起的一个字符，字符串常量是双引号引起的 0 个或若干个字符。

**含义** : 字符常量相当于一个整型值( ASCII 值),可以参加表达式运算; 字符串常量代表一个地址值(该字符串在内存中存放位置)。

**占内存大小**：字符常量只占 2 个字节; 字符串常量占若干个字节。

# 方法

## 静态方法可以调用非静态方法吗

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

# 形参和实参

形参：是一个形式参数，主要定义在方法中，用来接收实参，没有确定的值。

实参：是一个实际的参数，用来传递给方法的参数，有确定的值。

# 值传递和引用传递

值传递：传递的是实参值的拷贝，会创建一个副本。

引用传递：传递的引用对象在内存中的地址，不会创建副本，对形参的修改会影响实参。

>Java 中只有值传递，是没有引用传递的。
>
>- 如果参数是基本类型的话，很简单，传递的就是基本类型的字面量值的拷贝，会创建副本。
>- 如果参数是引用类型，传递的就是实参所引用的对象在堆中地址值的拷贝，同样也会创建副本

