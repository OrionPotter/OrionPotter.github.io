---
title: java异步编程
tag:
- java
---



# 认识异步编程

## 异步编程概念与作用

同步编程：每个线程同时只能发送一个请求，并同步等待返还，为提高性能，引入多个线程来实现并行处理。

异步编程：是一种程序并行运行的手段，可以让程序中的一个工作单元与主程序线程分开独立运行，并在工作单元结束后，通知主程序线程它的运行结果或失败原因。

作用：

1. 提高程序的性能和响应能力。
2. 提高线程的利用率。

## 异步编程场景

1. 日志的异步打印
2. Spring框架中@Async注解
3. 异步RPC调用（Netty、Dubbo）
4. Servlet、Webflux

# 显式使用线程和线程池实现异步编程

## 显式使用线程实现异步编程

>实现异步编程方式：
>
>1. 实现Runnable接口的run方法，传递Runnable接口的实现类作为创建Thread的参数，启动线程
>2. 实现Thread类，重新run方法

```java
//实现1
public static void main(String[] args) throws InterruptedException {
        long start = System.currentTimeMillis();
        Thread thread = new Thread(()->{
            doSomethingA();
        },"threadA");
        thread.start();
        doSomethingB();
        thread.join();
        System.out.println("执行时间为："+(System.currentTimeMillis()-start));
    }
//实现2
public static void main(String[] args) throws InterruptedException {
        long start = System.currentTimeMillis();
        Thread thread = new Thread("ThreadA"){
            @Override
            public void run() {
                doSomethingA();
            }
        };
        thread.start();
        doSomethingB();
        thread.join();
        System.out.println("执行时间："+(System.currentTimeMillis()-start));

    }

```

>**注意：**
>
>1. `thread.join()`方法会阻塞其他线程
>
>2. java中线程有Deamon和非Deamon之分，默认我们创建的都是非Deamon线程，如果要创建Deamon要进行SetDeamon(true),当jvm中不存在非Deamon线程则会推出虚拟机。
>
>3. 守护线程不一定完成执行取决于用户线程，设置守护线程要在start前设置，java普通运行的是两个线程，一个是主线程，一个是GC线程，GC线程是守护线程。

缺点：

1. 线程的创建与销毁时有开销的--》线程池
2. 没有限制线程的个数，使用不当会导致系统进程用尽--》线程池
3. 异步任务执行完后没有返回值--》Future

## 显式使用线程池实现异步编程

### 如何显式使用线程池实现异步编程

>使用线程池实现线程复用，当需要执行异步任务的时候，直接把任务投递到线程池进行异步进行

```java
    /**
     * 创建线程池
     * @return
     */
    private final static ExecutorService threadPoolExecutor(){
        int availableProcessors = Runtime.getRuntime().availableProcessors();
        return  new ThreadPoolExecutor(availableProcessors,
                availableProcessors*2,
                1,
                TimeUnit.MINUTES,
                new LinkedBlockingQueue<>(5),
                new ThreadPoolExecutor.CallerRunsPolicy());

    }

    /**
     * 提交异步任务到线程池执行
     * @param args
     * @throws InterruptedException
     */
    public static void main(String[] args) throws InterruptedException {
        long start = System.currentTimeMillis();
        ThreadPoolExample.threadPoolExecutor().execute(()->{
            doSomethingA();
        });
        doSomethingB();
        System.out.println("耗时："+(System.currentTimeMillis()-start));
    }
	/**
	* 有返回值的异步执行，但是get方法会阻塞其他线程
	*/
	public static void main(String[] args) throws ExecutionException, InterruptedException {
        long start = System.currentTimeMillis();
        Future<?> submit = ThreadPoolExample.threadPoolExecutor().submit(() -> doSomethingA());
        System.out.println(submit.get());
        doSomethingB();
        System.out.println("耗时："+(System.currentTimeMillis()-start));
    }
```

###  线程池ThreadpoolExecutor原理剖析

1. 概述

