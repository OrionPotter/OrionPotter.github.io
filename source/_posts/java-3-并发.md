---
title: java基础-并发编程
tag:
- java
---

# 基础概念

## 什么是线程和进程

**线程**：线程是CPU的调度单位，是一个进程中独立运行的最小子任务，它共享进程的资源。

**进程**：进程是操作系统分配资源和调度执行的基本单位，它包含了一个或多个线程，一个应用程序启动相当于起了一个进程。

## 并行与并发的区别

- **并发**：两个及两个以上的作业在同一 **时间段** 内执行。
- **并行**：两个及两个以上的作业在同一 **时刻** 执行。

## 多线程的优缺点

### 多线程的优点

1. **CPU利用率**：多线程可以充分利用多核处理器的优势，提升程序的运行效率。
2. **实现并发**：多线程可以同时处理多个并发任务，例如同时下载多个文件或处理多个客户端请求，从而提高系统的吞吐量。

### 多线程的缺点

1. **上下文切换开销**：线程的上下文切换需要保存和恢复线程的状态，频繁的上下文切换，会消耗系统资源，增加CPU的负担。
2. **数据一致性**：多个线程同时读写同一个变量。如果不加以正确的同步控制，会出现数据不一致的问题。
3. **死锁和活锁**：容易出现死锁和活锁问题，多个线程互相等待对方释放资源，导致程序无法继续执行。

## Java中实现多线程的方式

**java的线程启动，最终依赖于Thread.start方法**

- 继承`Thread`类
- 实现`Runnable`接口
- 实现`Callable`接口和使用`Future`

# 线程的基本操作

## 线程的生命周期

**新建状态(New):** 线程对象被创建时的初始状态，还未调用`start()`方法启动线程。

**就绪 (Runnable):** 当调用线程对象的`start()`方法后，线程进入就绪状态。就绪状态的线程已经具备了运行的条件，等待CPU调度执行。

**阻塞 (Blocked):**  线程被阻塞，等待获取一个监视器锁，以进入同步块或方法，或者在调用`Object.wait()`后重新进入同步块或方法。

**WAITING（等待）:** 线程因为调用了`Object.wait()`、`Thread.join()`或`LockSupport.park()`等方法，而进入等待状态，等待其他线程执行特定操作。

**TIMED_WAITING（定时等待):** 线程因为调用了带有超时参数的等待方法，如`Thread.sleep()`、`Object.wait(long)`、`Thread.join(long)`等，而进入定时等待状态。

**终止 (Terminated):** 线程执行完毕或者因为未捕获的异常退出，进入终止状态。

## 创建和启动线程

### 继承Thread类

>通过继承Thread类，重写run(),创建子类对象即为创建一个线程，调用start方法即可启动线程

```java
public class ExtendThread extends Thread {
    @Override
    public void run() {
        System.out.println("extend thread execute");
    }
    public static void main(String[] args) {
        ExtendThread thread = new ExtendThread();
        thread.start();
    }
}
```

**注意：线程的执行顺序和代码编写的顺序没有关系**

### 实现Runnable接口

>Runnable接口只有一个run方法，实现Runnable接口，实现run()，创建Thread类并传入Runnable实例，调用Thread类实例的start()

```java
public class ImplementsRunnable implements Runnable {
    @Override
    public void run() {
        System.out.println("implements Runnable execute");
    }
    public static void main(String[] args) {
        Thread thread = new Thread(new ImplementsRunnable());
        thread.start();
    }
}
```

### 实现Callable接口

>Callable接口只有一个call(),它与Runnable接口都属于接口，不同的是它可以返回值，实现Callable接口，实现call(),创建FutureTask,传入callbale接口实例，创建Thread类实例，传入FutureTask实例，调用Thread的start方法

```java
public class ImplementsCallable implements Callable<String> {
    @Override
    public String call() throws Exception {
        System.out.println("implements Callable execute");
        return "success";
    }

    public static void main(String[] args) throws ExecutionException, InterruptedException {
        FutureTask<String> futureTask = new FutureTask<>(new ImplementsCallable());
        Thread thread = new Thread(futureTask);
        thread.start();
        System.out.println("返回值为: "+futureTask.get());
    }
}
```

## 线程的优先级设置

线程的优先级可以通过 `setPriority()` 方法来设置。线程的优先级范围通常是从1到10，其中1是最低优先级，10是最高优先级，默认优先级是5,线程调度器会尽可能地按照线程的优先级来调度执行。

```java
ExtendThread thread = new ExtendThread();
thread.setPriority(10);
thread.start();
thread.getPriority();//获取优先级
```

>通过合理设置线程的优先级，可以在一定程度上影响线程的调度顺序，但应注意它的实际影响可能因环境而异。

## 线程的命名

通过两种方式来命名线程：使用构造函数或者设置名称属性。

### 构造函数

```java
Thread thread = new Thread(new ImplementsRunnable(),"thread name");
```

### 设置名称属性

```java
Thread thread = new Thread(new ImplementsRunnable());
thread.setName("thread name");
thread.start();
```

### 获取线程名称

```java
thread.getName()：获取线程的名称。
```

## 线程睡眠

```java
Thread.sleep(long millis);//让当前正在执行的线程休眠指定的毫秒数。
```

## 线程中断

```java
thread.interrupt();中断线程，设置线程的中断状态为true。
Thread.isInterrupted();判断线程是否被中断，返回一个boolean值。
Thread.interrupted();静态方法，测试当前线程是否被中断，并清除中断状态。
```

## 线程同步

```java
thread.join();//等待该线程终止。
thread.join(long millis);//等待该线程终止的最长时间为millis毫秒。
Thread.yield();//暂停当前正在执行的线程对象，并执行其他线程。
```

## 等待/通知机制

```java
thread.wait();//导致当前线程等待，直到另一个线程调用该对象的notify()或notifyAll()方法来唤醒线程。
thread.notify();//唤醒在对象上等待的单个线程，如果有多个线程在等待，则由线程调度器决定唤醒哪一个线程。
thread.notifyAll();//唤醒在当前对象上等待的所有线程。
```



# 线程同步

## 什么是线程同步？

线程同步是指多个线程对共享资源进行访问时，按照一定顺序进行操作，以避免由于竞争而导致数据不一致或程序崩溃的一种机制。简单来说，线程同步就是“排队”，让多个线程一个接一个地访问共享资源，避免同时操作导致混乱。

## 同步机制目的

线程同步的主要目的是保证多线程环境下共享数据的一致性和程序的正确性。

**具体来说，线程同步可以防止以下问题：**

- **竞态条件: 由于多个线程同时修改共享数据，导致数据值不一致。**
- **死锁: 两个或多个线程相互等待资源，导致任何线程都无法继续执行。**
- **活锁: 两个或多个线程陷入循环等待，导致程序一直处于忙碌状态，但无法取得实际进展。**

## 同步机制的分类

### 互斥同步

互斥同步是指在同一时刻，只能有一个线程访问共享资源。其他试图访问共享资源的线程必须等待，直到当前线程释放资源后才能继续。

