---
title: Spring理论知识
tag:
- java
---

# Spring介绍

## 什么是spring

Spring是一个轻量级的java开发框架，解决了企业级开发中业务逻辑层和其他层的耦合问题，简化了java开发。

## Spring框架的设计目标、理念和核心

**设计目标**：为开发者提供轻量级开发平台。

**设计理念**：IOC容器实现耦合对象间的关系管理，通过控制反转将对象之间的依赖关系交给IOC容器。

**核心**: 控制反转（IOC容器）和面向切面编程（AOP）。

## 优缺点

**优点：**

1. IOC实现解耦
2. 支持AOP编程
3. 支持声明式事务
4. 集成了各种框架

**缺点：**

spring依赖反射，反射影响性能

## 应用场景

企业级的应用开发，如SSH、SSM框架

## Spring有哪些模块

### 核心容器

+ core: 提供了框架的基本组成部分，包括IoC和依赖注入特性。`BeanFactory`是核心容器的一个主要组件。
+ Beans: 这个模块提供了`BeanFactory`，是Spring IoC的基础。它实现了Spring框架的配置、创建和管理Java对象的功能。
+ Context: `ApplicationContext`是一个更高级的容器，扩展了`BeanFactory`，提供了更全面的框架功能，例如事件传播、声明式机制和支持各种企业服务。
+ SpEL: 提供了一个功能强大的表达式语言，用于在运行时查询和操作对象图。

### 数据访问/集成

+ JDBC: 提供了JDBC抽象层，简化了与数据库的交互，解决了资源管理和错误处理问题。
+ ORM: 集成了多个ORM框架，如Hibernate、JPA、MyBatis等。提供了ORM框架的集成支持，简化了持久化层的开发。
+ OXM: 提供了对象/Xml映射的抽象层，支持JAXB、Castor等映射工具
+ JMS: 提供了Java消息服务的支持，简化了消息的发送和接收。
+ Transactions: 提供了声明式事务管理功能，使事务管理更加方便和灵活。

### WEB

+ WEB: 提供了创建Web应用程序的基础功能，包括多部分文件上传和初始化Web容器的IoC容器。
+ WEB Servlet: 提供了Spring的Model-View-Controller（MVC）实现，支持构建灵活的Web应用程序。
+ Web struts: 提供了与Struts的集成支持。
+ Web Socket: 提供了WebSocket的支持，允许实时的双向通信。

### AOP

+ AOP: 提供了面向切面编程的功能，使得开发者可以定义方法拦截器和切入点，以便将代码分离为切面。
+ ASPECTS: 提供了与AspectJ的集成支持。

### 工具

提供了类加载器和Java代理的支持，以实现服务器级别的增强。

### 消息

提供了基于消息的应用程序的支持，包含了消息传递的基础设施和消息处理的支持。

### 测试

提供了对JUnit和TestNG的集成支持，方便进行单元测试和集成测试。它包含了模拟对象和Spring应用上下文的测试支持。

## Spring用到的设计模式

**工厂模式**：BeanFactory就是简单工厂模式的体现，用来创建对象的实例。
**单例模式：**Bean默认为单例模式。
**代理模式：**Spring的AOP功能用到了JDK的动态代理和CGLIB字节码生成技术。
**模板方法**：用来解决代码重复的问题。比如. RestTemplate, JmsTemplate, JpaTemplate。
**观察者模式：**当一个对象的状态发生改变时，所有依赖于它的对象都会得到通知被制动更新，如Spring中listener的实现–ApplicationListener。

## Spring有哪些事件

**上下文更新事件（ContextRefreshedEvent）**：在调用ConfigurableApplicationContext 接口中的refresh()方法时被触发。

**上下文开始事件（ContextStartedEvent）**：当容器调用ConfigurableApplicationContext的Start()方法开始/重新开始容器时触发该事件。

**上下文停止事件（ContextStoppedEvent）**：当容器调用ConfigurableApplicationContext的Stop()方法停止容器时触发该事件。

**上下文关闭事件（ContextClosedEvent）**：当ApplicationContext被关闭时触发该事件。容器被关闭时，其管理的所有单例Bean都被销毁。

**请求处理事件（RequestHandledEvent**）：在Web应用中，当一个http请求（request）结束触发该事件。如果一个bean实现了ApplicationListener接口，当一个ApplicationEvent 被发布以后，bean会自动被通知。



