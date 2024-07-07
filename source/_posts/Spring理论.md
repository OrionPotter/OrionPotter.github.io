---
title: Spring理论知识
tag:
- Spring
---

# Spring介绍

## 什么是spring

Spring是一个轻量级的java开发框架，解决了企业级开发中业务逻辑层和其他层的耦合问题，简化了java开发。

## Spring框架的设计目标、理念和核心

**设计目标**：提高应用的灵活性、可维护性和可测试性，降低企业级应用开发的复杂性和成本。

**设计理念**：通过依赖注入和面向切面编程实现松耦合、简化开发。

**核心**: 控制反转（IOC容器）和面向切面编程（AOP）。

## 优缺点

**优点：**

1. IOC实现解耦
2. 支持AOP编程
3. 支持声明式事务
4. 集成了各种框架

**缺点：**

spring依赖反射，反射影响性能

## Spring有哪些模块

<img src="https://telegraph-image-2ni.pages.dev/file/700c3272d2f8475f681bb.png" style="zoom:55%;" />

**核心容器**

+ core: 提供了框架的基本组成部分，包括IoC和依赖注入特性。
+ Beans: 这个模块提供了`BeanFactory`，是Spring IoC的基础。它实现了Spring框架的配置、创建和管理Java对象的功能。
+ Context: `ApplicationContext`是一个更高级的容器，扩展了`BeanFactory`，提供了更全面的框架功能，例如事件传播、声明式机制和支持各种企业服务。
+ SpEL: 提供了一个功能强大的表达式语言，用于在运行时查询和操作对象图。

**数据访问/集成**

+ JDBC: 提供了JDBC抽象层，简化了与数据库的交互，解决了资源管理和错误处理问题。
+ ORM: 集成了多个ORM框架，如Hibernate、JPA、MyBatis等。提供了ORM框架的集成支持，简化了持久化层的开发。
+ OXM: 提供了对象/Xml映射的抽象层，支持JAXB、Castor等映射工具
+ JMS: 提供了Java消息服务的支持，简化了消息的发送和接收。
+ Transactions: 提供了声明式事务管理功能，使事务管理更加方便和灵活。

**WEB**

+ WEB: 提供了创建Web应用程序的基础功能，包括多部分文件上传和初始化Web容器的IoC容器。
+ WEB Servlet: 提供了Spring的Model-View-Controller（MVC）实现，支持构建灵活的Web应用程序。
+ Web struts: 提供了与Struts的集成支持。
+ Web Socket: 提供了WebSocket的支持，允许实时的双向通信。

**AOP**

+ AOP: 提供了面向切面编程的功能，使得开发者可以定义方法拦截器和切入点，以便将代码分离为切面。
+ ASPECTS: 提供了与AspectJ的集成支持。

**工具**：提供了类加载器和Java代理的支持，以实现服务器级别的增强。

**消息**：提供了基于消息的应用程序的支持，包含了消息传递的基础设施和消息处理的支持。

**测试**：提供了对JUnit和TestNG的集成支持，方便进行单元测试和集成测试。它包含了模拟对象和Spring应用上下文的测试支持。

## Spring设计模式

**工厂模式**：BeanFactory就是简单工厂模式的体现，用来创建对象的实例。
**单例模式：**Bean默认为单例模式。
**代理模式：**Spring的AOP功能用到了JDK的动态代理和CGLIB字节码生成技术。
**模板方法**：用来解决代码重复的问题。比如. RestTemplate, JmsTemplate, JpaTemplate。
**观察者模式：**当一个对象的状态发生改变时，所有依赖于它的对象都会得到通知被制动更新，如Spring中listener的实现–ApplicationListener。

## Spring事件

**上下文更新事件（ContextRefreshedEvent）**：在调用ConfigurableApplicationContext 接口中的refresh()方法时被触发。

**上下文开始事件（ContextStartedEvent）**：当容器调用ConfigurableApplicationContext的Start()方法开始/重新开始容器时触发该事件。

**上下文停止事件（ContextStoppedEvent）**：当容器调用ConfigurableApplicationContext的Stop()方法停止容器时触发该事件。

**上下文关闭事件（ContextClosedEvent）**：当ApplicationContext被关闭时触发该事件。容器被关闭时，其管理的所有单例Bean都被销毁。

**请求处理事件（RequestHandledEvent**）：在Web应用中，当一个http请求（request）结束触发该事件。如果一个bean实现了ApplicationListener接口，当一个ApplicationEvent 被发布以后，bean会自动被通知。

1. **扩展Spring的功能**：事件机制提供了一个机制，可以在Spring的生命周期中触发特定的操作，从而扩展Spring的功能。
2. **实现自定义逻辑**：事件机制可以用于实现自定义的逻辑，例如在请求被处理时触发某个操作。
3. **提高应用程序的灵活性**：事件机制可以提高应用程序的灵活性，允许在不同的阶段触发特定的操作。

# 核心容器

## Core模块

### Resource接口

Spring的`Resource`抽象提供了一种统一的方式来访问底层资源。

- `UrlResource`: 包装一个 `java.net.URL`,可用于访问任何可以用 URL 正常访问的对象,如文件、HTTP 目标、FTP 目标等。
- `ClassPathResource`: 表示应从类路径中获取的资源。它使用线程上下文类加载器、给定的类加载器或给定的类来加载资源。
- `FileSystemResource`: 用于处理 `java.io.File` 和 `java.nio.file.Path` 的资源实现。它支持作为文件和 URL 进行解析。
- `ServletContextResource`: 用于处理 `ServletContext` 资源的资源实现,它解释相对于相关 Web 应用程序根目录的相对路径。

```java
ClassPathResource classPathResource = new ClassPathResource("applicationContext.xml");
FileSystemResource fileSystemResource = new FileSystemResource("D:\\applicationContext.xml");
```

### Core 工具类

`ReflectionUtils`工具类

`ReflectionUtils` 是 Spring 框架提供的一个工具类,用于简化反射操作。它提供了一系列静态方法,用于执行常见的反射任务。

```java
//获取可访问的构造函数
Constructor<T> accessibleConstructor(Class<T> clazz, Class<?>... parameterTypes)
//清除内部缓存
void clearCache()
//检查方法是否声明异常    
boolean declaresException(Method method, Class<?> exceptionType)
//遍历类层次结构中的字段
void doWithFields(Class<?> clazz, FieldCallback fc)
void doWithFields(Class<?> clazz, FieldCallback fc, FieldFilter ff)
//遍历类层次结构中的方法
void doWithMethods(Class<?> clazz, MethodCallback mc)
void doWithMethods(Class<?> clazz, MethodCallback mc, MethodFilter mf)    
```

`CollectionUtils`工具类

