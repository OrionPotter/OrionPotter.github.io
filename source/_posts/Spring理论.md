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

### Resource 抽象

+ `Resource` 接口及其实现类（`ClassPathResource`、`FileSystemResource` 等）

+ 资源文件的加载和使用

### Core 工具类

+ `ReflectionUtils`、`CollectionUtils` 等工具类

### IoC 容器基础

#### 什么是Spring IOC 容器

IoC容器是Spring框架用于管理应用程序中bean的生命周期的组件。它负责实例化、配置和组装 bean,并提供给应用程序使用。

#### IOC的作用

1. **管理bean的生命周期**：负责实例化bean、配置bean的属性和依赖关系、管理bean的作用域(singleton、prototype等)、销毁bean
2. **依赖注入**：通过构造函数、setter 方法或字段注入 bean 的依赖使得 bean 可以声明式地接收依赖,而不需要自己创建依赖
3. **解耦应用程序组件**：通过依赖注入,bean不需要知道自己的依赖是谁提供的提高了组件的可重用性和可测试性
4. **配置管理**：支持多种配置方式,如 XML、注解和 Java 配置提供了灵活的配置方式,适应不同的需求
5. **生命周期管理**：支持bean的生命周期回调方法可以在bean初始化和销毁时执行定制的逻辑

#### IoC的实现原理/流程

1. **Bean定义的载入和解析**：Spring支持多种Bean定义的方式,如 XML、注解和 Java 配置类容器会将这些 Bean 定义信息加载到 BeanDefinition 对象中通过 BeanDefinitionReader 等组件完成 Bean 定义的解析和注册
2. **Bean的实例化和依赖注入**：当应用程序请求获取 Bean 时,容器会负责实例化 Bean容器使用反射机制创建 Bean 实例,并通过 setter 方法或构造函数注入依赖容器会缓存已经创建的 Bean 实例,提高性能
3. **Bean生命周期管理**：容器负责管理 Bean 的整个生命周期,包括初始化、依赖注入、销毁等容器提供了 BeanPostProcessor、InitializingBean 等扩展点,开发者可以自定义生命周期逻辑
4. **依赖查找和注入**：容器提供了getBean()等方法供开发者查找和获取Bean实例依赖注入可以是手动配置,也可以是自动装配
5. **容器的扩展机制**：Spring 提供了丰富的扩展机制,如 BeanFactoryPostProcessor、BeanPostProcessor 等开发者可以通过实现这些接口来扩展容器的功能,如添加自定义的 Bean 后处理逻辑
6. **事件机制**：Spring 容器内部定义了一系列事件,如 ContextRefreshedEvent、RequestHandledEvent 等开发者可以注册事件监听器,在特定事件发生时执行自定义逻辑

#### 什么是依赖注入？

IOC控制反转是一种设计理念，具体的实现方式有两种，一种是依赖注入，一种是依赖查找，依赖查找就是硬编码，A类对象初始化的时候创建B对象，依赖注入是交由IOC容器进行管理的，A类不再去实例化B类对象，而是简单声明B，由IOC容器负责将B的实例提供给A



### Bean的生命周期

根据搜索结果,Spring Bean的生命周期可以从以下几个角度来分析:

1. Bean的实例化

- Spring容器根据配置文件或注解元数据创建Bean的实例。
- 如果是单例模式,容器只会创建一次。
- 如果是多例模式,每次请求都会创建一个新的实例。

2. 设置属性值和依赖关系

- 容器根据配置文件或注解中指定的属性值和依赖关系设置Bean的属性值。
- 这个过程称为依赖注入。

3. BeanNameAware和BeanFactoryAware接口

- 如果Bean实现了BeanNameAware接口,容器会将Bean的ID传递给setBeanName()方法。
- 如果Bean实现了BeanFactoryAware接口,容器会将容器自身传递给setBeanFactory()方法。

4. BeanPostProcessor前置处理

- 容器会检查Bean是否实现了BeanPostProcessor接口。
- 如果实现了,容器会在Bean的初始化方法被调用之前调用postProcessBeforeInitialization()方法。

5. InitializingBean和init-method

- 如果Bean实现了InitializingBean接口,容器会调用afterPropertiesSet()方法。
- 如果在配置文件中指定了init-method,容器会调用指定的初始化方法。

