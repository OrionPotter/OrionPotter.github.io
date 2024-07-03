---
title: java基础-并发编程
tag:
- java
---

# 基础概念

## 什么是线程和进程

**线程**：线程是CPU的调度单位，是一个进程中独立运行的最小子任务，它共享进程的资源。

**进程**：进程是操作系统分配资源和调度执行的基本单位，它包含了一个或多个线程，一个应用程序启动相当于起了一个进程。

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

## 线程的生命周期

**新建状态(New):** 线程对象被创建时的初始状态，还未调用`start()`方法启动线程。

**就绪 (Runnable):** 当调用线程对象的`start()`方法后，线程进入就绪状态。就绪状态的线程已经具备了运行的条件，等待CPU调度执行。

**阻塞 (Blocked):**  线程被阻塞，等待获取一个监视器锁，以进入同步块或方法，或者在调用`Object.wait()`后重新进入同步块或方法。

**WAITING（等待）:** 线程因为调用了`Object.wait()`、`Thread.join()`或`LockSupport.park()`等方法，而进入等待状态，等待其他线程执行特定操作。

**TIMED_WAITING（定时等待):** 线程因为调用了带有超时参数的等待方法，如`Thread.sleep()`、`Object.wait(long)`、`Thread.join(long)`等，而进入定时等待状态。

**终止 (Terminated):** 线程执行完毕或者因为未捕获的异常退出，进入终止状态。

## 线程的优先级设置

线程的优先级可以通过 `setPriority()` 方法来设置。线程的优先级范围通常是从1到10，其中1是最低优先级，10是最高优先级，默认优先级是5,线程调度器会尽可能地按照线程的优先级来调度执行。

```java
ExtendThread thread = new ExtendThread();
thread.setPriority(10);
thread.start();
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



# 线程同步

## 为什么需要线程同步

线程同步是为了防止多个线程同时访问共享资源时产生不一致的数据或状态。没有同步机制的话，可能会出现以下问题：

- **数据竞争**：多个线程同时修改同一个变量，导致数据不一致。
- **死锁**：多个线程相互等待对方释放资源，导致程序无法继续执行。
- **饥饿**：某些线程长时间得不到资源，导致无法执行。

## 同步机制

两种主要的同步机制：同步方法和同步块。

### 同步方法

同步方法是指在方法声明中使用 `synchronized` 关键字。一个同步方法在同一时间只能被一个线程访问。

```java
public synchronized void synchronizedMethod() {
    // 线程安全的代码
}
```

### 同步块

同步块是指在方法内部使用 `synchronized` 关键字来同步某一块代码。同步块可以减少同步的范围，从而提高性能。

```java
public void method() {
    synchronized(this) {
        // 线程安全的代码
    }
}
```

### 使用场景

- **同步方法**适合于整个方法都需要加锁的情况，使用简单，但可能会降低性能，因为整个方法被锁住时其他线程无法访问。
- **同步代码块**适合于只需部分代码需要加锁的情况，可以精确控制加锁的范围，可以提高程序的并发性能，避免不必要的阻塞。

## `synchronized`关键字

`synchronized` 关键字可以用来修饰方法或代码块，以确保同一时间只有一个线程可以执行这些代码。

### 修饰实例方法

```java
public synchronized void instanceMethod() {
    // 线程安全的代码
}
```

### 修饰静态方法

```java
public static synchronized void staticMethod() {
    // 线程安全的代码
}
```

### 修饰代码块

```java
public void method() {
    synchronized(this) {
        // 线程安全的代码
    }
}
```

## `volatile`关键字

`volatile` 关键字用于声明变量，确保变量的更新操作对所有线程是可见的,它防止了变量在线程本地缓存中的存储，确保每次读取都是从主内存中读取。也可以禁止指令重排

```java
private volatile boolean flag = true;
```

## `ReentrantLock`

`ReentrantLock`（可重入锁），它允许线程在持有锁的情况下能够再次获取同一个锁,具有显式锁定机制，提供了更灵活的锁定操作,它比 `synchronized` 关键字更强大。

**创建 ReentrantLock 对象：**

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

## 悲观锁和乐观锁

悲观锁：共享资源只能被一个线程独享受，有synchronized、ReentrantLock。

乐观锁：共享资源不独享，只有在修改的时候会通过版本号或者cas（比较和交换）算法验证数据是否被其他线程修改，有原子变量类（比如`AtomicInteger`、`LongAdder`）。

## 死锁及其避免方法

死锁是指两个或多个线程相互等待对方释放资源，导致程序无法继续执行。

### 死锁示例

```java
public class Deadlock {
    private final Object lock1 = new Object();
    private final Object lock2 = new Object();