`CollectionUtils` 是 Spring 框架提供的另一个工具类,用于简化集合操作。

```java
//检查集合是否为空
boolean isEmpty(Collection<?> collection)
boolean isEmpty(Map<?, ?> map)
//合并集合
Collection<?> mergeArrayIntoCollection(Object array, Collection<Object> collection)
//过滤集合
Collection<?> select(Collection<?> collection, Predicate<? super Object> predicate)
//转换集合
Collection<?> collect(Collection<?> collection, Transformer<? super Object, ?> transformer)
//查找集合中的元素
Object find(Collection<?> collection, Predicate<? super Object> predicate)    
```

### IoC 容器基础

#### 什么是Spring IOC 容器

IoC容器是Spring框架用于管理应用程序中bean的生命周期的组件,它负责管理bean的生命周期、配置和组装 bean,并提供给应用程序使用。

#### IOC的作用

1. **管理bean的生命周期**：负责实例化bean、配置bean的属性和依赖关系、管理bean的作用域、销毁bean。
2. **依赖注入**：通过构造函数、setter 方法或字段注入 bean 的依赖使得 bean 可以声明式地接收依赖,而不需要自己创建依赖。

#### Bean的生命周期

<img src="https://telegraph-image-2ni.pages.dev/file/205dcba19454277e044b4.png" style="zoom: 50%;" />



**源码**

```java
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final Object[] args) {
    // 1. 实例化 Bean
    BeanWrapper instanceWrapper = null;
    if (mbd.isSingleton()) {
        instanceWrapper = this.factoryBeanInstanceCache.remove(beanName);
    }
    if (instanceWrapper == null) {
        instanceWrapper = createBeanInstance(beanName, mbd, args);
    }
    final Object bean = (instanceWrapper != null ? instanceWrapper.getWrappedInstance() : null);
    Class<?> beanType = (instanceWrapper != null ? instanceWrapper.getWrappedClass() : null);

    // 2. 允许后处理器修改合并的 Bean 定义
    synchronized (mbd.postProcessingLock) {
        if (!mbd.postProcessed) {
            applyMergedBeanDefinitionPostProcessors(mbd, beanType, beanName);
            mbd.postProcessed = true;
        }
    }

    // 3. 提前暴露单例 Bean，解决循环依赖问题
    boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences && isSingletonCurrentlyInCreation(beanName));
    if (earlySingletonExposure) {
        if (logger.isDebugEnabled()) {
            logger.debug("Eagerly caching bean '" + beanName + "' to allow for resolving potential circular references");
        }
        addSingletonFactory(beanName, new ObjectFactory<Object>() {
            @Override
            public Object getObject() throws BeansException {
                return getEarlyBeanReference(beanName, mbd, bean);
            }
        });
    }

    // 4. 初始化 Bean 实例
    Object exposedObject = bean;
    try {
        // 4.1 属性赋值
        populateBean(beanName, mbd, instanceWrapper);
        // 4.2 初始化 Bean
        if (exposedObject != null) {
            exposedObject = initializeBean(beanName, exposedObject, mbd);
        }
    } catch (Throwable ex) {
        if (ex instanceof BeanCreationException && beanName.equals(((BeanCreationException) ex).getBeanName())) {
            throw (BeanCreationException) ex;
        } else {
            throw new BeanCreationException(mbd.getResourceDescription(), beanName, "Initialization of bean failed", ex);
        }
    }

    // 5. 处理早期单例引用
    if (earlySingletonExposure) {
        Object earlySingletonReference = getSingleton(beanName, false);
        if (earlySingletonReference != null) {
            if (exposedObject == bean) {
                exposedObject = earlySingletonReference;
            } else if (!this.allowRawInjectionDespiteWrapping && hasDependentBean(beanName)) {
                String[] dependentBeans = getDependentBeans(beanName);
                Set<String> actualDependentBeans = new LinkedHashSet<String>(dependentBeans.length);
                for (String dependentBean : dependentBeans) {
                    if (!removeSingletonIfCreatedForTypeCheckOnly(dependentBean)) {
                        actualDependentBeans.add(dependentBean);
                    }
                }
                if (!actualDependentBeans.isEmpty()) {
                    throw new BeanCurrentlyInCreationException(beanName,
                            "Bean with name '" + beanName + "' has been injected into other beans [" +
                                    StringUtils.collectionToCommaDelimitedString(actualDependentBeans) +
                                    "] in its raw version as part of a circular reference, but has eventually been " +
                                    "wrapped. This means that said other beans do not use the final version of the " +
                                    "bean. This is often the result of over-eager type matching - consider using " +
                                    "'getBeanNamesOfType' with the 'allowEagerInit' flag turned off, for example.");
                }
            }
        }
    }

    // 6. 注册可销毁的 Bean
    try {
        registerDisposableBeanIfNecessary(beanName, bean, mbd);
    } catch (BeanDefinitionValidationException ex) {
        throw new BeanCreationException(mbd.getResourceDescription(), beanName, "Invalid destruction signature", ex);
    }

    return exposedObject;
}
```

1. 实例化：Spring容器根据配置文件或注解元数据创建Bean的实例，如果是单例模式,容器只会创建一次，如果是多例模式,每次请求都会创建一个新的实例。

2. 属性赋值：容器根据配置文件或注解中指定的属性值和依赖关系设置Bean的属性值，这个过程称为依赖注入。

3. BeanNameAware和BeanFactoryAware接口：Aware接口,用于让Bean感知自身在Spring容器中的一些信息。

4. BeanPostProcessor前置处理：如果实现了BeanPostProcessor接口,容器会在Bean的初始化方法被调用之前调用postProcessBeforeInitialization()方法执行自定义逻辑。

5. InitializingBean和init-method：如果Bean实现了InitializingBean接口,容器会在属性注入完成后调用afterPropertiesSet()方法，如果在配置文件中指定了init-method,容器会调用指定的初始化方法。

6. BeanPostProcessor后置处理：如果实现了BeanPostProcessor接口,容器会在Bean的初始化方法被调用之前调用postProcessAfterInitialization()方法执行自定义逻辑。

7. 使用Bean：此时Bean已经准备就绪,可以被应用程序使用了。

8. 销毁Bean：如果Bean实现了DisposableBean接口或者在配置中指定了destroy-method,则在容器关闭时执行相应的销毁方法。

#### 什么是依赖注入？

IOC控制反转是一种设计理念，具体的实现方式有两种，一种是依赖注入，一种是依赖查找，依赖查找就是硬编码，A类对象初始化的时候创建B对象，依赖注入是交由IOC容器进行管理的，A类不再去实例化B类对象，而是简单声明B，由IOC容器负责将B的实例提供给A