# Spring控制反转

## 什么是Spring IOC 容器

Spring的IoC（Inversion of Control，控制反转）容器是Spring框架的核心部分。IoC是一种设计原则，主要目标是减少代码的耦合度,提升代码的可扩展性和可维护性。在IoC的工作模式下，不是由组件本身去new创建依赖对象，而是由Ioc容器来创建并注入所依赖的对象。

## IOC的优点是什么？

1. 降低了代码的耦合度：对象之间的依赖关系由IOC容器进行管理和维护，对象之间的依赖性大大降低，代码之间的耦合度也就降低了。

2. 利于模块化开发：通过控制反转，我们可以将程序的各个模块独立开发，然后利用IOC容器管理各个模块之间的依赖关系。

3. 提高了代码的扩展性：由于我们可以很容易地替换、增加、删除程序中的组件和服务，因此IOC提高了代码的扩展性。

4. 利于单元测试：由于各个对象之间的依赖关系由IOC容器进行管理，我们可以利用此特性为对象提供模拟的依赖，进而方便进行单元测试。

5. 集中管理所有的JavaBeans：在Spring IOC容器中，我们定义了一组JavaBeans，并指定它们的依赖关系。容器在启动时就会生成这些对象，并根据我们定义的依赖关系自动地进行注入。每次我们需要使用某个对象时，只需要让IOC容器为我们生成就可以了。

## Spring IoC 的实现原理

Spring的IOC实现原理主要是通过工厂模式和反射实现的。下面是一个大致的过程：

1. 配置信息读取：IOC容器首先从配置文件(XML)或者配置类（全注解形式）中读取配置信息。读取的信息主要包括需要管理的Bean以及Bean之间的依赖关系。

2. 实例化Bean：根据读取的配置信息，IOC容器通过Java的反射机制创建对应的JavaBean实例。这一步的本质就是调用JavaBean的构造方法创建一个新的JavaBean实例。

3. 依赖注入：当所有的JavaBean都被实例化后，IOC容器根据配置的依赖关系对这些实例进行依赖注入。依赖注入的意思就是将一个JavaBean需要依赖的对象设置到这个JavaBean中。这个过程也是利用了Java的反射机制，通过调用JavaBean的set方法来实现的。

4. Bean的使用：当IOC容器完成了Bean的实例化和依赖注入后，这些JavaBean就可以在应用中被使用了。每当我们需要使用某个JavaBean时，都可以从IOC容器中获取。

5. 生命周期管理：IOC容器负责管理JavaBean的整个生命周期，这包括Bean的创建、初始化、使用和销毁。当JavaBean不再被需要时，IOC容器将会负责销毁这个JavaBean。



## Spring 的 IoC支持哪些功能

1. 依赖注入：这是Spring IoC最核心的功能。Spring IoC容器负责创建对象，解决对象与对象之间的依赖性，以及将依赖的对象注入需要它们的对象中。

2. 实例化Bean：Spring的IoC容器负责创建和管理Bean。Bean是Spring IoC容器管理的对象。这些Bean可以是业务服务对象，数据访问对象，和其他任何可以由Spring管理和配置的对象。

3. Bean的生命周期管理：Spring的IoC容器负责管理Bean的完整生命周期。从创建Bean，初始化~注入依赖，使用Bean,到最后销毁Bean。

4. 配置形式多样：Spring IoC容器支持多种形式的配置，包括XML配置、注解配置以及Java代码配置。

5. AOP支持：Spring的IoC容器对AOP（面向切面编程）提供了支持，从而允许开发者通过预先定义的“切面”，在运行时对应用程序的行为进行修改。

6. 集成第三方框架：Spring IoC 可以轻松地与其他框架集成，如Hibernate、JPA、JDBC等。

7. 事件处理：Spring的IoC容器支持事件处理。当在Spring应用上下文中发生某个动作时，开发者可以定义一些事件处理器来处理这些事件。

8. 国际化支持：Spring的IoC容器支持国际化，可以使应用程序容易支持多地区或多语言。

9. 事务管理：Spring的IoC容器为业务对象提供统一的事务管理接口，简化了对于事务处理的编程。



## BeanFactory 和 ApplicationContext有什么区别？

