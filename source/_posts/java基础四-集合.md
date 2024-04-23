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

# Set

## Comparable 和 Comparator 的区别

**Comparable 可以看作是“对内”进行排序接口，而 Comparator 是“对外”进行排序的接口。**

+ 含义区别：comparable是比较，comparator是比较器的意思。
+ 重写方法：comparable要重写compareTo方法,comparator要重写compare方法。
+ 应用方式：comparable一般是在类中重写，comparator一般在集合工具类中传入匿名内部类。

### 基于comparator实现

```java
@Data
@AllArgsConstructor
public class Subject {
    Integer subject_id;
    String subject_name;
}
```

```java
public class BasicOfComparator {
    public static void main(String[] args) {
        Subject s1 = new Subject(10,"java");
        Subject s2 = new Subject(8,"mysql");
        Subject s3 = new Subject(14,"redis");
        List<Subject> list = new ArrayList<Subject>(){
            {
                add(s1);
                add(s2);
                add(s3);
            }
        };
        Collections.sort(list, new Comparator<Subject>() {
            @Override
            public int compare(Subject o1, Subject o2) {
                return o2.getSubject_id().compareTo(o1.getSubject_id());
            }
        });
        for (Subject subject : list) {
            System.out.println(subject.toString());
        }
    }
```

### 基于comparbale实现

```java
@Data
@AllArgsConstructor
public class Subject implements Comparable<Subject>{
    Integer subject_id;
    String subject_name;

    @Override
    public int compareTo(Subject o) {
        return o.getSubject_id().compareTo(this.getSubject_id());
    }
}
```

```java
public class BasicOfComparable {
    public static void main(String[] args) {
        Subject s1 = new Subject(10,"java");
        Subject s2 = new Subject(8,"mysql");
        Subject s3 = new Subject(14,"redis");
        List<Subject> list = new ArrayList<Subject>(){
            {
                add(s1);
                add(s2);
                add(s3);
            }
        };
        Collections.sort(list);
        for (Subject subject : list) {
            System.out.println(subject.toString());
        }
    }
}
```

## 如何理解SET集合无序性和不可重复性

Set是一个基于Hash算法的数组，它的无序性体现在元素经过hash算法以后，存储在数组中的位置是无序的，不可重复性是指元素经过hash算法之后，计算出来的数组下标，如果存在数据元素，根据equals方法判断是否是同一个，如果是则新的覆盖旧的，所以set里面没有重复的元素。

## HashSet、LinkedHashSet、TreeSet的区别

**相同点**：都是Set集合的实现类，元素唯一不重复，都不是现成安全

**区别：**

数据结构：HashSet是底层是哈希表，基于hashmap实现的，LinkedHashSet底层是链表和哈希表，满足FIFO，TreeSet底层是红黑树，元素是有序的。

应用场景：HashSet应用不保证插入和取出元素顺序的场景，LinkedHashSet应用于FIFO场景，TreeSet应用于排序场景

# Queue

## Queue和Deque的区别

Queue是单端队列，只能从一端插入元素，另一端删除元素。Queue扩展了collection的接口分为两类方法，一类是操作失败后抛出异常，另一种是返回特殊值

| `Queue` 接口 | 抛出异常  | 返回特殊值 |
| ------------ | --------- | ---------- |
| 插入队尾     | add(E e)  | offer(E e) |
| 删除队首     | remove()  | poll()     |
| 查询队首元素 | element() | peek()     |

Deque是双端队列，可以在队尾和队首进行插入元素和删除元素。Deque扩展了Queue的接口，增加了队尾和队首的进行删除和插入的方法，根据失败后处理方式的不同分为两类。

| `Deque` 接口 | 抛出异常      | 返回特殊值      |
| ------------ | ------------- | --------------- |
| 插入队首     | addFirst(E e) | offerFirst(E e) |
| 插入队尾     | addLast(E e)  | offerLast(E e)  |
| 删除队首     | removeFirst() | pollFirst()     |
| 删除队尾     | removeLast()  | pollLast()      |
| 查询队首元素 | getFirst()    | peekFirst()     |
| 查询队尾元素 | getLast()     | peekLast()      |