互斥同步的常见实现方式是使用互斥锁（mutex）。互斥锁是一种二进制信号量，其值只能为 0 或 1。当一个线程获得互斥锁时，其值变为 1，表示该线程正在访问共享资源；其他线程试图获得互斥锁时，其值将保持为 1，导致其他线程阻塞，直到当前线程释放互斥锁，其值变为 0，其他线程才能继续尝试获取。

### 信号量同步

信号量同步是一种更通用的同步机制，它允许多个线程同时访问共享资源，但必须遵循一定的规则。

信号量使用一个整型计数器来表示可用的资源数量。当一个线程试图访问共享资源时，先需要获取信号量。如果计数器大于 0，则表示有可用的资源，计数器减 1，该线程获得资源；如果计数器等于 0，则表示没有可用的资源，该线程必须等待，直到其他线程释放资源，计数器加 1，该线程才能继续尝试获取。

### 条件变量同步

条件变量是一种基于互斥锁的同步机制，它允许多个线程等待特定条件的发生。

条件变量通常与互斥锁一起使用，用于控制多个线程对共享资源的访问顺序。例如，生产者-消费者模式中，生产者线程负责生产数据并放入缓冲区，消费者线程负责从缓冲区中取出数据。为了避免生产者和消费者线程同时访问缓冲区，可以使用条件变量来控制生产者和消费者线程的访问顺序。

### 读写锁

读写锁是一种特殊的互斥锁，它允许多个线程同时读取共享资源，但只能有一个线程写入共享资源。

读写锁提高了多线程环境下读取共享资源的效率，因为多个线程可以同时读取共享资源，而不需要像互斥锁那样排队等待。

### 同步机制的选择

- 如果只需要保证一个线程独占访问共享资源，可以使用互斥锁。
- 如果需要控制多个线程访问共享资源的数量，可以使用信号量。
- 如果需要等待特定条件发生，可以使用条件变量。
- 如果需要提高读取共享资源的效率，可以使用读写锁。

# 线程安全

## 什么是线程安全？

线程安全是指一个对象在多个线程同时访问的情况下，能够保持其状态的一致性和行为的正确性。简单来说，线程安全就是“不怕多线程”，多个线程可以放心地访问同一个对象

## 线程安全问题

### 竞态条件

竞态条件是指多个线程对共享数据进行操作时，由于操作的顺序不同，导致最终结果不一致的一种情况。

**例如：**

假设有一个银行账户，有两个线程要分别从该账户中提取 100 元。如果代码没有采取任何同步措施，那么就有可能出现以下情况：

- 线程 1 首先检查账户余额为 1000 元，然后开始取款操作。
- 在线程 1 取款操作的过程中，线程 2 也检查账户余额为 1000 元，并开始取款操作。
- 最终，两个线程都成功取走了 100 元，导致账户余额变为 800 元，而不是预期的 900 元。

### 死锁

死锁是指两个或多个线程相互等待资源，导致任何线程都无法继续执行的一种情况。

**例如：**

假设有两个线程，线程 1 需要获取资源 A 和资源 B，线程 2 需要获取资源 B 和资源 A。如果代码没有采取任何同步措施，那么就有可能出现死锁：

- 线程 1 先获取了资源 A，然后试图获取资源 B。
- 线程 2 先获取了资源 B，然后试图获取资源 A。
- 最终，两个线程都处于等待状态，无法继续执行。

### 活锁

活锁是指两个或多个线程陷入循环等待，导致程序一直处于忙碌状态，但无法取得实际进展的一种情况。

**例如：**

假设有两个线程，线程 1 需要获取资源 A 和资源 B，线程 2 需要获取资源 B 和资源 A。如果代码没有采取任何同步措施，那么就有可能出现活锁：

- 线程 1 先释放资源 A，然后试图获取资源 B。
- 线程 2 先释放资源 B，然后试图获取资源 A。
- 两个线程不断地释放和获取资源，但始终无法同时获取到所需的两个资源，导致程序一直处于忙碌状态。

## 线程安全的设计原则

+ 避免共享数据：如果可以，尽量避免多个线程共享数据。这样可以从根本上消除线程安全问题的可能性。

+ 使用同步机制保护共享数据：如果必须共享数据，则必须使用合适的同步机制来保护共享数据。

+ 使用不可变对象：如果可以，尽量使用不可变对象。不可变对象一旦创建就不能被修改，因此线程安全。

+ 打破依赖关系：如果可以，尽量打破线程之间的依赖关系。这样可以减少线程之间同步的需求。

## 线程安全方法

### 互斥锁

#### `synchronized`关键字

`synchronized` 关键字可以用来修饰方法或代码块，以确保同一时间只有一个线程可以执行这些代码。

**1. 同步方法**

```java
public synchronized void instanceMethod() {
    // 线程安全的代码
}
```

**2. 同步静态方法**

```java
public static synchronized void staticMethod() {
    // 线程安全的代码
}
```

**3. 同步代码块**

```java
public void method() {
    synchronized(this) {
        // 线程安全的代码
    }
}
```

**锁升级的过程**

无锁->偏向锁（有一个线程访问同步代码）->轻量级锁（多个线程访问进行CAS自旋，用户态）->重量级锁（自旋大于10次升级为重量级锁，内核态）

#### `ReentrantLock可重入锁`

`ReentrantLock`（可重入锁），它允许线程在持有锁的情况下能够再次获取同一个锁,具有显式锁定机制，提供了更灵活的锁定操作,它比 `synchronized` 关键字更强大。

**创建ReentrantLock对象**

```java
ReentrantLock lock = new ReentrantLock();
```

**获取锁：**

使用 `lock()` 方法获取锁。如果锁不可用，当前线程会被阻塞，直到获取到锁为止。

```java
lock.lock();
try {
    // 执行需要同步的代码块
} finally {
    // 一定要在 finally 块中释放锁，确保异常时也能正确释放锁
    lock.unlock();
}
```

**释放锁：**

使用 `unlock()` 方法释放锁。一般在 `try-finally` 块中释放锁，确保不论是否发生异常，都能正确释放锁资源。

**使用 tryLock() 尝试获取锁**

`tryLock()` 方法尝试获取锁，如果获取成功立即返回 true，如果获取失败（锁被其他线程持有），立即返回 false。

```java
if (lock.tryLock()) {
    try {
        // 成功获取锁，执行同步代码块
    } finally {
        lock.unlock();
    }
} else {
    // 获取锁失败，做相应的处理
}
```

**设置锁的公平性：**

在创建 ReentrantLock 对象时，可以选择是否使用公平锁（Fairness）。公平锁会按照线程请求的顺序来获取锁，而非公平锁则允许“插队”，可能会导致某些线程长时间等待。

```java
ReentrantLock fairLock = new ReentrantLock(true); // 使用公平锁
```

**其他方法：**

- `isLocked()`：查询锁是否被任何线程持有。
- `getHoldCount()`：查询当前线程持有锁的次数。
- `isHeldByCurrentThread()`：查询当前线程是否持有锁。

### 信号量同步

信号量同步用于控制共享资源的数量。它允许多个线程同时访问共享资源，但必须遵循一定的规则。