6. BeanPostProcessor后置处理

- 容器会检查Bean是否实现了BeanPostProcessor接口。
- 如果实现了,容器会在Bean的初始化方法被调用之后调用postProcessAfterInitialization()方法。

7. 使用Bean

- 此时Bean已经准备就绪,可以被应用程序使用了。

8. 销毁Bean

- 如果Bean实现了DisposableBean接口,容器会在Bean销毁的时候调用destroy()方法。
- 如果在配置文件中指定了destroy-method,容器会调用指定的销毁方法。

## Beans模块

**BeanFactory：**

- `BeanFactory` 接口及其实现类（`XmlBeanFactory`、`DefaultListableBeanFactory` 等）

**Bean 定义：**

- 使用 XML、注解和 Java 配置定义 Bean
- Bean 的作用域（singleton、prototype 等）

### 什么是Bean

Spring Bean代指的就是那些被 IoC 容器所管理的对象。

### 如何定义一个Bean

在Spring中，一个Bean就是由Spring IoC容器实例化、组装和管理的对象,有三种定义Spring Bean的方式

**XML配置**

```xml
<bean id="anotherBean" class="com.example.AnotherClass"></bean>
<bean id="myBean" class="com.example.MyClass">
   <property name="anotherClass" ref="anotherBean"/>
</bean>
```

**注解配置**

```java
@Component
public class MyBean {
    @Autowired
    private AnotherClass anotherClass;
}
```

**Java配置**

```java
@Configuration
public class AppConfig {
    @Bean
    public MyBean myBean() {
        return new MyBean(anotherBean());
    }

    @Bean
    public AnotherClass anotherBean() {
       return new AnotherClass();
    }
}
```

### Bean的作用域

1. Singleton：在每个Spring IoC容器中，一个Bean定义对应唯一一个单独的Bean实例。单例是所有作用域的默认值。

2. Prototype：原型作用域会导致在每次对特定Bean请求的时候，都会创建一个新的Bean实例。

3. Request：在一个HTTP请求的生命周期范围内，Spring容器会返回该bean的同一个实例。只有在Web应用程序的上下文中，这个作用域才可用。

4. Session：在一个HTTP Session 中，Spring容器会返回该Bean的同一个实例。只有在Web应用程序的上下文中，此作用域才可用。

5. Global Session：在一个全局的HTTP Session中，Spring容器会返回该Bean的同一个实例。这通常被用在Portlet应用环境。只有在Web应用程序的上下文中，此作用域才可用。





**依赖注入：**

- 构造器注入和 Setter 注入
- 自动装配（autowiring）的模式（byName、byType、constructor）



## 基于XML注入Bean的方式

### 构造器注入

构造器注入是通过在Spring XML配置文件中使用<constructor-arg>元素，和相对应的构造器参数进行依赖注入。

```java
<bean id="textEditor" class="com.example.TextEditor">
    <constructor-arg ref="spellChecker"/>
</bean>
<bean id="spellChecker" class="com.example.SpellChecker"/>
```

### Setter注入

Setter注入是通过在Spring XML配置文件中使用<property>元素，和相对应的setter方法进行依赖注入。

```java
<bean id="textEditor" class="com.example.TextEditor">
    <property name="spellChecker" ref="spellChecker"/>
</bean>
<bean id="spellChecker" class="com.example.SpellChecker"/>
```

### 自动装配模式

在Spring框架中，在配置文件中设定bean的依赖关系是一个很好的机制，Spring 容器能够自动装配相互合作的bean，这意味着容器不需要和配置，能通过Bean工厂自动处理bean之间的协作。这意味着 Spring可以通过向Bean Factory中注入的方式自动搞定bean之间的依赖关系。自动装配可以设置在每个bean上，也可以设定在特定的bean上。

### 自动装配Bean的方式

1. No: 这是默认的配置，没有发生自动装配。Bean引用需要通过ref属性定义。

2. By Name: 配置中的autowire =“byName”允许容器查看其属性的名称，并寻找定义在配置中具有相同名称的bean。

例如：

```xml
<bean id="textEditor" class="com.example.TextEditor" autowire="byName" />
<bean id="spellChecker" class="com.example.SpellChecker" />
```

