---
title: SpringBoot实践
tag:
- java
- springboot
---

# 入门

## SringBoot介绍

Spring Boot是一个用于创建独立、生产级Spring应用程序的框架。它简化了Spring应用程序的开发，通过提供一系列开箱即用的配置和功能，使开发者能够快速上手并专注于业务逻辑。

主要特点：
- **简化Spring开发**：提供更快、更广泛的入门体验。
- **默认配置**：提供开箱即用的配置，同时允许灵活定制。
- **嵌入式服务器**：支持内置服务器（如Tomcat、Jetty），无需外部部署。
- **非功能性特性**：内置支持安全性、度量、健康检查和外部化配置等常见需求。
- **无代码生成**：无需代码生成或XML配置（除非需要生成原生镜像）。

Spring Boot应用程序可以通过`java -jar`命令或传统的WAR包方式启动，非常适合快速开发和部署Java应用程序。

## 系统要求

Spring Boot 2.4.8 需要 Java 8 或更高版本，并且可以兼容到 Java 16，包括 Java 16。还需要 Spring Framework 5.3.8 或以上版本。

**构建工具版本要求**

| 构建工具 | 版本 |
| -------- | ---- |
| Maven    | 3.3+ |
| Gradle   | 6.x  |

### Servlet 容器

Spring Boot 支持以下嵌入式 Servlet 容器

| Servlet 容器                        | Servlet 版本 |
| :---------------------------------- | :----------- |
| Tomcat 10.0                         | 5.0          |
| Jetty 11.0                          | 5.1          |
| Undertow 2.2 (Jakarta EE 9 variant) | 5.0          |

**默认配置的容器是 Tomcat**

**原因：**

1. **广泛使用**：Tomcat 是最常用的 Servlet 容器之一，具有广泛的社区支持和成熟的生态系统。
2. **稳定性和性能**：Tomcat 在性能和稳定性方面表现出色，适用于大多数应用场景。
3. **Spring Boot 的历史原因**：Spring Boot 从一开始就默认使用 Tomcat，许多开发者已经习惯了这种配置。

**修改为 Jetty或者Undertow,先排除Tomcat依赖，再添加对应依赖**

```xml
<dependencies>
    <!-- Exclude Tomcat -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <exclusions>
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-tomcat</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
    
    <!-- Include Jetty -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-jetty</artifactId>
    </dependency>
    <!-- Include Undertow -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-undertow</artifactId>
    </dependency>
</dependencies>
```



### GraalVM 原生镜像

>**GraalVM 是一个多语言虚拟机，支持多种编程语言和运行时环境。GraalVM 原生镜像（Native Image）是 GraalVM 提供的一项功能，可以将 Java 应用程序编译成独立的本地可执行文件。这种本地可执行文件不依赖于 JVM，可以在没有 Java 运行时环境的情况下运行。**

