---
title: spring webflux
---

# 学习路线



## **Lambda表达式和Stream流编程**

   - **Lambda表达式**：Java 8 引入了Lambda表达式，简化了匿名内部类的使用，使代码更加简洁，Lambda表达式是函数式编程的一部分，通过学习它，可以理解函数作为一等公民的思想，即函数可以作为参数传递和返回值。
   - **Stream流**：Java 8 中的Stream API允许对集合执行声明式操作（如过滤、映射、规约），并支持并行处理，Stream流的操作链具有惰性，直到终端操作才执行，这种流式处理思想与Reactive编程有共通之处。

## **函数式编程的思想**

   - 函数式编程是一种编程范式，强调函数的不可变性、无副作用、纯函数等概念，学习函数式编程有助于理解Reactive编程的核心思想，因为Reactive编程依赖于非阻塞、异步处理，这些都是函数式编程的重要特征。

## **JDK 9的响应式流（Reactive Streams）**

   - **Flux**：JDK 9 引入了Reactive Streams API，为异步流处理提供了标准。Flux是Reactor库中的核心组件之一，可以看作是Stream API的扩展版，专为异步、非阻塞环境设计。通过Flux，数据流可以是动态的、无限的，且支持背压机制。
   - **背压和实现机制**：背压（Backpressure）是响应式流的重要概念，指的是在数据生产者和消费者之间进行协调，防止生产者过度生产数据而导致消费者处理不过来。学习背压有助于理解如何在Reactive编程中平衡系统的负载。

##  **掌握Reactor库的基础**

   - 熟练掌握了Lambda表达式、Stream API和Reactive Streams之后，Reactor库中的核心概念和操作（如Flux、Mono）都是这些基础的扩展。

##  **学习WebFlux**

   - 学习WebFlux时，掌握了函数式编程的思想、响应式流的概念以及背压机制，这些都是WebFlux的基石。WebFlux构建在Reactor之上，理解Reactor库的运作会更容易掌握WebFlux的工作原理和应用。



<img src="https://telegraph-image-2ni.pages.dev/file/4939e3692f13dd640bc3f.png" style="zoom: 33%;" />



# 前置基础

## 函数式接口

函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。

### 如何定义函数式接口

函数式接口只能包含一个抽象方法，并且通过@FunctionalInterface注解标注此接口

```java
@FunctionalInterface
public interface OpreationAdd {
    int opreationAdd(int a,int b);
}
```

### Java8提供的函数式接口

| 序号 | 函数式接口           | 描述                                   |
| ---- | -------------------- | -------------------------------------- |
| 1    | **Consumer<T>**      | 代表了接受一个输入参数并且无返回的操作 |
| 2    | **Function<T,R>**    | 接受一个输入参数，返回一个结果。       |
| 3    | **Supplier<T>**      | 无参数，返回一个结果。                 |
| 4    | **UnaryOperator<T>** | 接受一个参数为类型T,返回值类型也为T。  |
| 5    | **Predicate<T>**     | 接受一个输入参数，返回一个布尔值结果。 |

### 使用方式

```java
//consumer
Consumer<String> consumer = System.out::println;
consumer.accept("hello");
//function
Function<String,Integer> function = String::length;
System.out.println(function.apply("hello"));
//supplier
Supplier<String> supplier = () -> "result";
System.out.println(supplier.get());
//unaryopreator
UnaryOperator<Integer> unaryOperator = x -> x * 2;
System.out.println(unaryOperator.apply(10));
//predicte
Predicate<String> predicate = s -> s.length() > 5;
System.out.println(predicate.test("abc"));
```

## Lambda

Lambda表达式也叫闭包，允许把函数作为一个方法的参数传递到方法中。

### 语法

可以理解为将一个方法，去除方法名，将方法参数用->方式指向方法体

```java
(parameters) -> expression
or
(paramters) -> {expression;}
```

### 使用方式

```java
OpreationAdd opreationAdd = (a, b) -> a + b;
System.out.println(opreationAdd.opreationAdd(3, 6));
```

**注意事项**

1. 成员变量不能和lambda表达式的变量同名
2. lambda表达式可以访问final修饰的成员变量

## Stream

### 什么是Stream

Stream是一种流式操作，流在管道中传输，可以在管道中任意节点做处理，经过中间操作和最终操作后得到最终的处理结果。

### 如何创建Stream

创建Stream就是指从数据源如数组、集合获取一个流

#### 通过集合创建流

Java8 中的 Collection 接口被扩展，提供了两个获取流的方法：