在上面的例子中，如果TextEditor类有一个SpellChecker类型的setSpellChecker方法，那么spellChecker bean会被自动装配到textEditor bean中。

3. By Type: 当我们将autowire的属性设置为byType时，Spring容器为该bean的每一属性尝试匹配并自动装配exact type的单个bean。如果找到更多相同类型的bean，就会抛出异常。

4. By Constructor: 类似于byType，但适用于构造器参数。如果在容器中没有发现构造器参数的类型或者有多余一个的类型，则抛出异常。

5. Autodetect: Spring首先尝试使用构造器自动装配，如果失败，Spring会尝试由类型（byType）装配。



**BeanPostProcessor：**

- `BeanPostProcessor` 接口及其实现
- 自定义 Bean 后处理器



## Context模块

**ApplicationContext：**

- `ApplicationContext` 接口及其实现类（`ClassPathXmlApplicationContext`、`FileSystemXmlApplicationContext` 等）
- `ConfigurableApplicationContext` 接口及其扩展

**事件机制：**

- 自定义事件和监听器
- 发布和处理应用事件

**国际化（i18n）：**

- `MessageSource` 接口及其实现
- 国际化消息资源的加载和使用

**注解支持：**

- 使用注解配置 Bean（`@Component`、`@Service`、`@Repository`、`@Controller`）
- 组件扫描（`@ComponentScan`）
- 注解驱动的依赖注入（`@Autowired`、`@Qualifier`）

### BeanFactory 和 ApplicationContext有什么区别？

BeanFactory和ApplicationContext都是Spring框架中的核心接口，用于管理和创建bean对象。但在使用过程中，它们之间有一些主要的区别如下：

1. 功能：相比于BeanFactory，ApplicationContext具有更多的功能。BeanFactory主要提供了基础的IOC功能，主要是用于创建和管理Bean。而ApplicationContext除了支持BeanFactory所提供的所有功能外，还提供了更多高级的应用框架特性，如实现消息资源的国际化，事件传播，资源加载和透明的创建上下文（如WebApplicationContext）等。

2. 启动方式：BeanFactory在初始化后并不会立即初始化单例Bean，而是在获取对象时才会创建。这种方式被称为懒加载。而对于ApplicationContext而言，当配置文件被加载后，其管理的所有单例Bean都会被立即初始化。

3. 事件发布：ApplicationContext具有事件发布功能，可以监听ApplicationContext中的事件，而BeanFactory则没有这个能力。

4. 应用场景：ApplicationContext用于对企业级应用程序提供支持，其功能更加强大且适用于大型系统。相反，BeanFactory则更适用于轻量级应用程序或者小型项目。

5. 内置支持：ApplicationContext对许多企业级服务有内置支持，如邮件服务、JNDI查找以及模板系统等。相对的，BeanFactory没有内置支持这些服务。

因此，虽然在很多情况下BeanFactory和ApplicationContext可以互换使用，但是在大多数复杂应用程序中，倾向于使用ApplicationContext，以取得其更多的框架性的特性。

### ApplicationContext实现有哪些

1. ClassPathXmlApplicationContext：该实现是Spring最常用的ApplicationContext实现类之一，它可以加载类路径中的XML配置文件，创建上下文。

2. FileSystemXmlApplicationContext：该实现也可以加载XML配置文件，但与ClassPathXmlApplicationContext不同的是，它可以加载文件系统中的任何路径下的XML配置文件。

3. AnnotationConfigApplicationContext：这是一个相对新的ApplicationContext实现类，用于基于Java注解的配置。它可以接受一个或多个带有@Configuration注解的类作为输入，也可以通过scan(String... basePackages)方法设置包路径来扫描你的应用程序。

4. WebApplicationContext：这是一个专用于Web应用程序的ApplicationContext实现，它增加了对Web相关环境的支持。

5. XmlWebApplicationContext：这是WebApplicationContext的一个实现，它可以加载Web应用中的XML配置文件。

6. AnnotationConfigWebApplicationContext：这也是WebApplicationContext的一个实现，它支持基于Java注解的配置。

7. RefreshableApplicationContext：这是一个特殊的ApplicationContext接口，它增加了一个refresh方法，允许在运行时重新加载配置。

