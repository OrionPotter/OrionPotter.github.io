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

1. 单行注释：`//`
2. 多行注释：`/**/`
3. 

