```java
public class Buffer {
    private Semaphore semaphore = new Semaphore(10); // 限制资源数量为 10

    public void put(Object item) throws InterruptedException {
        semaphore.acquire(); // 获取许可
        try {
            // 将 item 放入缓冲区
        } finally {
            semaphore.release(); // 释放许可
        }
    }

    public Object take() throws InterruptedException {
        semaphore.acquire(); // 获取许可
        try {
            // 从缓冲区中取出一个 item
        } finally {
            semaphore.release(); // 释放许可
        }
    }
}
```

### 条件变量同步

条件变量同步是一种基于互斥锁的同步机制，它允许多个线程等待特定条件发生。通常与 `Lock` 接口一起使用。

```
public class ProducerConsumer {
    private Queue<Object> queue = new LinkedList<>();
    private Condition notEmptyCondition = lock.newCondition();
    private Condition notFullCondition = lock.newCondition();

    public void produce(Object item) throws InterruptedException {
        lock.lock();
        try {
            while (queue.size() == MAX_SIZE) {
                notFullCondition.await(); // 等待缓冲区不满
            }
            queue.offer(item); // 将 item 放入缓冲区
            notEmptyCondition.signal(); // 通知消费者可以消费
        } finally {
            lock.unlock();
        }
    }

    public Object consume() throws InterruptedException {
        lock.lock();
        try {
            while (queue.isEmpty()) {
                notEmptyCondition.await(); // 等待缓冲区非空
            }
            Object item = queue.poll(); // 从缓冲区中取出一个 item
            notFullCondition.signal(); // 通知生产者可以生产
            return item;
        } finally {
            lock.unlock();
        }
    }
}

```

### 读写锁

主要有两个锁：读锁和写锁。通过维护一个计数器来追踪读锁和写锁的持有情况，读操作之间可以共享读锁，写操作必须独占写锁，适合读多写少的场景，可以提升并发性能。

```java
public class Cache<K, V> {
    private final Map<K, V> cacheMap = new HashMap<>();
    private final ReadWriteLock lock = new ReentrantReadWriteLock();

    public V get(K key) {
        lock.readLock().lock(); // 获取读锁
        try {
            return cacheMap.get(key);
        } finally {
            lock.readLock().unlock(); // 释放读锁
        }
    }

    public void put(K key, V value) {
        lock.writeLock().lock(); // 获取写锁
        try {
            cacheMap.put(key, value);
        } finally {
            lock.writeLock().unlock(); // 释放写锁
        }
    }
}
```

## 悲观锁和乐观锁

悲观锁：共享资源只能被一个线程独享受，有synchronized、ReentrantLock。

乐观锁：共享资源不独享，只有在修改的时候会通过版本号或者cas（比较和交换）算法验证数据是否被其他线程修改，有原子变量类。

### 避免死锁的方法

1. **避免嵌套锁定**：尽量避免一个锁内再获取另一个锁。
2. **锁定顺序**：确保所有线程以相同的顺序获取锁。
3. **使用超时**：使用 `tryLock` 方法尝试获取锁，并设置超时时间。

```java
public class AvoidDeadlock {
    private final ReentrantLock lock1 = new ReentrantLock();
    private final ReentrantLock lock2 = new ReentrantLock();

    public void method1() {
        try {
            if(lock1.tryLock(1, TimeUnit.SECONDS)) {
                try {
                    if(lock2.tryLock(1, TimeUnit.SECONDS)) {
                        try {
                            // 线程安全的代码
                        } finally {
                            lock2.unlock();
                        }
                    }
                } finally {
                    lock1.unlock();
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

# 线程池

## 什么是线程池

线程池是一种管理和重复利用线程的机制，当有任务要处理时，直接从线程池中获取线程来处理，处理完之后线程并不会立即被销毁，而是等待下一个任务。

## 线程池的优点

1. **降低资源消耗**：通过重复利用线程，减少了线程创建和销毁的开销。
2. **提高响应速度**：任务可以立即执行，无需等待线程创建。
3. **提高线程的可管理性**：可以限制线程的数量，防止因线程过多导致的资源消耗问题。
4. **提供更强的任务执行能力**：可以对线程进行统一的管理、调优和监控。

## 线程池的状态

<img src="https://telegraph-image-2ni.pages.dev/file/185dea93ba62f526dd009.png" style="zoom:50%;" />



1. **RUNNING（运行）**：线程池处于正常工作状态，能够接受新的任务，并且处理阻塞队列中的任务。
2. **SHUTDOWN（关闭）**：不再接受新的任务，但是能够处理阻塞队列中已经存在的任务，等待阻塞队列中的任务完成。
3. **STOP（停止）**：不再接受新的任务，也不处理阻塞队列中的任务，并且会中断正在处理中的任务。
4. **TIDYING（整理）**：所有任务都已经终止，工作线程数为0，线程池会转换到这个状态来执行一些内部清理工作。
5. **TERMINATED（终止）**：线程池完全终止，已经执行了terminated()钩子方法。

```java
private static final int RUNNING    = -1 << COUNT_BITS;
private static final int SHUTDOWN   =  0 << COUNT_BITS;
private static final int STOP       =  1 << COUNT_BITS;
private static final int TIDYING    =  2 << COUNT_BITS;
private static final int TERMINATED =  3 << COUNT_BITS;
```



## 创建线程池的方式

**方式一：通过`ThreadPoolExecutor`构造函数来创建（推荐）**

**方式二：通过 `Executor` 框架的工具类 `Executors` 来创建。**

### 使用 `ThreadPoolExecutors` 创建线程池

线程池必须手动通过 `ThreadPoolExecutor` 的构造函数来声明，避免使用`Executors` 类创建线程池，会有OOM风险,**使用有界队列，控制线程创建数量。**显示地给我们的线程池命名，这样有助于我们定位问题。

```java
public class CustomThreadPoolExample {
    public static void main(String[] args) {
        int corePoolSize = 5;// 核心线程数
        int maxPoolSize = 10;// 最大线程数
        long keepAliveTime = 5000; //当线程数大于核心线程数时，多余的空闲线程存活的最长时间
        BlockingQueue<Runnable> workQueue = new ArrayBlockingQueue<>(10); //任务队列，用来储存等待执行任务的队列
        ThreadFactory threadFactory = Executors.defaultThreadFactory(); //线程工厂，用来创建线程，一般默认即可
        RejectedExecutionHandler handler = new ThreadPoolExecutor.CallerRunsPolicy(); //拒绝策略，当提交的任务过多而不能及时处理时，我们可以定制策略来处理任务

        // 创建自定义线程池
        ThreadPoolExecutor customThreadPool = new ThreadPoolExecutor(
                corePoolSize, maxPoolSize, keepAliveTime, TimeUnit.MILLISECONDS,
                workQueue, threadFactory, handler);

        // 执行任务
        for (int i = 0; i < 100; i++) {
            customThreadPool.execute(() -> System.out.println("Executing task"+ Thread.currentThread()));
        }

        // 关闭线程池
        customThreadPool.shutdown();
    }
}
```

**参数介绍：**

- `corePoolSize` : 任务队列未达到队列容量时，最大可以同时运行的线程数量。
- `maximumPoolSize` : 任务队列中存放的任务达到队列容量的时候，当前可以同时运行的线程数量变为最大线程数。
- `workQueue`: 新任务来的时候会先判断当前运行的线程数量是否达到核心线程数，如果达到的话，新任务就会被存放在队列中。
  - 容量为 `Integer.MAX_VALUE` 的 `LinkedBlockingQueue`（无界队列）：`FixedThreadPool` 和 `SingleThreadExector` 。`FixedThreadPool`最多只能创建核心线程数的线程（核心线程数和最大线程数相等），`SingleThreadExector`只能创建一个线程（核心线程数和最大线程数都是 1），二者的任务队列永远不会被放满。
  - `SynchronousQueue`（同步队列）：`CachedThreadPool` 。`SynchronousQueue` 没有容量，不存储元素，目的是保证对于提交的任务，如果有空闲线程，则使用空闲线程来处理；否则新建一个线程来处理任务。也就是说，`CachedThreadPool` 的最大线程数是 `Integer.MAX_VALUE` ，可以理解为线程数是可以无限扩展的，可能会创建大量线程，从而导致 OOM。
  - `DelayedWorkQueue`（延迟阻塞队列）：`ScheduledThreadPool` 和 `SingleThreadScheduledExecutor` 。`DelayedWorkQueue` 的内部元素并不是按照放入的时间排序，而是会按照延迟的时间长短对任务进行排序，内部采用的是“堆”的数据结构，可以保证每次出队的任务都是当前队列中执行时间最靠前的。`DelayedWorkQueue` 添加元素满了之后会自动扩容原来容量的 1/2，即永远不会阻塞，最大扩容可达 `Integer.MAX_VALUE`，所以最多只能创建核心线程数的线程。

- `keepAliveTime`:线程池中的线程数量大于 `corePoolSize` 的时候，如果这时没有新的任务提交，核心线程外的线程不会立即销毁，而是会等待，直到等待的时间超过了 `keepAliveTime`才会被回收销毁。
- `unit` : `keepAliveTime` 参数的时间单位。
- `threadFactory` :executor 创建新线程的时候会用到。
- `handler` : 拒绝策略
  - `ThreadPoolExecutor.AbortPolicy`：抛出 `RejectedExecutionException`来拒绝新任务的处理。
  - `ThreadPoolExecutor.CallerRunsPolicy`：调用执行自己的线程运行任务，也就是直接在调用`execute`方法的线程中运行(`run`)被拒绝的任务，如果执行程序已关闭，则会丢弃该任务。因此这种策略会降低对于新任务提交速度，影响程序的整体性能。如果你的应用程序可以承受此延迟并且你要求任何一个任务请求都要被执行的话，你可以选择这个策略。
  - `ThreadPoolExecutor.DiscardPolicy`：不处理新任务，直接丢弃掉。
  - `ThreadPoolExecutor.DiscardOldestPolicy`：此策略将丢弃最早的未处理的任务请求。

### 使用 `Executors` 创建线程池

Java 提供了 `Executors` 类来创建不同类型的线程池。它是一个工厂类，提供了多种静态方法来创建不同配置的线程池。

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

## 如何启动线程池

### execute方法

```java
public interface Executor {
    void execute(Runnable command);
}
```

用于提交不需要返回值的任务，适合简单的异步执行。

### submit方法

```java
public interface ExecutorService extends Executor {
    <T> Future<T> submit(Callable<T> task);
    <T> Future<T> submit(Runnable task, T result);
    Future<?> submit(Runnable task);
}    
```

`submit` 方法会返回一个 `Future` 对象，通过 `Future` 对象我们可以获取任务的执行结果，取消任务的执行，或者检查任务是否完成。

如果任务执行过程中抛出了异常，异常会被封装在 `Future` 对象中，并在调用 `get()` 方法时抛出。

## 线程池原理分析

```java
public void execute(Runnable command) {
        if (command == null)
            throw new NullPointerException();
        int c = ctl.get();
        if (workerCountOf(c) < corePoolSize) {
            if (addWorker(command, true))
                return;
            c = ctl.get();
        }
        if (isRunning(c) && workQueue.offer(command)) {
            int recheck = ctl.get();
            if (! isRunning(recheck) && remove(command))
                reject(command);
            else if (workerCountOf(recheck) == 0)
                addWorker(null, false);
        }
        else if (!addWorker(command, false))
            reject(command);
 }