### applicationContext配置文件

1. Bean 的定义

<bean>标签是配置文件中最常见的元素。每一个<bean>标签都会告诉 Spring 应该实例化、配置和提供哪种类型的类。<bean>元素包括 id、class 属性,以及可能包含的<property>或<constructor-arg>元素等,它们定义了 bean 属性的注入方式。

```xml
<bean id="myBean" class="com.example.MyBean">
    <property name="property1" value="value1" />
    <property name="property2" ref="anotherBean" />
</bean>
```

2. 别名配置

<alias>标签允许为 Bean 定义一个或多个别名。这使得我们可以使用不同的名字引用同一个 Bean。

```xml
<alias name="myBean" alias="myBeanAlias" />
```

3. Bean 的作用范围

Spring 提供了不同的 Bean 作用范围,如 singleton(单例)、prototype(多例)、request、session 等。我们可以在<bean>标签中使用 scope 属性来设置 Bean 的作用范围。

```xml
<bean id="myBean" class="com.example.MyBean" scope="prototype" />
```

4. 集合类型

<list>、<set>、<map>、<props>等标签允许我们注入集合类型的属性。

```xml
<bean id="myBean" class="com.example.MyBean">
    <property name="list">
        <list>
            <value>value1</value>
            <value>value2</value>
        </list>
    </property>
</bean>
```

5. 组件扫描

<context:component-scan>标签告诉 Spring 在哪些包下面进行扫描,将标注了@Component 及其派生注解的类注册为 bean。

```xml
<context:component-scan base-package="com.example" />
```

6. 导入其他配置文件

<import>元素允许将多个小的 XML 配置文件组合成一个大的配置文件,增加了配置文件的模块性和可管理性。

```xml
<import resource="classpath:another-config.xml" />
```

7. 消息源配置

<context:property-placeholder>元素用于外部化字符串到属性文件。

```xml
<context:property-placeholder location="classpath:config.properties" />
```

8. AspectJ 支持

<aop:config>元素用于配置 AOP 代理,<aop:aspect>元素用于声明一个切面,<aop:before>、<aop:after>、<aop:around>等元素用于声明通知。

```xml
<aop:config>
    <aop:aspect id="myAspect" ref="myAspectBean">
        <aop:before pointcut="execution(* com.example..*(..))" method="beforeMethod" />
    </aop:aspect>
</aop:config>
```

1. 

### Spring中的单例Bean是线程安全吗？

不是线程安全，Spring中的bean默认是单例bean，对无状态的对象来说是线程安全，对有状态的bean是非线程安全。

### 如何处理并发线程问题

在一般情况下，只有无状态的Bean才可以在多线程环境下共享，在Spring中，绝大部分Bean都可以声明为singleton作用域，因为Spring对一些Bean中非线程安全状态采用ThreadLocal进行处理，解决线程安全问题。



### 内部Bean

在Spring框架中，当一个bean仅被用作另一个bean的属性时，它能被声明为一个内部bean。内部bean可以用setter注入“属性”和构造方法注入“构造参数”的方式来实现，内部bean通常是匿名的，它们的Scope一般是prototype。

### 注解方式的依赖注入

#### @Autowired

`@Autowired` 是Spring提供的最常用的注解,用于实现自动装配。它可以应用于构造函数、setter方法和字段上。

```java
public class MyService {
    @Autowired
    private MyRepository repository;
}
```

Spring 容器会自动根据类型匹配来注入 `MyRepository` 实例。如果有多个匹配的 bean,则会抛出异常,这时可以使用 `@Qualifier` 来指定具体的 bean。

#### @Qualifier

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

#### @Resource

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



### 自动装配

### 自动装配过程

1. **Bean 实例化**: Spring 容器会根据 Bean 的定义实例化 Bean 对象。

2. **依赖查找和注入**
   - Spring容器会扫描Bean中使用@Autowired注解的属性、构造函数或 setter 方法。
   - 容器会尝试从容器中找到与这些依赖匹配的 Bean,并将其注入到目标 Bean 中。

3. **类型匹配**
   - 容器会先尝试按照类型匹配来找到合适的 Bean 注入。
   - 如果容器中存在多个匹配的 Bean,则会抛出 NoUniqueBeanDefinitionException 异常。