>```java
>// 高三位标记线程池的状态，低29位表示线程的个数
>private final AtomicInteger ctl = new AtomicInteger(ctlOf(RUNNING, 0));
>// 线程个数的掩码数
>private static final int COUNT_BITS = Integer.SIZE - 3;
>// 线程的最大个数
>private static final int CAPACITY   = (1 << COUNT_BITS) - 1;
>
>// runState is stored in the high-order bits
>// 接受新任务并处理阻塞队列里面的任务
>private static final int RUNNING    = -1 << COUNT_BITS;
>// 拒绝新任务但是处理阻塞队列里的任务
>private static final int SHUTDOWN   =  0 << COUNT_BITS;
>// 拒绝新任务，抛弃阻塞队列里的任务，同时中断正在处理的任务
>private static final int STOP       =  1 << COUNT_BITS;
>// 所有任务都执行完了，包括阻塞队列里面的任务，当前线程池活动线程数为0，将调用terminated方法
>private static final int TIDYING    =  2 << COUNT_BITS;
>// 终止状态
>private static final int TERMINATED =  3 << COUNT_BITS;
>// 返回运行状态
>private static int runStateOf(int c)     { return c & ~CAPACITY; }
>// 返回线程个数
>private static int workerCountOf(int c)  { return c & CAPACITY; }
>// 计算ctl新值
>private static int ctlOf(int rs, int wc) { return rs | wc; }
>```

线程池的参数配置

corePoolSize: 线程池核心线程个数

workQueue: 用于保存等待执行的任务阻塞队列（有界队列、无界队列、同步队列、优先级队列）

maximunPoolSize: 线程池的最大线程数量

threadFactory: 创建线程的工厂类

defaultHandler: 饱和策略（当队列达到maximunPoolSize后采取的策略）

keepAliveTime: 存活时间，当前线程数量>核心线程数量，且处于空闲状态，闲置连接能存活的最大时间

2. 提交任务到线程池原理解析

>ThreadPoolExecutor提交任务到线程池中的方法

| 方法                                           | 任务类型                         | 返回值   |
| ---------------------------------------------- | -------------------------------- | -------- |
| void execute(Runnable command)                 | Runnable类型的任务               | void     |
| <T> Future<T> submit(Callable<T> task);        | Runnable类型的任务               | 执行结果 |
| <T> Future<T> submit(Runnable task, T result); | Runnable类型的任务以及result内容 | result   |

3. 线程池中任务执行原理

>当用户提交任务到线程池后，在线程池没有执行拒绝策略的情况下，用户线程会马上返回，而提交的任务要么切换到worker线程执行，要么放入阻塞队列里面由worker线程来执行。

4. 线程池的关闭

| 方法          | 作用                                                         | 返回值           |
| ------------- | ------------------------------------------------------------ | ---------------- |
| shutdown()    | 设置为shutdown状态，线程池不会接收新的任务，但是队列里面的任务还是要执行的 | void             |
| shutdownNow() | 设置为stop状态，线程池不会接收新的任务，并且会丢弃工作队列里面的任务 | 被丢弃的任务列表 |

5. 线程池的拒绝策略

>拒绝策略执行的触发条件：线程池中线程的个数达到maxpoolsize,对于新投递的任务进行拒绝策略的执行。

| 拒绝策略                | 策略内容                                         |
| ----------------------- | ------------------------------------------------ |
| CallerRunsPolicy()      | 使用调用线程执行新提交的任务                     |
| AbortPolicy()           | 抛弃新增任务，抛出RejectedExecutionException     |
| DiscardOldestPolicy（） | 抛弃队列里面最老的任务，并把新任务添加到队列里面 |
| DiscardPolicy()         | 抛弃新增任务                                     |

# 基于JDK中的Future实现异步编程

3.1 jdk中的future

>```java
>public interface Future<V> {
>	//取消任务，如果任务正在执行，mayInterruptIfRunning设置为true打断，否则不中断
>    boolean cancel(boolean mayInterruptIfRunning);
>
>    //如何任务在执行前被取消返回true,否则返回false
>    boolean isCancelled();
>
>    //判断任务是否已经完成
>    boolean isDone();
>	
>    // 等待异步任务执行完，返回结果
>    
>    V get() throws InterruptedException, ExecutionException;
>	
>    //到达超时时间后，返回，不会一直阻塞调用线程
>    
>    V get(long timeout, TimeUnit unit)
>        throws InterruptedException, ExecutionException, TimeoutException;
>}
>```

3.2.1 FutureTask概述

>1.FutureTask只有当任务结束才能获取返回值。
>
>2.返回值只能通过get方法获取，调用get会阻塞
>
>3.任务一旦运行完成不能被重启，除非运行过程中使用了runAndReset方法

3.2.2 FutureTask类图结构

