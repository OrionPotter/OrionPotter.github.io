---
title: String字符串
description: 完整学习字符串相关知识
---

# String属于基本数据类型吗？

>String是一个字符串对象，属于引用数据类型，不属于基本数据类型

# String常用的方法

## 获取类

`int length() 获取字符串长度`

`char charAt(int) 获取指定索引的字符` 

`int indexOf(String) 获取指定字符串的索引`

`int lastIndexOf(String) 获取指定字符串的最后一次的索引`

`String substring(int) 获取从指定坐标到最后的字符串` 

`String substring(int,int) 获取[int,int)的指定字符串`

`String concat(String) 获取拼接后的字符串`

## 判断类

`boolean equals(String) 判断两个字符串内容是否相同 ` 

`boolean equalsIgnoreCase(String) 忽略大小写，判断两个字符串内容是否相同`

`boolean contains(String) 判断字符串是否包含指定字符串`

`boolean startsWith(String) 判断字符串是否以指定字符串开始`

`boolean endsWith(String) 判断字符串是否以指定字符串结尾`

`boolean isEmpty() 判断字符串是否为空`

## 数组类

`byte[] getBytes() 字符串转为字节数组`

`char[] toCharArray() 字符串转为字符数组`

`String[] split(String) 将字符串按照指定字符串切割成字符串数组`

## 转换类

`String toUpperCase() 字符串转大写`

`String toLowerCase() 字符串转小写`

`String replace(String,String) 字符串替换，匹配方式：非正则表达式匹配。它会按照字面意义去查找和替换目标字符串，不解析任何特殊字符作为正则表达式元字符。`

`String replaceAll(String,String) 字符串全部替换，支持正则，匹配方式：正则表达式匹配。它可以识别并使用正则表达式的各种特殊字符和模式来匹配复杂的情况。`

`String repalceFirst(String,String) 字符串指替换第一次`

`String trim() 字符串将开头和结尾的空格剔除` 

# String、StringBuffer、StringBuilder的区别

```java
public final class String implements java.io.Serializable, Comparable<String>, CharSequence { private final char value[]; }
public final class StringBuffer extends AbstractStringBuilder implements Serializable, CharSequence {}
public final class StringBuilder extends AbstractStringBuilder implements Serializable, CharSequence {}
```

## 可变性

String是不可变的，StringBuffer和StringBuilder是可变，这个可变指的是否对原对象内容是否变更

>String类中使用final修饰的字符数组存储字符串，是不可变的，StringBuffer和StringBuilder都继承了AbstractStringBuilder，内部通过char[] value;存储，所以说它们是可变的。
>
>final关键字修饰的类不能被继承，修饰的方法不能被重写，修饰的变量是基本数据类型则值不能改变，修饰的变量是引用类型则不能再指向其他对象。

## 线程安全

`String` 中的对象是不可变的，也就可以理解为常量，线程安全。`AbstractStringBuilder` 是 `StringBuilder` 与 `StringBuffer` 的公共父类，定义了一些字符串的基本操作，如 `expandCapacity`、`append`、`insert`、`indexOf` 等公共方法。`StringBuffer` 对方法加了同步锁或者对调用的方法加了同步锁，所以是线程安全的。`StringBuilder` 并没有对方法进行加同步锁，所以是非线程安全的。

## 性能

每次对 `String` 类型进行改变的时候，都会生成一个新的 `String` 对象，然后将指针指向新的 `String` 对象。`StringBuffer` 每次都会对 `StringBuffer` 对象本身进行操作，而不是生成新的对象并改变对象引用。相同情况下使用 `StringBuilder` 相比使用 `StringBuffer` 没有使用synchronized锁，性能有所提升，但多线程环境下存在安全风险。

## 总结

1. 操作少量的数据: 适用 `String`
2. 单线程操作字符串缓冲区下操作大量数据: 适用 `StringBuilder`
3. 多线程操作字符串缓冲区下操作大量数据: 适用 `StringBuffer`

# 字符串拼接用+还是StringBuilder

>字符串的+或者+=运算符，实质是生成一个StringBuilder对象，拼接后调用toString()方法后再生成一个字符串对象。如果频繁操作还是建议使用`StringBuilder` 对象进行字符串拼接。

# 字符串常量池

>在Java中，字符串常量池是一个特殊的内存区域（位于方法区），用于存储字符串字面量（也称为字符串常量）。当创建一个字符串对象时，如果它的值来源于字面量或者已经存在于字符串常量池中的字符串对象，则不会创建新的对象，而是直接引用池中的已存在对象，这样可以减少内存消耗并提升性能。

## 关于创建对象的个数，考虑以下几种场景：

1. 使用字面量创建字符串：String s1 = "abc"; String s2 = "abc";
    java在这种情况下，尽管有两个引用s1和s2，但在内存中只会有一个字符串对象"abc"存储在字符串常量池中。因为编译器会确保相同内容的字符串字面量只创建一次对象。
2. 使用new关键字创建字符串：String s3 = new String("abc");
    java使用new关键字创建字符串时，会在堆内存中创建一个新的字符串对象，即使"abc"已经存在于字符串常量池中也是如此。因此，这里会有两个对象，一个是常量池中的"abc"，另一个是在堆上新建的"abc"对象。
1. 使用intern()方法：String s4 = new String("abc").intern();
java的intern()方法会尝试将当前字符串对象添加到字符串常量池中，如果常量池已有该字符串，则返回池中该字符串的引用。所以，如果上述代码运行时，常量池没有"abc"，则会将新建的"abc"对象的引用复制到常量池，并使s4指向常量池中的"abc"；如果有，则直接返回池中已有的"abc"引用，此时堆上的新对象可能会被垃圾回收。