BeanFactory和ApplicationContext都是Spring框架中的核心接口，用于管理和创建bean对象。但在使用过程中，它们之间有一些主要的区别如下：

1. 功能：相比于BeanFactory，ApplicationContext具有更多的功能。BeanFactory主要提供了基础的IOC功能，主要是用于创建和管理Bean。而ApplicationContext除了支持BeanFactory所提供的所有功能外，还提供了更多高级的应用框架特性，如实现消息资源的国际化，事件传播，资源加载和透明的创建上下文（如WebApplicationContext）等。

2. 启动方式：BeanFactory在初始化后并不会立即初始化单例Bean，而是在获取对象时才会创建。这种方式被称为懒加载。而对于ApplicationContext而言，当配置文件被加载后，其管理的所有单例Bean都会被立即初始化。

3. 事件发布：ApplicationContext具有事件发布功能，可以监听ApplicationContext中的事件，而BeanFactory则没有这个能力。

4. 应用场景：ApplicationContext用于对企业级应用程序提供支持，其功能更加强大且适用于大型系统。相反，BeanFactory则更适用于轻量级应用程序或者小型项目。

5. 内置支持：ApplicationContext对许多企业级服务有内置支持，如邮件服务、JNDI查找以及模板系统等。相对的，BeanFactory没有内置支持这些服务。

因此，虽然在很多情况下BeanFactory和ApplicationContext可以互换使用，但是在大多数复杂应用程序中，倾向于使用ApplicationContext，以取得其更多的框架性的特性。

## ApplicationContext实现有哪些

1. ClassPathXmlApplicationContext：该实现是Spring最常用的ApplicationContext实现类之一，它可以加载类路径中的XML配置文件，创建上下文。

2. FileSystemXmlApplicationContext：该实现也可以加载XML配置文件，但与ClassPathXmlApplicationContext不同的是，它可以加载文件系统中的任何路径下的XML配置文件。

3. AnnotationConfigApplicationContext：这是一个相对新的ApplicationContext实现类，用于基于Java注解的配置。它可以接受一个或多个带有@Configuration注解的类作为输入，也可以通过scan(String... basePackages)方法设置包路径来扫描你的应用程序。

4. WebApplicationContext：这是一个专用于Web应用程序的ApplicationContext实现，它增加了对Web相关环境的支持。

5. XmlWebApplicationContext：这是WebApplicationContext的一个实现，它可以加载Web应用中的XML配置文件。

6. AnnotationConfigWebApplicationContext：这也是WebApplicationContext的一个实现，它支持基于Java注解的配置。

7. RefreshableApplicationContext：这是一个特殊的ApplicationContext接口，它增加了一个refresh方法，允许在运行时重新加载配置。

## 依赖注入

### 什么是Spring的依赖注入？

IOC控制反转是一种设计理念，具体的实现方式有两种，一种是依赖注入，一种是依赖查找，依赖查找就是硬编码，A类对象初始化的时候创建B对象，依赖注入是交由IOC容器进行管理的，A类不再去实例化B类对象，而是简单声明B，由IOC容器负责将B的实例提供给A

### 依赖注入的实现方式

- 构造器注入：通过构造器参数的方式将依赖注入对象，Spring IoC容器在创建bean时，使用构造器进行依赖注入。
- set方法注入：通过set方法将依赖注入对象，这是最常用的一种方式。
- 字段注入：通过反射直接在字段上注入依赖对象。这种方式不推荐使用，因为它会破坏封装原则。





# Spring Bean

## 什么是Spring Bean

Spring Bean代指的就是那些被 IoC 容器所管理的对象。

## 如何定义一个Spring Bean

在Spring中，一个Bean就是由Spring IoC容器实例化、组装和管理的对象,有三种定义Spring Bean的方式

### XML配置

 在XML配置文件中你可以使用<bean>标签来定义一个Bean，指定其类名以及bean的id或name。

```xml
<bean id="anotherBean" class="com.example.AnotherClass"></bean>
<bean id="myBean" class="com.example.MyClass">
   <property name="anotherClass" ref="anotherBean"/>
</bean>
```

### 注解配置

可以在类上使用特定的注解来定义一个Bean，例如@Component, @Service, @Repository, @Controller。当你开启了组件扫描(component scanning)，Spring会自动根据注解定义Bean。

