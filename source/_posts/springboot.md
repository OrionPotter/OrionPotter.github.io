### 一、入门

#### 1.入门介绍

Spring Boot帮助你创建可以运行的独立的、基于Spring的生产级应用程序。 我们对Spring平台和第三方库采取了有主见的观点，这样你就能以最少的麻烦开始工作。 大多数Spring Boot应用程序只需要很少的Spring配置。

你可以使用Spring Boot来创建Java应用程序，可以通过使用 `java -jar` 或更传统的war部署来启动。

我们的主要目标是。

- 为所有的Spring开发提供一个根本性的更快、更广泛的入门体验。
- 开箱即用，但随着需求开始偏离默认值，请迅速摆脱困境。
- 提供一系列大类项目常见的非功能特性（如嵌入式服务器、安全、度量、健康检查和外部化配置）。
- 绝对没有代码生成（当不以原生镜像为目标时），也不要求XML配置。

#### 2.安装要求

+ jdk
+ maven

**pom.xml配置情况**

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>org.example</groupId>
    <artifactId>person_use</artifactId>
    <version>1.0-SNAPSHOT</version>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.6.0</version>
    </parent>
    <properties>
        <maven.compiler.source>8</maven.compiler.source>
        <maven.compiler.target>8</maven.compiler.target>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

**MainApplication.java**

```java
RestController
@SpringBootApplication
public class MainApplication {
    @RequestMapping("/")
    public String home(){
        return "hello,world";
    }

    public static void main(String[] args) {
        SpringApplication.run(MainApplication.class,args);
    }
}
```



#### 3. @RestController 和 @RequestMapping 注解

+ `@RestController =@Controller +@ResponseBody`将返回的结果字符串直接响应给客户端
+ `@RequestMapping`提供了routing路由信息

#### 4.@SpringBootApplication 注解

`@SpringBootApplication`=`@SpringBootConfiguration`+`@EnableAutoConfiguration`+`@ComponentScan`

`@EnableAutoConfiguration`告诉Spring Boot根据你添加的jar依赖项 "猜测" 你想如何配置Spring

#### 5.main 方法

main方法通过调用 `run` 方法，把应用委托给Spring Boot的 `SpringApplication` 类。 `SpringApplication` 引导我们的应用程序启动Spring，而Spring又会启动自动配置的Tomcat网络服务器。 我们需要将 `启动类得类名.class` 作为参数传递给 `run` 方法，以告诉 `SpringApplication` 哪个是主要的Spring组件。 `args` 数组也被传入，这是命令行参数。

#### 6.创建一个可执行 Jar

打包为一个独立可执行jar包，它完全可以运行在生产环境中。 可执行的jar文件（有时被称为 “fat jar”）是包含你的编译类以及你的代码运行所需的所有jar依赖项的压缩包。springboot采取了直接嵌套jar,为了创建一个可执行的jar，我们需要在 `pom.xml` 中添加 `spring-boot-maven-plugin` 插件。在 `pom.xml` 的 `dependencies` 节点下面插入以下几行。

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

### 二、使用Spring Boot进行开发

####  1. 构建系统

Spring Boot的每个版本都提供了一个它所支持的依赖的列表。 在实践中，你不需要在构建配置中为这些依赖声明版本，因为Spring Boot会帮你管理这些。 当你升级Spring Boot本身时，这些依赖也会一同升级。

##### 1.1 Maven

>在Maven中使用Spring Boot

##### 1.2 官方starter

Starter是一系列开箱即用的依赖，你可以在你的应用程序中导入它们。 通过你Starter，可以获得所有你需要的Spring和相关技术的一站式服务，免去了需要到处大量复制粘贴依赖的烦恼。 例如，如果你想开始使用Spring和JPA进行数据库访问，那么可以直接在你的项目中导入 `spring-boot-starter-data-jpa` 依赖。

Starter含了很多你需要的依赖，以使项目快速启动和运行，并拥有一套一致的、受支持的可管理的过渡性依赖。