#### IoC的实现原理/流程

1. **读取配置**：IOC容器读取XML配置文件或注解,获取Bean的定义信息。
2. **创建Bean注册表**：根据Bean的定义信息为每个Bean创建一个BeanDefinition,并保存到一个ConcurrentHashMap注册表中，key为beanName,value为BeanDefinition对象。
3. **按需实例化Bean**：第一次请求Bean时,通过反射机制根据BeanDefinition中的类名实例化Bean对象以及依赖的Bean，并放到一级缓存(单例池)中。
4. **依赖注入**：Bean实例化后,根据BeanDefinition中的依赖信息,将依赖的Bean实例或者属性值通过set注入或者构造注入到目标Bean中。
5. **返回Bean实例**：IOC容器返回应用程序所需的Bean实例。

### Bean的循环依赖问题

解决方案：提前暴露未完成的bean

Spring在创建bean时并不是等它完全完成,而是将创建中的bean提前曝光(加入到singletonFactories三级缓存),当下一个bean创建需要依赖此bean时,从三级缓存获取。这样就能解决循环依赖。

1. 先创建A对象,并将其放入三级缓存
2. A需要注入B,到缓存中查找B,没有,触发B的创建
3. 创建B对象,并将其放入三级缓存
4. B需要注入A,从缓存中找到未完成的A对象,完成注入
5. 最后再对A的B属性进行填充,从缓存中拿到B对象



## Beans模块

### 什么是Bean

Spring Bean代指的就是那些被 IoC 容器所管理的对象。

### 如何定义一个Bean

在Spring中，一个Bean就是由Spring IoC容器实例化、组装和管理的对象,有三种定义Spring Bean的方式

**XML配置**

```xml
<bean id="createBeanExample" class="com.spring.learn.entity.CreateBeanExample"/>
```

**注解配置**

```xml
<!-- applicationContext.xml 开启组件扫描 -->
<context:component-scan base-package="com.spring" />
```

```java
//添加 @Component 注解
@Component
public class CreateBeanExample {
    public void createBean() {
        System.out.println("创建Bean成功了");
    }
}
```

**Java配置**

```xml
<!-- applicationContext.xml 开启组件扫描 -->
<context:component-scan base-package="com.spring" />
```

```java
@Configuration
public class App {
    @Bean
    public CreateBeanExample createBeanExample() {
        return new CreateBeanExample();
    }
}
```

### 如何获取Bean

BeanFactory接口提供的两个实现类：xmlBeanFactory、DefaultListableBeanFactory

- `XmlBeanFactory` 实现类

```java
ClassPathResource classPathResource = new ClassPathResource("applicationContext.xml");
BeanFactory beanFactory = new XmlBeanFactory(classPathResource);
```

+ `DefaultListableBeanFactory` 实现类

```java
// 创建 DefaultListableBeanFactory 实例
DefaultListableBeanFactory beanFactory = new DefaultListableBeanFactory();
// 注册 Bean 定义
BeanDefinitionRegistry registry = beanFactory;
BeanDefinitionBuilder builder = BeanDefinitionBuilder.genericBeanDefinition(MyBean.class);
builder.addPropertyValue("message", "Hello, Spring!");
registry.registerBeanDefinition("myBean", builder.getBeanDefinition());
// 获取 Bean 实例
MyBean bean = beanFactory.getBean(MyBean.class);
System.out.println(bean.getMessage()); // 输出: "Hello, Spring!"
// 自定义 Bean 后处理器
beanFactory.addBeanPostProcessor(new MyBeanPostProcessor());
// 再次获取 Bean 实例
bean = (MyBean) beanFactory.getBean("myBean");
System.out.println(bean.getMessage()); // 输出: "Hello, Spring! (Processed)"
```

### 作用域

| 作用域        | 描述                                    | 适用场景                                      |
| ------------- | --------------------------------------- | --------------------------------------------- |
| Singleton     | 一个 BeanFactory 只有一个该 bean 的实例 | 通用 bean，需要保持单一实例                   |
| Prototype     | 每次请求都会创建一个新的实例            | 有状态的 bean，需要每次都创建新实例           |
| Request       | 每次 HTTP 请求创建一个新实例            | Web 应用程序中，每个 HTTP 请求需要独立的 bean |
| Session       | 每次 HTTP session 创建一个新实例        | Web 应用程序中，与用户会话相关的 bean         |
| GlobalSession | 全局 HTTP session 作用域                | Portlet 环境下，与整个应用程序会话相关的 bean |

xml配置

```xml
<bean id="createBeanExample" class="com.spring.learn.entity.CreateBeanExample" scope="singleton"/>
```

java配置

```java
@Configuration
public class App {
    @Bean
    @Scope("prototype")
    public CreateBeanExample createBeanExample() {
        return new CreateBeanExample();
    }
}
```

> Spring中的单例Bean是线程安全吗？
>
> 虽然 Spring 单例 bean 是线程安全的，但如果bean包含可变状态（例如实例变量），需要确保正确地处理并发访问，可以通过同步机制（如 `synchronized` 关键字或使用线程安全的集合类）来保证数据的一致性。

### 依赖注入

#### 构造器注入和Setter注入

**构造器注入**

```java
<bean id="user" class="com.spring.learn.entity.User">
        <constructor-arg name="username" value="lithium"/>
        <constructor-arg name="age" value="12"/>
</bean>
```

```java
@Configuration
public class App {
    @Bean
    @Scope("prototype")
    public User user() {
        return new User("lithium",12);
    }
}
```

**Setter注入**

```java
<bean name="user" class="com.spring.learn.entity.User">
        <property name="username" value="lithium"/>
        <property name="age" value="12"/>
</bean>
```

```java
@Configuration
public class App {
    @Bean
    @Scope("prototype")
    public User user() {
        User user = new User();
        user.setUsername("lithium");
        user.setAge(12);
        return user;
    }

}
```

#### 自动装配

在Spring框架中，在配置文件中设定bean的依赖关系是一个很好的机制，Spring 容器能够自动装配相互合作的bean，这意味着容器不需要和配置，能通过Bean工厂自动处理bean之间的协作。这意味着 Spring可以通过向Bean Factory中注入的方式自动搞定bean之间的依赖关系。自动装配可以设置在每个bean上，也可以设定在特定的bean上。

1. No: 这是默认的配置，没有发生自动装配,Bean引用需要通过ref属性定义。

```xml
<bean name="address" class="com.spring.learn.entity.Address">
        <property name="province" value="sd"/>
        <property name="city" value="NJ"/>
</bean>
<bean name="user" class="com.spring.learn.entity.User" autowire="default">
        <property name="username" value="lithium"/>
        <property name="age" value="12"/>
        <property name="address" ref="address"/>
</bean>
```

