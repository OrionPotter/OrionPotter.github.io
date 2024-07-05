---
title: java基础
tag:
- java
---

# 常识

## java语言的特点

>java语言简单易学，跨平台，面向对象，支持多线程和网络编程，自动垃圾回收安全稳定。

## SE和EE和ME的区别

>Java SE（Standard Edition）是用于开发桌面、服务器和嵌入式设备的标准版Java平台；
>
>Java EE（Enterprise Edition）是用于构建企业级应用程序的扩展版Java平台；
>
>Java ME（Micro Edition）是用于开发嵌入式设备和移动设备上的应用程序的微型版Java平台。

## JVM和JDK和JRE

<img src="https://telegraph-image-2ni.pages.dev/file/320e0df0b2e3f5989a10b.png" style="zoom: 50%;" />

总结：

1. JDK = JRE + java开发者工具
2. JRE = JVM + java基础类库

>常用java开发者工具：javac(编译器)、javadoc（文档注释工具）、jdb（调试器）、jconsole（基于 JMX 的可视化监控⼯具）、javap（反编译工具）等
>
>常用java基础类库：java.lang包（包装类、字符串、异常）、java.util包（集合）、java.io包（文件）、java.math包（数学）、java.net包（网络编程）

## 什么是字节码，字节码的好处？

>javac编译器将.java源代码编译成.class文件，这个class文件叫字节码，字节码在JVM上运行，write once run anywhere，提高了程序的执行效率和可移植性。

## 为什么说 Java 语言“编译与解释并存

Java程序要经过先编译，后解释两个步骤，由javac进行编译，生成字节码（`.class` 文件），字节码必须由 Java 解释器来解释执行。

## java和c++的区别

1. Java没有指针，程序内存更加安全

2. java单继承，c++可以多继承

3. java有自动垃圾回收机制

# 基本语法

## 注释

<img src="https://telegraph-image-2ni.pages.dev/file/8e39fd729ba83918652d7.png" style="zoom: 50%;" />

## 标识符和关键字的区别

类名、变量名、方法名这些名字是标识符，关键字就是被赋予特殊含义的标识符。

## 运算符

### 自增自减运算符

符号在前就先加/减，符号在后就后加/减

### 位运算符

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

>将操作数的所有位向右移动指定的位数，左侧空出的位用0填充。对于无符号整数，符号位也会移动。`x >>> 1`,相当于 x 除以 2。如果是负数会变为最大数

**注意：**当两个相同的数做按位与和按位或操作时，结果都将是这个相同的数本身。当两个相同的数进行按位异或操作时，结果是0；而当一个数进行按位非操作时，结果是该数的每个位取反。

## continue、break、return的区别

continue:结束本次循环，继续执行下次循环

break：结束循环

return: 结束运行程序

## 原码和反码和补码

>数字是以补码的形式存在计算机中，正数三码合一，负数反码符号位取反，补码加1

**原码**：数字二进制位的最高位为符号位，0为正数，1为负数，其余位表示数字的值。

**反码**：正数的反码和原码是一致的，负数的反码是除符号位其余位取反。

**补码**：正数的补码和原码是一致的，负数的补码是在反码的基础上加1。

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
| boolean      | 1      | 8    | false   | true、flase                   | Boolean   |