```java
@Component
public class MyBean {
    @Autowired
    private AnotherClass anotherClass;
}
```

### Java配置

创建一个带有@Configuration的配置类，在该类中使用@Bean注解定义Bean。

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

## Spring配置文件包含了哪些信息

1. Bean的定义：这是配置文件中最常见的元素。每一个<bean>标签都会告诉Spring应该实例化、配置和提供哪种类型的类。<bean>元素包括id、class属性，以及可能包含的<property>或<constructor-arg>元素等，它们定义了bean属性的注入方式。

2. 别名配置：<alias>标签允许为Bean定义一个或多个别名。这使得我们可以使用不同的名字引用同一个Bean。

3. Bean的作用范围：Spring提供了不同的Bean作用范围，如singleton(单例)，prototype(多例)，request，session等。我们可以在<bean>标签中使用scope属性来设置Bean的作用范围。

4. 集合类型：<list>、<set>、<map>、<props>等标签允许我们注入集合类型的属性。

5. 组件扫描：<context:component-scan>标签告诉Spring在哪些包下面进行扫描，将标注了@Component及其派生注解的类注册为bean。

6. 导入其他配置文件：<import>元素允许将多个小的XML配置文件组合成一个大的配置文件，增加了配置文件的模块性和可管理性。

7. 消息源配置：<context:property-placeholder>元素用于外部化字符串到属性文件。

8. AspectJ支持：<aop:config>元素用于配置AOP代理，<aop:aspect>元素用于声明一个切面，<aop:before>、<aop:after>、<aop:around>等元素用于声明通知。

## 基于XML注入Bean有哪些方式

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

## Spring Bean的作用域

1. Singleton：在每个Spring IoC容器中，一个Bean定义对应唯一一个单独的Bean实例。单例是所有作用域的默认值。

2. Prototype：原型作用域会导致在每次对特定Bean请求的时候，都会创建一个新的Bean实例。

3. Request：在一个HTTP请求的生命周期范围内，Spring容器会返回该bean的同一个实例。只有在Web应用程序的上下文中，这个作用域才可用。

4. Session：在一个HTTP Session 中，Spring容器会返回该Bean的同一个实例。只有在Web应用程序的上下文中，此作用域才可用。

5. Global Session：在一个全局的HTTP Session中，Spring容器会返回该Bean的同一个实例。这通常被用在Portlet应用环境。只有在Web应用程序的上下文中，此作用域才可用。

## Spring中的单例Bean是线程安全吗？

不是线程安全，Spring中的bean默认是单例bean，对无状态的对象来说是线程安全，对有状态的bean是非线程安全。

## 如何处理并发线程问题

在一般情况下，只有无状态的Bean才可以在多线程环境下共享，在Spring中，绝大部分Bean都可以声明为singleton作用域，因为Spring对一些Bean中非线程安全状态采用ThreadLocal进行处理，解决线程安全问题。

## Bean的声明周期是什么

1. 实例化Bean: 这是Bean的生命周期开始的地方，Spring通过Bean的构造器或工厂方法创建Bean实例。

2. 设置Bean属性（依赖注入): Spring通过Bean定义中的属性为Bean实例填充属性。这可能涉及到自动装配的过程。

3. 调用BeanNameAware的setBeanName方法: 如果Bean实现了BeanNameAware接口，Spring会传入Bean的id。

4. 调用BeanFactoryAware的setBeanFactory方法: 如果Bean实现了BeanFactoryAware接口，Spring会调用它的setBeanFactory方法，传入工厂自身的实例。

5. 调用ApplicationContextAware的setApplicationContext方法: 如果Bean实现了ApplicationContextAware接口，那么Spring容器会调用setApplicationContext方法，传入用于获取所有Bean配置和服务的ApplicationContext。

6. 调用BeanPostProcessor的postProcessBeforeInitialization方法: Spring将这个Bean实例交给BeanPostProcessor的postProcessBeforeInitialization方法。

7. 调用InitializingBean的afterPropertiesSet方法: 如果Bean实现了InitializingBean接口，Spring容器会在所有属性被设置后调用它的afterPropertiesSet方法。

8. 调用自定义初始化方法: 如果通过init-method属性指定了初始化方法，Spring容器将调用它。

9. 调用BeanPostProcessor的postProcessAfterInitialization方法: Spring将Bean实例交给BeanPostProcessor的postProcessAfterInitialization方法。

