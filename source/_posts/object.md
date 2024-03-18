---
title: Object类介绍
---

# Object类的常见方法

>Object是所有类的父类，它主要提供了11个方法

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



# == 和 equals的区别

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

# hashcode的作用

>`hashcode（）`的作用是获取hash码（int 整数）也称散列码，这个hash码的作用是确定对象在hash表的位置,所有类都有这个函数
>
>`public native int hashCode();`



# 为什么要有hashcode，hashset是如何检查重复的

>提高执行效率，以hashset如何检查重复说明，怎么提高效率的，当把对象加入到hashset的时候，hashset会首先根据对象的hashcode值来判断加入的位置下标，如果下标位置没值就直接插入了，有值的话再调用equals方法判断两个对象是否相等，如果相等就不会让其加入，如果不相等就会重新散列到新的位置，这样做的好处是减少了equals执行次数，提高了执行效率。

总结：

如果两个对象的`hashCode` 值相等，那这两个对象不一定相等（哈希碰撞）。

如果两个对象的`hashCode` 值相等并且`equals()`方法也返回 `true`，我们才认为这两个对象相等。

如果两个对象的`hashCode` 值不相等，我们就可以直接认为这两个对象不相等。

# 为什么重写equals必须重写hashcode

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