>**关于Starter的命名**
>
>所有**官方的**Starter都遵循一个类似的命名模式；`spring-boot-starter-*`，其中 `*` 是一个特定类型的应用程序。 这种命名结构是为了在你需要寻找Starter时提供帮助。 许多IDE中集成的Maven可以让你按名称搜索依赖。 例如，如果安装了相应的Eclipse或Spring Tools插件，你可以在POM编辑器中按下 `ctrl-space` ，然后输入 “spring-boot-starter” 来获取完整的列表。
>
>第三方启动器不应该以 `spring-boot` 开头，因为它是留给Spring Boot官方组件的。 相反，第三方启动器通常以项目的名称开始。 例如，一个名为 `thirdpartyproject` 的第三方启动器项目通常被命名为 `thirdpartyproject-spring-boot-starter`。

####  2. 代码结构

Spring Boot对代码的布局，没有特别的要求。 但是，有一些最佳实践。

##### 2.1 避免使用default包

当一个类不包括 `package` 的声明时，它被认为是在 “default package” 中。 通常应避免使 “default package”。 对于使用了 `@ComponentScan`, `@ConfigurationPropertiesScan`, `@EntityScan` 或者 `@SpringBootApplication` 注解的Spring Boot应用程序来说，它可能会造成一个问题：项目中的所有jar里面的所有class都会被读取（扫描）。

>遵循Java推荐的包的命名惯例，使用域名反转作为包名（例如， `com.example.project`）。

##### 2.2 启动类的位置