2. By Name: 配置中的autowire =“byName”允许容器查看其属性的名称，并寻找定义在配置中具有相同名称的bean。

```xml
<bean name="address" class="com.spring.learn.entity.Address">
        <property name="province" value="sd"/>
        <property name="city" value="NJ"/>
</bean>
<bean name="user" class="com.spring.learn.entity.User" autowire="byName">
        <property name="username" value="lithium"/>
        <property name="age" value="12"/>
</bean>
```

3. By Type: 当我们将autowire的属性设置为byType时，Spring容器为该bean的每一属性尝试匹配并自动装配exact type的单个bean。如果找到更多相同类型的bean，就会抛出异常。
4. By Constructor: 类似于byType，但适用于构造器参数。如果在容器中没有发现构造器参数的类型或者有多余一个的类型，则抛出异常。

```xml
<bean name="address" class="com.spring.learn.entity.Address">
        <constructor-arg name="province" value="SD"/>
        <constructor-arg name="city" value="NJ"/>
</bean>
<bean name="user" class="com.spring.learn.entity.User" autowire="constructor">
        <constructor-arg name="username" value="lithium"/>
        <constructor-arg name="age" value="12"/>
</bean>
```

### 如何进行Bean的自定义逻辑

`BeanPostProcessor`是Spring框架中用于对Spring管理的bean进行后处理的接口。它提供了一种机制，可以在 bean 实例化和依赖注入之后以及自定义初始化方法之前，对 bean 进行额外的处理。

`BeanPostProcessor` 接口定义了两个方法：

1. `postProcessBeforeInitialization(Object bean, String beanName)`：在bean的初始化回调方法（如 `afterPropertiesSet` 或自定义的初始化方法）调用之前执行,可以对bean进行预处理操作。
2. `postProcessAfterInitialization(Object bean, String beanName)`：在bean的初始化回调方法调用之后执行,可以在这里对 bean 进行一些后处理操作，可以返回一个包装后的 bean。

**定义BeanPostProcessor**

```java
public class MyBeanPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        if (bean instanceof User) {
            System.out.println("BeforeInitialization : " + beanName);
        }
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof User) {
            System.out.println("AfterInitialization : " + beanName);
        }
        return bean;
    }
}
```

**配置方式**

1.xml配置

```xml
<bean id="myBeanPostProcessor" class="com.spring.learn.MyBeanPostProcessor"/>
```

2.Java配置

```java
@Configuration
public class App {
    @Bean
    public MyBeanPostProcessor myBeanPostProcessor(){
        return new MyBeanPostProcessor();
    }
}    
```

## Context模块

### ApplicationContext接口

`ApplicationContext`它提供了许多功能来管理 Spring 应用中的 bean，它是 Spring IoC 容器的一种高级形式，继承了 `BeanFactory`，提供了更多的企业级功能。

`ApplicationContext`实现类

1. ClassPathXmlApplicationContext：从类路径下的 XML 配置文件中加载上下文。
2. FileSystemXmlApplicationContext： 从文件系统中的 XML 配置文件中加载上下文。
3. AnnotationConfigApplicationContext： 从 Java 配置类中加载上下文，常用于基于注解和 Java 配置的 Spring 应用。
4. WebApplicationContext： 专门为 web 应用设计的 `ApplicationContext` 接口，继承自 `ApplicationContext`，用于 web 应用程序中的上下文管理。

```java
ApplicationContext applicationContext = new ClassPathXmlApplicationContext("applicationContext.xml");
ApplicationContext applicationContext1 = new FileSystemXmlApplicationContext("applicationContext.xml");
ApplicationContext applicationContext2 = new AnnotationConfigApplicationContext(App.class);
```

### `ConfigurableApplicationContext`接口

`ConfigurableApplicationContext` 扩展了 `ApplicationContext` 接口，提供了额外的配置和生命周期管理方法。这使得 Spring 应用程序上下文可以更灵活地进行配置和管理。

```java
ConfigurableApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
//刷新应用上下文，使其重新加载所有的 bean 定义并应用所有的配置.
context.refresh();
//关闭应用上下文，释放所有的资源和锁.
context.close();
//注册一个钩子，当 JVM 关闭时，自动调用 close() 方法。
context.registerShutdownHook();
```

### 事件机制

Spring 的事件机制允许应用程序在发生特定事件时发布和处理自定义事件，Spring 提供了一个标准的方式来实现事件驱动的编程模式，通过发布事件和监听事件来解耦组件之间的交互。

**自定义事件**

```java
public class CustomEvent extends ApplicationEvent {
    private String message;

    public CustomEvent(Object source, String message) {
        super(source);
        this.message = message;
    }

    public String getMessage() {
        return message;
    }
}
```

**创建事件监听器**

```java
@Component
public class CustomEventListener  implements ApplicationListener<CustomEvent> {
    @Override
    public void onApplicationEvent(CustomEvent event) {
        System.out.println("Received custom event - " + event.getMessage());
    }
}
```

**创建发布事件**

```java
@Component
public class CustomEventPublisher {
    @Autowired
    private ApplicationEventPublisher applicationEventPublisher;

    public void publishEvent(String message) {
        CustomEvent event = new CustomEvent(this, message);
        applicationEventPublisher.publishEvent(event);
    }
}
```

### 注解支持

#### **开启注解配置**

```java
// 指定配置类
@Configuration
// 指定扫描包路径
@ComponentScan(basePackages = "com.spring.learn")
public class App {

}
```

```java
ApplicationContext context = new AnnotationConfigApplicationContext(App.class);
```

#### **注解方式注入**

**@Autowired**

`@Autowired` 是Spring提供的最常用的注解,用于实现自动装配。它可以应用于构造函数、setter方法和字段上。

```java
public class MyService {
    @Autowired
    private MyRepository repository;
}
```

Spring 容器会自动根据类型匹配来注入 `MyRepository` 实例。如果有多个匹配的 bean,则会抛出异常,这时可以使用 `@Qualifier` 来指定具体的 bean。

**@Qualifier**

`@Qualifier` 注解用于进一步限定 `@Autowired` 的注入对象。当有多个同类型的 bean 时,可以使用 `@Qualifier` 来指定注入哪个 bean。

```java
@Component
@Qualifier("myRepository")
public class MyRepositoryImpl implements MyRepository {
}

@Service
public class MyService {
    @Autowired
    @Qualifier("myRepository")
    private MyRepository repository;
}
```

**@Resource**

`@Resource` 是Java标准 (JSR-250) 提供的注解,Spring 也支持使用。它与 `@Autowired` 的区别在于:

1. `@Resource` 默认按照名称装配bean,而 `@Autowired` 默认按照类型装配。
2. `@Resource` 可以不指定名称,此时会按照属性名称装配。

```java
public class MyService {
    @Resource
    private MyRepository repository;
}
```

`@Autowired` 是最常用的,可以结合 `@Qualifier` 来进一步限定注入对象。`@Resource` 则提供了另一种按名称注入的方式。

### BeanFactory 和 ApplicationContext有什么区别？

| 特点/功能      | BeanFactory                         | ApplicationContext                                       |
| -------------- | ----------------------------------- | -------------------------------------------------------- |
| **基本功能**   | 管理和获取 bean 实例                | 在 BeanFactory 功能基础上增强，提供更多企业级功能        |
| **延迟初始化** | 是                                  | 是                                                       |
| **提前初始化** | 否（按需初始化）                    | 是（预加载所有 singleton bean）                          |
| **功能丰富性** | 较少，主要为 IoC 和 DI 提供基础支持 | 提供 AOP、事务管理、国际化、事件发布、资源管理等高级功能 |
| **实现类**     | `DefaultListableBeanFactory`        | `ClassPathXmlApplicationContext`                         |
| **使用场景**   | 资源受限环境或需要定制扩展时使用    | 大多数应用场景推荐使用，提供更多功能和便利               |
| **性能**       | 较轻量级，启动时资源占用较少        | 启动时可能占用更多资源，但提高了应用响应速度             |



## SpEL模块

### 什么是SpEL

SpEL（Spring Expression Language）是Spring框架中的一种功能强大的表达式语言。它用于在运行时查询和操作对象图，类似于EL（Expression Language），但功能更为强大和灵活。SpEL的设计目的是提供一种通用的表达式求值引擎，可以在Spring应用程序的不同部分（例如配置、注解、XML）中使用。

### 主要功能

+ **访问对象属性和调用方法**：直接获取对象的属性值或者调用对象的方法。

+ **条件和逻辑运算**：支持条件判断（等于、大于、小于等）和逻辑运算（与、或、非）。

+ **数学和字符串操作**：进行数学计算（加减乘除）和字符串操作（连接、截取等）。

+ **集合和数组处理**：遍历、访问、过滤集合和数组元素。

+ **类型转换和类型检查**：转换对象类型或者检查对象类型。

+ **引用外部变量和 Bean**：引用系统变量、环境变量和 Spring 容器中的 Bean。

+ **模板表达式**：在配置文件和注解中动态配置属性和依赖关系。

### `ExpressionParser` 接口

`ExpressionParser` 接口是用于解析表达式的核心接口，而`SpelExpressionParser` 是其默认实现，用于解析 SpEL 表达式。

```java
ExpressionParser parser = new SpelExpressionParser();
// Example SpEL expressions
String expression = "'Hello World'.concat('!')";
String result = parser.parseExpression(expression).getValue(String.class);
System.out.println(result); // Output: Hello World!
```

### 对象图导航

**访问对象属性和方法调用**

```java
@Component
public class MyBean {
    private String name = "Alice";
    private int age = 30;

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }
}
```

```java
@Component
public class MyComponent {
    @Autowired
    private MyBean myBean;

    @Value("#{ myBean.name }")
    private String name;

    @Value("#{ myBean.getAge() }")
    private int age;
	
}    
```

**访问数组和集合**

```java
public class MyComponent {
	@Value("#{ {'apple', 'banana', 'orange'} }")
    private String[] fruits;

    @Value("#{ {'apple', 'banana', 'orange'}.?[startsWith('a')] }")
    private List<String> fruitsStartingWithA;
}    
```

### 逻辑和数学运算

**逻辑运算**

```java
@Component
public class MyComponent {

    @Value("#{ 1 == 1 }")
    private boolean isEqual;

    @Value("#{ 10 > 5 }")
    private boolean isGreater;

    @Value("#{ 'John' != 'Doe' }")
    private boolean isNotEqual;

}
```

**数学运算**

```java
@Component
public class MyComponent {

    @Value("#{ 10 + 5 }")
    private int addition;

    @Value("#{ 20 - 10 }")
    private int subtraction;

    @Value("#{ 3 * 4 }")
    private int multiplication;

    @Value("#{ 20 / 5 }")
    private int division;

}
```

### 模板表达式

```java
@Component
public class MyComponent {

    @Value("#{ T(java.lang.Math).random() * 100.0 }")
    private double randomNumber;
}
```



# AOP

## 什么是AOP

面向切面编程（AOP）是一种编程范式，旨在通过在应用程序中横切关注点（cross-cutting concerns）的分离，使得系统更易于理解、维护和扩展。

## AOP的优势

1. **模块化**：将跨领域关注点与业务逻辑分离，增强了代码的模块化。
2. **可重用性**：切面可以应用于多个目标对象，增强了代码的可重用性。
3. **可维护性**：减少了样板代码，使得业务逻辑更清晰，提高了代码的可维护性。
4. **灵活性**：通过配置或注解，可以灵活地控制切面的应用范围和行为。

## AOP的核心概念

<img src="https://telegraph-image-2ni.pages.dev/file/708c30e38f2d3237291f6.png" style="zoom:45%;" />



1. **切面（Aspect）**：就像一个特殊的功能模块，负责某种特定的任务，例如日志记录或安全检查。
2. **连接点（Join Point）**：程序执行的某个具体点，比如方法调用或异常抛出。
3. **通知（Advice）**：切面中实际执行的代码，比如在方法执行前后进行日志记录。
4. **切入点（Pointcut）**：定义切面应用的位置，通过表达式指定哪些方法需要应用切面。
5. **目标对象（Target Object）**：实际执行业务逻辑的对象，例如我们要记录日志的业务类。
6. **代理（Proxy）**：AOP 框架创建的对象，负责将切面逻辑应用到目标对象上。
7. **织入（Weaving）**：将切面应用到目标对象并创建代理对象的过程。

## AOP运行原理

Spring AOP通过代理模式在运行时将切面（Aspect）应用到目标对象（Target Object）上。

### 运行过程

1.定义切面

- **定义切面类和通知**：开发者编写切面类，切面类中包含多个通知（Advice）,通知定义了在目标方法执行前、执行后、返回后或抛出异常时要执行的逻辑。
- **定义切入点（Pointcut）**：使用表达式（如`execution(* com.example.demo.UserService.getUser())`）定义切入点，指定哪些方法会被拦截。

2.Spring容器初始化

- **Spring配置解析**：Spring解析AOP相关的配置，生成Bean定义。可以使用注解（如`@Aspect`、`@Before`、`@After`）或XML配置。
- **组件扫描**：Spring扫描配置中指定的包，找到切面类和目标对象，并将它们注册为Spring Bean。