- default Stream stream() : 返回一个顺序流
- default Stream parallelStream() : 返回一个并行流

```java
List<Integer> list = Arrays.asList(1,2,3,4,5,6);
Stream<Integer> stream = list.stream();
Stream<Integer> integerStream = list.parallelStream();
```

#### 通过数组创建流

Java8 中的 Arrays 的静态方法 stream() 可以获取数组流：

- static Stream stream(T[] array): 返回一个流
- public static IntStream stream(int[] array)
- public static LongStream stream(long[] array)
- public static DoubleStream stream(double[] array)

```java
Integer[] a = {1,2,3,4,5,6,7,8,9};
Stream<Integer> stream = Arrays.stream(a);
```

#### 通过Stream的of

Stream类静态方法 of(), 通过显示值创建一个流。它可以接收任意数量的参数。

```java
Stream<Integer> integerStream = Stream.of(1, 2, 3, 4, 5, 6, 7, 8, 9);
```

### 中间操作

中间操作主要包括筛选、映射、排序

**筛选**

| **方 法**               | **描 述**                                                    |
| :---------------------- | :----------------------------------------------------------- |
| **filter(Predicatep)**  | 接收 Lambda ， 从流中排除某些元素                            |
| **distinct()**          | 筛选，通过流所生成元素的 hashCode() 和 equals() 去除重复元素 |
| **limit(long maxSize)** | 截断流，使其元素不超过给定数量                               |
| **skip(long n)**        | 跳过元素，返回一个扔掉了前 n 个元素的流。 若流中元素不足 n 个，则返回一个空流。与 limit(n) 互补 |

**映射**

| **方法**                            | **描述**                                                     |
| :---------------------------------- | :----------------------------------------------------------- |
| **map(Function f)**                 | 接收一个函数作为参数，该函数会被应用到每个元素上，并将其映射成一个新的元素。 |
| **mapToDouble(ToDoubleFunction f)** | 接收一个函数作为参数，该函数会被应用到每个元素上，产生一个新的 DoubleStream。 |
| **mapToInt(ToIntFunction f)**       | 接收一个函数作为参数，该函数会被应用到每个元素上，产生一个新的 IntStream。 |
| **mapToLong(ToLongFunction f)**     | 接收一个函数作为参数，该函数会被应用到每个元素上，产生一个新的 LongStream。 |
| **flatMap(Function f)**             | 接收一个函数作为参数，将流中的每个值都换成另一个流，然后把所有流连接成一个流 |

**排序**

| **方法**                       | **描述**                           |
| :----------------------------- | :--------------------------------- |
| **sorted()**                   | 产生一个新流，其中按自然顺序排序   |
| **sorted(Comparator** **com)** | 产生一个新流，其中按比较器顺序排序 |

### 终止操作

- 终端操作会从流的流水线生成结果。其结果可以是任何不是流的值，例如：List、nteger，甚至是 void 。
- 流进行了终止操作后，不能再次使用。

| **方法**                                 | **描述**                                                     |
| :--------------------------------------- | :----------------------------------------------------------- |
| **allMatch(Predicate p)**                | 检查是否匹配所有元素                                         |
| **anyMatch(Predicate p)**                | 检查是否至少匹配一个元素                                     |
| **noneMatch(Predicate** **p)**           | 检查是否没有匹配所有元素                                     |
| **findFirst()**                          | 返回第一个元素                                               |
| **findAny()**                            | 返回当前流中的任意元素                                       |
| **count()**                              | 返回流中元素总数                                             |
| **max(Comparator c)**                    | 返回流中最大值                                               |
| **min(Comparator c)**                    | 返回流中最小值                                               |
| **forEach(Consumer c)**                  | 内部迭代(使用 Collection 接口需要用户去做迭代，称为外部迭代。 相反，Stream API 使用内部迭代——它帮你把迭代做了) |
| **reduce(T identity, BinaryOperator b)** | 可以将流中元素反复结合起来，得到一个值。返回 T               |
| **reduce(BinaryOperator b)**             | 可以将流中元素反复结合起来，得到一个值。返回 Optional        |
| **collect(Collector c)**                 | 将流转换为其他形式。接收一个 Collector接口的实现，用于给Stream中元素做汇总的方法 |

### 示例

一个包含员工的列表，并希望筛选出工资超过 5000 的员工，并按工资降序排列，最后获取前三名员工的名字列表。

