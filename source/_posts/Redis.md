---
title: redis-学习
tag: redis
---

## redis安装

**官方snapd商店安装**

```shell
sudo yum install epel-release -y
sudo yum install snapd -y 
sudo systemctl enable --now snapd.socket 
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install redis
```

**官方源码安装[推荐]**

1.安装阿里源

```shell
# CentOS 7
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
```

2.安装编译器

```shell
yum install gcc-c++ -y
```

3.下载源码

```shell
wget https://download.redis.io/redis-stable.tar.gz
```

4.编译redis

```shell
tar -xzvf redis-stable.tar.gz
cd redis-stable
make
```

5.安装生成的可执行文件

```shell
make install
```

6.启动redis

```shell
redis-server
```

## 简单动态字符串

>Redis没有使用C语言的字符串，而是自己构建了一种名为简单动态字符串SDS（simple dynamic string）的抽象类型，并把sds用作默认redis的默认字符串表示。Redis数据库里面的键值对最底层都是由SDS实现的

#### 1.SDS定义

C语言表示

```c
struct sdshdr{
    // 记录buf 数组中已使用的字节数
    // 等于sds 所保存的长度
    int len;
    // 记录buf 数组中未使用的字节的数量
    int  free;
    //字节数组，用于保存字符串
    char buf[];
}
```

>buf字节数组和c语言的字符串保持一致，都以空字符结尾

#### 2.SDS与C字符串的区别

>C语言使用长度为N+1的字节数组表示长度为N的字符串，字节数组最后都是以空字符（'\0'）结尾

2.1 常数复杂度获取长度

+ C字符串不记录长度，需要依次遍历，直到空字符串返回长度，时间复杂度为O(N)
+ SDS中记录了长度的属性len,时间复杂度为O(1)

即使字符串的长度很长，使用strlen的命令的时间复杂度是O(1)

2.2 杜绝缓冲区溢出

+ C语言字符串拼接必须先分配空间，要不然会内存溢出
+ SDS会自动扩容所拼接字符串大小

2.3 减少字符串修改带来的内存分配次数

+ 空间预分配
+ 惰性空间释放

>空间预分配：当字符串的长度（len）小于1MB,预分配给free的空间大小和len长度一致，当字符串长度大于30Mb，预分配1Mb给free
>
>惰性空间释放：当要删除部分字符的时候，会将删除的空间保留到free里面

2.4 二进制安全

>C字符串中不能包含'\0',否则会被程序认为是字符串结尾，这限制了只能保存文本数据，不能保存图片、音频、视频等二进制数据。
>
>SDS的api都是二进制安全的，不会对数据进行限制、过滤等数据存进来是什么样的，他读取就是什么样的，redis用的buf数组不是用来保存字符，而是保存二进制数据。因此redis可以保存任意格式的二进制数据

2.5 兼容部分c字符串函数

>sds保留了空字符结尾的特性，可以重用部分c语言的函数，从而避免重复代码编写。

## 链表

>链表提供了高效的节点重排能力，以及顺序性节点访问方式，并且可以通过增删节点来调整链表的长度