## ArrayDeque与LinkedList的区别

相同点：ArrayDeque和LinkedList都实现了Deque接口，两个都有队列的功能。

区别：

+ ArrayDeque是基于可变长数组和双指针实现的，而LinkedList是基于链表实现的
+ ArrayDeque不能存储Null数据，LinkedList可以存储
+ ArrayDeque当容量满了以后涉及扩容会复制整个数组，丢弃旧数组，涉及了内存复制性能较低，当数据量大的时候LinkedList处理效率比较低，整体而言优先使用ArrayDeque实现队列

## 为什么有Stack还要用Deque实现栈

Stack继承了vector属于线程安全的，当处理大量数据的时候效率比较低。

## 什么是优先级队列

优先级队列（Priority Queue）跟普通的队列有相似的行为，都是遵循队列的基本原则—先进先出（FIFO）, 但它有一个额外的特性：每个元素都有各自的“优先级”。

在优先级队列中，元素被赋予优先级。当访问元素时，具有最高优先级的元素最先被访问。优先级队列有两个常见的应用场景：

1. 数据压缩：优先级队列常常被用于数据压缩，特别是霍夫曼编码。

2. Dijkstra算法：优先级队列也是实现Dijkstra算法的关键工具。

优先级队列是通过二叉堆实现的，它提供了O(log n)的添加和删除时间复杂度，以及O(1)的查询最大 / 最小元素时间复杂度。

**特点：**

`PriorityQueue` 利用了二叉堆的数据结构来实现的，底层使用可变长的数组来存储数据

`PriorityQueue` 通过堆元素的上浮和下沉，实现了在 O(logn) 的时间复杂度内插入元素和删除堆顶元素。

`PriorityQueue` 是非线程安全的，且不支持存储 `NULL` 和 `non-comparable` 的对象。

`PriorityQueue` 默认是小顶堆，但可以接收一个 `Comparator` 作为构造参数，从而来自定义元素优先级的先后。

## 什么是阻塞队列

阻塞队列（Blocking Queue）是一种特殊的队列，当队列为空时，消费者尝试从队列里取出元素的操作会被阻塞，直到队列中有可用元素；同样，当队列已满时，生产者尝试向队列添加元素的操作也会被阻塞，直到队列有可用空间。

### 阻塞队列的实现类

1. ArrayBlockingQueue：是一个由数组支持的有界阻塞队列，队列的容量在初始化时设定。

2. LinkedBlockingQueue：是一个由链表支持的可选定长（即可以选择是否定长）阻塞队列。

3. PriorityBlockingQueue：是一个不限大小的并发阻塞队列。队列中的元素可按自然顺序进行排序，也可以通过Comparator接口进行排序。

4. DelayQueue：是一个在定时未到时，不能从中获取元素的无界阻塞队列，其内部实现是一个PriorityQueue。元素由其时间戳的长短决定队列中的排序，队头对象的定时时间最长。

5. SynchronousQueue：不存储元素的阻塞队列，每一个put操作必须等待一个take操作，反之亦然。

6. LinkedTransferQueue：是一种由链表结构组成的无界阻塞TransferQueue队列，相当于其他队列的综合体。TransferQueue是一种阻塞队列，其中的生产者的等待可能是为了将元素转移/传递到消费者。

7. LinkedBlockingDeque：是一个由链表结构组成的双向阻塞队列。在最初提供的阻塞队列中，LinkedBlockingDeque是唯一一个支持前后两端插入和移除元素的队列。

### ArrayBlockingQueue和LinkedBlockingDeque的区别

1. 数据结构：ArrayBlockingQueue基于数组实现的。LinkedBlockingDeque基于链表实现的。

2. 性能：LinkedBlockingDeque基于链表结构，插入和移除元素效率比较高。

3. 双端访问：LinkedBlockingDeque支持从两端插入和移除元素。而ArrayBlockingQueue只能在队尾插入，在对头移除。

4. 灵活性：LinkedBlockingDeque支持双端插入和移除，且可以选择是否定长，更具灵活性。

