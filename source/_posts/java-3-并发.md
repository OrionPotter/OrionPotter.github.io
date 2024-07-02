---
title: java基础-并发编程
tag:
- java
---

# 线程和进程

进程和线程都属于计算机中的执行单位，进程是操作系统分配的资源（CPU、内存）单位，线程是CPU的调度单位，线程属于进程，一个进程包含多个线程，处理多任务时，一般采用多线程处理，多进程切换开销较大，效率低。在Java中，当我们启动 main 函数时其实就是启动了一个 JVM 的进程，而 main 函数所在的线程就是这个进程中的一个线程，也称主线程。

# java实现多线程的方式

## 继承Thread类

>通过继承Thread类，重写run(),创建子类对象即为创建一个线程，调用start方法即可启动线程

```java
public class MultiThread extends Thread {
    @Override
    public void run() {
        System.out.println("基于Thread子类创建多线程,当前线程为:"+Thread.currentThread());
    }

    public static void main(String[] args) {
        MultiThread multiThread1 = new MultiThread();
        multiThread1.setName("Thread-1");
        MultiThread multiThread2 = new MultiThread();
        multiThread1.setName("Thread-2");
        MultiThread multiThread3 = new MultiThread();
        multiThread1.setName("Thread-3");
        multiThread1.start();
        multiThread2.start();
        multiThread3.start();
    }
}
```

**注意：线程的执行顺序和代码编写的顺序没有关系**

## 实现Runnable接口

>Runnable接口只有一个run方法，实现Runnable接口，实现run()，创建Thread类并传入Runnable实例，调用Thread类实例的start()

```java
// Runnable接口
@FunctionalInterface
public interface Runnable {
    public abstract void run();
}
// 实现Runnable接口创建多线程
public class MultiThread implements Runnable {
    @Override
    public void run() {
        System.out.println("基于Runnable接口实现多线程,当前线程为:"+Thread.currentThread());
    }
    public static void main(String[] args) {
        MultiThread multiThread1 = new MultiThread();
        Thread thread1 = new Thread(multiThread1);
        thread1.setName("Thread-1");
        thread1.start();
        MultiThread multiThread2 = new MultiThread();
        Thread thread2 = new Thread(multiThread2);
        thread2.setName("Thread-2");
        thread2.start();
        MultiThread multiThread3 = new MultiThread();
        Thread thread3 = new Thread(multiThread3);
        thread3.setName("Thread-3");
        thread3.start();
    }
}
```



## 实现Callable接口

>Callable接口只有一个call(),它与Runnable接口都属于接口，不同的是它可以返回值，实现Callable接口，实现call(),创建FutureTask,传入callbale接口实例，创建Thread类实例，传入FutureTask实例，调用Thread的start方法

```java
// Callable接口
@FunctionalInterface
public interface Callable接口<V> {
    V call() throws Exception;
}
// 基于Callable接口实现多线程
public class MultiThread implements Callable<String> {

    @Override
    public String call() throws Exception {
        return "基于Callable接口实现多线程,当前线程为: "+Thread.currentThread();
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        MultiThread multiThread = new MultiThread();
        FutureTask<String> futureTask = new FutureTask<String>(multiThread);
        Thread thread = new Thread(futureTask);
        
        thread.start();
        System.out.println("返回值为: "+futureTask.get());
    }
}
```

## 线程池

>通过线程池创建多线程

```java
public class MultiThread {
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        //1. 创建单一线程的线程池
        ExecutorService executorService = Executors.newSingleThreadExecutor();
        //2. 创建固定大小的线程池
        ExecutorService fixedThreadPool = Executors.newFixedThreadPool(10);
        //3. 创建可缓存的线程池
        ExecutorService cachedThreadPool = Executors.newCachedThreadPool();
        //4. 创建一个拥有多个任务队列的线程池
        ExecutorService workStealingPool = Executors.newWorkStealingPool();
        //5. 创建一个定长线程池，支持定时及周期性任务执行
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(10);

        executorService.submit(new Runnable() {
            @Override
            public void run() {
                System.out.println("线程池提交Runnable任务！！！");
            }
        });

        Future<String> submit = executorService.submit(new Callable<String>() {
            @Override
            public String call() throws Exception {
                return "线程池提交Callable任务！！！";
            }
        });
        System.out.println(submit.get());
        executorService.shutdown();
    }
}
```

**java的线程启动，最终依赖于Thread.start方法**

# 线程的生命周期和状态