4. **@Qualifier 限定**
   - 如果存在多个匹配的 Bean,可以使用 @Qualifier 注解来进一步限定要注入的 Bean。
   - 容器会根据 @Qualifier 指定的限定符来查找合适的 Bean 进行注入。

5. **自动装配模式**
   - Spring 容器支持 byType、byName 等不同的自动装配模式。
   - 容器会根据配置的自动装配模式来决定如何查找和注入依赖 Bean。

6. **依赖解析**
   - 如果容器中没有找到匹配的 Bean,则会根据 @Autowired 注解的 required 属性来决定是否抛出异常。
   - 如果 required=true,则会抛出 NoSuchBeanDefinitionException 异常;如果 required=false,则会注入 null。

7. **Bean 生命周期回调**
   - 在依赖注入完成后,容器会调用 Bean 的生命周期回调方法,如 @PostConstruct 注解标注的方法。

## SpEL模块

**表达式解析：**

- `ExpressionParser` 接口及其实现（`SpelExpressionParser`）
- 使用表达式在 XML 和注解中进行配置

**对象图导航：**

- 使用 SpEL 访问对象属性、方法调用、数组和集合

**逻辑和数学运算：**

- 使用 SpEL 进行基本的逻辑运算和数学运算

**模板表达式：**

- 在配置文件和注解中使用 SpEL 表达式

### 什么是SpEL

SpEL（Spring Expression Language）是Spring框架中的一种功能强大的表达式语言。它用于在运行时查询和操作对象图，类似于EL（Expression Language），但功能更为强大和灵活。SpEL的设计目的是提供一种通用的表达式求值引擎，可以在Spring应用程序的不同部分（例如配置、注解、XML）中使用。

### SpEL的主要功能和特性

1. **基本语法和操作**：
   - 支持常见的操作符：算术运算符（`+`, `-`, `*`, `/`），关系运算符（`==`, `!=`, `<`, `>`, `<=`, `>=`），逻辑运算符（`and`, `or`, `not`），以及条件运算符（`?:`）。
   - 支持方法调用：可以调用Java对象的方法，例如`T(Math).random()`调用`Math.random()`方法。
   - 支持属性访问：可以访问对象的属性，例如`person.name`。
2. **集合和数组**：
   - 支持列表、集合、数组和字典的操作。例如，`list[0]`访问列表的第一个元素，`map['key']`访问字典的值。
   - 提供了强大的集合操作符，例如投影（`![...]`）和选择（`?[...]`）。
3. **内置函数**：
   - 提供了多种内置函数，例如字符串操作函数、数学函数等。
4. **模板表达式**：
   - 可以在字符串中嵌入表达式，例如`"Hello, #{user.name}"`。
5. **安全性和错误处理**：
   - 提供了配置和控制表达式求值的安全性和错误处理机制。

### SpEL的示例

#### 在配置文件中使用SpEL

Spring XML配置文件中可以使用SpEL

```xml
<bean id="person" class="com.example.Person">
    <property name="name" value="John Doe"/>
    <property name="age" value="#{30}"/>
</bean>

<bean id="greetingService" class="com.example.GreetingService">
    <property name="message" value="#{'Hello, ' + person.name}"/>
</bean>
```

在这个示例中，SpEL用于将`person` bean的`name`属性值嵌入到`greetingService` bean的`message`属性中。

#### 在注解中使用SpEL

SpEL可以在Spring注解中使用，例如在Spring EL注解中：

```java
@Service
public class UserService {

    @Value("#{systemProperties['user.name']}")
    private String systemUserName;

    @Value("#{T(Math).random() * 100}")
    private double randomValue;

    public void printValues() {
        System.out.println("System User Name: " + systemUserName);
        System.out.println("Random Value: " + randomValue);
    }
}
```

#### 在Spring表达式中使用SpEL

Spring表达式可以通过`ExpressionParser`和`EvaluationContext`来解析和求值：