以上几步完成后，Bean准备好并可用于使用了。

当容器关闭时,存在一个清理阶段:

1. 调用DisposableBean的destroy方法: 如果Bean实现了DisposableBean接口，Spring容器将调用它的destroy方法。

2. 调用自定义销毁方法: 如果通过destroy-method属性指定了销毁方法，Spring容器将调用它。

## 什么是内部Bean

在Spring框架中，当一个bean仅被用作另一个bean的属性时，它能被声明为一个内部bean。内部bean可以用setter注入“属性”和构造方法注入“构造参数”的方式来实现，内部bean通常是匿名的，它们的Scope一般是prototype。

## 如何注入一个集合

类型用于注入一列值，允许有相同的值。

类型用于注入一组值，不允许有相同的值。

类型用于注入一组键值对，键和值都可以为任意类型。

类型用于注入一组键值对，键和值都只能为String类型。

## 自动装配

### 什么是Bean的自动装配

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

### @Autowired自动装配的过程

@Autowired自动装配是Spring框架中用于自动解析和注入依赖关系的主要机制之一。它允许Spring自动将bean注入到其他bean中，而无需显式配置。下面是@Autowired自动装配的主要过程：

1.检测@Autowired注解

当Spring容器启动时，它会扫描应用程序上下文中的所有bean定义，寻找标记有@Autowired注解的字段、构造函数或者方法。

2.查找匹配的依赖

对于标记了@Autowired注解的字段、构造函数或者方法，Spring会尝试找到与之匹配的依赖项，这些依赖项通常是其他bean。匹配的依赖项可以是：

- 与字段或方法参数类型匹配的单个bean。
- 与字段或方法参数类型匹配的多个bean（按照类型进行自动装配）。
- 与字段或方法参数名称匹配的单个bean（按照名称进行自动装配）。

3.解析依赖

一旦找到了匹配的依赖项，Spring会尝试解析它。解析的过程通常涉及创建依赖项的实例，这可能包括调用构造函数、调用工厂方法或者从bean池中获取现有的bean实例。

4.注入依赖

一旦依赖项被成功解析，Spring将其注入到目标bean中。这可能涉及将依赖项设置为目标bean的字段、构造函数参数或者方法参数。

5.解决循环依赖

在自动装配过程中，如果存在循环依赖，Spring会尝试解决这些循环依赖。通常情况下，Spring会通过创建代理对象来解决循环依赖，确保每个bean都可以在需要时被正确注入。

6.生命周期管理

最后，一旦所有依赖关系都得到满足，Spring会继续管理bean的生命周期，包括初始化和销毁阶段的回调。

### 自动装配的缺点

1. **不适合复杂的依赖关系**： 在某些情况下，应用程序可能具有复杂的依赖关系，自动装配可能无法满足所有的需求。特别是当存在多个实现或候选项时，Spring可能无法准确地选择要注入的bean。
2. **难以调试**： 当自动装配出现问题时，调试起来可能会比较困难。由于Spring负责bean的创建和依赖注入，因此在运行时跟踪问题可能需要花费更多的时间。
3. **隐藏依赖关系**： 使用自动装配时，bean之间的依赖关系可能不够明显。在代码中看不到显式的依赖注入，可能会导致理解和维护代码变得困难。
4. **不利于代码的可读性**： 自动装配可能使代码变得更加难以理解，尤其是对于那些不熟悉Spring框架的开发者来说。没有明确的依赖注入语句，可能会导致代码更加隐蔽和晦涩。
5. **潜在的性能影响**： 自动装配可能会对应用程序的性能产生一些影响，尤其是在大型应用中。Spring需要扫描大量的bean定义并尝试解析它们之间的依赖关系，这可能会导致一定程度的性能开销。
6. **不稳定性**： 自动装配可能会导致代码更加脆弱和不稳定。当应用程序的配置发生变化时，可能会影响到自动装配的行为，从而导致意想不到的问题。

# Spring注解

## 什么是spring注解

Spring框架提供了一系列的注解，用于在应用程序中标记类、字段、方法或参数，以提供额外的元数据和指导Spring容器的行为。这些注解使得配置更加简洁，代码更加清晰，并提高了开发效率。

## 什么是注解的自动装配