3.创建代理对象: Spring AOP使用ProxyFactory创建代理对象，代理对象可以是JDK动态代理（如果目标对象实现了接口）或CGLIB代理（如果目标对象没有实现接口）。

- **JDK动态代理**：使用`java.lang.reflect.Proxy`创建代理对象，代理对象实现了目标对象的接口。
- **CGLIB代理**：使用CGLIB库创建目标对象的子类代理，代理对象通过覆盖目标对象的方法来实现代理功能。

4.方法拦截和通知执行

- **方法调用拦截**：当客户端代码调用代理对象的方法时，代理对象会拦截这个方法调用。
- 执行切面逻辑：
  - **前置通知（Before Advice）**：在目标方法执行前，代理对象会先执行前置通知。
  - **目标方法执行**：代理对象调用目标对象的方法。
  - **后置通知（After Advice）**：在目标方法执行后，代理对象执行后置通知。
  - **返回通知（AfterReturning Advice）**：在目标方法成功返回后，代理对象执行返回通知。
  - **异常通知（AfterThrowing Advice）**：在目标方法抛出异常后，代理对象执行异常通知。
  - **环绕通知（Around Advice）**：代理对象在执行目标方法前后，分别执行环绕通知的前后部分逻辑。

5.织入（Weaving）：运行时织入AOP在运行时将切面逻辑应用到目标对象上，Spring通过代理对象在方法调用时动态地将切面逻辑织入目标对象的方法中。

### 技术角度

**代理模式**：

- **JDK动态代理**：适用于目标对象实现了接口的情况，Spring会创建目标对象的代理实例，代理对象会拦截方法调用并将切面逻辑织入。
- **CGLIB代理**：适用于目标对象没有实现接口的情况，Spring会创建目标对象的子类代理实例，通过覆盖目标对象的方法来织入切面逻辑。

### 源码角度

#### 启动过程

1.配置解析： Spring解析配置文件，将AOP相关配置转换为Bean定义。在XML配置中，可以使用`<aop:config>`和`<aop:aspect>`等标签定义切面。

```java
<aop:config>
    <aop:aspect ref="myAspect">
        <aop:pointcut id="myPointcut" expression="execution(* com.example.service.*.*(..))"/>
        <aop:before method="beforeMethod" pointcut-ref="myPointcut"/>
    </aop:aspect>
</aop:config>
```

2.创建代理：Spring在创建Bean实例时，如果该Bean配置了AOP，会通过`ProxyFactory`创建代理对象，核心类是`ProxyFactoryBean`。

```java
// AbstractAutoProxyCreator.java
protected Object wrapIfNecessary(Object bean, String beanName, Object cacheKey) {
    if (bean instanceof AopInfrastructureBean) {
        return bean;
    }
    if (shouldSkip(bean, beanName)) {
        return bean;
    }
    Object[] specificInterceptors = getAdvicesAndAdvisorsForBean(bean.getClass(), beanName, null);
    if (specificInterceptors != DO_NOT_PROXY) {
        Object proxy = createProxy(bean.getClass(), beanName, specificInterceptors, new SingletonTargetSource(bean));
        return proxy;
    }
    return bean;
}
```

#### 代理对象的创建

**JDK动态代理**：如果目标对象实现了接口，Spring会使用`java.lang.reflect.Proxy`类创建代理对象。代理类实现了目标对象的所有接口，并在调用方法时执行切面逻辑。

```java
// JdkDynamicAopProxy.java
@Override
public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    MethodInvocation invocation = new ReflectiveMethodInvocation(target, method, args, interceptors);
    return invocation.proceed();
}
```

**CGLIB代理**：如果目标对象没有实现接口，Spring会使用CGLIB库创建代理对象，生成目标对象的子类并覆盖方法。

```java
// CglibAopProxy.java
protected Object createProxyClassAndInstance(Enhancer enhancer, Callback[] callbacks) {
    enhancer.setCallbacks(callbacks);
    return enhancer.create();
}
```

#### 方法拦截与通知执行

代理对象在方法调用时，会执行切面逻辑。Spring AOP通过`MethodInterceptor`接口实现方法拦截。

**前置通知（Before Advice）**：

```java
// MethodBeforeAdviceInterceptor.java
@Override
public Object invoke(MethodInvocation mi) throws Throwable {
    this.advice.before(mi.getMethod(), mi.getArguments(), mi.getThis());
    return mi.proceed();
}
```

后置通知（After Advice）:

```java
// AfterReturningAdviceInterceptor.java
@Override
public Object invoke(MethodInvocation mi) throws Throwable {
    Object retVal = mi.proceed();
    this.advice.afterReturning(retVal, mi.getMethod(), mi.getArguments(), mi.getThis());
    return retVal;
}
```

**环绕通知（Around Advice）**

```java
// AspectJAroundAdvice.java
@Override
public Object invoke(MethodInvocation mi) throws Throwable {
    return aspectAdvice.invoke(adviceMethod, joinPoint, mi.getArguments());
}
```

## Spring AOP和AspectJ AOP的区别

Spring AOP（面向切面编程）和AspectJ AOP（又称纯AspectJ AOP）都是面向切面编程的实现，但它们之间有一些区别：

1. **依赖关系**：
   - Spring AOP依赖于Spring框架，它是Spring的一个子模块，完全集成在Spring IoC容器中。而AspectJ AOP是一个独立的AOP框架，不依赖于Spring框架，可以单独使用。
2. **代理机制**：
   - Spring AOP基于运行时代理，通过Spring容器在运行时动态地为目标对象创建代理对象，并将切面逻辑织入到代理对象的方法调用中。
   - AspectJ AOP可以使用两种代理方式：编译时代理和运行时代理。编译时代理需要在编译阶段进行织入切面逻辑，而运行时代理是在运行时动态创建代理对象，并织入切面逻辑。
3. **性能**：
   - Spring AOP相对于AspectJ AOP来说，代理对象的创建和切面逻辑的织入是在运行时进行的，因此性能相对较低。
   - AspectJ AOP在编译阶段或者类加载阶段将切面逻辑织入到目标对象中，因此性能相对较高。
4. **切点表达式**：
   - Spring AOP只支持基于方法的切点表达式。
   - AspectJ AOP支持更丰富的切点表达式，可以基于方法、字段、构造函数等进行切面编程。
5. **功能**：
   - Spring AOP提供了一组简单的AOP功能，可以满足大多数应用的需求。它适合于轻量级的应用和简单的切面需求。
   - AspectJ AOP提供了更为强大和灵活的功能，支持复杂的切面编程，包括对类的静态结构进行操作，如修改类的字节码。

## JDK动态代理和CGLIB动态代理的区别