```java
public class SpELDemo {
    public static void main(String[] args) {
        ExpressionParser parser = new SpelExpressionParser();
        StandardEvaluationContext context = new StandardEvaluationContext();

        // 简单的字符串表达式
        String expression1 = "'Hello World'.toUpperCase()";
        String result1 = parser.parseExpression(expression1).getValue(String.class);
        System.out.println(result1); // 输出 "HELLO WORLD"

        // 计算表达式
        String expression2 = "100 * 2 + 400";
        int result2 = parser.parseExpression(expression2).getValue(Integer.class);
        System.out.println(result2); // 输出 600

        // 调用方法和访问属性
        context.setVariable("person", new Person("John", 30));
        String expression3 = "#person.name";
        String result3 = parser.parseExpression(expression3).getValue(context, String.class);
        System.out.println(result3); // 输出 "John"
    }
}
```

在这个示例中，`SpelExpressionParser`用于解析表达式并获取其值。







# AOP

## 什么是AOP

AOP（Aspect-Oriented Programming，面向切面编程）是Spring框架中的一个重要特性，它旨在通过分离跨领域关注点（cross-cutting concerns）来提高代码的模块化和可维护性。在传统的面向对象编程中，业务逻辑和跨领域关注点（如日志记录、事务管理、安全性等）往往会混在一起，使代码复杂且难以维护。AOP通过将这些关注点抽取为独立的“切面”（aspects），使得代码更清晰且更易于管理。

## AOP的核心概念

1. **切面（Aspect）**：切面是AOP的核心概念之一，它代表了跨领域关注点的模块化。一个切面可以包含多个通知（advice），定义了在程序执行的特定点上应执行的行为。
2. **连接点（Join Point）**：连接点是程序执行中的一个具体点，例如方法调用或异常抛出。Spring AOP支持方法级别的连接点。
3. **通知（Advice）**：通知是切面中实际执行的代码。Spring AOP定义了多种类型的通知，包括前置通知（Before）、后置通知（After）、返回通知（AfterReturning）、异常通知（AfterThrowing）和环绕通知（Around）。
4. **切入点（Pointcut）**：切入点定义了切面应用的位置。它通过表达式指定了连接点的集合，例如某个类的某些方法。
5. **目标对象（Target Object）**：目标对象是实际业务逻辑所在的对象，切面通过代理对象应用到目标对象上。
6. **代理（Proxy）**：代理是AOP框架创建的对象，用来实现切面和目标对象的连接。Spring AOP主要通过JDK动态代理和CGLIB代理实现。
7. **织入（Weaving）**：织入是将切面应用到目标对象并创建代理对象的过程。织入可以在编译时、类加载时或运行时进行。Spring AOP采用的是运行时织入。

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

## 示例代码

### 创建切面类

```java
@Aspect
@Component
public class LoggingAspect {

    @Before("execution(* com.example.service.*.*(..))")
    public void logBeforeMethodExecution() {
        System.out.println("A method in the service package is about to be executed.");
    }
}
```

`@Aspect`注解将`LoggingAspect`类标记为一个切面，`@Before`注解定义了一个前置通知，表示在执行`com.example.service`包中的任何方法之前都会执行`logBeforeMethodExecution`方法。

### 配置Spring应用上下文

使用注解配置类来启用AOP：

```java
@Configuration
@ComponentScan(basePackages = "com.example")
@EnableAspectJAutoProxy
public class AppConfig {
}
```

在这个配置类中，`@EnableAspectJAutoProxy`注解启用了Spring的AOP支持。 

### 创建目标对象

```java
@Service
public class UserService {

    public void createUser() {
        System.out.println("Creating a new user...");
    }
}
```

### 测试AOP功能

```java
public class MainApp {

    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        UserService userService = context.getBean(UserService.class);
        userService.createUser();
    }
}
```

运行这个主程序，你会看到以下输出：

```css
A method in the service package is about to be executed.
Creating a new user...
```

## AOP的优势

1. **模块化**：将跨领域关注点与业务逻辑分离，增强了代码的模块化。
2. **可重用性**：切面可以应用于多个目标对象，增强了代码的可重用性。
3. **可维护性**：减少了样板代码，使得业务逻辑更清晰，提高了代码的可维护性。
4. **灵活性**：通过配置或注解，可以灵活地控制切面的应用范围和行为。

# 事务

## Spring事务传播机制

Spring 事务传播机制用于定义当一个事务方法被另一个事务方法调用时事务应该如何传播。

