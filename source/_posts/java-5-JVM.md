---
title: java基础-JVM
tag:
- java
---

# JVM基础

## JVM的主要组成部分及其作用

1. **类加载器（ClassLoader）**：负责加载Java类文件，将其转化为JVM能够识别的Class对象。
2. **运行时数据区（Runtime Data Area）**：JVM在执行Java程序时会使用到的数据区，包括方法区、堆、虚拟机栈、本地方法栈和程序计数器。
3. **执行引擎（Execution Engine）**：负责执行字节码，包括解释器、即时编译器（JIT）和垃圾回收器等。
4. **本地接口（Native Interface）**：JNI（Java Native Interface）允许Java代码与其他编程语言（如C/C++）编写的代码进行交互。

## JVM运行时数据区

1. **方法区（Method Area）**：存储已被虚拟机加载的类信息、常量、静态变量和即时编译后的代码等数据。
2. **堆（Heap）**：存放对象实例和数组，是GC主要管理的区域。
3. **虚拟机栈（Java Virtual Machine Stack）**：存放每个线程的栈帧（方法调用过程中的局部变量表、操作数栈、方法返回地址等）。
4. **本地方法栈（Native Method Stack）**：为本地方法服务，与虚拟机栈类似。
5. **程序计数器（Program Counter Register）**：当前线程执行的字节码的行号指示器。

## 深拷贝和浅拷贝

- **浅拷贝**：复制对象时只复制对象的引用，不复制对象本身。
- **深拷贝**：复制对象时，除了复制对象的引用，还复制对象本身及其包含的所有对象。

## 堆和栈的区别

- **堆**：用于存储对象实例，线程共享，生命周期较长，由GC管理。
- **栈**：用于存储局部变量、方法调用等，线程私有，生命周期较短，方法执行完自动释放。

## 队列和栈是什么？有什么区别？

- **队列（Queue）**：FIFO（先进先出）数据结构，元素从尾部插入，从头部删除。
- **栈（Stack）**：LIFO（后进先出）数据结构，元素从顶部插入和删除。

# HotSpot虚拟机对象探秘

## 对象的创建

- **类加载检查**：检查类是否已加载，未加载则加载类。
- **分配内存**：在堆中为对象分配内存，使用指针碰撞或空闲列表。
- **初始化**：对分配的内存进行零值初始化。
- **设置对象头**：初始化对象的元数据信息。
- **执行构造方法**：调用<init>方法进行初始化。

## 为对象分配内存

- **指针碰撞**：适用于内存规整的堆，通过移动指针分配内存。
- **空闲列表**：适用于内存不规整的堆，通过维护空闲列表分配内存。

## 处理并发安全问题

- **CAS**：通过乐观锁的方式解决并发问题。
- **TLAB**：每个线程分配一个本地缓冲区（Thread Local Allocation Buffer）进行内存分配。

## 对象的访问定位

- **句柄访问**：对象引用存储的是句柄地址，句柄中包含对象实例数据和类型数据的指针。
- **直接指针**：对象引用存储的是对象实例的直接地址。

# 内存溢出异常

## Java会存在内存泄漏吗？请简单描述

Java中也会存在内存泄漏，例如，长生命周期对象持有短生命周期对象的引用，导致短生命周期对象无法被GC回收。

# 垃圾收集器

## 简述Java垃圾回收机制

Java的垃圾回收机制通过GC自动回收不再使用的对象，主要算法包括标记-清除、复制和标记-整理等。

## GC是什么？为什么要GC

GC（Garbage Collection）是垃圾回收的缩写，自动管理内存，防止内存泄漏，提高程序稳定性和性能。

## 垃圾回收的优点和原理。并考虑2种回收机制

- **优点**：自动内存管理，减少内存泄漏，提高开发效率。
- **标记-清除**：标记所有存活对象，清除未标记的对象。
- **复制**：将存活对象复制到新空间，清除旧空间。

## 垃圾回收器的基本原理是什么？垃圾回收器可以马上回收内存吗？有什么办法主动通知虚拟机进行垃圾回收？

垃圾回收器通过跟踪对象的引用链，回收不可达的对象。垃圾回收器不能马上回收内存，可通过`System.gc()`或`Runtime.getRuntime().gc()`主动通知进行垃圾回收。

## Java中都有哪些引用类型？

- **强引用**：不会被GC回收。
- **软引用**：内存不足时会被回收。
- **弱引用**：在GC时会被回收。
- **虚引用**：无法通过引用访问对象，仅用于监控对象的回收。

## 怎么判断对象是否可以被回收？