>浮点数在计算机中的存储分为三部分分别是符号位（区分正负数，0是整数）、指数（幂次确定整数的范围）、小数（小数位确定了精度）
>
>比如float类型是32位，是[单精度浮点](https://www.zhihu.com/search?q=单精度浮点&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})表示法：符号位（sign）占用1位，用来表示正负数，指数位（[exponent](https://www.zhihu.com/search?q=exponent&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})）占用8位，用来表示指数，小数位（fraction）占用23位，用来表示小数，不足位数补0。
>
>而double类型是64位，是[双精度浮点表示法](https://www.zhihu.com/search?q=双精度浮点表示法&search_source=Entity&hybrid_search_source=Entity&hybrid_search_extra={"sourceType"%3A"answer"%2C"sourceId"%3A221485161})：符号位占用1位，指数位占用11位，小数位占用52位。
>
>在Java中，布尔类型的数据占用的空间是规定为1字节（8位）。然而，Java虚拟机在处理布尔值时可能会进行优化，因此实际上只用一个位来存储布尔值就足够了，但在内存中它仍然占用1字节。这是因为Java虚拟机处理内存时，以字节为最小单位进行管理，所以即使一个布尔值只需要一个位，它在内存中仍然会占用整个字节的空间。

可以看到，像 `byte`、`short`、`int`、`long`能表示的最大正数都减 1 了。这是为什么呢？

>对于 Java 中的整数类型（如 byte、short、int、long），其二进制表示中最高位是符号位，0 表示正数，1 表示负数。因此，如果要表示最大的正数，需要将除了最高位之外的所有位都设为 1。但是由于最高位已经被用于表示符号，所以在表示正数时，最大值需要减去一个单位，以确保不会溢出变成负数。

## 基本类型和包装类型的区别

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

**包装类的equals()重写过，比较值全部使用 equals 方法比较,比较内存地址用==**

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

**注意：超过long以后会从导致溢出，会从最小值开始算**

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

**解决方案：**

1. 从字符串创建一个BigInteger对象：

   `BigInteger bigInt1 = new BigInteger("9999999999999999999999999999999");`

2. 使用长整型或者其他类型转换为BigInteger:

   `long longValue = Long.MAX_VALUE;`

   `BigInteger bigInt2 = BigInteger.valueOf(longValue).add(BigInteger.ONE);`

   `BigInteger result = bigInt1.add(bigInt2);`



# 类结构

## 变量

### 成员变量和局部变量的区别

**访问修饰符：**成员变量可以被 `public`,`private`,`static` 等修饰符所修饰，而局部变量不能被访问控制修饰符及 `static` 所修饰；但是，成员变量和局部变量都能被 `final` 所修饰。

**作用域：**成员变量的作用域是整个类，局部变量作用域是方法中

**默认值**：成员变量如果没有被赋初始值，则会自动以类型的默认值而赋值（一种情况例外:被 `final` 修饰的成员变量也必须显式地赋值），而局部变量则不会自动赋值，在使用之前显式地初始化。

### 静态变量的作用

静态变量也就是被 `static` 关键字修饰的变量。它可以被类的所有实例共享，无论一个类创建了多少个对象，它们都共享同一份静态变量。也就是说，静态变量只会被分配一次内存，即使创建多个对象，这样可以节省内存。

### 字符型和字符串变量的区别

**形式** : 字符常量是单引号引起的一个字符，字符串常量是双引号引起的 0 个或若干个字符。

**含义** : 字符常量相当于一个整型值( ASCII 值),可以参加表达式运算; 字符串常量代表一个地址值(该字符串在内存中存放位置)。

**占内存大小**：字符常量只占 2 个字节; 字符串常量占若干个字节。

## 方法

### 静态方法可以调用非静态方法吗

静态方法是属于类的，在类加载的时候就会分配内存，可以通过类名直接访问。而非静态成员属于实例对象，只有在对象实例化之后才存在，需要通过类的实例对象去访问。

在类的非静态成员不存在的时候静态方法就已经存在了，此时调用在内存中还不存在的非静态成员，属于非法操作。

### 静态方法和实例方法的区别

调用方式：静态方法，直接类名.静态方法名，实例方法，必须先创建对象，对象.实例方法

访问限制：静态方法只可以访问静态变量或者静态方法，不能访问实例变量和实例方法，实例方法没有这个限制

## 参数

### 可变长参数

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

### 形参和实参

形参：是一个形式参数，主要定义在方法中，用来接收实参，没有确定的值。

实参：是一个实际的参数，用来传递给方法的参数，有确定的值。

### 值传递和引用传递

值传递：传递的是实参值的拷贝，会创建一个副本。

引用传递：传递的引用对象在内存中的地址，不会创建副本，对形参的修改会影响实参。

>Java 中只有值传递，是没有引用传递的。
>
>- 如果参数是基本类型的话，很简单，传递的就是基本类型的字面量值的拷贝，会创建副本。
>- 如果参数是引用类型，传递的就是实参所引用的对象在堆中地址值的拷贝，同样也会创建副本

# 面向对象

## 什么是面向对象

面向对象编程，OOP（Object Oriented Programming）它是一种编程思想，把数据和行为封装成一个对象，以模拟现实世界的实体和交互。

## 如何区分面向对象和面向过程

- 面向过程：将问题看作一系列步骤，通过一个个方法执行解决问题，重点在于算法和流程控制。
- 面向对象：将问题拆分成一系列对象，这些对象有自己的属性和方法，通过对象间方法调用解决问题，重点在于封装、继承和多态，以及对象之间的关系。

## 对象实例和对象引用的区别

- 对象实例：在程序运行时new关键字创建的对象，存储在堆内存中，具有属性和方法。
- 对象引用：指向对象实例的变量，存储在栈中，它存储的是对象实例内存地址。

> 一般说的对象相等指的是对象实例相等，指的是两个对象实例在内存中的内容是一致的，引用相等指的两个或多个引用指向同一个对象实例，比较的是内存地址。
>
> - 一个对象引用可以指向0个或者1个对象实例
> - 一个对象实例可以被多个对象引用指向

## 构造方法

> 构造方法（Constructor）是一种特殊类型的方法，用于在创建对象实例时初始化对象的状态。构造方法的名称必须与类名相同，并且没有返回类型（甚至不是void），因为它们不返回任何值。
>
> 如果一个类没有明确定义构造方法，编译器会自动生成一个默认的无参构造方法，该构造方法仅仅执行了一些默认的初始化操作。但是，如果你显式地定义了构造方法，编译器就不会再生成默认构造方法，所以需要注意是否需要手动提供无参构造方法。

1. **初始化对象**：构造方法用于初始化新创建的对象实例的状态。它们通常会对对象的属性进行初始化，以确保对象在创建后处于一种合适的初始状态。
2. **与类名相同**：构造方法的名称必须与类名完全相同，包括大小写。这是为了告诉编译器这个方法是一个构造方法。
3. **没有返回类型**：构造方法没有返回类型，甚至不是void。这是因为构造方法的目的不是返回值，而是初始化对象实例。
4. **可以重载**：一个类可以有多个构造方法，它们可以根据参数列表的不同进行重载。这使得我们可以根据不同的需求来创建对象实例。

## 重写与重载

重写（Override）：子类重写父类的方法，但是方法的名称、参数列表、返回类型和父类保持一致，只改变方法体的内容，实现多态性。

重载（Overload）：同一个类中定义多个有相同名称但参数列表（参数的个数、顺序、类型）不同的方法，可以根据不同的参数列表调用不同的方法。

## 面向对象的特性

### 封装

> 封装是把对象的属性和方法封装成一个类，通过封装可以把一个对象的属性隐藏在对象内部，对外提供公共的接口（方法）来操作内部数据，以保护数据安全，防止外部直接修改。

### 继承

> 继承是在已存在的类的基础上创建子类，子类可以实现自己的属性和方法，也可以用父类的功能，但不能选择性地继承父类。通过使用继承，可以快速地创建新的类，可以提高代码的重用。

1. 子类拥有父类对象所有的属性和方法（包括私有属性和私有方法），但是父类中的私有属性和方法子类是无法访问，**只是拥有**。
2. 子类可以拥有自己属性和方法，即子类可以对父类进行扩展。
3. 子类可以用自己的方式实现父类的方法。（以后介绍）。

### 多态

> 多态是指对象在不同情况下可以以不同的形态呈现出来，体现在方法的重写上，子类重写父类的方法，父类的引用指向子类的实例并且调用子类重写的方法。

Java实现多态有三个必要条件：继承、重写、向上转型。

继承：在多态中必须存在有继承关系的子类和父类。

重写：子类对父类中某些方法进行重新定义，在调用这些方法时就会调用子类的方法。

向上转型：是指子类对象可以赋值给父类引用变量，会调用子类的重写的方法。

## 接口和抽象类的区别

> 接口：通过interface关键字来表明这是接口，定义了一组抽象方法，没有具体的实现，方法默认是public abstract修饰、变量默认为public static final修饰
>
> 抽象类：通过abstract关键字来表明这是接口，既可以包含抽象方法也可以包含非抽象方法，可以有构造函数，也可以有成员变量，作为一个基类，提供通用功能的实现，但直接不能被实例化。

相同点：

1. **抽象性**：接口和抽象类都是抽象的，不能直接实例化。
2. **模板性**：接口和抽象类都可以作为其他类的模板或基类，提供通用的行为规范或实现。
3. **多态性**：接口和抽象类都支持多态性，即同一方法调用可能会有不同的实现，具体取决于对象的类型。
4. **扩展性**：接口和抽象类都可以被子类实现或继承，并且可以通过添加新的方法或修改现有的方法来扩展功能。

区别：

1. 方法：
   - **接口**：只有抽象方法，但不包含方法的具体实现。
   - **抽象类**：可以有抽象方法，也可以有非抽象方法
2. 构造函数：
   - 抽象类可以有构造函数，而接口不能有构造函数。
3. 继承：
   - **接口**：多实现
   - **抽象类**：单继承，继承具有传递性。
4. 变量：
   - **接口**：变量默认是public static final的
   - **抽象类**：可以定义实例变量，可以是各种访问修饰符。
5. 使用场景：
   - **接口**：如果不同的类需要具有相似但不同的行为，可以考虑使用接口来实现。
   - **抽象类**：如果多个类有相似的行为，可以将这些行为提取到一个抽象类中，并让这些类继承该抽象类来实现代码复用。

## 深拷贝、浅拷贝、引用拷贝

深拷贝和浅拷贝都是指对对象的拷贝，例如一个对象如果有两种类型的属性，基本数据类型和引用数据类型

浅拷贝（**Shallow Copy**）就是指会拷贝基本数据类型的值，以及引用数据类型的引用，不会拷贝引用数据类型指向的对象，浅拷贝出来的对象内部的引用数据类型指向原来对象，通过clone()方法可以实现

深拷贝（**Deep Copy**）即会拷贝基本数据类型的值，也会拷贝引用数据类型指向的对象，是完全都复制了一份，通过递归复制或者序列化和反序列化实现。

引用拷贝（**Reference Copy**）就是两个不同的引用指向同一个对象。

# 常用类

## Object类

### Object类的方法

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



### == 和 equals的区别

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

### hashcode的作用

>`hashcode（）`的作用是获取hash码（int 整数）也称散列码，这个hash码的作用是确定对象在hash表的位置,所有类都有这个函数
>
>`public native int hashCode();`



### 为什么要有hashcode，hashset是如何检查重复的

>提高执行效率，以hashset如何检查重复说明，怎么提高效率的，当把对象加入到hashset的时候，hashset会首先根据对象的hashcode值来判断加入的位置下标，如果下标位置没值就直接插入了，有值的话再调用equals方法判断两个对象是否相等，如果相等就不会让其加入，如果不相等就会重新散列到新的位置，这样做的好处是减少了equals执行次数，提高了执行效率。

总结：

如果两个对象的`hashCode` 值相等，那这两个对象不一定相等（哈希碰撞）。

如果两个对象的`hashCode` 值相等并且`equals()`方法也返回 `true`，我们才认为这两个对象相等。

如果两个对象的`hashCode` 值不相等，我们就可以直接认为这两个对象不相等。

### 为什么重写equals必须重写hashcode

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

## String类

### String属于基本数据类型吗？

>String是一个字符串对象，属于引用数据类型，不属于基本数据类型

### String常用的方法

#### 获取类

`int length() 获取字符串长度`

`char charAt(int) 获取指定索引的字符` 

`int indexOf(String) 获取指定字符串的索引`

`int lastIndexOf(String) 获取指定字符串的最后一次的索引`

`String substring(int) 获取从指定坐标到最后的字符串` 

`String substring(int,int) 获取[int,int)的指定字符串`

`String concat(String) 获取拼接后的字符串`

#### 判断类

`boolean equals(String) 判断两个字符串内容是否相同 ` 

`boolean equalsIgnoreCase(String) 忽略大小写，判断两个字符串内容是否相同`

`boolean contains(String) 判断字符串是否包含指定字符串`

`boolean startsWith(String) 判断字符串是否以指定字符串开始`

`boolean endsWith(String) 判断字符串是否以指定字符串结尾`

`boolean isEmpty() 判断字符串是否为空`

#### 数组类

`byte[] getBytes() 字符串转为字节数组`

`char[] toCharArray() 字符串转为字符数组`

`String[] split(String) 将字符串按照指定字符串切割成字符串数组`

#### 转换类

`String toUpperCase() 字符串转大写`

`String toLowerCase() 字符串转小写`

`String replace(String,String) 字符串替换，匹配方式：非正则表达式匹配。它会按照字面意义去查找和替换目标字符串，不解析任何特殊字符作为正则表达式元字符。`

`String replaceAll(String,String) 字符串全部替换，支持正则，匹配方式：正则表达式匹配。它可以识别并使用正则表达式的各种特殊字符和模式来匹配复杂的情况。`

`String repalceFirst(String,String) 字符串指替换第一次`

`String trim() 字符串将开头和结尾的空格剔除` 

### String、StringBuffer、StringBuilder的区别

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence { private final char value[]; }
public final class StringBuffer extends AbstractStringBuilder implements Serializable, CharSequence {}
public final class StringBuilder extends AbstractStringBuilder implements Serializable, CharSequence {}
```

#### 可变性

String是不可变的，StringBuffer和StringBuilder是可变，这个可变指的是否对原对象内容是否变更

>String类中使用final修饰的字符数组存储字符串，是不可变的，StringBuffer和StringBuilder都继承了AbstractStringBuilder，内部通过char[] value;存储，所以说它们是可变的。
>
>final关键字修饰的类不能被继承，修饰的方法不能被重写，修饰的变量是基本数据类型则值不能改变，修饰的变量是引用类型则不能再指向其他对象。

#### 线程安全

`String` 中的对象是不可变的，也就可以理解为常量，线程安全。`AbstractStringBuilder` 是 `StringBuilder` 与 `StringBuffer` 的公共父类，定义了一些字符串的基本操作，如 `expandCapacity`、`append`、`insert`、`indexOf` 等公共方法。`StringBuffer` 对方法加了同步锁或者对调用的方法加了同步锁，所以是线程安全的。`StringBuilder` 并没有对方法进行加同步锁，所以是非线程安全的。

#### 性能

每次对 `String` 类型进行改变的时候，都会生成一个新的 `String` 对象，然后将指针指向新的 `String` 对象。`StringBuffer` 每次都会对 `StringBuffer` 对象本身进行操作，而不是生成新的对象并改变对象引用。相同情况下使用 `StringBuilder` 相比使用 `StringBuffer` 没有使用synchronized锁，性能有所提升，但多线程环境下存在安全风险。

#### 总结

1. 操作少量的数据: 适用 `String`
2. 单线程操作字符串缓冲区下操作大量数据: 适用 `StringBuilder`
3. 多线程操作字符串缓冲区下操作大量数据: 适用 `StringBuffer`

### 字符串拼接用+还是StringBuilder

>字符串的+或者+=运算符，实质是生成一个StringBuilder对象，拼接后调用toString()方法后再生成一个字符串对象。如果频繁操作还是建议使用`StringBuilder` 对象进行字符串拼接。

### 字符串常量池

>在Java中，字符串常量池是一个特殊的内存区域（位于方法区），用于存储字符串字面量（也称为字符串常量）。当创建一个字符串对象时，如果它的值来源于字面量或者已经存在于字符串常量池中的字符串对象，则不会创建新的对象，而是直接引用池中的已存在对象，这样可以减少内存消耗并提升性能。

#### 关于创建对象的个数，考虑以下几种场景：

1. 使用字面量创建字符串：String s1 = "abc"; String s2 = "abc";
   java在这种情况下，尽管有两个引用s1和s2，但在内存中只会有一个字符串对象"abc"存储在字符串常量池中。因为编译器会确保相同内容的字符串字面量只创建一次对象。
2. 使用new关键字创建字符串：String s3 = new String("abc");
   java使用new关键字创建字符串时，会在堆内存中创建一个新的字符串对象，即使"abc"已经存在于字符串常量池中也是如此。因此，这里会有两个对象，一个是常量池中的"abc"，另一个是在堆上新建的"abc"对象。
3. 使用intern()方法：String s4 = new String("abc").intern();
   java的intern()方法会尝试将当前字符串对象添加到字符串常量池中，如果常量池已有该字符串，则返回池中该字符串的引用。所以，如果上述代码运行时，常量池没有"abc"，则会将新建的"abc"对象的引用复制到常量池，并使s4指向常量池中的"abc"；如果有，则直接返回池中已有的"abc"引用，此时堆上的新对象可能会被垃圾回收。

## 异常

> 异常是在程序执行过程中遇到的一种意外情况或错误，它会干扰正常的程序执行流程。

### 异常的类型

> 异常的父类是Throwable有两个⼦类Exception和Error。
>
> Error是程序⽆法处理的错误，⼀旦出现这个错误，虚拟机将被迫停⽌运⾏。
>
> Exception不会导致程序停⽌，⼜分为两个部分RunTimeException运⾏时异常和CheckedException检查异常
>
> RunTimeException常常发⽣在程序运⾏过程中，会导致程序当前线程执⾏失败。CheckedException常常发⽣在程序编译过程中，会导致程序编译不通过。

<img src="https://telegraph-image-2ni.pages.dev/file/f5fc08365d6eedc7d186d.png" alt="img" style="zoom:50%;" />

### Throwable类的常用方法

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

### 异常处理

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

# 高级语言特性

## 泛型

> 泛型（Generics）是Java中一种参数化类型的概念，它允许在定义类、接口和方法时使用类型参数。通过泛型，可以使类、接口和方法在定义时不指定具体的数据类型，而是在实例化或调用时再指定具体的类型。
>
> 使用泛型的主要目的是提高代码的灵活性、可重用性和安全性，同时减少重复代码的编写。泛型可以在编译时进行类型检查，避免在运行时出现类型转换错误，提高了代码的安全性。

### 泛型的使用方式

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

### 项目中哪些使用泛型

1.前后端返回的统一接口CommonResult

2.自定义的excel处理类ExcelUtil动态的指定的类型导出数据

3.集合类，例如，`ArrayList<String>`表示一个只能存储字符串类型的ArrayList。

## 反射

### 什么是反射（Reflection）

> 允许在运行时动态地检查类、获取类的信息（如字段、方法、构造函数等），以及调用类的方法、访问或修改类的属性等。

### 反射可以做什么

1. **获取类的信息**：可以获取类的名称、包名、父类、实现的接口等信息。
2. **获取类的字段（Field）信息**：可以获取类中定义的字段的名称、类型、修饰符等信息。
3. **获取类的方法（Method）信息**：可以获取类中定义的方法的名称、参数类型、返回类型、修饰符等信息。
4. **获取类的构造函数信息**：可以获取类中定义的构造函数的参数类型、修饰符等信息。
5. **动态调用方法**：可以在运行时动态地调用类的方法，传递参数并获取返回值。
6. **动态创建对象**：可以在运行时动态地创建类的对象，并对对象进行操作。

### 反射的使用场景

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

## 注解

### 什么是注解

注解(Annotation)是Java语言用于将元数据(metadata)与程序元素(类、方法、字段等)关联的一种机制。它提供了一种形式化的方法,使代码可以在编译期被特定的工具或编译器进行处理。注解本身不会直接影响程序的语义,但可以被用来生成辅助代码、校验程序逻辑等。

### 注解的作用

1. **编译时检查** - 通过注解表达约束条件,编译器可以检查这些约束是否被违反。例如`@Override`确保方法正确覆写。
2. **生成辅助代码** - 注解可以被工具处理,生成相关的辅助代码,如XML配置文件、代理类等。
3. **运行时处理** - 在运行时通过反射获取注解信息,并进行相应的处理,如缓存管理、权限控制等。

### 注解的分类

1. **Java内置注解** - Java语言内置的标准注解,如`@Override`、`@Deprecated`、`@SuppressWarnings`等。
2. **元注解** - 用于定义注解的注解,如`@Retention`、`@Target`、`@Inherited`、`@Documented`等。
3. **自定义注解** - 根据具体需求自行定义的注解。

### 元注解详解

元注解是用来定义其他注解的注解,它们可以嵌套地应用于其他注解上。常见的元注解包括:

- `@Retention` - 指定注解的保留策略,可选值为SOURCE(源码级别)、CLASS(class文件级别)和RUNTIME(运行时级别)。
- `@Target` - 指定注解可以应用的程序元素类型,如TYPE、METHOD、FIELD等。
- `@Inherited` - 指定注解是否可以被子类继承。
- `@Documented` - 指定注解是否可以被javadoc工具文档化。
- `@Repeatable` - 指定注解是否可以在同一个程序元素上重复使用。(Java 8新增)

### 自定义注解

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

### 注解的含义

#### @Target

@Target元注解用于指定注解可以应用于哪些程序元素。它接受一个ElementType参数的数组,常用的ElementType值包括:

- ElementType.TYPE - 可应用于类、接口、枚举等
- ElementType.FIELD - 可应用于字段、枚举常量
- ElementType.METHOD - 可应用于方法
- ElementType.PARAMETER - 可应用于方法参数
- ElementType.CONSTRUCTOR - 可应用于构造函数
- ElementType.LOCAL_VARIABLE - 可应用于局部变量
- ElementType.ANNOTATION_TYPE - 可应用于注解类型

例如,@Target({ElementType.METHOD, ElementType.TYPE})表示该注解可以应用于方法和类/接口上。

#### @Retention

@Retention元注解用于指定注解的生命周期,即注解信息在哪个级别被保留下来。它接受一个RetentionPolicy参数,常用的RetentionPolicy值包括:

- RetentionPolicy.SOURCE - 注解只保留在源代码级别,编译时被丢弃
- RetentionPolicy.CLASS - 注解保留在class文件级别,但在运行时会被JVM丢弃
- RetentionPolicy.RUNTIME - 注解可以在运行时被JVM保留,因此可以通过反射读取注解信息

@Retention(RetentionPolicy.RUNTIME)表示该注解在运行时可以被反射访问。 

### 注解的应用场景

1. **配置管理** - 使用注解配置替代XML文件,如Spring的`@Configuration`、`@Bean`等。
2. **ORM映射** - 使用注解描述对象与数据库表的映射,如JPA的`@Entity`、`@Table`等。
3. **校验约束** - 使用注解表达校验规则,如Bean Validation的`@NotNull`、`@Size`等。
4. **日志记录** - 使用注解标记需要记录日志的方法,如Log4j的`@Log`。
5. **缓存管理** - 使用注解标记需要缓存的方法及缓存策略。
6. **安全控制** - 使用注解控制方法的安全访问级别,如Spring Security的`@Secured`。
7. **异步处理** - 使用注解标记需要异步执行的方法,如Spring的`@Async`。
8. **事务管理** - 使用注解配置事务属性,如Spring的`@Transactional`。

## SPI

> SPI 即 Service Provider Interface ，字面意思就是：“服务提供者的接口”，我的理解是：专门提供给服务提供者或者扩展框架功能的开发者去使用的一个接口。
>
> SPI 将服务接口和具体的服务实现分离开来，将服务调用方和服务实现者解耦，能够提升程序的扩展性、可维护性。修改或者替换服务实现并不需要修改调用方。
>
> 很多框架都使用了 Java 的 SPI 机制，比如：Spring 框架、数据库加载驱动、日志接口、以及 Dubbo 的扩展实现等等。

## 序列化

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