```java
List<Employee> employees = Arrays.asList(
                new Employee("Alice", 6000),
                new Employee("Bob", 4500),
                new Employee("Charlie", 7000),
                new Employee("David", 5500),
                new Employee("Eve", 3000)
        );

List<String> collect = employees.stream()
                .filter(e -> e.getSalary() > 5000)
                .sorted((e1, e2) -> e2.getSalary() - e1.getSalary())
                .limit(3)
                .map(Employee::getName)
                .collect(Collectors.toList());

collect.forEach(System.out::println);
```



# 正式学习

## 基础概念

### **Reactive Programming Introduction**

**Reactive Programming** 是一种编程范式，专注于处理数据流和传播变化,这种编程方式强调异步数据流、非阻塞操作和对变化的即时反应。

- **异步 (Asynchronous)**: 在异步编程中，任务不会阻塞线程，允许其他任务继续执行。这有助于提高应用程序的性能和响应速度。
- **非阻塞 (Non-blocking)**: 非阻塞意味着操作不会让调用者等待结果，而是立即返回，使系统能高效处理更多的并发任务。
- **响应式流 (Reactive Streams)**: 这是一个处理数据流的标准化规范，支持背压机制（Backpressure），确保数据生产者不会压垮消费者,`Reactive Streams` 规范包括四个核心接口：`Publisher`、`Subscriber`、`Subscription`、和 `Processor`。

### **Project Reactor**

**Project Reactor** 是一个遵循 Reactive Streams 规范的库，提供强大的 API 来处理异步数据流。它的核心组件包括 `Mono` 和 `Flux`。

- **Mono**: 表示一个包含 0 或 1 个元素的异步序列。适用于可能产生单个值或没有值的场景。

  ```java
  Mono<String> mono = Mono.just("Hello, Mono!");
  mono.subscribe(System.out::println); // 输出: Hello, Mono!
  ```

- **Flux**: 表示一个包含 0 到 N 个元素的异步序列。适用于处理多个值的场景。

  ```java
  Flux<String> flux = Flux.just("Hello", "Flux", "!");
  flux.subscribe(System.out::println); 
  // 输出:
  // Hello
  // Flux
  // !
  ```

- **Schedulers**: `Schedulers` 是 Reactor 提供的调度器，用于指定操作执行的线程模型。常用的调度器类型包括：

  - `Schedulers.boundedElastic()`: 用于 I/O 密集型操作，提供一个弹性线程池。
  - `Schedulers.parallel()`: 用于 CPU 密集型操作，提供固定大小的线程池，通常与 CPU 核心数一致。
  - `Schedulers.single()`: 提供单线程调度器，适用于需要在同一线程中执行的任务。

  ```java
  Flux.just("Task 1", "Task 2")
      .subscribeOn(Schedulers.boundedElastic())
      .doOnNext(task -> System.out.println("Processing: " + task))
      .subscribe();
  ```

## **Introduction to Spring WebFlux**

- 理解Spring WebFlux的架构及其与Spring MVC的区别。
- 学习Spring WebFlux的请求处理模型。

### **Creating Reactive Endpoints**

- 使用`RouterFunction`和`HandlerFunction`创建函数式路由。
- 使用注解驱动方式（`@RestController`）创建反应式控制器。

### **Reactive Data Access**

- 学习使用Spring Data R2DBC进行反应式数据库操作。
- 了解如何使用Reactor API进行异步数据处理。

## 深入学习

### **Error Handling in WebFlux**

- 学习错误处理策略：`onErrorResume`、`onErrorReturn`、`onErrorMap`等。

### **Testing Reactive Applications**

- 使用`StepVerifier`进行Reactive流的单元测试。
- 学习如何测试WebFlux应用的不同层面。

### **Backpressure**

- 理解反压机制及其在WebFlux中的应用。
- 学习如何在应用中处理背压问题。

## 进阶

### **Integration with Other Frameworks**

- 了解如何将Spring WebFlux与其他框架（如WebSockets、Kafka、RabbitMQ）集成。
- 学习Spring Cloud Gateway中的WebFlux应用。

### **Performance Tuning**

- 学习如何进行性能调优，优化反应式应用的吞吐量和延迟。

### **Security in Reactive Applications**

- 学习Spring Security的反应式集成，如何保护WebFlux应用。

## 实践项目

### **Develop a Full Reactive Application**

- 设计并实现一个完整的Spring WebFlux项目，包括数据访问、路由、错误处理、安全性等。
- 结合Kafka或RabbitMQ，实现异步消息传递和处理。

### **Deploying Reactive Applications**

- 了解如何在生产环境中部署和监控Spring WebFlux应用。
- 学习如何使用工具（如Prometheus、Grafana）进行实时监控。

