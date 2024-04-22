---
title: java基础-集合
tag:
- java
typora-root-url: ./..
---

# 什么是集合

java中集合也叫容器，由两大派类接口而来，一类是Conllection接口，存放的是单类型的元素，一类是Map，存放的是键值对。Collection接口主要有三大子接口分别为List、Set、Queue（线性表、链表、栈、队列都在这些接口中）



<img src="/images/集合.drawio.svg" style="zoom:70%;" />

# List、Set、Queue、Map的区别

+ List 存储的元素是有序可以重复的。
+ Set 存储的元素是无序不可以重复。
+ Queue 存储的元素有先后的顺序
+ Map 存储的是一对键值对，key是无序不可以重复的，value是无序可以重复的。

# List

## ArrayList和Array的区别

ArrayList是基于动态数组实现的，Array是一个静态数组。

+ 存储空间：数组是固定长度的，集合可变长度的。
+ 存储类型：ArrayList只能存储引用数据类型，Array可以存储基本数据类型，也可以存储引用数据类型
+ 存储内容：ArrayList可以存储不同数据类型的对象，Array只能存储一种数据类型的元素

## ArrayList和Array转换

```java
// 数组转换ArrayList的方法
public static void ArrayToArrayList() {
        String[] array = {"a", "b", "c", "d"};
        //1. use Arrays.asList()
        List<String> listOne = Arrays.asList(array);
        //2. use Collections.addAll()
        List<String> listTwo = new ArrayList<>();
        Collections.addAll(listTwo,array);
        //3. use Constructor
        List<String> listThree = new ArrayList<>(Arrays.asList(array));
        //4. use lambda
        List<String> listFour = Stream.of(array).collect(Collectors.toList());
    }
// ArrayList转换数组的方法
public static void ArrayListToArray() {
        List<String> list = new ArrayList<>(Arrays.asList("a","b","c","d"));
        //1. 转成Object数组
        Object[] objects = list.toArray();
        //2. 转成指定类型的数组
        String[] stringOne = list.toArray(new String[0]);
        //3. 使用lambda的方式转换成数组
        String[] stringsTwo = list.stream().toArray(String[]::new);
    }
```

## ArrayList和Vector的区别

+ ArrayList是List的主要实现类，线程不安全

+ Vector是List的古老实现类，线程安全。

## Vector和Stack的关系

Stack继承Vector，Stack实现了后进先出的栈，Vector是一个列表，两个都是线程安全。

## ArrayList的插入和删除的时间复杂度

插入：

+ 头插法：O(n)
+ 尾插法：O(1)
+ 指定位置插入：O(n)

删除：

+ 头删法：O(n)
+ 尾删法：O(1)
+ 指定位置删除：O(n)

## LinkedList的插入和删除的时间复杂度

+ 头插法/删法：O(1)
+ 尾插法/删法：O(1)
+ 指定位置插入/删除：O(n)

## LinkedList为什么没有实现RandomAccess接口

RandomAccess是一个标记接口，用来表明实现该接口的类支持随机访问（通过元素下标访问）。LinkedList底层是双向链表，内存不连续，无法支持随机访问。

## ArrayList和LinkedList的区别

+ 数据结构：ArrayList是基于动态数组实现的，是顺序存储，支持随机访问，LinkedList是基于双向链表实现的（JDK 1.6之前为循环双向链表，JDK 1.7取消了循环）不支持顺序存储和随机访问
+ 效率：ArrayList如果涉及数组重组的插入和删除的操作效率较低，查询比较快，LinkedList查询效率比较低，插入删除效率比较高。