```

1. 如果当前运行的线程数小于核心线程数，那么就会新建一个线程来执行任务。
2. 如果当前运行的线程数等于或大于核心线程数，但是小于最大线程数，那么就把该任务放入到任务队列里等待执行。
3. 如果向任务队列投放任务失败（任务队列已经满了），但是当前运行的线程数是小于最大线程数的，就新建一个线程来执行任务。
4. 如果当前运行的线程数已经等同于最大线程数了，新建线程将会使当前运行的线程超出最大线程数，那么当前任务会被拒绝，拒绝策略会调用`RejectedExecutionHandler.rejectedExecution()`方法。

# 高级多线程技术

## Future 和 Callable 接口

- **Callable 接口**：`java.util.concurrent.Callable` 是一个泛型接口，类似于 `Runnable`，但是可以返回一个结果或抛出一个异常。它的 `call()` 方法可以在执行时返回结果。

  ```java
  public interface Callable<V> {
      V call() throws Exception;
  }
  // 示例
  public class MyCallable implements Callable<Integer> {
      @Override
      public Integer call() throws Exception {
          // 模拟一些计算
          int result = 0;
          for (int i = 0; i < 10; i++) {
              result += i;
          }
          return result;
      }
  }
  ```

- **Future 接口**：`java.util.concurrent.Future` 表示异步计算的结果。它提供了方法来检查计算是否完成、等待计算的完成以及获取计算的结果。

  ```java
  public interface Future<V> {
      boolean cancel(boolean mayInterruptIfRunning);
      boolean isCancelled();
      boolean isDone();
      V get() throws InterruptedException, ExecutionException;
      V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
  }
  // 示例
  public class FutureExample {
      public static void main(String[] args) {
          ExecutorService executor = Executors.newSingleThreadExecutor();
          Callable<Integer> callable = new MyCallable();
          Future<Integer> future = executor.submit(callable);
  
          try {
              Integer result = future.get(); // 阻塞直到任务完成
              System.out.println("计算结果: " + result);
          } catch (InterruptedException | ExecutionException e) {
              e.printStackTrace();
          } finally {
              executor.shutdown();
          }
      }
  }
  ```

## CompletableFuture接口

CompletableFuture 是 Java 8 中引入的一种用于异步编程的类。它扩展了 Future 接口，提供了许多新的特性，使得异步编程更加方便、灵活。

### CompletableFuture用途

**创建异步任务**

- `supplyAsync(Supplier<? extends T> supplier)`：创建一个异步任务，该任务将在 ForkJoinPool 中异步执行，并返回由指定的 `Supplier` 提供的计算结果。
- `runAsync(Runnable runnable)`：创建一个异步任务，该任务将在 ForkJoinPool 中异步执行，但不返回任何结果。

**组合异步任务**

- `thenCombine(CompletableFuture<U> other, BiFunction<? super T, ? super U, ? extends V> combiner)`：将当前 CompletableFuture 与另一个 CompletableFuture 组合起来，并使用指定的 `BiFunction` 函数组合两个 CompletableFuture 的结果。
- `thenCompose(Function<? super T, ? extends CompletableFuture<? extends V>> finisher)`：将当前 CompletableFuture 的结果转换为另一个 CompletableFuture，并使用指定的 `Function` 函数启动另一个异步任务。
- `allOf(CompletableFuture<?>... futures)`：创建一个新的 CompletableFuture，该 CompletableFuture 将在所有指定的 CompletableFuture 都完成后完成。
- `anyOf(CompletableFuture<?>... futures)`：创建一个新的 CompletableFuture，该 CompletableFuture 将在任何一个指定的 CompletableFuture 完成后完成。

**处理异步任务结果**

- `thenAcceptAsync(Consumer<? super T> action)`：对当前 CompletableFuture 的结果执行指定的 `Consumer` 函数，但不返回任何结果。
- `thenApplyAsync(Function<? super T, ? extends V> function)`：对当前 CompletableFuture 的结果应用指定的 `Function` 函数，并返回函数的返回值。
- `thenAcceptBothAsync(CompletableFuture<?> other, BiConsumer<? super T, ? super U> action)`：对当前 CompletableFuture 和另一个 CompletableFuture 的结果执行指定的 `BiConsumer` 函数，但不返回任何结果。
- `thenCombineAsync(CompletableFuture<?> other, BiFunction<? super T, ? super U, ? extends V> combiner)`：将当前 CompletableFuture 与另一个 CompletableFuture 组合起来，并使用指定的 `BiFunction` 函数组合两个 CompletableFuture 的结果，但返回函数的返回值。

**管理异常**

- `exceptionally(Function<Throwable, ? extends T> function)`：为当前 CompletableFuture 指定异常处理程序。如果 CompletableFuture 执行过程中发生异常，则异常处理程序将被调用，并使用异常作为参数。
- `handleAsync(BiFunction<? super T, ? super Throwable, ? extends V> function)`：为当前 CompletableFuture 指定异步异常处理程序。如果 CompletableFuture 执行过程中发生异常，则异步异常处理程序将被调用，并使用结果作为参数。

**CompletableFuture优点**

- **易于使用**：CompletableFuture 提供了直观易用的 API，可以轻松地启动、组合和管理异步任务。
- **功能强大**：CompletableFuture 提供了丰富的功能，可以满足各种异步编程需求。
- **可扩展性强**：CompletableFuture 可以与其他异步编程框架配合使用，例如 Spring 异步编程框架。

**CompletableFuture的应用场景**

- **网络编程**：CompletableFuture 可以用于异步地发送和接收网络请求。
- **I/O 操作**：CompletableFuture 可以用于异步地进行文件读写等 I/O 操作。
- **高并发编程**：CompletableFuture 可以用于提高并发程序的性能。

```java
public class CompletableFutureExample {
        public static void main(String[] args) throws Exception {
            int a = 10;
            int b = 12;
            
			//创建有返回值的异步任务
            CompletableFuture<Integer> future1 = CompletableFuture.supplyAsync(() -> count(a));
            CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(() -> count(b));

            //合并两个异步任务的结果
            CompletableFuture<String> combinedFuture = future1.thenCombine(future2, (result1, result2) -> {
                return result1 + "\n\n" + result2;
            });

            //输出合并后的结果
            combinedFuture.thenAcceptAsync(result -> System.out.println(result));
        }