1. **基于的实现技术**：
   - JDK动态代理是基于Java反射机制实现的，它利用Java提供的InvocationHandler接口和Proxy类来生成代理对象。
   - CGLIB动态代理是基于字节码生成技术实现的，它通过修改目标类的字节码，在运行时动态生成目标类的子类作为代理对象。
2. **代理对象类型**：
   - JDK动态代理只能代理实现了接口的目标类，即只能代理接口类型的目标对象。
   - CGLIB动态代理可以代理没有实现接口的类，即可以代理普通的Java类。
3. **性能**：
   - JDK动态代理在创建代理对象时需要实现接口，因此会更加节省内存和资源，但由于是基于反射实现的，因此在调用代理方法时相对较慢。
   - CGLIB动态代理在创建代理对象时不需要实现接口，因此更加灵活，但由于是基于字节码生成技术，生成的代理类通常比较复杂，因此在创建代理对象时会消耗更多的资源，但在调用代理方法时性能更高。
4. **对final方法的处理**：
   - JDK动态代理无法代理目标类中的final方法，因为final方法无法被子类重写。
   - CGLIB动态代理可以代理目标类中的final方法，因为它是通过生成目标类的子类来实现代理的，可以覆盖目标类中的final方法。
5. **依赖关系**：
   - JDK动态代理是Java标准库的一部分，无需额外的依赖，但只能代理接口类型的目标对象。
   - CGLIB动态代理需要依赖于CGLIB库，使用时需要将CGLIB库引入项目中，但可以代理普通的Java类。

## AOP示例代码

### 创建切面类

```java
@Component
//@Aspect注解将LoggingAspect类标记为一个切面
@Aspect
public class LoggingAspect {
    // 前置通知 - 在方法调用前执行
    @Before("execution(* com.spring.learn.service.UserService.getUser())")
    public void logBeforeGetUser(JoinPoint joinPoint) {
        System.out.println("Before executing getUser() method");
    }

    // 后置通知 - 在方法调用后执行
    @After("execution(* com.spring.learn.service.UserService.getUser())")
    public void logAfterGetUser(JoinPoint joinPoint) {
        System.out.println("After executing getUser() method");
    }
}
```

### 启用AOP

```java
@Configuration
@ComponentScan(basePackages = "com.spring.learn")
// 在这个配置类中@EnableAspectJAutoProxy注解启用了Spring的AOP支持。 
@EnableAspectJAutoProxy
public class App {

}
```

### 创建目标对象

```java
@Service
public class UserService {
    //连接点就是这个方法
    public void getUser() {
        System.out.println("Executing getUser() method");
    }
}
```



# 事务

## 什么是事务

事务是一个完整的工作单元，要么全部执行，要么全部不执行。

## 事务的特性

包括ACID特性：原子性（Atomicity）、一致性（Consistency）、隔离性（Isolation）、持久性（Durability）。

## 事务管理

事务管理是在应用程序中处理和管理事务的过程，Spring提供了声明式和编程式两种事务管理方式。



## 声明式事务

### 什么是声明式事务

声明式事务是指通过配置或注解的方式来声明和管理事务，而不是在代码中手动编写事务管理的逻辑。在spring框架中进行了声明式事务后可以在运行时自动开启、提交、回滚事务。

### 声明式事务的原理

声明式事务使用AOP（面向切面编程，Aspect-Oriented Programming）来实现。当一个方法被声明为事务性方法时，Spring在方法调用之前和之后自动插入事务管理逻辑。

### 实现声明式事务的方式

**1.配置类**

```java
@Configuration
@ComponentScan("com.spring")
//在配置类中启用事务管理
@EnableTransactionManagement
public class AppConfig {

    @Bean
    public DriverManagerDataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/test");
        dataSource.setUsername("root");
        dataSource.setPassword("password");
        return dataSource;
    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource());
    }
}
```

**2.业务类**

```java
@Service
public class UserService {

    @Transactional
    public void createUser(User user) {
        // 业务逻辑代码
    }
}
```

**3.事务回滚**

Spring 事务管理默认情况下，会在遇到未被捕获的 `RuntimeException` 和 `Error` 时自动回滚事务。如果方法中抛出了这些类型的异常，Spring 会回滚事务，撤销在事务中进行的所有更改。

```java
@Service
public class UserService {
	//指定在捕获到哪些异常时回滚事务。
    @Transactional(rollbackFor = {SQLException.class, CustomException.class})
    public void createUser(User user) throws CustomException {
        // 业务逻辑代码
    }
	//指定在捕获到哪些异常时不回滚事务
    @Transactional(noRollbackFor = {RuntimeException.class})
    public void updateUser(User user) {
        // 业务逻辑代码
    }
}
```

**4.事务超时**

事务超时用于限制事务的执行时间。如果事务在指定时间内没有完成，Spring 将自动回滚事务。可以通过 `@Transactional` 注解的 `timeout` 属性设置事务的超时时间，单位是秒。

```java
@Service
public class UserService {

    @Transactional(timeout = 5)
    public void createUser(User user) {
        // 业务逻辑代码，必须在5秒内完成，否则事务会被回滚
    }
}
```

**5.事务只读**

如果一个事务只进行数据查询，不进行数据更新，可以通过 `@Transactional` 注解的 `readOnly` 属性将其设置为只读，提高性能。只读事务不涉及数据的更新操作，因此数据库可以优化查询操作。

```java
@Service
public class UserService {

    @Transactional(readOnly = true)
    public User getUserById(Long id) {
        // 只进行数据查询
        return userRepository.findById(id).orElse(null);
    }
}
```

### 声明式事务的优点

1. **简化代码**：简化了代码开发。
2. **解耦**：事务管理逻辑与业务逻辑分离，代码更清晰易读。
3. **可配置性强**：通过配置文件或注解，可以灵活地控制事务的传播行为、隔离级别和回滚规则等。
4. **提高可维护性**：由于事务管理是集中配置的，更改事务管理策略时只需修改配置或注解，而不需要修改业务代码

## Spring事务传播机制

Spring 事务传播机制用于定义当一个事务方法被另一个事务方法调用时事务应该如何传播。

1. PROPAGATION_REQUIRED (默认) : 如果当前存在事务,则加入该事务;如果当前没有事务,则创建一个新事务。

2. PROPAGATION_SUPPORTS : 如果当前存在事务,则加入该事务;如果当前没有事务,则以非事务的方式继续运行。

3. PROPAGATION_MANDATORY : 如果当前存在事务,则加入该事务;如果当前没有事务,则抛出异常。

4. PROPAGATION_REQUIRES_NEW : 无论当前是否有事务,都创建一个新事务,并在自己的事务内执行;如果当前存在事务,则把当前事务挂起。