注解的自动装配是Spring框架中一种依赖注入（DI）的方式，它利用注解来指示Spring容器在创建bean时自动解析并注入其依赖项。自动装配通过识别类之间的依赖关系，并根据特定的注解自动完成依赖注入的过程。

在使用自动装配时，开发者无需显式地在XML配置文件中声明bean之间的依赖关系，而是使用特定的注解来标记类的字段、构造函数或者方法参数，以指示Spring容器如何进行依赖注入。

### @Autowired注解

最常用的自动装配注解是@Autowired。通过@Autowired注解，可以将一个bean自动注入到另一个bean中，而无需手动配置依赖关系。

**示例：**

```
@Component
public class CustomerService {

    private CustomerRepository customerRepository;

    @Autowired
    public CustomerService(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    // Other methods...
}
```

在这个例子中，CustomerService类中的customerRepository字段被@Autowired注解标记，Spring容器将自动查找与该字段类型匹配的bean，并将其注入到CustomerService实例中。

### @Qualifier注解

有时，当存在多个匹配的bean时，Spring无法确定要注入的确切bean。这时可以结合@Autowired和@Qualifier注解来指定要注入的特定bean的名称。

**示例：**

```
@Component
public class CustomerService {

    private CustomerRepository customerRepository;

    @Autowired
    public CustomerService(@Qualifier("customerRepositoryImpl") CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    // Other methods...
}
```

在这个例子中，@Qualifier("customerRepositoryImpl")指示Spring容器注入名为"customerRepositoryImpl"的bean，而不是根据类型来匹配。

### @Resource注解

除了@Autowired和@Qualifier外，还可以使用@Resource注解进行自动装配。@Resource注解默认按照bean的名称来进行装配，可以通过name属性指定要注入的bean的名称。

**示例：**

```
@Component
public class CustomerService {

    @Resource(name="customerRepositoryImpl")
    private CustomerRepository customerRepository;

    // Other methods...
}
```

## 常见的注解有哪些

1. **@Component**：
   - 用于标记一个类作为Spring组件，让Spring自动扫描并将其注册为bean。
2. **@Controller**：
   - 用于标记一个类作为Spring MVC控制器。
3. **@Service**：
   - 用于标记一个类作为服务层组件，通常用于业务逻辑的实现。
4. **@Repository**：
   - 用于标记一个类作为数据访问层组件，通常用于数据库访问操作。
5. **@Autowired**：
   - 用于自动装配依赖，将匹配的bean注入到标记了@Autowired的字段、构造函数或方法参数中。
6. **@Qualifier**：
   - 与@Autowired一起使用，用于指定要注入的特定bean的名称。
7. **@Value**：
   - 用于注入简单值（如基本类型、字符串、引用等）到bean的属性中。
8. **@Configuration**：
   - 用于标记一个类为Spring的配置类，通常与@Bean一起使用，提供bean的定义。
9. **@Bean**：
   - 用于定义一个bean，通常用于@Configuration类中，用于声明要由Spring容器管理的bean。
10. **@Scope**：
    - 用于指定bean的作用域（如单例、原型、会话等）。
11. **@Lazy**：
    - 用于指定bean是否延迟初始化。
12. **@RequestMapping**：
    - 用于映射HTTP请求到控制器的处理方法，常用于Spring MVC中。
13. **@PathVariable**：
    - 用于将URI模板变量映射到处理器方法的参数。
14. **@RequestParam**：
    - 用于从请求参数中获取值，常用于处理器方法的参数中。
15. **@ResponseBody**：
    - 用于指示方法返回的对象应该直接写入HTTP响应正文中，而不是视图解析器解析为视图。
16. **@ResponseStatus**：
    - 用于将特定的HTTP状态码映射到处理器方法或异常类。
17. **@ExceptionHandler**：
    - 用于在控制器中定义异常处理方法。
18. **@Transactional**：
    - 用于声明一个事务方法，通常用于服务层方法上。



# Spring数据访问

## Spring事务传播机制

Spring事务传播机制是指在方法调用链中存在多个事务方法时，如何管理这些方法之间的事务行为的规则和策略。Spring定义了一系列的事务传播行为，以便在不同的场景下选择合适的事务处理方式。

以下是Spring框架中定义的事务传播行为：