        private static int count(int  a) {
            try {
                return a;
            } catch (Exception e) {
                throw new RuntimeException("failed count");
            }
        }
}
```

## CompletionService 的使用

`CompletionService` 接口用于管理一组异步任务的执行，并提供一种方法来获取这些任务的结果。

```java
public class CompletionServiceExample {
    public static void main(String[] args) {
        ExecutorService executor = Executors.newFixedThreadPool(3);
        CompletionService<Integer> completionService = new ExecutorCompletionService<>(executor);

        for (int i = 0; i < 5; i++) {
            final int taskId = i;
            completionService.submit(() -> {
                TimeUnit.SECONDS.sleep(taskId);
                return taskId;
            });
        }

        for (int i = 0; i < 5; i++) {
            try {
                Future<Integer> future = completionService.take(); // 阻塞直到有任务完成
                Integer result = future.get();
                System.out.println("完成任务: " + result);
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
        executor.shutdown();
    }
}
```

## Fork/Join 框架

`java.util.concurrent.ForkJoinPool` 和 `java.util.concurrent.RecursiveTask` / `RecursiveAction` 组成了 Fork/Join 框架，用于处理可以被分解为更小任务并行执行的任务集合。它适用于分治算法，提供了更高效的并行处理能力。

```java
public class FibonacciTask extends RecursiveTask<Integer> {
    private final int n;

    public FibonacciTask(int n) {
        this.n = n;
    }

    @Override
    protected Integer compute() {
        if (n <= 1) {
            return n;
        } else {
            FibonacciTask task1 = new FibonacciTask(n - 1);
            task1.fork(); // 分解任务

            FibonacciTask task2 = new FibonacciTask(n - 2);
            int result2 = task2.compute(); // 直接计算右侧的子任务

            return task1.join() + result2; // 等待左侧任务完成并合并结果
        }
    }

    public static void main(String[] args) {
        int n = 10; // 计算斐波那契数列的第10项
        FibonacciTask task = new FibonacciTask(n);
        int result = task.compute();
        System.out.println("Fibonacci number at position " + n + " is " + result);
    }
}
```

## 并行流（Parallel Streams）

Java 8 引入了并行流（Parallel Streams），可以通过流的 `parallel()` 方法将顺序流转换为并行流，以便在多核处理器上并行执行操作。它利用 Fork/Join 框架来实现并行化的操作，简化了编写并行代码的过程。

```java
List<Integer> list = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8);

// 顺序流
list.stream().forEach(System.out::println);

// 并行流
list.parallelStream().forEach(System.out::println);
```

# 并发包（java.util.concurrent）

## 多线程工具类

### CountDownLatch

**作用：** CountDownLatch是一个同步工具类，它允许一个或多个线程等待其他线程完成操作。

**示例：** 假设有一个主线程和多个工作线程，主线程希望等待所有工作线程都完成某个任务后再继续执行，可以使用CountDownLatch来实现这种等待机制。

```java
public class CountDownLatchExample {
    public static void main(String[] args) throws InterruptedException {
        int numThreads = 3;
        CountDownLatch latch = new CountDownLatch(numThreads);

        for (int i = 0; i < numThreads; i++) {
            Thread thread = new Thread(new Worker(latch));
            thread.start();
        }

        // 主线程等待所有工作线程完成
        latch.await();
        System.out.println("All workers have finished, main thread can proceed.");
    }

    static class Worker implements Runnable {
        private final CountDownLatch latch;

        Worker(CountDownLatch latch) {
            this.latch = latch;
        }

        public void run() {
            try {
                // 模拟工作
                Thread.sleep((int) (Math.random() * 1000));
                System.out.println("Worker finished its job.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } finally {
                // 完成工作，倒计数器减一
                latch.countDown();
            }
        }
    }
}
```

### CyclicBarrier

**作用：** CyclicBarrier也是用来同步多个线程的工具类，它允许一组线程互相等待，直到所有线程都到达某个公共屏障点。

**示例：** 假设有一组数据处理任务，需要所有任务完成后，再执行合并操作。

```java
public class CyclicBarrierExample {
    public static void main(String[] args) {
        int numWorkers = 3;
        CyclicBarrier barrier = new CyclicBarrier(numWorkers, () -> {
            System.out.println("All workers have reached the barrier, can proceed with merging results.");
        });

        for (int i = 0; i < numWorkers; i++) {
            Thread thread = new Thread(new Worker(barrier));
            thread.start();
        }
    }