5. PROPAGATION_NOT_SUPPORTED : 以非事务方式执行操作,如果当前存在事务,则把当前事务挂起。

6. PROPAGATION_NEVER : 以非事务方式执行,如果当前存在事务,则抛出异常。

7. PROPAGATION_NESTED : 如果当前存在事务,则创建一个事务作为当前事务的嵌套事务来运行;如果当前没有事务,则相当于REQUIRED。

## 事务的隔离级别

`ISOLATION_DEFAULT`：这是默认值，表示使用底层数据库的默认隔离级别。

`ISOLATION_READ_UNCOMMITTED`：允许读取尚未提交的数据变更，可能导致脏读、不可重复读、幻读。

`ISOLATION_READ_COMMITTED`：对已提交数据的读取，可能导致不可重复读、幻读。

`ISOLATION_REPEATABLE_READ`：对相同字段的多次读取结果都是一致的，可能导致幻读。

`ISOLATION_SERIALIZABLE`：完全服从ACID的隔离级别，所有事务依次逐个执行。

```java
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // 使用默认隔离级别
    @Transactional
    public void createUser(User user) {
        userRepository.save(user);
    }

    // 设置隔离级别为READ_UNCOMMITTED
    @Transactional(isolation = Isolation.READ_UNCOMMITTED)
    public void readUncommitted() {
        // 业务逻辑代码
    }

    // 设置隔离级别为READ_COMMITTED
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public void readCommitted() {
        // 业务逻辑代码
    }

    // 设置隔离级别为REPEATABLE_READ
    @Transactional(isolation = Isolation.REPEATABLE_READ)
    public void repeatableRead() {
        // 业务逻辑代码
    }

    // 设置隔离级别为SERIALIZABLE
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public void serializable() {
        // 业务逻辑代码
    }
}
```



## Spring事务什么时候会失效?

1. **异常处理不当**

   - 如果在事务方法中抛出未被捕获的异常,Spring 会认为事务失败,进行回滚。
   - 如果在事务方法中捕获异常并进行处理,但没有正确地触发事务回滚,也会导致事务失效。

2. **方法调用方式不当**

   - 如果事务方法是通过 new 关键字直接调用的,而不是通过 Spring 容器管理的 Bean 来调用,事务将不会生效。
   - 这是因为 Spring 的事务管理依赖于 AOP 代理,只有通过 Spring 容器管理的 Bean 才能正确地应用事务。

3. **事务传播机制设置不当** : 如果在嵌套事务场景下,内层事务的传播机制设置为 PROPAGATION_NEVER 或 PROPAGATION_NOT_SUPPORTED,将导致外层事务失效。

4. **数据源配置不当** : 如果数据源没有正确配置事务管理器,事务也无法生效。

5. **事务注解使用不当** :如果事务注解 `@Transactional` 没有正确地应用在方法上,或者应用在了非 public 方法上,事务也可能失效。

## Spring中的事务是如何实现的

1. **AOP代理**：Spring利用AOP机制为被@Transactional注解或XML配置的方法创建代理对象。这些代理对象拦截方法调用，并在方法调用前后执行额外的逻辑，如开启和提交事务、回滚事务等。
2. **事务管理器**：Spring定义了多个事务管理器接口，如PlatformTransactionManager、DataSourceTransactionManager等。这些事务管理器负责管理事务的生命周期，包括事务的开启、提交、回滚以及事务的隔离级别和超时设置等。
3. **事务切面**：Spring利用AOP将事务逻辑织入到业务方法调用中，形成事务切面。通过AOP，Spring能够在方法调用前后执行事务管理器定义的事务操作，从而实现事务的管理和控制。
4. **事务的开始和提交**：当调用一个被@Transactional注解或XML配置的方法时，Spring事务切面会首先尝试开启一个事务。如果当前没有事务存在，则创建一个新的事务；如果已经存在事务，则加入到当前事务中。在方法执行完成后，如果方法执行成功，Spring事务切面将提交事务；如果方法发生异常，则回滚事务。
5. **事务的隔离级别和传播行为**：Spring允许在@Transactional注解中指定事务的隔离级别和传播行为。隔离级别定义了事务的并发控制策略，传播行为定义了事务的传播方式。这些设置可以影响事务的行为，如保证数据一致性、避免并发问题等。





# Spring注解

| 注解类型             | 注解              | 说明                                               |
| -------------------- | ----------------- | -------------------------------------------------- |
| **配置类相关注解**   | `@Configuration`  | 标注一个类为配置类，相当于一个Spring XML配置文件。 |
|                      | `@ComponentScan`  | 配置组件扫描的基准包。                             |
|                      | `@Import`         | 导入其他配置类。                                   |
|                      | `@PropertySource` | 指定属性源，如properties文件。                     |
| **Bean相关注解**     | `@Component`      | 标注一个类为Spring组件。                           |
|                      | `@Service`        | 标注一个类为服务层组件。                           |
|                      | `@Repository`     | 标注一个类为数据访问组件，即DAO。                  |
|                      | `@Controller`     | 标注一个类为Spring MVC控制器。                     |
|                      | `@RestController` | 标注一个类为Spring MVC RESTful风格的控制器。       |
|                      | `@Bean`           | 标注一个方法返回一个Bean对象。                     |
| **依赖注入相关注解** | `@Autowired`      | 自动装配，可用于构造器、setter方法、属性或者参数。 |
|                      | `@Qualifier`      | 与`@Autowired`一起使用，提供更细粒度的控制。       |
|                      | `@Resource`       | 相当于`@Autowired`加`@Qualifier`，按名称装配。     |
| **作用域相关注解**   | `@Scope`          | 指定Bean的作用域，如singleton、prototype等。       |
| **生命周期相关注解** | `@PostConstruct`  | 标注一个方法为初始化方法。                         |
|                      | `@PreDestroy`     | 标注一个方法为销毁方法。                           |
| **AOP相关注解**      | `@Aspect`         | 标注一个类为切面。                                 |
|                      | `@Pointcut`       | 定义切点表达式。                                   |
|                      | `@Before`         | 前置通知。                                         |
|                      | `@After`          | 后置通知。                                         |
|                      | `@AfterReturning` | 返回通知。                                         |
|                      | `@AfterThrowing`  | 异常通知。                                         |
|                      | `@Around`         | 环绕通知。                                         |
| **其他注解**         | `@Value`          | 注入属性值。                                       |
|                      | `@Required`       | 标注setter方法必须在配置时设置值。                 |
|                      | `@Lazy`           | 延迟加载。                                         |
|                      | `@DependsOn`      | 定义依赖关系。                                     |
|                      | `@Primary`        | 指定首选的Bean。                                   |