    public void method1() {
        synchronized(lock1) {
            synchronized(lock2) {
                // 线程安全的代码
            }
        }
    }

    public void method2() {
        synchronized(lock2) {
            synchronized(lock1) {
                // 线程安全的代码
            }
        }
    }
}
```

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

# 线程间通信



## `wait()`、`notify()`和`notifyAll()`方法

**`wait()`方法**：使当前线程进入等待状态，同时释放对象锁。

```java
synchronized (obj) {
    while (condition) {
        obj.wait(); // 等待，并释放obj的锁
    }
    // 执行需要同步的操作
}
```

**`notify()`方法**：唤醒在对象上等待的单个线程，如果有多个线程在等待，则由线程调度器决定唤醒哪一个线程。

```java
synchronized (obj) {
    // 修改条件
    obj.notify(); // 唤醒在obj上等待的一个线程
}
```

**`notifyAll()`方法**：唤醒在对象上等待的所有线程。

```java
synchronized (obj) {
    // 修改条件
    obj.notifyAll(); // 唤醒在obj上等待的所有线程
}
```

## 使用`Condition`对象进行线程通信

Java并发包中的 `Condition` 接口提供了更灵活的线程通信方式，通常与 `Lock` 接口一起使用。

- **创建Condition对象**：

  ```
  ReentrantLock lock = new ReentrantLock();
  Condition condition = lock.newCondition();
  ```

- **使用`await()`和`signal()`方法**：

  ```java
  lock.lock();
  try {
      while (condition) {
          condition.await(); // 等待条件满足
      }
      // 执行需要同步的操作
      condition.signal(); // 唤醒一个等待的线程
  } finally {
      lock.unlock();
  }
  ```

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

# 线程池

## 什么是线程池

线程池是一种管理和重复利用线程的机制，当有任务要处理时，直接从线程池中获取线程来处理，处理完之后线程并不会立即被销毁，而是等待下一个任务。

## 线程池的优点

1. **降低资源消耗**：通过重复利用线程，减少了线程创建和销毁的开销。
2. **提高响应速度**：任务可以立即执行，无需等待线程创建。
3. **提高线程的可管理性**：可以限制线程的数量，防止因线程过多导致的资源消耗问题。
4. **提供更强的任务执行能力**：可以对线程进行统一的管理、调优和监控。

## 创建线程池的方式

**方式一：通过`ThreadPoolExecutor`构造函数来创建（推荐）**

**方式二：通过 `Executor` 框架的工具类 `Executors` 来创建。**

### 使用 `ThreadPoolExecutors` 创建线程池

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



## 并发集合

**ConcurrentHashMap**

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

**CopyOnWriteArrayList**

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

# 多线程工具类

## CountDownLatch

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

## CyclicBarrier

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

## Semaphore

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
                semaphore.acquire();
                System.out.println("Thread " + Thread.currentThread().getName() + " is working.");
                Thread.sleep((int) (Math.random() * 1000));
                semaphore.release();
                System.out.println("Thread " + Thread.currentThread().getName() + " has finished.");
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
```