1. **REQUIRED**：
   - 如果当前存在事务，则加入该事务，如果当前没有事务，则创建一个新的事务。
   - 这是默认的事务传播行为。
2. **SUPPORTS**：
   - 如果当前存在事务，则加入该事务，如果当前没有事务，则以非事务的方式执行。
3. **MANDATORY**：
   - 必须在事务中执行，如果当前没有事务，则抛出异常。
4. **REQUIRES_NEW**：
   - 每次都会开启一个新的事务，如果当前存在事务，则将当前事务挂起。
5. **NOT_SUPPORTED**：
   - 以非事务的方式执行操作，如果当前存在事务，则将当前事务挂起。
6. **NEVER**：
   - 以非事务的方式执行操作，如果当前存在事务，则抛出异常。
7. **NESTED**：
   - 如果当前存在事务，则在嵌套事务中执行，如果当前没有事务，则创建一个新的事务。
   - 如果外层事务提交，则嵌套事务也会提交；如果外层事务回滚，则嵌套事务也会回滚。
   - 只对DataSourceTransactionManager事务管理器有效，对JtaTransactionManager不适用。

## Spring事务什么时候会失效?

1. **未使用代理调用事务方法**：
   - 当使用非代理的方式调用事务方法时，Spring无法拦截方法调用以管理事务，导致事务不会生效。通常情况下，Spring通过AOP代理来管理事务，因此直接在同一个类中调用另一个带有@Transactional注解的方法，事务是不会生效的。
2. **事务方法内部捕获异常**：
   - 当事务方法内部捕获异常，并在捕获异常后不再向外抛出时，Spring将无法检测到异常，从而无法触发事务的回滚。这种情况下，需要在事务方法内部确保异常能够正确传播出去，或者通过其他方式告知Spring事务管理器发生了异常。
3. **跨越事务边界的调用**：
   - 当一个事务方法内部调用另一个事务方法，而这两个方法都被标记为@Transactional时，Spring事务管理器可能会失效。这是因为默认情况下，Spring只会为外部调用的事务方法创建新的事务，而不会为内部调用的事务方法创建新的事务。解决这个问题的一种方法是使用REQUIRES_NEW传播行为来确保内部调用也创建新的事务。
4. **并发问题**：
   - 当多个线程同时访问同一个事务方法时，如果没有适当地处理并发问题，可能会导致事务失效。例如，在并发环境下，如果未正确设置事务的隔离级别，可能会导致脏读、不可重复读或幻读等问题，从而影响事务的一致性和正确性。
5. **不支持的数据访问方式**：
   - 在使用某些特定的数据访问技术（如直接使用JDBC操作数据库）时，Spring的事务管理可能会失效。因为Spring的事务管理通常依赖于特定的事务管理器（如DataSourceTransactionManager），如果使用的数据访问方式不兼容事务管理器，事务可能无法生效。

## Spring中的事务是如何实现的

1. **AOP代理**：
   - Spring利用AOP机制为被@Transactional注解或XML配置的方法创建代理对象。这些代理对象拦截方法调用，并在方法调用前后执行额外的逻辑，如开启和提交事务、回滚事务等。
2. **事务管理器**：
   - Spring定义了多个事务管理器接口，如PlatformTransactionManager、DataSourceTransactionManager等。这些事务管理器负责管理事务的生命周期，包括事务的开启、提交、回滚以及事务的隔离级别和超时设置等。
3. **事务切面**：
   - Spring利用AOP将事务逻辑织入到业务方法调用中，形成事务切面。通过AOP，Spring能够在方法调用前后执行事务管理器定义的事务操作，从而实现事务的管理和控制。
4. **事务的开始和提交**：
   - 当调用一个被@Transactional注解或XML配置的方法时，Spring事务切面会首先尝试开启一个事务。如果当前没有事务存在，则创建一个新的事务；如果已经存在事务，则加入到当前事务中。在方法执行完成后，如果方法执行成功，Spring事务切面将提交事务；如果方法发生异常，则回滚事务。
5. **事务的隔离级别和传播行为**：
   - Spring允许在@Transactional注解中指定事务的隔离级别和传播行为。隔离级别定义了事务的并发控制策略，传播行为定义了事务的传播方式。这些设置可以影响事务的行为，如保证数据一致性、避免并发问题等。

## 声明式事务

### 什么是声明式事务

