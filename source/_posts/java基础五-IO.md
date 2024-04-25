---
title: java基础-io
tag:
- java
typora-root-url: ./..
---

# 什么是IO

根据冯.诺依曼结构，计算机结构分为 5 大部分：运算器、控制器、存储器、输入设备、输出设备。

<img src="https://telegraph-image-2ni.pages.dev/file/b412f6130798df7f5dcf8.jpg" style="zoom: 33%;" />

输入设备（比如键盘）和输出设备（比如显示器）都属于外部设备。网卡、硬盘这种既可以属于输入设备，也可以属于输出设备。

输入设备向计算机输入数据，输出设备接收计算机输出的数据。

根据大学里学到的操作系统相关的知识：为了保证操作系统的稳定性和安全性，一个进程的地址空间划分为 **用户空间（User space）** 和 **内核空间（Kernel space ）** 。

像我们平常运行的应用程序都是运行在用户空间，只有内核空间才能进行系统态级别的资源有关的操作，比如文件管理、进程通信、内存管理等等。也就是说，我们想要进行 IO 操作，一定是要依赖内核空间的能力。

并且，用户空间的程序不能直接访问内核空间。

当想要执行 IO 操作时，由于没有执行这些操作的权限，只能发起系统调用请求操作系统帮忙完成。

因此，用户进程想要执行 IO 操作的话，必须通过 **系统调用** 来间接访问内核空间

我们在平常开发过程中接触最多的就是 **磁盘 IO（读写文件）** 和 **网络 IO（网络请求和响应）**。

**从应用程序的视角来看的话，我们的应用程序对操作系统的内核发起 IO 调用（系统调用），操作系统负责的内核执行具体的 IO 操作。也就是说，我们的应用程序实际上只是发起了 IO 操作的调用而已，具体 IO 的执行是由操作系统的内核来完成的。**

当应用程序发起 I/O 调用后，会经历两个步骤：

1. 内核等待 I/O 设备准备好数据
2. 内核将数据从内核空间拷贝到用户空间。



# Java中3种常见 IO 模型

## BIO

同步阻塞 IO 模型中，应用程序发起 read 调用后，会一直阻塞，直到内核把数据拷贝到用户空间

## NIO

同步非阻塞 IO 模型中，应用程序会一直发起 read 调用，等待数据从内核空间拷贝到用户空间的这段时间里，线程依然是阻塞的，直到在内核把数据拷贝到用户空间。

相比于同步阻塞 IO 模型，同步非阻塞 IO 模型确实有了很大改进。通过轮询操作，避免了一直阻塞。

但是，这种 IO 模型同样存在问题：应用程序不断进行 I/O 系统调用轮询数据是否已经准备好的过程是十分消耗 CPU 资源的

## AIO

异步 IO 是基于事件和回调机制实现的，也就是应用操作之后会直接返回，不会堵塞在那里，当后台处理完成，操作系统会通知相应的线程进行后续的操作。



# 字符流和字节流的区别

<img src="/images/IO.drawio.svg" style="zoom:70%;" />

在java中IO指的是input和output，在java中分为输入流和输出流，根据处理数据不同的单位分为字节流和字符流。字节流以字节（8位）为单位进行数据处理，如图片、视频，字符流是以字符进行为单位进行数据处理，如文本。

+ 处理单位：字节流以字节为单位，字符流以字符为单位。
+ 用途：字节流可以处理所有类型的数据，字符流只能处理字符类型的数据。
+ 处理中文字符：字节流可能会出现乱码的情况，字符流按字符处理，不会出现乱码

# 字节流

## InputStream

`InputStream`用于从源头（通常是文件）读取数据（字节信息）到内存中，`java.io.InputStream`抽象类是所有字节输入流的父类。

`read()`：返回输入流中下一个字节的数据。返回的值介于 0 到 255 之间。如果未读取任何字节，则代码返回 `-1` ，表示文件结束。

`read(byte b[ ])` : 从输入流中读取一些字节存储到数组 `b` 中。如果数组 `b` 的长度为零，则不读取。如果没有可用字节读取，返回 `-1`。如果有可用字节读取，则最多读取的字节数最多等于 `b.length` ， 返回读取的字节数。这个方法等价于 `read(b, 0, b.length)`。