1. PROPAGATION_REQUIRED (默认) : 如果当前存在事务,则加入该事务;如果当前没有事务,则创建一个新事务。

2. PROPAGATION_SUPPORTS : 如果当前存在事务,则加入该事务;如果当前没有事务,则以非事务的方式继续运行。

3. PROPAGATION_MANDATORY : 如果当前存在事务,则加入该事务;如果当前没有事务,则抛出异常。

4. PROPAGATION_REQUIRES_NEW : 无论当前是否有事务,都创建一个新事务,并在自己的事务内执行;如果当前存在事务,则把当前事务挂起。

5. PROPAGATION_NOT_SUPPORTED : 以非事务方式执行操作,如果当前存在事务,则把当前事务挂起。

6. PROPAGATION_NEVER : 以非事务方式执行,如果当前存在事务,则抛出异常。

7. PROPAGATION_NESTED : 如果当前存在事务,则创建一个事务作为当前事务的嵌套事务来运行;如果当前没有事务,则相当于REQUIRED。

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

## 声明式事务

### 什么是声明式事务

声明式事务是指通过配置或注解的方式来声明和管理事务，而不是在代码中手动编写事务管理的逻辑。在spring框架中进行了声明式事务后可以在运行时自动开启、提交、回滚事务。

### 声明式事务的原理

声明式事务使用AOP（面向切面编程，Aspect-Oriented Programming）来实现。当一个方法被声明为事务性方法时，Spring在方法调用之前和之后自动插入事务管理逻辑。

### 实现声明式事务的方式

**1.使用XML配置**

声明式事务通常通过XML配置文件来实现。以下是一个简单的示例：

```xml
<!-- 启用事务注解驱动 -->
<tx:annotation-driven transaction-manager="transactionManager"/>
```

**2.使用注解**



```java
@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Transactional
    public void createUser(User user) {
        userRepository.save(user);
        // 其他业务逻辑
    }
}
```

### 声明式事务的优点

1. **简化代码**：简化了代码开发。
2. **解耦**：事务管理逻辑与业务逻辑分离，代码更清晰易读。
3. **可配置性强**：通过配置文件或注解，可以灵活地控制事务的传播行为、隔离级别和回滚规则等。
4. **提高可维护性**：由于事务管理是集中配置的，更改事务管理策略时只需修改配置或注解，而不需要修改业务代码



# Spring注解

1. 配置类相关注解

- `@Configuration`: 标注一个类为配置类,相当于一个Spring XML配置文件。
- `@ComponentScan`: 配置组件扫描的基准包。
- `@Import`: 导入其他配置类。
- `@PropertySource`: 指定属性源,如properties文件。

2. Bean相关注解

- `@Component`: 标注一个类为Spring组件。
- `@Service`: 标注一个类为服务层组件。
- `@Repository`: 标注一个类为数据访问组件,即DAO。
- `@Controller`: 标注一个类为Spring MVC控制器。
- `@RestController`: 标注一个类为Spring MVC RESTful风格的控制器。
- `@Bean`: 标注一个方法返回一个Bean对象。

3. 依赖注入相关注解

- `@Autowired`: 自动装配,可用于构造器、setter方法、属性或者参数。
- `@Qualifier`: 与`@Autowired`一起使用,提供更细粒度的控制。
- `@Resource`: 相当于`@Autowired`加`@Qualifier`,按名称装配。

4. 作用域相关注解

- `@Scope`: 指定Bean的作用域,如singleton、prototype等。

5. 生命周期相关注解

- `@PostConstruct`: 标注一个方法为初始化方法。
- `@PreDestroy`: 标注一个方法为销毁方法。

6. AOP相关注解

- `@Aspect`: 标注一个类为切面。
- `@Pointcut`: 定义切点表达式。
- `@Before`: 前置通知。
- `@After`: 后置通知。
- `@AfterReturning`: 返回通知。
- `@AfterThrowing`: 异常通知。
- `@Around`: 环绕通知。

7. 其他注解

- `@Value`: 注入属性值。
- `@Required`: 标注setter方法必须在配置时设置值。
- `@Lazy`: 延迟加载。
- `@DependsOn`: 定义依赖关系。
- `@Primary`: 指定首选的Bean。