通过引用计数或可达性分析算法判断对象是否可达，不可达的对象可以被回收。

## 在Java中，对象什么时候可以被垃圾回收？

当对象没有任何强引用时，可以被垃圾回收。

## JVM中的永久代中会发生垃圾回收吗？

在JDK 8之前，永久代中会发生垃圾回收，但频率较低。JDK 8以后，永久代被移除，替代为元空间（Metaspace）。

## 说一下JVM有哪些垃圾回收算法？

- **标记-清除算法**：标记存活对象，清除未标记对象。
- **复制算法**：将存活对象复制到新空间，清除旧空间。
- **标记-整理算法**：标记存活对象，将存活对象移动到一端，清除剩余空间。
- **分代收集算法**：将堆分为新生代和老年代，分别使用不同的垃圾回收算法。

## 说一下JVM有哪些垃圾回收器？

- **Serial收集器**：单线程收集，适用于单CPU环境。
- **Parallel收集器**：多线程收集，适用于多CPU环境。
- **CMS收集器**：低停顿时间的并发收集器，适用于低停顿需求的应用。
- **G1收集器**：面向服务端应用，适用于大内存、多CPU环境。

## 详细介绍一下CMS垃圾回收器？

- **初始标记**：标记GC Roots可达的对象，短暂停顿。
- **并发标记**：标记所有可达对象，不停顿。
- **重新标记**：修正并发标记期间的变动，短暂停顿。
- **并发清除**：清除不可达对象，不停顿。

## 新生代垃圾回收器和老年代垃圾回收器都有哪些？有什么区别？

- **新生代垃圾回收器**：Serial、ParNew、Parallel Scavenge。特点是频繁回收、停顿时间短。
- **老年代垃圾回收器**：Serial Old、CMS、Parallel Old。特点是回收频率低、停顿时间长。

## 简述分代垃圾回收器是怎么工作的？

分代垃圾回收器将堆划分为新生代和老年代。新生代对象生命周期短，频繁回收；老年代对象生命周期长，较少回收。回收时，新生代使用复制算法，老年代使用标记-整理或CMS。

# 内存分配策略

## 简述java内存分配与回收策略以及Minor GC和Major GC

- **内存分配**：对象优先在Eden区分配，大对象直接进入老年代，长期存活对象进入老年代。
- **Minor GC**：针对新生代的垃圾回收，频繁但耗时短。
- **Major GC**：针对老年代的垃圾回收，频率低但耗时长。

## 对象优先在Eden区分配

大多数新创建的对象在Eden区分配，当Eden区满时触发Minor GC，将存活对象移到Survivor区。

## 大对象直接进入老年代

避免在新生代频繁复制大对象，减少内存复制开销。

## 长期存活对象将进入老年代

对象在Survivor区经历多次GC后，晋升到老年代。

# 虚拟机类加载机制

>Java类加载机制是Java虚拟机（JVM）的核心组成部分之一，负责在运行时加载、链接和初始化类。通俗的来讲就是每个.java文件经过javac编译工具编译后生成.class文件，类加载机制就是把这些.class文件中的二进制读到内存中，并对数据进行链接（验证、准备、解析）和初始化，初始化完成后，会在方法区保存一份该类的元数据，同时在堆中创建一个与之对应的`Class`对象，该`Class`对象包含了该类的相关信息。

## 类的生命周期

加载（Loading）-> 验证（Verification）-> 准备（Preparation）-> 解析（Resolution）-> 初始化（Initialization）-> 使用（Usage）-> 卸载（unloading）

1.加载指将字节码文件加载到JVM

2.验证指是否符合JVM虚拟机的规范

3.准备指给静态变量分配内存空间，并设置置默认初始值

4.解析指将类的符号引用转换为直接引用，让虚拟机可以找到对应的内存地址

5.初始化指对静态代码块和静态变量进行初始化操作

6.使用指可以被程序其他的类调用或者说直接引用

7.卸载指在java虚拟机中，如果某个类不再使用，那就认为这个类是无用的，可以被卸载。

## 类什么时候会加载

1.创建类的实例：当程序中使用`new`关键字创建类的实例时，对应的类会被加载。例如：

```java
MyClass obj = new MyClass();
```

2.**访问类的静态变量或静态方法**：当程序中访问类的静态变量或静态方法时，对应的类也会被加载。例如：

```java
MyClass.staticMethod();
```

3.**通过反射动态加载类**：通过Java的反射机制，可以在运行时动态加载类。例如：**

```java
Class.forName("com.example.MyClass");
```