`read(byte b[], int off, int len)`：在`read(byte b[ ])` 方法的基础上增加了 `off` 参数（偏移量）和 `len` 参数（要读取的最大字节数）。

`skip(long n)`：忽略输入流中的 n 个字节 ,返回实际忽略的字节数。

`available()`：返回输入流中可以读取的字节数。

`close()`：关闭输入流释放相关的系统资源。

## OutputStream

`write(int b)`：将特定字节写入输出流。

`write(byte b[ ])` : 将数组`b` 写入到输出流，等价于 `write(b, 0, b.length)` 。

`write(byte[] b, int off, int len)` : 在`write(byte b[ ])` 方法的基础上增加了 `off` 参数（偏移量）和 `len` 参数（要读取的最大字节数）。

`flush()`：刷新此输出流并强制写出所有缓冲的输出字节。

`close()`：关闭输出流释放相关的系统资源。

# 字符流

字节流对字符的处理（特别是中文）会出现乱码，字符流默认采用unicode编码，避免这个情况。

**字符流的优点：**

1.可以处理中文字符

2.支持unicode编码，也可以根据构造函数自定义编码集

3.可以实现读一行，写一行

## Reader

`read()` : 从输入流读取一个字符。

`read(char[] cbuf)` : 从输入流中读取一些字符，并将它们存储到字符数组 `cbuf`中，等价于 `read(cbuf, 0, cbuf.length)` 。

`read(char[] cbuf, int off, int len)`：在`read(char[] cbuf)` 方法的基础上增加了 `off` 参数（偏移量）和 `len` 参数（要读取的最大字符数）。

`skip(long n)`：忽略输入流中的 n 个字符 ,返回实际忽略的字符数。

`close()` : 关闭输入流并释放相关的系统资源。

## Writer

`write(int c)` : 写入单个字符。

`write(char[] cbuf)`：写入字符数组 `cbuf`，等价于`write(cbuf, 0, cbuf.length)`。

`write(char[] cbuf, int off, int len)`：在`write(char[] cbuf)` 方法的基础上增加了 `off` 参数（偏移量）和 `len` 参数（要读取的最大字符数）。

`write(String str)`：写入字符串，等价于 `write(str, 0, str.length())` 。

`write(String str, int off, int len)`：在`write(String str)` 方法的基础上增加了 `off` 参数（偏移量）和 `len` 参数（要读取的最大字符数）。

`append(CharSequence csq)`：将指定的字符序列附加到指定的 `Writer` 对象并返回该 `Writer` 对象。

`append(char c)`：将指定的字符附加到指定的 `Writer` 对象并返回该 `Writer` 对象。

`flush()`：刷新此输出流并强制写出所有缓冲的输出字符。

`close()`:关闭输出流释放相关的系统资源。

# 缓冲流

IO 操作是很消耗性能的，缓冲流将数据加载至缓冲区，一次性读取/写入多个字节，从而避免频繁的 IO 操作，提高流的传输效率。

## 字节缓冲流

`BufferedInputStream` 从源头（通常是文件）读取数据（字节信息）到内存的过程中不会一个字节一个字节的读取，而是会先将读取到的字节存放在缓存区，并从内部缓冲区中单独读取字节。这样大幅减少了 IO 次数，提高了读取效率。

`BufferedOutputStream` 将数据（字节信息）写入到目的地（通常是文件）的过程中不会一个字节一个字节的写入，而是会先将要写入的字节存放在缓存区，并从内部缓冲区中单独写入字节。这样大幅减少了 IO 次数，提高了读取效率

## 字符缓冲流

`BufferedReader` （字符缓冲输入流）和 `BufferedWriter`（字符缓冲输出流）类似于 `BufferedInputStream`（字节缓冲输入流）和`BufferedOutputStream`（字节缓冲输入流），内部都维护了一个字节数组作为缓冲区。不过，前者主要是用来操作字符信息。

# 转换流

转换流主要是InputStreamReader和OutputStreamWriter,InputStreamReader 用于将字节输入流转换为字符输入流，其中 OutputStreamWriter 用于将字节输出流转换为字符输出流。使用转换流可以在一定程度上避免乱码，还可以指定输入输出所使用的字符集。

```java
InputStreamReader isr = new InputStreamReader(new FileInputStream("example.txt"), "UTF-8);
OutputStreamWriter osw = new OutputStreamWriter(new FileOutputStream("example.txt"), "UTF-8");
```