Spring Boot应用程序可以通过使用 GraalVM 22.3 或以上版本 [转换为原生镜像](https://springdoc.cn/spring-boot/native-image.html#native-image.introducing-graalvm-native-images)。

镜像可以通过 [本地构建工具](https://github.com/graalvm/native-build-tools) Gradle/Maven插件或GraalVM提供的 `native-image` 工具来创建。你也可以使用 [native-image Paketo buildpack](https://github.com/paketo-buildpacks/native-image) 来创建原生镜像。

支持以下版本。

| 名称               | 版本   |
| :----------------- | :----- |
| GraalVM Community  | 22.3   |
| Native Build Tools | 0.9.23 |

## hello world

### 前提条件

**安装方式：**Maven安装

**软件版本：**

+ jdk 1.8
+ maven 3.3.X+

### Maven创建项目

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>myproject</artifactId>
    <version>0.0.1-SNAPSHOT</version>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.4.8</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <!-- 将在此添加其他行... -->

    <!-- ((只有当你使用 milestone 或 snapshot 版本时，你才需要这个。)) -->
    <repositories>
        <repository>
            <id>spring-snapshots</id>
            <url>https://repo.spring.io/snapshot</url>
            <snapshots><enabled>true</enabled></snapshots>
        </repository>
        <repository>
            <id>spring-milestones</id>
            <url>https://repo.spring.io/milestone</url>
        </repository>
    </repositories>
    <pluginRepositories>
        <pluginRepository>
            <id>spring-snapshots</id>
            <url>https://repo.spring.io/snapshot</url>
        </pluginRepository>
        <pluginRepository>
            <id>spring-milestones</id>
            <url>https://repo.spring.io/milestone</url>
        </pluginRepository>
    </pluginRepositories>
</project>

```

### 添加依赖到classpath

Spring Boot提供了一些`starter`，不同的`starter`提供不同的功能，添加`starter`可以快速的把一套功能所需要jar添加到你的classpath。例如添加web依赖：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
</dependencies>
```

spring-boot-starter-web包含的依赖项详情如下：

1. **spring-boot-starter**：
   - `org.springframework.boot:spring-boot-starter`
   - 包含 Spring Boot 的核心功能和自动配置支持。
2. **spring-boot-starter-json**：
   - `org.springframework.boot:spring-boot-starter-json`
   - 包含 Jackson 依赖，用于处理 JSON 数据。
3. **spring-boot-starter-tomcat**：
   - `org.springframework.boot:spring-boot-starter-tomcat`
   - 包含嵌入式 Tomcat 容器。
4. **spring-web**：
   - `org.springframework:spring-web`
   - 提供 Spring MVC 框架的核心功能。
5. **spring-webmvc**：
   - `org.springframework:spring-webmvc`
   - 提供 Spring MVC 框架的 Web 层功能。
6. **hibernate-validator**：
   - `org.hibernate.validator:hibernate-validator`
   - 提供 Java Bean 验证功能。
7. **spring-boot-starter-logging**：
   - `org.springframework.boot:spring-boot-starter-logging`
   - 包含 SLF4J 和 Logback，用于日志记录。

**可以运行以下命令查看依赖树,包含哪些依赖**

```bash
mvn dependency:tree -Dincludes=org.springframework.boot:spring-boot-starter-web
```

### 编写代码

Maven默认会从`src/main/java` 编译源代码，因此我们创建一个`src/main/java/MyApplication.java` 的文件，包含以下代码：

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

####  @RestController 和 @RequestMapping 注解

+ `@RestController =@Controller +@ResponseBody`将返回的结果字符串直接响应给客户端
+ `@RequestMapping`提供了routing路由信息，告诉所有请求都被映射到home()

#### @SpringBootApplication 注解

`@SpringBootApplication`=`@SpringBootConfiguration`+`@EnableAutoConfiguration`+`@ComponentScan`

`@EnableAutoConfiguration`实现了自动配置，告诉Spring Boot根据你添加的`starter`依赖项 "猜测" 你想如何配置Spring

#### main 方法

main方法通过调用 `run` 方法，把应用委托给Spring Boot的 `SpringApplication` 类。 `SpringApplication` 引导我们的应用程序启动Spring，而Spring又会启动自动配置的Tomcat网络服务器。 我们需要将 `启动类得类名.class` 作为参数传递给 `run` 方法，以告诉 `SpringApplication` 哪个是主要的Spring组件。 `args` 数组也被传入，这是命令行参数。

### 运行程序

命令行输入`mvn spring-boot:run`

```bash
$ mvn spring-boot:run

  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/
 :: Spring Boot ::  (v2.4.8-SNAPSHOT)
....... . . .
....... . . . (log output here)
....... . . .
........ Started MyApplication in 0.906 seconds (process running for 6.514)
```

打开你的浏览器，访问 `localhost:8080` ，看到以下输出。

```http
Hello World!
```



### 创建一个可执行 Jar

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

# 使用Spring Boot进行开发

## starter

Starter 是一组开箱即用的依赖，简化了项目配置。例如，使用 `spring-boot-starter-data-jpa` 轻松集成 Spring 和 JPA。

**关于Starter的命名**

官方 Starter 命名为 `spring-boot-starter-*`，第三方 Starter 应以项目名称开头，如 `thirdpartyproject-spring-boot-starter`。



## 代码结构

避免使用 "default package"，使用反转域名（如 `com.example.project`）作为包名，以防止 Spring Boot 应用程序扫描项目中所有 JAR 包里的所有类，增加不必要的开销和潜在问题。

## 启动类的位置

建议将启动类放在根包中,项目结构如下，高于其他类，确保 `@SpringBootApplication` 默认扫描子包中的所有组件。如果不使用 `@SpringBootApplication`，可以用 `@EnableAutoConfiguration` 和 `@ComponentScan` 代替。

**项目结构**

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

## Configuration 类

> Spring Boot倾向于使用Java代码进行配置，建议通过 `@Configuration`类而非 XML 配置。启动类通常作为主要的`@SpringBootConfiguration` 类(相当于`@Configuration`)。

### 导入Configuration 类

 `@Import` 注解可以用来导入额外的配置类。 

 `@ComponentScan` 指定扫描路径，来自动扫描加载所有Spring组件，包括 `@Configuration` 类。

### 导入XML配置文件

`@ImportResource` 注解来加载XML配置文件，将xml配置文件中的bean映射成配置类中bean。

## 自动装配（配置）

>Spring Boot的自动装配机制旨在简化配置过程，通过自动检测和配置应用程序所需的组件和服务。

### 自动配置的工作原理

1. **依赖检测**：Spring Boot 会根据你项目中的依赖自动检测所需的配置。例如，如果你添加了 HSQLDB 依赖，Spring Boot 会检测到这一点。
2. **默认配置**：如果你没有手动配置某些 Bean（例如 `DataSource`），Spring Boot 会提供默认配置。例如，在检测到 HSQLDB 依赖且没有手动配置 `DataSource` 的情况下，Spring Boot 会自动配置一个内存数据库。

### 启用自动配置

要启用自动配置功能，你需要在你的配置类上添加 `@EnableAutoConfiguration` 或 `@SpringBootApplication` 注解。

- `@EnableAutoConfiguration`：启用 Spring Boot 的自动配置机制。
- `@SpringBootApplication`：这是一个组合注解，包含了 `@EnableAutoConfiguration`、`@ComponentScan` 和 `@SpringBootConfiguration`，通常用于 Spring Boot 应用的主类。

### 示例代码

#### 自动配置

假设你有一个简单的 Spring Boot 应用，并且添加了 HSQLDB 依赖。

**pom.xml**：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.hsqldb</groupId>
        <artifactId>hsqldb</artifactId>
        <scope>runtime</scope>
    </dependency>
</dependencies>
```

**Application.java**：

```java
@SpringBootApplication
public class Application {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

`@SpringBootApplication` 注解启用了自动配置功能。因为你添加了 HSQLDB 依赖，并且没有手动配置 `DataSource`，Spring Boot 会自动配置一个内存数据库。

#### 手动配置

如果你想手动配置 `DataSource`，可以在配置类中定义一个 `DataSource` Bean。

**DataSourceConfig.java**：

```java
@Configuration
public class DataSourceConfig {

    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql://localhost:3306/mydb");
        dataSource.setUsername("root");
        dataSource.setPassword("password");
        return dataSource;
    }
}
```

Spring Boot 的自动配置机制会检测到你已经手动配置了 `DataSource`，因此不会再自动配置内存数据库。

### 如何禁用指定类进行自动装配

如果你想禁用掉项目中某些自动装配类，可以在 `@SpringBootApplication` 注解的 `exclude` 属性中指定，如下例所示。

```java
@SpringBootApplication(exclude = { DataSourceAutoConfiguration.class })
public class MyApplication {

}
```

## 依赖注入Bean

springBoot推荐使用构造函数注入和 `@ComponentScan` 注解扫描 Bean。如果启动类在顶级包中，`@ComponentScan` 可省略参数。`@SpringBootApplication` 已包含 `@ComponentScan`。以下示例展示了 `@Service` Bean 使用构造器注入 `RiskAssessor` Bean。

**示例代码：**

```java
@Service
public class MyAccountService implements AccountService {

    private final RiskAssessor riskAssessor;

    public MyAccountService(RiskAssessor riskAssessor) {
        this.riskAssessor = riskAssessor;
    }
}
```

如果一个Bean有多个构造函数，你需要用 `@Autowired` 注解来告诉Spring该用哪个构造函数进行注入。

```java
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

## @SpringBootApplication 注解介绍

SpringBoot的开发者希望应用程序可以进行自动装配、自动组件扫描、允许导入额外的配置类，因此采用了`@SpringBootApplication` 注解就可以用来启用这三个功能

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



# 核心特性

## SpringApplication

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

## 启用失败

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

## 懒初始化（Lazy Initialization）

`SpringApplication` 允许应用程序被懒初始化。 当启用懒初始化时，Bean在需要时被创建，而不是在应用程序启动时。 因此，懒初始化可以减少应用程序的启动时间。 在一个Web应用程序中，启用懒初始化后将导致许多与Web相关的Bean在收到HTTP请求之后才会进行初始化。

懒初始化的一个缺点是它会延迟发现应用程序的问题。 如果一个配置错误的Bean被懒初始化了，那么在启动过程中就不会再出现故障，问题只有在Bean被初始化时才会显现出来。 还必须注意确保JVM有足够的内存来容纳应用程序的所有Bean，而不仅仅是那些在启动期间被初始化的Bean。 由于这些原因，默认情况下不启用懒初始化，建议在启用懒初始化之前，对JVM的堆大小进行微调。

可以使用 `SpringApplicationBuilder` 的 `lazyInitialization` 方法或 `SpringApplication` 的 `setLazyInitialization` 方法以编程方式启用懒初始化。 另外，也可以使用 `spring.main.lazy-initialization` 属性来启用，如下例所示。

```yaml
spring:
  main:
    lazy-initialization: true
```

>如果你想禁用某些Bean的懒初始化，同时对应用程序的其他部分使用懒初始化，你可以使用 `@Lazy(false)` 注解将其`Lazy` 属性显式地设置为 false。

## 自定义 Banner

启动时打印的Banner可以通过在 classpath 中添加 `banner.txt` 文件或通过将 `spring.banner.location` 属性设置为该文件的位置来自定义。 如果该文件的编码不是UTF-8，你可以通过 `spring.banner.charset` 属性设置其字符编码。

## 自定义 SpringApplication

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

## Builder API

`SpringApplicationBuilder` 允许你链式调用多个方法，包括调用 `parent` 和 `child` 方法，创建一个层次结构，如下例所示。

```java
new SpringApplicationBuilder().sources(Parent.class)
    .child(Application.class)
    .bannerMode(Banner.Mode.OFF)
    .run(args);
```

## Application 可用性

在平台上部署时，应用程序可以使用 Kubernetes Probes等基础设施向平台提供有关其可用性的信息。Spring Boot对常用的 “liveness” 和 “readiness” 可用性状态提供了开箱即用的支持。如果你使用Spring Boot的 “actuator” ，那么这些状态将作为健康端点组（health endpoint groups）暴露出来。

## Liveness State

一个应用程序的 “Liveness” 状态告诉我们它的内部状态是否允许它正常工作，或者在当前失败的情况下自行恢复。 一个broken状态的 “Liveness” 状态意味着应用程序处于一个无法恢复的状态，基础设施应该重新启动应用程序。Spring Boot应用程序的内部状态大多由Spring `ApplicationContext` 表示。如果 application context 已成功启动，Spring Boot就认为应用程序处于有效状态。一旦context被刷新，应用程序就被认为是活的

## Readiness State

应用程序的 “Readiness” 状态告诉平台，该应用程序是否准备好处理流量。 failing状态的 “Readiness” 告诉平台，它暂时不应该将流量发送到该应用程序。 这通常发生在启动期间，当 `CommandLineRunner` 和 `ApplicationRunner` 组件还在被处理的时候，或者是应用程序觉得目前负载已经到了极限，不能再处理额外的请求的时候。

一旦 `ApplicationRunner` 和 `CommandLineRunner` 被调用完成，就认为应用程序已经准备好了

## 管理应用程序的可用性状态

## Application 事件和监听器

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

## WEB 环境（Environment）

`SpringApplication` 会试图帮你创建正确类型的 `ApplicationContext`。 确定为 `WebApplicationType` 的算法如下。

- 如果Spring MVC存在，就会使用 `AnnotationConfigServletWebServerApplicationContext`。
- 如果Spring MVC不存在而Spring WebFlux存在，则使用 `AnnotationConfigReactiveWebServerApplicationContext`。
- 否则，将使用 `AnnotationConfigApplicationContext`。

这意味着，如果你在同一个应用程序中使用Spring MVC和新的 `WebClient`（来自于Spring WebFlux），Spring MVC将被默认使用。 你可以通过调用 `setWebApplicationType(WebApplicationType)` 来轻松覆盖。

也可以通过调用 `setApplicationContextFactory(…)` 来完全控制使用的 `ApplicationContext` 类型。

## 访问应用参数

如果你需要访问传递给 `SpringApplication.run(..)` 的命令行参数，你可以注入一个 `org.springframework.boot.ApplicationArguments` bean。 通过 `ApplicationArguments` 接口，你可以访问原始的 `String[]` 参数以及经过解析的 `option` 和 `non-option` 参数。如以下例子所示。

## 使用 ApplicationRunner 或 CommandLineRunner

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

## 程序退出

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

## 管理功能

通过指定 `spring.application.admin.enabled` 属性，可以启用应用程序的管理相关功能。 这在 `MBeanServer` 平台上暴露了 [`SpringApplicationAdminMXBean`](https://github.com/spring-projects/spring-boot/tree/main/spring-boot-project/spring-boot/src/main/java/org/springframework/boot/admin/SpringApplicationAdminMXBean.java)。 你可以使用这个功能来远程管理你的Spring Boot应用程序。 这个功能对任何服务包装器的实现也很有用。

## 应用程序启动追踪

在应用程序启动期间，`SpringApplication` 和 `ApplicationContext` 执行许多与应用程序生命周期相关的任务。 beans的生命周期，甚至是处理应用事件。 通过 [`ApplicationStartup`](https://docs.spring.io/spring-framework/docs/6.1.0-M1/javadoc-api/org/springframework/core/metrics/ApplicationStartup.html), ，Spring框架 [允许你用 `StartupStep` 对象来跟踪应用程序的启动顺序](https://docs.spring.io/spring-framework/docs/6.1.0-M1/reference/html/core.html#context-functionality-startup)。 这些数据可以为分析目的而收集，或者只是为了更好地了解应用程序的启动过程。

你可以在设置 `SpringApplication` 实例时选择一个 `ApplicationStartup` 实现。 例如，要使用 `BufferingApplicationStartup`，你可以这么写。

## 外部化的配置