4.**启动应用程序时的入口类加载**：当启动Java应用程序时，会指定一个入口类，该入口类会被加载并执行`main()`方法。这也会触发入口类所依赖的其他类的加载。

5.**继承**：当一个类继承了另一个类时，子类的加载会导致父类也被加载，除非父类已经被加载过。

6.**实现接口**：当一个类实现了某个接口时，接口中定义的常量会被加载。

## 类的加载过程

<img src="https://telegraph-image-2ni.pages.dev/file/2dded58d88ad824bb04c3.png" style="zoom:33%;" />

类的加载过程有五个阶段，其中验证、准备、解析这个子阶段属于链接阶段。下面详细说下，类的加载过程的每个阶段

1.**加载**：将类的字节码被加载到JVM中。包括从文件系统或者网络中读取.class文件，并将其转换为内存中的二进制数据。在加载阶段，还会为类创建一个`java.lang.Class`对象。

2.**验证**：确保类的字节码符合JVM规范，不会导致安全问题或运行时异常。

3.**准备**：为类的静态变量分配内存空间，并设置默认初始值。

4.**解析**：将类中的符号引用转换为直接引用，使得虚拟机能够找到对应的内存地址。

5.**初始化**：在初始化阶段，执行类的静态初始化器（static initializer）和静态变量初始化。静态初始化器是类中的静态代码块，用于初始化类的静态成员变量或执行其他静态初始化操作。





## 类加载器

> 在**加载**阶段，类加载器通过类的全限定名，获取该类字节流数据。

1.**启动类加载器（Bootstrap Class Loader）：**负责加载jre\lib 目录下的jar，由C++实现，不是ClassLoader子类。

2.**拓展类加载器（Extension Class Loader）：**负责加载Java平台中扩展功能的一些jar包，包括jre\lib\ext 目录中 jar包。由Java代码实现。

3.**应用程序类加载器（Application Class Loader）：**我们自己开发的应用程序，就是由它进行加载的，负责加载ClassPath路径下所有jar包。

4.**自定义类加载器（Custom Class Loader）**：可以加载任何类，包括Java标准库中的类、第三方库中的类以及自己编写的类。其加载范围和方式可以根据需求进行灵活定制。

<img src="https://telegraph-image-2ni.pages.dev/file/e1208860284124c277d23.png" style="zoom: 50%;" />





## 双亲委派模型

>简单说就是爹能干的，儿子肯定不干，就是任何一个类加载器在接到一个类的加载请求时，都会先让其父类进行加载，只有父类无法加载（或者没有父类）的情况下，才尝试自己加载。

1. **安全性（Security）**：双亲委派模型可以确保Java核心类库不会被替换或篡改，从而提高了Java程序的安全性。由于Java核心类库由启动类加载器加载，且无法被覆盖，因此不容易受到恶意攻击。
2. **避免类的重复加载（Avoidance of Duplicate Loading）**：双亲委派模型可以避免同一个类被不同的类加载器加载多次，从而节省了内存空间并减少了资源浪费。
3. **统一标准（Standardization）**：双亲委派模型提供了一个统一的类加载机制，使得Java应用程序具有一致的行为。无论是在Java虚拟机的实现上，还是在开发Java应用程序时，都能够遵循同样的加载规则，减少了不必要的复杂性和混乱。
4. **类的隔离性（Isolation）**：双亲委派模型通过委派链的方式实现了类的隔离，每个类加载器只负责加载自己能够访问到的类，从而有效地隔离了不同模块或组件的类，防止了类之间的相互干扰和冲突。
5. **性能优化（Performance Optimization）**：双亲委派模型在加载类时会先检查父类加载器是否已经加载过该类，如果已经加载过，则直接返回已加载的类，从而减少了重复加载和搜索的时间，提高了加载性能。

## 自定义类加载器

自定义类加载器的好处：