声明式事务是指通过配置或注解的方式来声明和管理事务，而不是在代码中手动编写事务管理的逻辑。在spring框架中进行了声明式事务后可以在运行时自动开启、提交、回滚事务。

### 声明式事务的原理

声明式事务使用AOP（面向切面编程，Aspect-Oriented Programming）来实现。当一个方法被声明为事务性方法时，Spring在方法调用之前和之后自动插入事务管理逻辑。

### 实现声明式事务的方式

**1.使用XML配置**

声明式事务通常通过XML配置文件来实现。以下是一个简单的示例：

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:tx="http://www.springframework.org/schema/tx"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="
           http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd
           http://www.springframework.org/schema/tx
           http://www.springframework.org/schema/tx/spring-tx.xsd">

    <!-- 数据源和事务管理器配置 -->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <!-- 配置数据源属性 -->
    </bean>

    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!-- 启用事务注解驱动 -->
    <tx:annotation-driven transaction-manager="transactionManager"/>

    <!-- 事务性bean配置 -->
    <bean id="userService" class="com.example.UserService"/>
</beans>

```

**2.使用注解**

Spring推荐使用注解来配置声明式事务，它简洁和直观。常用的注解包括`@Transactional`。以下是一个示例：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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



# Spring面向切面编程

## 什么是AOP

AOP（Aspect-Oriented Programming，面向切面编程）是Spring框架中的一个重要特性，它旨在通过分离跨领域关注点（cross-cutting concerns）来提高代码的模块化和可维护性。在传统的面向对象编程中，业务逻辑和跨领域关注点（如日志记录、事务管理、安全性等）往往会混在一起，使代码复杂且难以维护。AOP通过将这些关注点抽取为独立的“切面”（aspects），使得代码更清晰且更易于管理。

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



## AOP的核心概念

1. **切面（Aspect）**：
   - 切面是AOP的核心概念之一，它代表了跨领域关注点的模块化。一个切面可以包含多个通知（advice），定义了在程序执行的特定点上应执行的行为。
2. **连接点（Join Point）**：
   - 连接点是程序执行中的一个具体点，例如方法调用或异常抛出。Spring AOP支持方法级别的连接点。
3. **通知（Advice）**：
   - 通知是切面中实际执行的代码。Spring AOP定义了多种类型的通知，包括前置通知（Before）、后置通知（After）、返回通知（AfterReturning）、异常通知（AfterThrowing）和环绕通知（Around）。
4. **切入点（Pointcut）**：
   - 切入点定义了切面应用的位置。它通过表达式指定了连接点的集合，例如某个类的某些方法。
5. **目标对象（Target Object）**：
   - 目标对象是实际业务逻辑所在的对象，切面通过代理对象应用到目标对象上。
6. **代理（Proxy）**：
   - 代理是AOP框架创建的对象，用来实现切面和目标对象的连接。Spring AOP主要通过JDK动态代理和CGLIB代理实现。
7. **织入（Weaving）**：
   - 织入是将切面应用到目标对象并创建代理对象的过程。织入可以在编译时、类加载时或运行时进行。Spring AOP采用的是运行时织入。

## 示例代码

### 创建切面类

```java
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

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
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@Configuration
@ComponentScan(basePackages = "com.example")
@EnableAspectJAutoProxy
public class AppConfig {
}
```

在这个配置类中，`@EnableAspectJAutoProxy`注解启用了Spring的AOP支持。 

### 创建目标对象

```java
import org.springframework.stereotype.Service;

@Service
public class UserService {

    public void createUser() {
        System.out.println("Creating a new user...");
    }
}
```

### 测试AOP功能

```java
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

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

# SpEL

## 什么是SpEL

SpEL（Spring Expression Language）是Spring框架中的一种功能强大的表达式语言。它用于在运行时查询和操作对象图，类似于EL（Expression Language），但功能更为强大和灵活。SpEL的设计目的是提供一种通用的表达式求值引擎，可以在Spring应用程序的不同部分（例如配置、注解、XML）中使用。

## SpEL的主要功能和特性

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

## SpEL的示例

### 在配置文件中使用SpEL

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

### 在注解中使用SpEL

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

### 在Spring表达式中使用SpEL

Spring表达式可以通过`ExpressionParser`和`EvaluationContext`来解析和求值：

```java
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;

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