## Exchanger

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
                String receivedData = exchanger.exchange(data);
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
                String receivedData = exchanger.exchange(data);
                System.out.println("Consumer received data from producer: " + receivedData);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
}
```

# 并发包（java.util.concurrent）

## 原子类

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



## `BlockingQueue`接口和实现类

`BlockingQueue`接口代表一个支持阻塞操作的队列，在检索元素时等待队列变为非空，在存储元素时等待空间变得可用。关键的实现类包括：

- **`ArrayBlockingQueue`**: 使用数组作为后端支持的有界阻塞队列。它具有固定的容量，在尝试向已满队列添加元素或从空队列检索元素时会阻塞。

  ```java
  BlockingQueue<Integer> arrayQueue = new ArrayBlockingQueue<>(10);
  arrayQueue.put(1); // 将1添加到队列中，如果队列已满则阻塞
  int head = arrayQueue.take(); // 获取并移除队列头部元素，如果队列为空则阻塞
  ```

- **`LinkedBlockingQueue`**: 使用链表作为后端支持的阻塞队列，可选地指定容量，默认情况下容量为`Integer.MAX_VALUE`。

  ```java
  BlockingQueue<String> linkedQueue = new LinkedBlockingQueue<>();
  linkedQueue.put("item"); // 将"item"添加到队列中，如果队列已满则阻塞
  String item = linkedQueue.take(); // 获取并移除队列头部元素，如果队列为空则阻塞
  ```

## `DelayQueue`和`PriorityBlockingQueue`

- **`DelayQueue`**: 实现了一个支持延迟获取元素的阻塞队列，队列中的元素只有在其延迟期满时才能被取出。

  ```java
  DelayQueue<DelayedElement> delayQueue = new DelayQueue<>();
  delayQueue.put(new DelayedElement("item1", 1000)); // 添加延迟1000毫秒的元素
  DelayedElement item = delayQueue.take(); // 在元素延迟期满时取出元素
  ```

- **`PriorityBlockingQueue`**: 实现了一个基于优先级堆的无界阻塞队列，队列中的元素可以按照它们的自然顺序或者通过提供的比较器进行排序。

  ```java
  PriorityBlockingQueue<Integer> priorityQueue = new PriorityBlockingQueue<>();
  priorityQueue.put(5); // 将5添加到优先级队列中
  int highestPriority = priorityQueue.take(); // 获取并移除优先级最高的元素
  ```

## `ConcurrentLinkedQueue`

- **`ConcurrentLinkedQueue`**: 实现了一个基于链表的无界线程安全队列，适用于多线程环境下高吞吐量的队列操作。

  ```java
  ConcurrentLinkedQueue<String> concurrentQueue = new ConcurrentLinkedQueue<>();
  concurrentQueue.add("item1"); // 添加"item1"到队列中
  String item = concurrentQueue.poll(); // 获取并移除队列头部元素，如果队列为空则返回null
  ```

## `ConcurrentSkipListMap`

- **`ConcurrentSkipListMap`**: 实现了一个并发的、基于跳表的`NavigableMap`，提供了对映射中元素的预期平均log(n)时间复杂度的操作。

  ```java
  ConcurrentSkipListMap<Integer, String> skipListMap = new ConcurrentSkipListMap<>();
  skipListMap.put(3, "Three");
  skipListMap.put(1, "One");
  skipListMap.put(2, "Two");
  
  String value = skipListMap.get(2); // 获取键为2的值，返回"Two"
  ```

# 性能调优和最佳实践

## 常见的性能问题和调优技巧

1. **内存泄漏**：
   - 使用内存分析工具（如Eclipse Memory Analyzer）来检测内存泄漏，查看对象引用链。
   - 确保及时释放不再需要的对象引用，尤其是长生命周期对象。
2. **高CPU使用率**：
   - 使用性能分析工具（如Java VisualVM）或线程分析工具（如jstack）来确定哪些线程消耗了大量CPU资源。
   - 优化算法和数据结构，减少CPU密集型操作。
3. **长时间的GC暂停**：
   - 使用GC日志分析工具（如GCViewer）来分析GC活动，查看GC类型和暂停时间。
   - 调整JVM的堆大小和GC算法，优化对象的创建和销毁，减少频繁GC的触发。
4. **低效的数据库访问**：
   - 使用数据库连接池管理数据库连接，避免频繁创建和销毁连接。
   - 使用批量更新和批量插入来减少数据库交互次数。
   - 缓存频繁访问的数据，减少对数据库的压力。

## 线程安全的设计模式

1. **Immutable对象**：使用`final`关键字声明对象引用和成员变量，确保对象状态不可变。

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

2. **ThreadLocal**：`ThreadLocal`提供了线程局部变量，每个线程都有自己的变量副本，避免了线程安全问题。

   ```java
   private static final ThreadLocal<SimpleDateFormat> dateFormatThreadLocal = ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd"));
   
   public static String formatDate(Date date) {
       return dateFormatThreadLocal.get().format(date);
   }
   ```

## 使用Java VisualVM和其他工具进行线程分析

1. **Java VisualVM**：
   - Java VisualVM是一个集成的、基于图形界面的分析工具，可以用来监视Java应用程序的性能和内存使用情况。
   - 可以通过VisualVM的线程界面查看每个线程的状态、堆栈信息和CPU使用情况，以便识别潜在的性能瓶颈和死锁情况。
2. **其他工具**：
   - **jstack**: 通过命令行可以生成线程快照，查看Java进程中每个线程的堆栈信息，分析线程状态和可能的死锁。
   - **VisualVM的Heap Dump和GC日志**: 可以分析内存使用情况和GC行为，识别内存泄漏和优化对象的分配和回收策略。





​	