+ NEW：新建状态，线程被创建出来，没有调用start方法
+ RUNABBLE：运行状态，线程调用了start方法，等待运行的状态
+ BLOCKED：阻塞状态，需要等待锁的释放
+ WAITING：等待状态，线程需要等待其他线程做出一些特定工作
+ TIME_WAITING: 超时等待状态，可以在指定时间内自动返回，不像WATING那样一直等待
+ TERMINATED: 终止状态，表示线程已经执行完毕

# 什么是线程的上下文切换

上下文切换是指CPU切换线程的执行过程，当一个线程正在执行时，CPU需要暂停当前线程的执行，并将其上下文（如程序计数器、寄存器内容、堆栈指针等）保存到内存中，然后加载另一个线程的上下文，使其继续执行。

# Thread.sleep方法和Object.wait方法的区别

相同：两个方法都可以停止线程的执行

区别：

+ sleep方法没有释放锁，wait方法释放锁
+ wait方法用于线程间的通信，线程不会自动苏醒，需要别的线程调用notify()或者notifyAll()，sleep()方法是暂停线程执行，到达指定时间后会自动苏醒。（wait(long timeout)方法也是这个作用）
+ sleep()是Thread类的方法，wait方法是Object类的





当然，我可以帮你列一个详细的Java多线程学习大纲，以便你系统地学习和掌握这方面的知识。以下是一个推荐的大纲：

# 基础概念

## 什么是线程和进程

**线程**：线程是CPU的调度单位，是一个进程中独立运行的最小子任务，它共享进程的资源。

**进程**：进程是操作系统分配资源和调度执行的基本单位，它包含了一个或多个线程，一个应用程序启动相当于起了一个进程。

## 多线程的优缺点

### 多线程的优点

1. **CPU利用率**：多线程可以充分利用多核处理器的优势，提升程序的运行效率。
2. **实现并发**：多线程可以同时处理多个并发任务，例如同时下载多个文件或处理多个客户端请求，从而提高系统的吞吐量。

### 多线程的缺点

1. **上下文切换开销**：线程的上下文切换需要保存和恢复线程的状态，这会消耗系统资源，增加CPU的负担。在线程数过多时，频繁的上下文切换会导致性能下降。
2. **数据一致性**：多线程共享同一个进程的资源，可能会导致资源竞争问题，例如多个线程同时读写同一个变量。如果不加以正确的同步控制，会出现数据不一致的问题。
3. **死锁和活锁**：多线程编程中容易出现死锁和活锁问题，多个线程互相等待对方释放资源，导致程序无法继续执行。这类问题通常很难发现和解决。

- Java中实现多线程的方式
  - 继承`Thread`类
  - 实现`Runnable`接口
  - 实现`Callable`接口和使用`Future`

# 线程的基本操作

- 创建和启动线程
- 线程的生命周期（新建、就绪、运行、阻塞、终止）
- 线程的优先级设置
- 线程的命名

# 线程同步

- 为什么需要线程同步
- 同步方法和同步块
- `synchronized`关键字的使用
- `volatile`关键字的使用
- 使用`ReentrantLock`进行显式锁定
- 死锁及其避免方法

# 线程间通信

- `wait()`、`notify()`和`notifyAll()`方法
- 使用`Condition`对象进行线程通信
- 生产者-消费者问题的解决方案

# 线程池

- 线程池的基本概念和优点
- 使用`Executors`创建线程池
- 线程池的类型（FixedThreadPool、CachedThreadPool、SingleThreadExecutor、ScheduledThreadPool）
- 自定义线程池的实现和配置

# 高级多线程技术

- `Future`和`Callable`接口
- `CompletionService`的使用
- 并发集合（`ConcurrentHashMap`、`CopyOnWriteArrayList`等）
- Fork/Join框架
- 并行流（Parallel Streams）

# 多线程工具类

- `CountDownLatch`
- `CyclicBarrier`
- `Semaphore`
- `Exchanger`

# 并发包（java.util.concurrent）

- `BlockingQueue`接口和实现类（如`ArrayBlockingQueue`、`LinkedBlockingQueue`）
- `DelayQueue`和`PriorityBlockingQueue`
- `ConcurrentLinkedQueue`
- `ConcurrentSkipListMap`

# 性能调优和最佳实践

- 常见的性能问题和调优技巧
- 线程安全的设计模式（如Immutable对象、ThreadLocal等）
- 使用Java VisualVM和其他工具进行线程分析





​	