    static class Worker implements Runnable {
        private final CyclicBarrier barrier;

        Worker(CyclicBarrier barrier) {
            this.barrier = barrier;
        }

        public void run() {
            try {
                // 模拟任务执行
                Thread.sleep((int) (Math.random() * 1000));
                System.out.println("Worker has finished its task and waiting at the barrier.");
                // 等待其他线程
                barrier.await();
                System.out.println("Worker has passed the barrier and continues execution.");
            } catch (InterruptedException | BrokenBarrierException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
```

### Semaphore

**作用：** Semaphore是用来控制同时访问特定资源的线程数量，它维护了一组许可证。

**示例：** 假设有一个连接池，限制最多只能有3个线程同时获取连接。

```java
public class SemaphoreExample {
    public static void main(String[] args) {
        int numConnections = 3;
        Semaphore semaphore = new Semaphore(numConnections);

        for (int i = 0; i < 5; i++) { // 假设有5个线程需要获取连接
            Thread thread = new Thread(new Worker(semaphore));
            thread.start();
        }
    }

    static class Worker implements Runnable {
        private final Semaphore semaphore;

        Worker(Semaphore semaphore) {
            this.semaphore = semaphore;
        }

        public void run() {
            try {
                semaphore.acquire();//获取许可
                System.out.println("Thread " + Thread.currentThread().getName() + " is working.");
                Thread.sleep((int) (Math.random() * 1000));
                //释放许可
                semaphore.release();
                System.out.println("Thread " + Thread.currentThread().getName() + " has finished.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
```

### Exchanger

**作用：** Exchanger是一个用于两个线程之间交换数据的同步工具类。

**示例：** 假设有两个线程，一个线程生产数据，一个线程消费数据，它们需要交换数据。

```java
public class ExchangerExample {
    public static void main(String[] args) {
        Exchanger<String> exchanger = new Exchanger<>();

        Thread producer = new Thread(new Producer(exchanger));
        Thread consumer = new Thread(new Consumer(exchanger));

        producer.start();
        consumer.start();
    }

    static class Producer implements Runnable {
        private final Exchanger<String> exchanger;

        Producer(Exchanger<String> exchanger) {
            this.exchanger = exchanger;
        }

        public void run() {
            try {
                String data = "Producer's data";
                System.out.println("Producer is exchanging data: " + data);
                String receivedData = exchanger.exchange(data);//交换消费者的数据
                System.out.println("Producer received data from consumer: " + receivedData);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }

    static class Consumer implements Runnable {
        private final Exchanger<String> exchanger;

        Consumer(Exchanger<String> exchanger) {
            this.exchanger = exchanger;
        }

        public void run() {
            try {
                String data = "Consumer's data";
                System.out.println("Consumer is exchanging data: " + data);
                String receivedData = exchanger.exchange(data);//交换生产者的数据
                System.out.println("Consumer received data from producer: " + receivedData);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
```

## 原子类

原子类主要用于解决多线程并发环境下对共享变量的 **原子操作** 问题。原子操作是指不可分割的操作，它确保一个操作要么成功执行，要么完全不执行，不会出现部分执行的情况。

在多线程环境下，多个线程可能会同时对共享变量进行操作，如果操作不是原子的，就可能导致数据竞争和不一致的问题。

```java
// 非原子操作
int counter = 0;

public void incrementCounter() {
    counter++; 
}
// 原子操作
AtomicInteger counter = new AtomicInteger(0);

public void incrementCounter() {
    counter.getAndIncrement(); //先读取 counter 的值，然后将值加 1，最后将新的值写回 counter。由于整个操作是原子的，所以不会出现数据竞争和不一致的问题。
}
```

**JUC 中的原子类主要包括以下几种：**

- `AtomicInteger`：用于原子操作 `int` 类型的值
- `AtomicLong`：用于原子操作 `long` 类型的值
- `AtomicBoolean`：用于原子操作 `boolean` 类型的值
- `AtomicReference`：用于原子操作引用类型的值
- `AtomicReferenceArray`：用于原子操作引用类型的数组

原子类提供了一种无锁的线程安全机制，通常用于计数器、标志位等场景。

```java
public class AtomicExample {
    private AtomicInteger counter = new AtomicInteger(0);

    public void increment() {
        counter.incrementAndGet();
    }

    public int getCounter() {
        return counter.get();
    }

    public static void main(String[] args) {
        AtomicExample example = new AtomicExample();
        example.increment();
        System.out.println("Counter: " + example.getCounter());
    }
}

public class AtomicBooleanExample {
    private AtomicBoolean flag = new AtomicBoolean(false);

    public void setTrue() {
        flag.set(true);
    }

    public boolean getFlag() {
        return flag.get();
    }

    public static void main(String[] args) {
        AtomicBooleanExample example = new AtomicBooleanExample();
        example.setTrue();
        System.out.println("Flag: " + example.getFlag());
    }
}

public class AtomicBooleanExample {
    private AtomicBoolean flag = new AtomicBoolean(false);

    public void setTrue() {
        flag.set(true);
    }

    public boolean getFlag() {
        return flag.get();
    }

    public static void main(String[] args) {
        AtomicBooleanExample example = new AtomicBooleanExample();
        example.setTrue();
        System.out.println("Flag: " + example.getFlag());
    }
}
```

## 安全队列

### BlockingQueue的实现类有哪些

+ ArrayBlockingQueue：使用数组存储的阻塞队列，具有固定的容量。

+ LinkedBlockingQueue：使用链表存储的阻塞队列，容量可变。

+ DelayQueue：支持延迟获取元素的阻塞队列，队列中的元素只有在其延迟期满时才能被取出。

+ PriorityBlockingQueue：基于优先级堆实现的无界阻塞队列，队列中的元素可以按照它们的自然顺序或通过提供的比较器进行排序。

+ ConcurrentLinkedQueue：基于链表的无界线程安全队列，适用于高吞吐量的队列操作。

### `ArrayBlockingQueue`

**`ArrayBlockingQueue`**: 使用数组作为后端支持的有界阻塞队列。它具有固定的容量，在尝试向已满队列添加元素或从空队列检索元素时会阻塞。

```java
BlockingQueue<Integer> arrayQueue = new ArrayBlockingQueue<>(10);
arrayQueue.put(1); // 将1添加到队列中，如果队列已满则阻塞
int head = arrayQueue.take(); // 获取并移除队列头部元素，如果队列为空则阻塞
```

### `LinkedBlockingQueue`

**`LinkedBlockingQueue`**: 使用链表作为后端支持的阻塞队列，可选地指定容量，默认情况下容量为`Integer.MAX_VALUE`。

```java
BlockingQueue<String> linkedQueue = new LinkedBlockingQueue<>();
linkedQueue.put("item"); // 将"item"添加到队列中，如果队列已满则阻塞
String item = linkedQueue.take(); // 获取并移除队列头部元素，如果队列为空则阻塞
```

### `DelayQueue`

**`DelayQueue`**: 实现了一个支持延迟获取元素的阻塞队列，队列中的元素只有在其延迟期满时才能被取出。

```java
DelayQueue<DelayedElement> delayQueue = new DelayQueue<>();
delayQueue.put(new DelayedElement("item1", 1000)); // 添加延迟1000毫秒的元素
DelayedElement item = delayQueue.take(); // 在元素延迟期满时取出元素
```

### `PriorityBlockingQueue`

**`PriorityBlockingQueue`**: 实现了一个基于优先级堆的无界阻塞队列，队列中的元素可以按照它们的自然顺序或者通过提供的比较器进行排序。

```java
public class PriorityBlockingQueueExample {
    public static void main(String[] args) throws InterruptedException {
        PriorityBlockingQueue<Integer> priorityBlockingQueue = new PriorityBlockingQueue<>(10,(a,b)->{
            return Integer.compare(a,b);
        });
        priorityBlockingQueue.put(10);
        priorityBlockingQueue.put(16);
        priorityBlockingQueue.put(9);
        System.out.println(priorityBlockingQueue.take());
        System.out.println(priorityBlockingQueue.take());
        System.out.println(priorityBlockingQueue.take());
    }
}
```

### `ConcurrentLinkedQueue`

**`ConcurrentLinkedQueue`**: 实现了一个基于链表的无界线程安全队列，适用于多线程环境下高吞吐量的队列操作。

```java
ConcurrentLinkedQueue<String> concurrentQueue = new ConcurrentLinkedQueue<>();
concurrentQueue.add("item1"); // 添加"item1"到队列中
String item = concurrentQueue.poll(); // 获取并移除队列头部元素，如果队列为空则返回null
```

## 并发集合

### ConcurrentHashMap

`java.util.concurrent.ConcurrentHashMap` 是线程安全的哈希表实现，比 `Hashtable` 和同步的 `HashMap` 更高效，支持高并发的读写操作。

```java
public class ConcurrentHashMapExample {
    public static void main(String[] args) {
        ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
        map.put("key1", 1);
        map.put("key2", 2);

        map.forEach((key, value) -> System.out.println(key + ": " + value));
    }
}
```

### CopyOnWriteArrayList

`java.util.concurrent.CopyOnWriteArrayList` 是线程安全的动态数组，适用于读多写少的场景。每次写操作（添加、修改和移除）都会创建一个新的复制数组，因此适合在迭代操作频繁且数据量不大的情况下使用。

```java
public class CopyOnWriteArrayListExample {
    public static void main(String[] args) {
        List<String> list = new CopyOnWriteArrayList<>();
        list.add("item1");
        list.add("item2");

        for (String item : list) {
            System.out.println(item);
        }
    }
}
```

### `ConcurrentSkipListMap`

**`ConcurrentSkipListMap`**: 实现了一个并发的、基于跳表的`NavigableMap`，提供了对映射中元素的预期平均log(n)时间复杂度的操作。

```java
ConcurrentSkipListMap<Integer, String> skipListMap = new ConcurrentSkipListMap<>();
skipListMap.put(3, "Three");
skipListMap.put(1, "One");
skipListMap.put(2, "Two");

String value = skipListMap.get(2); // 获取键为2的值，返回"Two"
```

**性能**：如果需要高性能的Map，并且可以接受元素无序，那么ConcurrentHashMap 是更好的选择。

**有序性**：如果需要有序的Map，那么ConcurrentSkipListMap 是更好的选择。

**哈希冲突**：如果担心哈希冲突，那么ConcurrentSkipListMap 是更好的选择。

# 线程通信解决方案



## 生产者-消费者问题的解决方案

生产者-消费者问题是一个经典的并发问题，涉及到一个共享的有限缓冲区，生产者向缓冲区存放数据，消费者从缓冲区取出数据。

- **使用`wait()`和`notify()`方法实现**：

  ```java
  public class synchronizedExample {
  
          private static final int BUFFER_SIZE = 10; // Buffer size
          private static final List<Integer> buffer = new ArrayList<>(BUFFER_SIZE); // Shared buffer
          private static final Object lock = new Object(); // Synchronization lock
  
          public static void main(String[] args) {
              Thread producerThread = new Thread(new Producer());
              Thread consumerThread = new Thread(new Consumer());
  
              producerThread.start();
              consumerThread.start();
          }
  
          static class Producer implements Runnable {
  
              @Override
              public void run() {
                  while (true) {
                      synchronized (lock) {
                          try {
                              // Wait if buffer is full
                              while (buffer.size() == BUFFER_SIZE) {
                                  lock.wait();
                              }
  
                              // Produce an item and add it to the buffer
                              int item = (int) (Math.random() * 100);
                              buffer.add(item);
                              System.out.println("Produced item: " + item);
  
                              // Notify consumer that item is available
                              lock.notify();
                          } catch (InterruptedException e) {
                              e.printStackTrace();
                          }
                      }
                  }
              }
          }
  
          static class Consumer implements Runnable {
  
              @Override
              public void run() {
                  while (true) {
                      synchronized (lock) {
                          try {
                              // Wait if buffer is empty
                              while (buffer.isEmpty()) {
                                  lock.wait();
                              }
  
                              // Consume an item from the buffer
                              int item = buffer.remove(0);
                              System.out.println("Consumed item: " + item);
  
                              // Notify producer that space is available
                              lock.notify();
                          } catch (InterruptedException e) {
                              e.printStackTrace();
                          }
                      }
                  }
              }
          }
  }
  ```

- **使用`Condition`对象实现**：

  ```java
  public class ConditionExample {
  
      private final List<Integer> list;
      private final int bufferSize;
      private final Lock lock = new ReentrantLock();
      Condition produce = lock.newCondition();
      Condition consumer = lock.newCondition();
  
      public ConditionExample(int bufferSize) {
          this.list = new ArrayList<>();
          this.bufferSize = bufferSize;
      }
  
      public void put(Integer item) throws Exception {
          lock.lock();
          try {
              while (list.size() == bufferSize) {
                  produce.await();
              }
              list.add(item);
              consumer.signal();
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              lock.unlock();
          }
      }
  
      public Integer get() throws Exception {
          lock.lock();
          try {
              while (list.isEmpty()) {
                  consumer.await();
              }
              Integer item = list.remove(0);  // Assuming remove(0) returns the first element
              produce.signal();
              return item;
          } catch (Exception e) {
              e.printStackTrace();
          } finally {
              lock.unlock();
          }
      }
  }
  ```

# 性能调优

## 调优技巧

1. **合理使用线程池**：尽量使用线程池来复用线程，减少线程创建和销毁的开销。

2. **避免死锁和竞态条件**：使用同步工具类（如 `java.util.concurrent` 包中的锁、条件变量等）来避免出现死锁和竞态条件。尽量避免使用低级别的同步机制，如 `synchronized` 关键字，而是使用更高级别的并发工具。

3. **减少锁粒度**：当需要同步访问共享资源时，尽可能缩小锁的范围，避免在整个方法或代码块上加锁。

4. **避免线程上下文切换**：线程的上下文切换会消耗大量的系统资源，尽量减少线程数量和频繁的线程切换。可以通过合理使用线程池来控制线程的数量，避免创建过多的线程。

5. **使用无锁数据结构**：对于高并发场景使用无锁数据结构（如  `ConcurrentHashMap`、`ConcurrentLinkedQueue` 等）来替代传统的同步集合，减少锁竞争。

6. **优化IO操作**：对于涉及IO操作的多线程程序，使用非阻塞IO或者异步IO技术，可以减少线程阻塞时间，提高系统的并发处理能力。

   

## 线程安全的设计模式

### Immutable对象

使用`final`关键字声明对象引用和成员变量，确保对象状态不可变。

```java
public final class ImmutableObject {
    private final int id;
    private final String name;
    
    public ImmutableObject(int id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public int getId() {
        return id;
    }
    
    public String getName() {
        return name;
    }
}
```

### ThreadLocal

#### ThreadLocal是什么

`ThreadLocal`是一个线程局部变量，可以让每个线程都有自己的变量副本，不同线程间的变量无法相互访问和修改，避免了线程安全问题。

```java
public class ThreadLocalExample  {
    private static final ThreadLocal<Integer> threadLocal = new ThreadLocal<>();
    
    public static void main(String[] args) throws InterruptedException {
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            new Thread(()->{
                threadLocal.set(finalI);
                System.out.println("当前局部变量值为: "+threadLocal.get());
            }).start();
        }

    }
}
```

#### ThreadLocal原理解析

ThreadLocal内部使用ThreadLocalMap来存储每个线程的变量副本，最终存到entry中继承WeakReference，其中key是ThreadLocal对象是弱引用，value是设置的值是强引用，ThreadLocalMap是ThreadLocal的静态内部类,每个线程都有自己的ThreadLocalMap。

```java
public void set(T value) {
        Thread t = Thread.currentThread();
        ThreadLocalMap map = getMap(t);
        if (map != null) {
            map.set(this, value);
        } else {
            createMap(t, value);
   }
}
```

#### 内存泄漏问题

由于ThreadLocalMap使用ThreadLocal作为key来存储entry,如果ThreadLocal被回收,key变成null,强引用的value无法释放，就会出现内存泄漏。所以ThreadLocal使用完毕后,需要调用remove()方法清除数据,避免出现内存泄漏。

```java
public void remove() {
         ThreadLocalMap m = getMap(Thread.currentThread());
         if (m != null) {
             m.remove(this);
         }
}
```

```java
ThreadLocal<String> threadLocal = new ThreadLocal<String>();
	try {
    	threadLocal.set("业务数据");
    	// TODO 其它业务逻辑
	} finally {
    	threadLocal.remove();
	}
```

#### 使用场景

- 隔离线程，存储一些不安全的工具类，如SimpleDateFormat
- Spring中的事务管理器
- SpringMvc中httpSession、HttpRequest、HttpResponse

## Java 内存模型（JMM）

Java 内存模型（Java Memory Model, JMM）定义了多线程程序中变量的访问规则，即一个线程如何与另一个线程通信。JMM 规定了在不同线程之间共享变量时的可见性和有序性。

JMM 的实现是基于happens-before原则的。happens-before 原则定义了两个事件之间的顺序关系，如果一个事件先行于另一个事件，则第一个事件对第二个事件可见。

### 关键概念

1. **可见性**：
   - 可见性问题是指一个线程对共享变量的修改，另一个线程是否能立即看到。
   - JMM 通过 `volatile` 关键字、锁（synchronized）、和 final 关键字来保证可见性。
2. **有序性**：
   - 有序性问题是指程序执行的顺序是否和代码的顺序一致。
   - JMM 允许编译器和处理器对指令进行重排序，但会保证重排序不会影响单线程程序的正确性。
   - `volatile` 关键字和锁也可以用来保证有序性。
3. **原子性**：
   - 原子性问题是指一个操作是否是不可分割的，即操作要么全部执行，要么全部不执行。
   - JMM 保证基本数据类型的读写操作是原子性的，但复合操作（如 i++）不是原子性的。



## `volatile` 关键字

`volatile` 关键字是 Java 提供的一种轻量级同步机制，用于确保变量的可见性和有序性。

##### 原理

- **可见性**：当一个变量被声明为 `volatile` 时，所有线程对该变量的读写操作都直接从主内存中读取或写入，而不是从线程的本地缓存中读取或写入。
- **有序性**：`volatile` 变量的读写操作不会被重排序，与 `volatile` 变量的读写操作之间存在内存屏障（Memory Barrier）。

## AQS

AQS（AbstractQueuedSynchronizer）是Java并发编程中用于实现同步锁的抽象类，它提供了统一的锁获取、释放、等待、唤醒等操作。AQS的核心思想是**使用一个原子操作**`state`来表示锁的状态，并使用一个**FIFO队列**来存储等待获取锁的线程。

**AQS关键部分：**

- **state**: 一个volatile的int类型变量，用来表示锁的当前状态。不同的state值代表不同的锁状态，例如0表示锁未被持有，1表示锁被持有，2表示存在等待队列等。
- **FIFO队列**: 用来存储等待获取锁的线程。AQS使用了一个称为**CLH队列**（Craig、Landin和Hagersten队列）的变体来实现FIFO队列。
- **tryAcquire**: 尝试获取锁的方法。如果state值为0，则表示锁未被持有，并尝试将其CAS（Compare And Swap）为1，表示获取锁成功。如果state值不为0，则表示锁已被持有，当前线程需要加入FIFO队列等待。
- **tryRelease**: 释放锁的方法。如果state值为当前线程的持有值，则将其CAS为0，表示释放锁成功。否则，表示当前线程不持有锁，抛出异常。
- **acquire**: 获取锁的方法。如果tryAcquire成功，则直接返回。如果tryAcquire失败，则当前线程会加入FIFO队列并等待。当锁被释放时，会唤醒FIFO队列中的第一个线程尝试获取锁。
- **release**: 释放锁的方法。与tryRelease类似，但会唤醒FIFO队列中的下一个等待线程。

**AQS类型的锁**

- **独占锁**: 只有一个线程可以持有锁。例如ReentrantLock。
- **共享锁**: 多个线程可以同时持有锁，但需要遵守特定的规则。例如ReentrantReadWriteLock。
- **公平锁**: 按照线程进入队列的顺序分配锁。
- **非公平锁**: 不按照线程进入队列的顺序分配锁，可能存在先到后得的情况。

**AQS优点：**

- **可扩展性**: AQS的代码结构清晰，易于扩展。
- **灵活性**: AQS可以支持多种类型的锁，满足不同的同步需求。
- **效率**: AQS采用了CAS操作和FIFO队列等技术，提高了锁的获取和释放效率。

## 线程分析工具

1. **Java VisualVM**：基于图形界面的多功能工具，可以监视本地和远程的Java应用程序，它提供了线程和堆栈跟踪的能力，可以用来识别应用程序中的线程问题和性能瓶颈。
2. **jstack**：JDK自带的一个命令行工具，用于生成 Java 应用程序中每个线程的堆栈跟踪信息，它可以帮助分析线程的状态、线程之间的死锁等问题。





​	