1. **动态更新（Dynamic Updating）**：自定义类加载器可以实现动态更新类的功能。例如，当应用程序运行时，可以检测到新的类文件并加载，从而实现热部署或动态扩展应用程序的功能。
2. **类的加密解密（Class Encryption and Decryption）**：自定义类加载器可以在加载类文件时进行解密操作，从而保护类文件的安全性。通过在加载过程中实现解密逻辑，可以防止类文件被恶意篡改或者盗用。
3. **加载非标准文件格式（Loading Non-Standard File Formats）**：自定义类加载器可以加载非标准的类文件格式，例如从数据库、网络或者自定义的存储介质中加载类文件。
4. **从特定位置加载类（Loading Classes from Specific Locations）**：自定义类加载器可以从特定的位置加载类文件，例如从特定的目录、JAR文件或者远程服务器加载类文件。
5. **实现类加载策略（Implementing Class Loading Strategies）**：自定义类加载器可以根据特定的策略加载类文件，例如按需加载、按版本加载或者按条件加载。
6. **解决类加载冲突（Resolving Class Loading Conflicts）**：自定义类加载器可以解决类加载冲突问题，例如当多个模块中存在相同类名但不同版本的类文件时，可以使用自定义类加载器实现类隔离和版本管理。
7. **实现类加载的权限控制（Implementing Class Loading Permissions）**：自定义类加载器可以实现对类加载的权限控制，例如根据用户身份或者访问权限加载不同的类文件。
8. **实现类的热替换（Implementing Class Hot Swapping）**：自定义类加载器可以实现类的热替换功能，即在运行时替换正在使用的类，而不需要重启应用程序。

>下面我们使用自定义的类加载器加载指定的类，并通过反射调用类的方法。

```java
public class CustomClassLoader extends ClassLoader{
    // 定义加载类的路径
    private String classPath;

    public CustomClassLoader(){}

    public CustomClassLoader(String classPath) {
        this.classPath = classPath;
    }
    @Override
    protected Class<?> findClass(String name) throws ClassNotFoundException {
        try {
            // 读取指定路径下的类文件的二进制数据
            byte[] data = loadClassData(name);
            // 调用defineClass方法将二进制数据转换为Class对象
            return defineClass(name, data, 0, data.length);
        } catch (Exception e) {
            throw new ClassNotFoundException("Class " + name + " not found.", e);
        }
    }
    // 加载类文件的二进制数据
    private byte[] loadClassData(String name) throws IOException {
        String fileName = classPath + File.separatorChar + name.replace('.', File.separatorChar) + ".class";
        try (InputStream inputStream = new FileInputStream(fileName);
             ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            int len;
            byte[] buffer = new byte[4096];
            while ((len = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, len);
            }
            return outputStream.toByteArray();
        }
    }
    public static void main(String[] args) throws Exception {
        // 自定义类加载器实例化
        CustomClassLoader classLoader = new CustomClassLoader("D:\\Project\\JAVA\\src\\com.example.CustomClassLoader.class");
        // 使用自定义类加载器加载指定类
        Class<?> clazz = classLoader.loadClass("com.example.CustomClassLoader");
        // 创建实例
        Object instance = clazz.newInstance();
        // 调用方法
        Method method = clazz.getMethod("sayHello");
        method.invoke(instance);
    }
    public void sayHello(){
        System.out.println("say hello");
    }
}
```

## 类加载器的作用域

> 类加载器的作用域（Scope）指的是类加载器加载类的可见范围和生命周期管理。类加载器的作用域决定了类的可见性、类的隔离性以及类的生命周期。

1. **可见性（Visibility）**：每个类加载器实例都有自己的加载路径和类加载命名空间，它只能看到自己加载的类和其父类加载器加载的类。因此，类加载器的可见性决定了哪些类对于特定的类加载器是可见的。
2. **隔离性（Isolation）**：类加载器的隔离性确保了每个类加载器实例加载的类相互之间是隔离的，即同一个类在不同的类加载器实例中被加载时，会被认为是不同的类。这种隔离性保护了应用程序的安全性和稳定性，防止不同模块或组件之间的类产生冲突和干扰。
3. **生命周期管理（Lifecycle Management）**：类加载器的生命周期管理包括类加载器的创建、使用和销毁。在Java应用程序中，类加载器的生命周期通常与应用程序的生命周期相对应。例如，在应用程序启动时创建类加载器实例，在应用程序结束时销毁类加载器实例。

# JVM调优

## 说一下JVM调优的工具？

常用的JVM调优工具包括：
- **jstat**：监控JVM内存和垃圾回收情况。
- **jmap**：生成堆转储快照，分析内存使用情况。
- **jstack**：生成线程快照，分析线程状态。
- **VisualVM**：图形化界面监控JVM性能。

## 常用的JVM调优的参数都有哪些？

- **-Xms**：设置初始堆大小。
- **-Xmx**：设置最大堆大小。
- **-Xmn**：设置新生代大小。
- **-XX:PermSize**：设置初始永久代大小（JDK 8前）。
- **-XX:MaxPermSize**：设置最大永久代大小（JDK 8前）。
- **-XX:MetaspaceSize**：设置初始元空间大小（JDK 8后）。
- **-XX:MaxMetaspaceSize**：设置最大元空间大小（JDK 8后）。
- **-XX:+UseG1GC**：使用G1垃圾回收器。