启动类放在一个根package中，高于其他的类，[`@SpringBootApplication`](https://springdoc.cn/spring-boot/using.html#using.using-the-springbootapplication-annotation) 注解一般都是注解在启动类上的。它默认会扫描当前类下的所有子包。例如，如果你正在编写一个JPA应用程序，你的 `@Entity` 类只有定义在启动类的子包下才能被扫描加载到。这样的好处也显而易见，`@SpringBootApplication` 默认只会扫描加载你项目工程中的组件。

**项目布局**

```
com
 +- example
     +- myapplication
         +- MyApplication.java
         |
         +- customer
         |   +- Customer.java
         |   +- CustomerController.java
         |   +- CustomerService.java
         |   +- CustomerRepository.java
         |
         +- order
             +- Order.java
             +- OrderController.java
             +- OrderService.java
             +- OrderRepository.java
```

#### 3. Configuration 类

Spring Boot倾向于通过Java代码来进行配置的定义。 虽然也可以使用XML来配置 `SpringApplication` ，但还是建议你通过 `@Configuration` 类来进行配置。 通常，可以把启动类是作为主要的 `@Configuration` 类。

##### 3.1 导入额外的 Configuration 类

不需要把所有的 `@Configuration` 放在一个类中。 `@Import` 注解可以用来导入额外的配置类。 另外，你可以使用 `@ComponentScan` 来自动扫描加载所有Spring组件，包括 `@Configuration` 类。

##### 3.2 导入 XML Configuration

需要使用基于XML的配置，我们建议你仍然从 `@Configuration` 类开始，然后通过 `@ImportResource` 注解来加载XML配置文件。

#### 4. 自动装配（配置）

Spring Boot的自动装配机制会试图根据你所添加的依赖来自动配置你的Spring应用程序。 例如，如果你添加了 `HSQLDB` 依赖，而且你没有手动配置任何DataSource Bean，那么Spring Boot就会自动配置内存数据库。

你需要将 `@EnableAutoConfiguration` 或 `@SpringBootApplication` 注解添加到你的 `@Configuration` 类中，从而开启自动配置功能。

##### 4.1. 逐步取代自动配置

自动配置是非侵入性的。自定义你自己的配置来取代自动配置的特定部分。 例如，如果你添加了你自己的 `DataSource` bean，默认的嵌入式数据库支持就会“退步”从而让你的自定义配置生效。

如果想知道在应用中使用了哪些自动配置，你可以在启动命令后添加 `--debug` 参数。 这个参数会为核心的logger开启debug级别的日志，会在控制台输出自动装配项目以及触发自动装配的条件。

##### 4.2. 禁用指定的自动装配类

如果你想禁用掉项目中某些自动装配类，你可以在 `@SpringBootApplication` 注解的 `exclude` 属性中指定，如下例所示。

```java
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class MyApplication {}
```

####  5. Spring Bean 和 依赖注入

推荐使用构造函数注入，并使用 `@ComponentScan` 注解来扫描Bean。可以在启动类添加 `@ComponentScan` 注解，也不需要定义它任何参数， 你的所有应用组件（`@Component`、`@Service`、`@Repository`、`@Controller` 和其他）都会自动注册为Spring Bean。

```java
@Service
public class MyAccountService implements AccountService {

    private final RiskAssessor riskAssessor;

    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
    }
}
//如果一个Bean有多个构造函数，你需要用 @Autowired 注解来告诉Spring该用哪个构造函数进行注入。
@Service
public class MyAccountService implements AccountService {

    private final RiskAssessor riskAssessor;

    private final PrintStream out;

    @Autowired
    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
        this.out = System.out;
    }

    public MyAccountService(RiskAssessor riskAssessor, PrintStream out) {
        this.riskAssessor = riskAssessor;
        this.out = out;
    }
}
```

#### 6.使用@SpringBootApplication 注解

应用程序能够使用自动配置、组件扫描，并且能够在他们的 "application class "上定义额外的配置。 一个 `@SpringBootApplication` 注解就可以用来启用这三个功能，如下。

- `@EnableAutoConfiguration`：启用Spring Boot的自动配置机制。
- `@ComponentScan`：对应用程序所在的包启用 `@Component` 扫描
- `@SpringBootConfiguration`：允许在Context中注册额外的Bean或导入额外的配置类

```java
// Same as @SpringBootConfiguration @EnableAutoConfiguration @ComponentScan
@SpringBootApplication
public class MyApplication {

    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }

}
```

#### 7.运行你的应用

如果你使用Spring Boot的Maven或Gradle插件来创建可执行jar，你可以使用 `java -jar` 来运行你的打包后应用程序，如下例所示。

```shell
$ java -jar target/myapplication-0.0.1-SNAPSHOT.jar
//打包后的jar程序，也支持通过命令行参数开启远程调试服务，如下。
$ java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n \
       -jar target/myapplication-0.0.1-SNAPSHOT.jar

```

#### 8.开发者工具（Developer Tools）

Spring Boot 提供了一套额外的工具，可以让你更加愉快的开发应用。 `spring-boot-devtools` 模块可以包含在任何项目中，以在开发期间提供一些有用的特性。 要使用devtools，请添加以下依赖到项目中。

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>
```

> 要启用devtools，无论用于启动应用程序的类加载器是什么，请设置启动参数 `-Dspring.devtools.restart.enabled=true` 。 在生产环境中不能这样做，因为运行devtools会有安全风险。 要禁用devtools，请删除该依赖或者设置启动参数 `-Dspring.devtools.restart.enabled=false`。
>
>在 Maven 中，`<optional>true</optional>` 的作用是将依赖项标记为可选的。当一个依赖项被标记为可选时，它不会被自动包含在项目的依赖关系中。
>
>当其他项目引用你的项目时，这些可选的依赖项将不会被传递性地引入。只有当其他开发者明确地将这些可选依赖项添加到他们的项目中，这些依赖项才会被包含。

### 三、核心特性

####  1. SpringApplication

通过 `SpringApplication` 类，你可以从 `main()` 方法中启动Spring应用程序。 在许多情况下，你可以直接调动 `SpringApplication.run` 静态方法，如以下例子所示。

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

默认情况下，会显示 `INFO` 级别的日志信息，包括一些相关的启动细节，比如启动应用程序的用户。 如果你需要 `INFO` 以外级别的日志，你可以设置它，如日志级别中所述。 应用程序的版本是使用main方法所在类的包的实现版本来确定的。 启动信息的记录可以通过设置 `spring.main.log-startup-info` 为 `false` 来关闭。 这也将关闭应用程序的激活的profiles的日志记录。

##### 1.1. 启用失败

如果你的应用程序启动失败，注册的 `FailureAnalyzers` 会尝试提供一个专门的错误信息提示和具体的解决办法。 例如，如果你在端口 `8080` 上启动一个网络应用，而该端口已经被使用，你应该看到类似于下面的信息。

```
***************************
APPLICATION FAILED TO START
***************************

Description:

Embedded servlet container failed to start. Port 8080 was already in use.

Action:

Identify and stop the process that is listening on port 8080 or configure this application to listen on another port.
```

如果 failure analyzer 不能够处理异常，你仍然可以显示完整的条件报告以更好地了解出错的原因。例如，如果你通过使用 `java -jar` 来运行你的应用程序，你可以按以下方式启用 `debug` 属性。

```shell
$ java -jar myproject-0.0.1-SNAPSHOT.jar --debug
```

##### 1.2. 懒初始化（Lazy Initialization）

`SpringApplication` 允许应用程序被懒初始化。 当启用懒初始化时，Bean在需要时被创建，而不是在应用程序启动时。 因此，懒初始化可以减少应用程序的启动时间。 在一个Web应用程序中，启用懒初始化后将导致许多与Web相关的Bean在收到HTTP请求之后才会进行初始化。

懒初始化的一个缺点是它会延迟发现应用程序的问题。 如果一个配置错误的Bean被懒初始化了，那么在启动过程中就不会再出现故障，问题只有在Bean被初始化时才会显现出来。 还必须注意确保JVM有足够的内存来容纳应用程序的所有Bean，而不仅仅是那些在启动期间被初始化的Bean。 由于这些原因，默认情况下不启用懒初始化，建议在启用懒初始化之前，对JVM的堆大小进行微调。

可以使用 `SpringApplicationBuilder` 的 `lazyInitialization` 方法或 `SpringApplication` 的 `setLazyInitialization` 方法以编程方式启用懒初始化。 另外，也可以使用 `spring.main.lazy-initialization` 属性来启用，如下例所示。

```yaml
spring:
  main:
    lazy-initialization: true
```

>如果你想禁用某些Bean的懒初始化，同时对应用程序的其他部分使用懒初始化，你可以使用 `@Lazy(false)` 注解将其`Lazy` 属性显式地设置为 false。

##### 1.3 自定义 Banner

启动时打印的Banner可以通过在 classpath 中添加 `banner.txt` 文件或通过将 `spring.banner.location` 属性设置为该文件的位置来自定义。 如果该文件的编码不是UTF-8，你可以通过 `spring.banner.charset` 属性设置其字符编码。

##### 1.4. 自定义 SpringApplication

如果 `SpringApplication` 的默认值不符合你的需求，你可以创建一个实例并对其进行自定义。 例如，要关闭Banner，你可以这样写。

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(MyApplication.class);
        application.setBannerMode(Banner.Mode.OFF);
        application.run(args);
    }
}
```

传递给 `SpringApplication` 的构造参数是 Spring Bean 的配置源。 在大多数情况下，这些是对 `@Configuration` 类的引用，但它们也可能是对 `@Component` 类的直接引用。

#####  1.5. Builder API

`SpringApplicationBuilder` 允许你链式调用多个方法，包括调用 `parent` 和 `child` 方法，创建一个层次结构，如下例所示。

```java
new SpringApplicationBuilder().sources(Parent.class)
    .child(Application.class)
    .bannerMode(Banner.Mode.OFF)
    .run(args);
```

#####  1.6. Application 可用性

在平台上部署时，应用程序可以使用 Kubernetes Probes等基础设施向平台提供有关其可用性的信息。Spring Boot对常用的 “liveness” 和 “readiness” 可用性状态提供了开箱即用的支持。如果你使用Spring Boot的 “actuator” ，那么这些状态将作为健康端点组（health endpoint groups）暴露出来。

###### 1.6.1. Liveness State

一个应用程序的 “Liveness” 状态告诉我们它的内部状态是否允许它正常工作，或者在当前失败的情况下自行恢复。 一个broken状态的 “Liveness” 状态意味着应用程序处于一个无法恢复的状态，基础设施应该重新启动应用程序。Spring Boot应用程序的内部状态大多由Spring `ApplicationContext` 表示。如果 application context 已成功启动，Spring Boot就认为应用程序处于有效状态。一旦context被刷新，应用程序就被认为是活的

###### 1.6.2. Readiness State

应用程序的 “Readiness” 状态告诉平台，该应用程序是否准备好处理流量。 failing状态的 “Readiness” 告诉平台，它暂时不应该将流量发送到该应用程序。 这通常发生在启动期间，当 `CommandLineRunner` 和 `ApplicationRunner` 组件还在被处理的时候，或者是应用程序觉得目前负载已经到了极限，不能再处理额外的请求的时候。

一旦 `ApplicationRunner` 和 `CommandLineRunner` 被调用完成，就认为应用程序已经准备好了

###### 1.6.3. 管理应用程序的可用性状态

##### 1.7. Application 事件和监听器

有些事件实际上是在 `ApplicationContext` 被创建之前触发的，所以你不能以 `@Bean` 的形式注册一个监听器。 你可以通过 `SpringApplication.addListeners(…)` 方法或 `SpringApplicationBuilder.listeners(…)` 方法注册它们。

如果你想让这些监听器自动注册，不管应用程序是如何创建的，你可以在你的项目中添加一个 `META-INF/spring.factories` 文件，并通过 `org.springframework.context.ApplicationListener` 属性来配置你的监听器，如以下例子所示。

```xml
org.springframework.context.ApplicationListener=com.example.project.MyListener
```

当应用程序运行时，Application event按以下顺序发布。

1. 一个 `ApplicationStartingEvent` 在运行开始时被发布，但在任何处理之前，除了注册监听器和初始化器之外。
2. 当在上下文中使用的 `Environment` 已知，但在创建上下文之前，将发布 `ApplicationEnvironmentPreparedEvent`。
3. 当 `ApplicationContext` 已准备好并且 `ApplicationContextInitializers` 被调用，但在任何Bean定义被加载之前，`ApplicationContextInitializedEvent` 被发布。
4. 一个 `ApplicationPreparedEvent` 将在刷新开始前但在Bean定义加载后被发布。
5. 在上下文被刷新之后，但在任何应用程序和命令行运行程序被调用之前，将发布一个 `ApplicationStartedEvent`。
6. 紧接着发布 `LivenessState.CORRECT` 状态的 `AvailabilityChangeEvent`，表明应用程序被认为是存活的。
7. 在任何[ApplicationRunner 和 CommandLineRunner](https://springdoc.cn/spring-boot/features.html#features.spring-application.command-line-runner)被调用后，将发布一个 `ApplicationReadyEvent`。
8. 紧接着发布 `ReadinessState.ACCEPTING_TRAFFIC` 状态的 `AvailabilityChangeEvent`，表明应用程序已经准备好为请求提供服务。
9. 如果启动时出现异常，将发布一个 `ApplicationFailedEvent`。

Application event 是通过使用Spring框架的事件发布机制来发布的。 该机制的一部分确保了发布给子context中的listener的事件也会发布给任何祖先context的listener。 因此，如果你的应用程序使用了多层级的 `SpringApplication`，一个监听器可能会收到同一类型应用程序事件的多个实例（重复收到事件通知）。

为了让你的listener能够区分事件是由哪个context（子、父）发送的，可以注入其application context，然后将注入的context与事件的context进行比较。 context可以通过实现 `ApplicationContextAware` 来注入，如果监听器是一个Bean，则可以通过使用 `@Autowired` 来注入。

##### 1.8. WEB 环境（Environment）

`SpringApplication` 会试图帮你创建正确类型的 `ApplicationContext`。 确定为 `WebApplicationType` 的算法如下。

- 如果Spring MVC存在，就会使用 `AnnotationConfigServletWebServerApplicationContext`。
- 如果Spring MVC不存在而Spring WebFlux存在，则使用 `AnnotationConfigReactiveWebServerApplicationContext`。
- 否则，将使用 `AnnotationConfigApplicationContext`。

这意味着，如果你在同一个应用程序中使用Spring MVC和新的 `WebClient`（来自于Spring WebFlux），Spring MVC将被默认使用。 你可以通过调用 `setWebApplicationType(WebApplicationType)` 来轻松覆盖。

也可以通过调用 `setApplicationContextFactory(…)` 来完全控制使用的 `ApplicationContext` 类型。

#####  1.9. 访问应用参数

如果你需要访问传递给 `SpringApplication.run(..)` 的命令行参数，你可以注入一个 `org.springframework.boot.ApplicationArguments` bean。 通过 `ApplicationArguments` 接口，你可以访问原始的 `String[]` 参数以及经过解析的 `option` 和 `non-option` 参数。如以下例子所示。

##### 1.10. 使用 ApplicationRunner 或 CommandLineRunner

如果你需要在 `SpringApplication` 启动后运行一些特定的代码，你可以实现 `ApplicationRunner` 或 `CommandLineRunner` 接口。 这两个接口以相同的方式工作，并提供一个单一的 `run` 方法，该方法在 `SpringApplication.run(…)` 执行完毕之前被调用。

```java
@Component
public class MyCommandLineRunner implements CommandLineRunner {

    @Override
    public void run(String... args) {
        // Do something...
    }
}
```

如果定义了多个 `CommandLineRunner` 或 `ApplicationRunner` Bean，并且需要它们按照特定的顺序先后执行。那么可以实现 `org.springframework.core.Ordered` 接口或使用 `org.springframework.core.annotation.Order` 注解来指定顺序。

##### 1.11. 程序退出

每个 `SpringApplication` 都向JVM注册了一个shutdown hook，以确保 `ApplicationContext` 在退出时优雅地关闭。 所有标准的Spring生命周期回调（如 `DisposableBean` 接口或 `@PreDestroy` 注解）都可以使用。

此外，如果Bean希望在调用 `SpringApplication.exit()` 时返回特定的退出代码，可以实现 `org.springframework.boot.ExitCodeGenerator` 接口。 然后，这个退出代码可以被传递给 `System.exit()` ，将其作为状态代码返回，如下面的例子所示。

```java
 @Bean
 public ExitCodeGenerator exitCodeGenerator(){
        return () -> 42;
    }

 public static void main(String[] args) {
        System.exit(SpringApplication.exit(SpringApplication.run(MainApplication.class,args)));
    }
```

另外，`ExitCodeGenerator` 接口可以由异常（Exception）实现。 当遇到这种异常时，Spring Boot会返回由实现的 `getExitCode()` 方法提供的退出代码。

如果有多个 `ExitCodeGenerator` ，则使用第一个生成的非零退出代码。 要控制生成器（Generator）的调用顺序，你可以实现 `org.springframework.core.Ordered` 接口或使用 `org.springframework.core.annotation.Order` 注解。

##### 1.12. 管理功能

通过指定 `spring.application.admin.enabled` 属性，可以启用应用程序的管理相关功能。 这在 `MBeanServer` 平台上暴露了 [`SpringApplicationAdminMXBean`](https://github.com/spring-projects/spring-boot/tree/main/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/admin/SpringApplicationAdminMXBean.java)。 你可以使用这个功能来远程管理你的Spring Boot应用程序。 这个功能对任何服务包装器的实现也很有用。

##### 1.13. 应用程序启动追踪

在应用程序启动期间，`SpringApplication` 和 `ApplicationContext` 执行许多与应用程序生命周期相关的任务。 beans的生命周期，甚至是处理应用事件。 通过 [`ApplicationStartup`](https://docs.spring.io/spring-framework/docs/6.1.0-M1/javadoc-api/org/springframework/core/metrics/ApplicationStartup.html), ，Spring框架 [允许你用 `StartupStep` 对象来跟踪应用程序的启动顺序](https://docs.spring.io/spring-framework/docs/6.1.0-M1/reference/html/core.html#context-functionality-startup)。 这些数据可以为分析目的而收集，或者只是为了更好地了解应用程序的启动过程。

你可以在设置 `SpringApplication` 实例时选择一个 `ApplicationStartup` 实现。 例如，要使用 `BufferingApplicationStartup`，你可以这么写。

### 2. 外部化的配置

