---
title: SpringBoot实践
tag:
- SpringBoot
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

>通过调用SpringApplication类的run静态方法，启动springboot应用程序

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) {
        SpringApplication.run(MyApplication.class, args);
    }
}
```

### 启用失败

如果应用程序启动失败，日志里面异常信息不够，可以通过debug模式启动，来显示完整的报告，更好的了解报错原因。

```shell
$ java -jar myproject-0.0.1-SNAPSHOT.jar --debug
```

### 懒初始化（Lazy Initialization）

懒加载就是应用程序启动的时候不会创建所有Bean，只有在需要这个Bean的时候才会创建这个Bean。

**创建懒加载的方式**

1. 使用 `SpringApplicationBuilder` 的 `lazyInitialization` 方法

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        new SpringApplicationBuilder(Application.class)
            .lazyInitialization(true)
            .run(args);
    }
}
```

2. 使用 `SpringApplication` 的 `setLazyInitialization` 方法

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication app = new SpringApplication(Application.class);
        app.setLazyInitialization(true);
        app.run(args);
    }
}
```

3. 使用 `spring.main.lazy-initialization` 属性

```yaml
spring:
  main:
    lazy-initialization: true
```

>如果你想禁用某些Bean的懒初始化，同时对应用程序的其他部分使用懒初始化，你可以使用 `@Lazy(false)` 注解将其`Lazy` 属性显式地设置为 false。

### 自定义 Banner

启动时打印的Banner可以通过在 classpath 中添加 `banner.txt` 文件或通过将 `spring.banner.location` 属性设置为该文件的位置来自定义。 如果该文件的编码不是UTF-8，你可以通过 `spring.banner.charset` 属性设置其字符编码。

### 自定义SpringApplication

如果需要修改springBoot的默认值，可以进行自定义，如关闭banner

```java
@SpringBootApplication
public class MpApplication {
    public static void main(String[] args) {
        SpringApplication springApplication = new SpringApplication(MpApplication.class);
        springApplication.setBannerMode(Banner.Mode.OFF);
        springApplication.run(args);
    }
}
```

### Builder API

`SpringApplicationBuilder` 允许你链式调用多个方法，包括调用 `parent` 和 `child` 方法，创建一个层次结构，如下例所示。

```java
new SpringApplicationBuilder().sources(Parent.class)
    .child(Application.class)
    .bannerMode(Banner.Mode.OFF)
    .run(args);
```

### Application 事件和监听器

在 Spring Boot 应用程序中，除了常见的 Spring 框架事件（如 `ContextRefreshedEvent`）之外，`SpringApplication` 还会发布一些额外的应用事件。这些事件可以帮助开发者在应用程序的不同启动阶段执行特定的逻辑。

**1.事件发布顺序**

以下是 `SpringApplication` 发布的事件按顺序列出：

1. **ApplicationStartingEvent**：
   - **时机**：应用程序启动时，最早发布的事件。
   - **作用**：在任何处理之前（除了注册监听器和初始化器），发布此事件。
2. **ApplicationEnvironmentPreparedEvent**：
   - **时机**：在上下文创建之前，当 `Environment` 已知时发布。
   - **作用**：表示 `Environment` 已准备好，但上下文还未创建。
3. **ApplicationContextInitializedEvent**：
   - **时机**：`ApplicationContext` 已准备好并且 `ApplicationContextInitializers` 被调用，但在任何 Bean 定义被加载之前发布。
   - **作用**：表示上下文已初始化，但还未加载 Bean 定义。
4. **ApplicationPreparedEvent**：
   - **时机**：在刷新开始前但在 Bean 定义加载后发布。
   - **作用**：表示 Bean 定义已加载，但上下文还未刷新。
5. **ApplicationStartedEvent**：
   - **时机**：上下文被刷新之后，但在任何应用程序和命令行运行程序被调用之前发布。
   - **作用**：表示应用程序已启动，但还未运行任何 `ApplicationRunner` 和 `CommandLineRunner`。
6. **AvailabilityChangeEvent (LivenessState.CORRECT)**：
   - **时机**：紧接着 `ApplicationStartedEvent` 发布。
   - **作用**：表明应用程序被认为是存活的（Liveness）。
7. **ApplicationReadyEvent**：
   - **时机**：在所有 `ApplicationRunner` 和 `CommandLineRunner` 被调用后发布。
   - **作用**：表示应用程序已准备好，可以接受请求。
8. **AvailabilityChangeEvent (ReadinessState.ACCEPTING_TRAFFIC)**：
   - **时机**：紧接着 `ApplicationReadyEvent` 发布。
   - **作用**：表明应用程序已准备好为请求提供服务（Readiness）。
9. **ApplicationFailedEvent**：
   - **时机**：启动时出现异常时发布。
   - **作用**：表示应用程序启动失败。

2.**注册监听器**

有些事件是在 `ApplicationContext` 被创建之前触发的，所以你不能以 `@Bean` 的形式注册监听器。你可以通过以下方式注册监听器：

1. **通过 `SpringApplication.addListeners(…)` 方法**：

```java
   SpringApplication app = new SpringApplication(MyApplication.class);
   app.addListeners(new MyApplicationListener());
   app.run(args);
```

2. **通过 `SpringApplicationBuilder.listeners(…)` 方法**：

```java
   new SpringApplicationBuilder(MyApplication.class)
       .listeners(new MyApplicationListener())
       .run(args);
```



### WEB 环境（Environment）

`SpringApplication` 会试图帮你创建正确类型的 `ApplicationContext`，具体 `WebApplicationType` 的算法如下。

- 如果Spring MVC存在，就会使用 `AnnotationConfigServletWebServerApplicationContext`。
- 如果Spring MVC不存在而Spring WebFlux存在，则使用 `AnnotationConfigReactiveWebServerApplicationContext`。
- 否则，将使用 `AnnotationConfigApplicationContext`。

### 访问应用参数

传递给 `SpringApplication.run(..)` 的命令行参数,通过 `ApplicationArguments` 接口，访问原始的 `String[]` 参数以及经过解析的 `option` 和 `non-option` 参数。

### 使用 ApplicationRunner 或 CommandLineRunner

`ApplicationRunner` 和 `CommandLineRunner` 是 Spring Boot 提供的两个接口，用于在 Spring Boot 应用程序启动完成后执行特定的代码。这两个接口的主要作用是在应用程序启动并初始化所有 Spring 容器和 beans 之后，执行一些自定义逻辑。它们提供了在应用程序初始化完成后立即执行代码的机制，适用于各种初始化任务、资源加载、数据检查等场景。

**1.ApplicationRunner**

`ApplicationRunner` 接口的 `run` 方法接受一个 `ApplicationArguments` 对象，该对象包含传递给应用程序的参数。

```java
@Component
public class MyApplicationRunner implements ApplicationRunner {

    @Override
    public void run(ApplicationArguments args) throws Exception {
        System.out.println("ApplicationRunner is running with args: " + args.getOptionNames());
    }
}
```

**2.CommandLineRunner**

`CommandLineRunner` 接口的 `run` 方法接受一个 `String` 数组，该数组包含传递给应用程序的原始命令行参数。

```java
@Component
public class MyCommandLineRunner implements CommandLineRunner {

    @Override
    public void run(String... args) throws Exception {
        System.out.println("CommandLineRunner is running with args: " + String.join(", ", args));
    }
}
```

**3.主要区别**

- **参数类型**：
  - `ApplicationRunner` 接受 `ApplicationArguments` 对象，提供了对传递给应用程序的参数的更丰富的访问方式。
  - `CommandLineRunner` 接受一个 `String` 数组，包含传递给应用程序的原始命令行参数。
- **使用场景**：
  - `ApplicationRunner` 更适合需要解析和处理复杂参数的场景。
  - `CommandLineRunner` 更适合处理简单的命令行参数。

### SpringBoot程序退出机制

**1.JVM Shutdown Hook**

每个 `SpringApplication` 都会向 JVM 注册一个 shutdown hook，以确保在 JVM 退出时优雅地关闭 `ApplicationContext`。这意味着在应用程序退出时，Spring 会自动调用所有标准的生命周期回调，例如实现了 `DisposableBean` 接口的 bean 或带有 `@PreDestroy` 注解的方法。

**2.ExitCodeGenerator 接口**

如果你希望在应用程序退出时返回特定的退出代码，可以实现 `org.springframework.boot.ExitCodeGenerator` 接口。这个接口只有一个方法 `getExitCode()`，返回一个整数作为退出代码。

### 开启管理功能

设置 `spring.application.admin.enabled` 属性为true，启用应用程序的管理相关功能，它会在 `MBeanServer` 平台上暴露了 `SpringApplicationAdminMXBean`，**打开 JMX 客户端**，**连接到应用程序**。

### SpringBoot启动流程分析

在 Spring Boot 应用程序启动期间，`SpringApplication` 和 `ApplicationContext` 会执行许多与应用程序生命周期相关的任务，包括 Bean 的生命周期管理和事件处理。为了更好地了解和分析应用程序的启动过程，Spring 框架提供了 `ApplicationStartup` 接口，通过 `StartupStep` 对象来跟踪应用程序的启动顺序。

## 外部化的配置

在不同的环境中使用相同的应用程序代码,可以通过多种外部配置源（如properties、YAML、环境变量、命令行参数）来实现。Spring Boot 使用一个特定的 `PropertySource` 顺序来加载配置，这样后面的配置源可以覆盖前面的配置源。

properties文件 > YAML文件 > 环境变量 > 命令行参数  

>properties文件和YAML文件，按顺序加载，JAR包内的先执行，JAR 包外的文件优先于 JAR 包内的文件。

**配置数据文件的加载顺序**

1. **在 JAR 包内的 `application.properties` 和 YAML 文件**。
2. **在 JAR 包内的特定 Profile 的 `application-{profile}.properties` 和 YAML 文件**。
3. **在 JAR 包外的 `application.properties` 和 YAML 文件**。
4. **在 JAR 包外的特定 Profile 的 `application-{profile}.properties` 和 YAML 文件**。

### 通过命令行参数获取属性

- **通过 `@Value` 注解**：直接注入属性值。
- **通过 `Environment` 接口**：使用 `Environment` 获取属性值。
- **通过 `@ConfigurationProperties` 注解**：将属性绑定到一个 POJO 类中。
- **通过 `ApplicationArguments` 接口**：获取原始的命令行参数。

### 通过Json获取属性

环境变量和系统属性往往有限制，这意味着有些属性名称不能使用。 为了帮助解决这个问题，Spring Boot允许你将一个属性块编码为一个单一的JSON结构。

```shell
$ SPRING_APPLICATION_JSON='{"my":{"name":"test"}}' java -jar myapp.jar
$ java -Dspring.application.json='{"my":{"name":"test"}}' -jar myapp.jar
$ java -jar myapp.jar --spring.application.json='{"my":{"name":"test"}}'
```

### 通过Application Properties获取属性

Spring Boot会自动从以下位置找到并加载 `application.properties` 和 `application.yaml` 文件。

#### 加载顺序

加载顺序如下，最后的会覆盖前面的

1. **当前目录的 `/config` 子目录**：
   - `file:./config/`
2. **当前目录**：
   - `file:./`
3. **类路径的 `/config` 包**：
   - `classpath:/config/`
4. **类路径的根目录**：
   - `classpath:/`

示例说明

假设你有以下配置文件内容：

```properties
#./config/application.properties
server.port=8081
spring.datasource.url=jdbc:mysql://localhost:3306/mydb_config
```

```properties
#./application.properties
server.port=8082
spring.datasource.url=jdbc:mysql://localhost:3306/mydb_root
```

```properties
#src/main/resources/config/application.properties
server.port=8083
spring.datasource.url=jdbc:mysql://localhost:3306/mydb_classpath_config
```

```properties
#src/main/resources/application.properties
server.port=8084
spring.datasource.url=jdbc:mysql://localhost:3306/mydb_classpath_root
```

最终结果

```properties
#src/main/resources/application.properties
server.port=8084
spring.datasource.url=jdbc:mysql://localhost:3306/mydb_classpath_root
```

#### 特定文件

Spring Boot可以使用 `application-{profile}` 的命名惯例加载profile特定的文件。

```properties
#application.profile
spring.profiles.active=prod
```

```properties
#application-prod.profile
server.port=8080
```

#### @ConfigurationProperties

`@ConfigurationProperties` 注解用于将外部化配置（如 `application.properties` 或 `application.yml` 文件中的属性）绑定到一个 POJO 类中。通过 `@ConfigurationProperties` 注解，你可以将一组相关的属性集中到一个类中，便于管理和使用。

1. **定义配置属性类**：创建一个 POJO 类，并使用 `@ConfigurationProperties` 注解指定属性前缀。
2. **启用配置属性**：在启动类中使用 `@EnableConfigurationProperties` 注解启用配置属性绑定。
3. **在其他组件中使用配置属性类**：通过依赖注入将配置属性类注入到需要使用的组件中。

### 通过环境变量获取参数

在 Unix/Linux/MacOS 中，你可以使用 `export` 命令

```bash
export SERVER_PORT=8085
export SPRING_DATASOURCE_URL=jdbc:mysql://localhost:3306/mydb_env
```

通过Environment接口获取变量

```java
@Component
public class MyComponent {

    @Autowired
    private Environment env;

    public void printProperties() {
        String serverPort = env.getProperty("server.port");
        String datasourceUrl = env.getProperty("spring.datasource.url");
        System.out.println("Server Port: " + serverPort);
        System.out.println("Datasource URL: " + datasourceUrl);
    }
}
```

# 国际化

在 Spring Boot 中，实现国际化（i18n）可以让应用程序支持多种语言和区域设置。以下是如何在 Spring Boot 应用程序中使用国际化的详细步骤：

## 配置国际化资源文件

首先，你需要创建包含不同语言的资源文件。通常，这些文件位于 `src/main/resources` 目录下，并且以 `.properties` 文件的形式存在。

- `messages.properties`（默认语言）

```properties
  greeting=Hello
  farewell=Goodbye
```

- `messages_fr.properties`（法语）

```properties
  greeting=Bonjour
  farewell=Au revoir
```

- `messages_es.properties`（西班牙语）

```properties
  greeting=Hola
  farewell=Adiós
```

## 配置 `MessageSource` Bean

在你的 Spring Boot 应用程序配置类中，配置 `MessageSource` Bean 以加载国际化资源文件。

```java
@Configuration
public class InternationalizationConfig implements WebMvcConfigurer {

    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasename("classpath:messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }

    @Bean
    public LocaleResolver localeResolver() {
        CookieLocaleResolver localeResolver = new CookieLocaleResolver();
        localeResolver.setDefaultLocale(Locale.US);
        return localeResolver;
    }

    @Bean
    public LocaleChangeInterceptor localeChangeInterceptor() {
        LocaleChangeInterceptor interceptor = new LocaleChangeInterceptor();
        interceptor.setParamName("lang");
        return interceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(localeChangeInterceptor());
    }
}
```

## 使用国际化资源

在你的控制器或服务中，你可以通过 `MessageSource` Bean 来获取国际化消息。

```java
@RestController
public class GreetingController {

    @Autowired
    private MessageSource messageSource;

    @GetMapping("/greeting")
    public String greeting(@RequestParam(name = "lang", required = false) String lang) {
        Locale locale = lang != null ? new Locale(lang) : Locale.getDefault();
        return messageSource.getMessage("greeting", null, locale);
    }
}
```

## 切换语言

你可以通过在 URL 中添加语言参数来切换语言。例如：

- `http://localhost:8080/greeting?lang=fr` 将返回 "Bonjour"
- `http://localhost:8080/greeting?lang=es` 将返回 "Hola"
- `http://localhost:8080/greeting` 将返回 "Hello"（默认语言）

## 使用 `@RequestHeader` 注解自动检测语言

你还可以使用 `@RequestHeader` 注解自动检测请求中的 `Accept-Language` 头来设置语言。

```java
@RestController
public class GreetingController {
    @Autowired
    private MessageSource messageSource;

    @GetMapping("/greeting")
    public String greeting(@RequestHeader(name = "Accept-Language", required = false) Locale locale) {
        return messageSource.getMessage("greeting", null, locale != null ? locale : Locale.getDefault());
    }
}
```

# Json

Spring Boot提供了与三个JSON库的集成,Jackson是首选和默认的库。

- Gson
- Jackson
- JSON-B

Jackson 是一个用于处理 JSON 数据的流行库，广泛应用于 Java 应用程序中。它可以轻松地将 Java 对象转换为 JSON 格式（序列化），以及将 JSON 数据转换为 Java 对象（反序列化）。在 Spring Boot 中，Jackson 通常用于处理 RESTful API 的请求和响应。

## 基本使用

### 序列化（将 Java 对象转换为 JSON）

```java
public class JacksonExample {
    public static void main(String[] args) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();

        // 创建一个示例对象
        User user = new User("John Doe", 30);

        // 将对象转换为 JSON 字符串
        String jsonString = objectMapper.writeValueAsString(user);
        System.out.println(jsonString);
    }
}
@Data
class User {
    private String name;
    private int age;
}
```

### 反序列化（将 JSON 转换为 Java 对象）

```java
public class JacksonExample {
    public static void main(String[] args) throws Exception {
        ObjectMapper objectMapper = new ObjectMapper();

        // JSON 字符串
        String jsonString = "{\"name\":\"John Doe\",\"age\":30}";

        // 将 JSON 字符串转换为对象
        User user = objectMapper.readValue(jsonString, User.class);
        System.out.println(user.getName() + " - " + user.getAge());
    }
}
```

##  SpringBoot中使用 Jackson

在 Spring Boot 中，Jackson 通常用于处理 RESTful API 的请求和响应。Spring Boot 默认使用 Jackson 作为 JSON 处理库。

### 创建Rest控制器

```java
@RestController
@RequestMapping("/api")
public class UserController {

    @GetMapping("/user")
    public User getUser() {
        return new User("John Doe", 30);
    }
}
```

### 发送请求并查看响应

启动应用程序后，访问 `http://localhost:8080/api/user`，你将看到以下 JSON 响应：

```json
{
    "name": "John Doe",
    "age": 30
}
```

## 自定义 Jackson 配置

在 Spring Boot 配置类中定义 `ObjectMapper` Bean 来自定义 Jackson 的配置。

```java
@Configuration
public class JacksonConfig {

    @Bean
    public ObjectMapper objectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.enable(SerializationFeature.INDENT_OUTPUT); // 启用缩进输出
        return objectMapper;
    }
}
```

## Jackson注解

```java
@JsonPropertyOrder({ "age", "name" }) // 指定 JSON 属性的顺序
@JsonProperty("full_name") // 自定义 JSON 属性名
@JsonIgnore // 忽略这个属性,使其不被序列化或反序列化
@JsonInclude 注解可以指定只包含非空属性    
@JsonSerialize 、@JsonDeserialize //注解可以自定义序列化和反序列化的逻辑。    
```

# Executor` 和 `TaskScheduler

`Executor` 和 `TaskScheduler` 在Spring Boot中的主要作用就是执行异步任务和定时任务。

##  异步任务执行 (`Executor`)

### 作用

异步任务允许你在后台执行一些耗时的操作，而不会阻塞主线程。这对于提高应用程序的性能和响应速度非常有用。常见的异步任务包括：

- 发送电子邮件
- 处理文件上传
- 调用远程服务
- 数据处理和计算

### 如何使用

使用 `@EnableAsync` 注解来启用异步任务执行，并使用 `@Async` 注解来标记需要异步执行的方法。

```java
@SpringBootApplication
@EnableAsync
public class AsyncApplication {
    public static void main(String[] args) {
        SpringApplication.run(AsyncApplication.class, args);
    }
}
```

```java
@Service
public class AsyncService {
    @Async
    public void executeAsyncTask() {
        System.out.println("Executing async task...");
        // 模拟耗时操作
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println("Async task completed.");
    }
}
```

## 定时任务执行 (`TaskScheduler`)

### 作用

定时任务允许你在指定的时间间隔或特定的时间点执行某些操作。这对于执行周期性任务非常有用。常见的定时任务包括：

- 数据备份
- 日志清理
- 定期报告生成
- 定时发送通知

### 如何使用

使用 `@EnableScheduling` 注解来启用定时任务执行，并使用 `@Scheduled` 注解来标记需要定时执行的方法。

```java
@SpringBootApplication
@EnableScheduling
public class SchedulingApplication {
    public static void main(String[] args) {
        SpringApplication.run(SchedulingApplication.class, args);
    }
}
```

```java
@Service
public class ScheduledService {
    @Scheduled(fixedRate = 5000)
    public void executeScheduledTask() {
        System.out.println("Executing scheduled task...");
    }
}
```

## 配置和优化

通过配置文件或自定义配置类来优化 `Executor` 和 `TaskScheduler` 的性能，以满足特定的需求。

```xml
spring:
  task:
    execution:
      pool:
        max-size: 16
        queue-capacity: 100
        keep-alive: "10s"
    scheduling:
      thread-name-prefix: "scheduling-"
      pool:
        size: 2
```

```java
@Configuration
public class AppConfig {

    @Bean(name = "taskExecutor")
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(8);
        executor.setMaxPoolSize(16);
        executor.setQueueCapacity(100);
        executor.setKeepAliveSeconds(10);
        executor.setThreadNamePrefix("Async-");
        executor.initialize();
        return executor;
    }

    @Bean
    public ThreadPoolTaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(2);
        scheduler.setThreadNamePrefix("Scheduling-");
        return scheduler;
    }
}
```

# Test

Spring Boot提供了强大的测试支持，可以帮助你编写和运行各种类型的测试，包括单元测试、集成测试和端到端测试。

## 单元测试

单元测试是测试代码的最小单位，通常是一个方法或一个类。Spring Boot提供了JUnit和Mockito等工具来编写单元测试。

### 依赖配置

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 测试类

```java
@SpringBootTest
public class MyServiceTest {

    @Test
    public void testAddition() {
        int result = 1 + 1;
        assertEquals(2, result);
    }
}
```

## 使用Mockito进行单元测试

Mockito是一个流行的Java库，用于创建和配置模拟对象。它非常适合用来测试依赖于其他类或服务的类。

### 服务类

```java
@Service
public class MyService {
    public String greet(String name) {
        return "Hello, " + name;
    }
}
```

### 测试类

```java
public class MyServiceTest {
    @Mock
    private MyService myService;

    @InjectMocks
    private MyServiceTest myServiceTest;

    public MyServiceTest() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testGreet() {
        when(myService.greet("World")).thenReturn("Hello, World");
        String result = myService.greet("World");
        assertEquals("Hello, World", result);
    }
}
```

## 集成测试

集成测试用于测试应用程序的不同部分如何协同工作。Spring Boot提供了 `@SpringBootTest` 注解来方便地进行集成测试。

### 控制器类

```java
@RestController
public class MyController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello, World";
    }
}
```

### 测试类

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class MyControllerTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    public void testHello() {
        ResponseEntity<String> response = restTemplate.getForEntity("/hello", String.class);
        assertEquals("Hello, World", response.getBody());
    }
}
```

## 使用MockMvc进行Web层测试

MockMvc是Spring提供的一个工具，用于测试Spring MVC控制器，而不需要启动整个服务器。

### 控制器类

```java
@RestController
public class MyController {
    @GetMapping("/hello")
    public String hello() {
        return "Hello, World";
    }
}
```

### 测试类

```java
@WebMvcTest(MyController.class)
public class MyControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testHello() throws Exception {
        mockMvc.perform(get("/hello"))
                .andExpect(status().isOk())
                .andExpect(content().string("Hello, World"));
    }
}
```

# Web

SpringBoot支持Web开发，目前有两大框架，Servlet web Application、Reactive Web两种框架

## Servlet Web Application

构建基于Servlet的Web应用，可以利用Spring Boot对Spring MVC或Jersey的自动配置，常用的是MVC模式。

### Spring web Mvc框架

#### 两种编程风格

+ 基于注解编程风格

+ 基于函数式编程的风格

#### SpringBoot中的Spring Mvc自动配置

1. **视图解析器**：
   - 包含 `ContentNegotiatingViewResolver` 和 `BeanNameViewResolver` Bean，用于视图解析。
2. **静态资源支持**：
   - 提供对静态资源（如CSS、JavaScript、图像）的服务支持，包括对WebJars的支持。
3. **类型转换和格式化**：
   - 自动注册 `Converter`、`GenericConverter` 和 `Formatter` Bean，用于类型转换和格式化。
   - 支持 `HttpMessageConverters`，用于将请求和响应转换为对象。
4. **消息代码解析器**：
   - 自动注册 `MessageCodesResolver`，用于国际化和本地化消息的解析。
5. **静态首页**：
   - 支持静态的 `index.html` 作为应用程序的首页。
6. **数据绑定初始化**：
   - 自动使用 `ConfigurableWebBindingInitializer` Bean，用于初始化数据绑定。

#### 定制Spring MVC

如果你需要在保留Spring Boot自动配置的基础上进行更多的MVC定制，可以使用以下方法：

1. 使用 `WebMvcConfigurer`

- 添加一个不含 `@EnableWebMvc` 注解的 `@Configuration` 类，实现 `WebMvcConfigurer` 接口。
- 适用于添加拦截器、格式化器、视图控制器等。

```java
   @Configuration
   public class MyWebMvcConfig implements WebMvcConfigurer {
       @Override
       public void addInterceptors(InterceptorRegistry registry) {
           registry.addInterceptor(new MyInterceptor());
       }

       @Override
       public void addFormatters(FormatterRegistry registry) {
           registry.addFormatter(new MyFormatter());
       }
   }
```

2. 使用 `WebMvcRegistrations`

- 声明一个 `WebMvcRegistrations` 类型的Bean，用于提供 `RequestMappingHandlerMapping`、`RequestMappingHandlerAdapter` 或 `ExceptionHandlerExceptionResolver` 的自定义实例。

```java
   @Configuration
   public class MyWebMvcRegistrations implements WebMvcRegistrations {
       @Override
       public RequestMappingHandlerMapping getRequestMappingHandlerMapping() {
           return new MyRequestMappingHandlerMapping();
       }

       @Override
       public RequestMappingHandlerAdapter getRequestMappingHandlerAdapter() {
           return new MyRequestMappingHandlerAdapter();
       }

       @Override
       public ExceptionHandlerExceptionResolver getExceptionHandlerExceptionResolver() {
           return new MyExceptionHandlerExceptionResolver();
       }
   }
```

3. 完全控制Spring MVC

- 添加自己的 `@Configuration` 并使用 `@EnableWebMvc` 注解，完全接管Spring MVC的配置。
- 适用于需要完全自定义Spring MVC行为的场景。

```java
   @Configuration
   @EnableWebMvc
   public class MyWebMvcConfig implements WebMvcConfigurer {
       // 完全自定义Spring MVC配置
   }
```

#### HTTP消息转换器（HttpMessageConverter）

`HttpMessageConverter` 是 Spring MVC 中用于将 HTTP 请求和响应的内容转换为 Java 对象和反之的接口。它在处理 RESTful Web 服务时非常有用，特别是当你需要将请求体转换为 Java 对象，或者将 Java 对象转换为响应体时。

**1.主要用途**

1. **请求体到Java对象的转换**：
   - 将客户端发送的 JSON、XML 或其他格式的数据转换为 Java 对象。
   - 例如，将一个 JSON 请求体转换为一个 Java 对象，以便在控制器方法中使用。
2. **Java对象到响应体的转换**：
   - 将控制器方法返回的 Java 对象转换为 JSON、XML 或其他格式的数据，以便发送给客户端。
   - 例如，将一个 Java 对象转换为 JSON 响应体，发送给客户端。

**2.默认行为**

Spring Boot 提供了一些开箱即用的合理默认值。默认情况下，Spring Boot 会自动配置以下 `HttpMessageConverter`：

- **JSON 转换**：使用 Jackson 库将 Java 对象转换为 JSON 格式，或将 JSON 格式的数据转换为 Java 对象。
- **XML 转换**：如果 Jackson XML 扩展可用，使用 Jackson XML 扩展进行 XML 转换；否则，使用 JAXB 进行 XML 转换。
- **字符串转换**：默认情况下，字符串是以 UTF-8 编码的。

**3.自定义** `HttpMessageConverter`

如果你需要添加或定制 `HttpMessageConverter`，可以通过配置类来实现。你可以添加新的转换器，或者覆盖默认的转换器。

**pom.xml**

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
    </dependency>
</dependencies>
```

**自定义转换器配置**

```java
@Configuration(proxyBeanMethods = false)
public class MyHttpMessageConvertersConfiguration {

    @Bean
    public HttpMessageConverters customConverters() {
        List<HttpMessageConverter<?>> converters = new ArrayList<>();
        
        // 添加一个自定义的字符串转换器
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(StandardCharsets.UTF_8);
        converters.add(stringConverter);
        
        // 添加一个自定义的 JSON 转换器
        MappingJackson2HttpMessageConverter jsonConverter = new MappingJackson2HttpMessageConverter();
        converters.add(jsonConverter);
        
        return new HttpMessageConverters(converters);
    }
}
```

`/api/hello` 端点将返回一个字符串，`/api/json` 端点将返回一个 JSON 对象,自定义的 `HttpMessageConverter` 将处理这些。

#### CORS 跨域的支持

跨源资源共享（CORS，Cross-Origin Resource Sharing）是一种W3C规范，允许服务器定义哪些跨域请求是被允许的。这对于现代Web应用程序来说非常重要，因为它允许客户端（如浏览器）从不同的域名请求资源，而不会受到同源策略的限制。

从Spring 4.2版本开始，Spring MVC 支持CORS。Spring Boot 提供了两种配置CORS的方法：

**1.局部CORS配置**

你可以在控制器类或方法上使用 `@CrossOrigin` 注解来配置CORS。例如

```java
@RestController
public class MyController {

    @CrossOrigin(origins = "http://example.com")
    @GetMapping("/api/data")
    public String getData() {
        return "Hello, World!";
    }
}
```

**2.全局CORS配置**

为整个应用程序配置CORS，可以通过实现 `WebMvcConfigurer` 接口并重写 `addCorsMappings` 方法来实现全局CORS配置。

```java
@Configuration(proxyBeanMethods = false)
public class MyCorsConfiguration {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {

            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // 允许跨域访问的路径
                registry.addMapping("/api/**")
                        // 允许的源
                        .allowedOrigins("http://example.com")
                        // 允许的方法
                        .allowedMethods("GET", "POST", "PUT", "DELETE")
                        // 允许的请求头
                        .allowedHeaders("*")
                        // 是否允许发送Cookie
                        .allowCredentials(true)
                        // 预检请求的缓存时间（秒）
                        .maxAge(3600);
            }
        };
    }
}
```

**3.CORS应用场景**

+ 前后端分离
+ 微服务
+ 第三方API调用

### JAX-RS 和 Jersey

- **JAX-RS**：Java API for RESTful Web Services，是一个标准的 API，用于创建 RESTful Web 服务。它提供了一组注解和接口，简化了 RESTful 服务的开发。
- **Jersey**：JAX-RS 的参考实现，提供了完整的 JAX-RS 功能，并扩展了许多额外的特性和功能，帮助开发者更高效地构建 RESTful 服务。

### 嵌入式Servlet容器支持

对于Servlet应用，Spring Boot包括对嵌入式 [Tomcat](https://tomcat.apache.org/)、 [Jetty](https://www.eclipse.org/jetty/) 和 [Undertow](https://github.com/undertow-io/undertow) 服务器的支持。默认情况下，嵌入式服务器监听 `8080` 端口的HTTP请求。

## 优雅停机

在生产环境中，应用程序的优雅停机（Graceful Shutdown）是一个非常重要的功能。它确保应用程序在停止或重启时能够完成正在进行的请求处理，并且正确地释放资源，从而避免数据丢失和服务中断。Spring Boot 提供了对优雅停机的支持，使得开发者可以更轻松地实现这一功能。

### 优雅停机的作用

1. **完成正在进行的请求**：确保正在处理的请求能够在应用程序停止前完成，避免请求被中断。
2. **释放资源**：正确地关闭数据库连接、文件句柄、线程池等资源，避免资源泄漏。
3. **避免数据丢失**：确保数据处理操作（如事务、文件写入）能够在应用程序停止前完成，避免数据丢失。
4. **提高系统稳定性**：在应用程序停止或重启时，减少对系统其他部分的影响，提高系统的整体稳定性。

### Spring Boot 的优雅停机配置

从 Spring Boot 2.3 开始，Spring Boot 提供了对优雅停机的内置支持。你可以通过配置文件来启用和配置优雅停机功能。

#### 配置示例

在 `application.properties` 或 `application.yml` 文件中配置优雅停机。

```xml
server:
#启用优雅停机功能。
  shutdown: graceful

spring:
  lifecycle:
#设置每个停机阶段的超时时间为30秒。
    timeout-per-shutdown-phase: 30s
```

### 优雅停机的实现

Spring Boot 的优雅停机机制主要通过以下几个步骤实现：

1. **接收停机信号**：当应用程序接收到停机信号（如 `SIGTERM`）时，Spring Boot 会开始优雅停机过程。
2. **停止接受新请求**：应用程序会停止接受新的请求，但会继续处理已经接收的请求。
3. **完成正在进行的请求**：应用程序会等待正在进行的请求处理完成，直到达到配置的超时时间。
4. **释放资源**：应用程序会正确地关闭数据库连接、文件句柄、线程池等资源。
5. **停止应用程序**：在所有请求处理完成并释放资源后，应用程序会停止。

>**使用Tomcat的优雅关机需要Tomcat 9.0.33或更高版本。**

# 整合技术

## 整合数据库

## 整合Mybatis

## 缓存

## Quartz Scheduler

## 发送邮件

## 校验

## 调用Rest服务

## Web Service

# Spring Boot理论部分

## 什么是Spring Boot？

Spring Boot是由Pivotal团队提供的一个基于Spring框架的开源项目，旨在简化Spring应用的开发。它通过约定优于配置的方式，减少了开发人员需要编写的配置代码，提供了一套快速创建独立运行、生产级Spring应用的解决方案。

## Spring Boot的主要特性有哪些？

- **自动配置**：根据项目中的依赖自动配置Spring应用。
- **独立运行**：可以打包成可执行的JAR或WAR文件，直接运行。
- **内嵌服务器**：默认提供内嵌的Tomcat、Jetty和Undertow服务器。
- **简化的Maven配置**：通过提供的“starter”依赖，简化Maven配置。
- **生产级监控和管理**：内置健康检查、监控和管理功能。
- **无代码生成**：没有代码生成，不需要配置文件生成，直接使用Java代码配置。

## Spring Boot与Spring的区别？

Spring Boot是对Spring框架的一种增强，旨在简化Spring应用的配置和部署。Spring Boot通过自动配置和内嵌服务器，使得Spring应用的开发更快捷、更简单。而Spring是一个全面的框架，提供了各种各样的组件和配置选项。

# Spring Boot的核心概念

## 什么是Spring Boot Starter？

Spring Boot Starter是一种方便的依赖包集合，提供了一组常用的依赖和自动配置。开发者只需添加相应的Starter依赖，即可快速引入所需的功能。例如，`spring-boot-starter-web`包含了开发Web应用所需的所有依赖。

## 什么是Spring Boot的自动配置？

Spring Boot的自动配置是一种机制，根据项目的依赖和配置，自动配置Spring应用上下文中的bean。通过`@EnableAutoConfiguration`或`@SpringBootApplication`注解启用，Spring Boot会根据项目中的类路径和bean定义，自动配置所需的bean。

## 什么是Spring Boot的约定优于配置？

Spring Boot采用约定优于配置的原则，提供合理的默认配置，减少开发人员的配置负担。如果默认配置不满足需求，开发人员可以通过配置文件或代码进行自定义配置。

### Spring Boot的主要注解有哪些？

- **@SpringBootApplication**：用于标注主类，集成了`@Configuration`、`@EnableAutoConfiguration`和`@ComponentScan`。
- **@Configuration**：用于定义配置类，等同于XML配置文件。
- **@EnableAutoConfiguration**：启用自动配置。
- **@ComponentScan**：自动扫描并注册组件。
- **@RestController**：用于创建RESTful Web服务的控制器。
- **@RequestMapping**：用于映射HTTP请求到处理方法。

# Spring Boot的配置

## Spring Boot的配置文件有哪些？

Spring Boot主要使用`application.properties`或`application.yml`来配置应用。配置文件位于`src/main/resources`目录下。

## 如何在Spring Boot中读取配置文件？

可以通过`@Value`注解或`@ConfigurationProperties`注解读取配置文件中的值。例如：

```java
@Value("${my.property}")
private String myProperty;
```

或者使用`@ConfigurationProperties`：

```java
@ConfigurationProperties(prefix = "my")
public class MyProperties {
    private String property;
    // getters and setters
}
```

## 如何配置多环境支持？

通过在`application.properties`文件中配置不同环境的配置文件，例如：

- `application-dev.properties`：开发环境配置。
- `application-prod.properties`：生产环境配置。
  然后在启动时通过`--spring.profiles.active=dev`或`application.yml`中的`spring.profiles.active=dev`指定激活的配置文件。

# Spring Boot的高级特性

## 什么是Spring Boot Actuator？

Spring Boot Actuator提供了一组用于监控和管理Spring Boot应用的端点，包括健康检查、审计、度量和环境信息等。可以通过`/actuator`访问这些端点，并通过配置文件进行自定义和安全设置。

## 什么是Spring Boot DevTools？

Spring Boot DevTools是一个开发工具包，旨在提高开发效率。它提供了自动重启、实时加载属性文件、调试等功能。当类路径上的文件发生变化时，DevTools会自动重新启动应用。

## 如何实现Spring Boot的安全管理？

Spring Boot可以集成Spring Security实现安全管理。只需添加`spring-boot-starter-security`依赖，并通过配置类或配置文件进行安全配置。例如：

```java
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
            .antMatchers("/public/**").permitAll()
            .anyRequest().authenticated()
            .and()
            .formLogin();
    }
}
```

## 什么是Spring Boot的异步处理？

Spring Boot支持通过`@EnableAsync`注解和`@Async`注解实现异步方法调用。例如：

```java
@EnableAsync
@SpringBootApplication
public class Application {
    // ...
}

public class MyService {
    @Async
    public void asyncMethod() {
        // 异步执行的代码
    }
}
```

## 什么是Spring Boot的事件机制？

Spring Boot提供了基于Spring事件的机制，允许在应用中发布和监听事件。可以通过`ApplicationEvent`类和`ApplicationListener`接口实现。例如：

```java
public class MyEvent extends ApplicationEvent {
    public MyEvent(Object source) {
        super(source);
    }
}

@Component
public class MyEventListener implements ApplicationListener<MyEvent> {
    @Override
    public void onApplicationEvent(MyEvent event) {
        // 处理事件
    }
}

@Autowired
private ApplicationEventPublisher eventPublisher;

public void publishEvent() {
    eventPublisher.publishEvent(new MyEvent(this));
}
```

# Spring Boot的数据访问

## Spring Boot如何集成JPA？

Spring Boot通过`spring-boot-starter-data-jpa`集成JPA。只需添加依赖并配置数据源，Spring Boot会自动配置EntityManagerFactory和事务管理。可以通过`@Entity`注解定义实体类，通过`JpaRepository`接口定义数据访问层。

## 如何在Spring Boot中使用MyBatis？

Spring Boot可以通过`spring-boot-starter-data-mybatis`集成MyBatis。配置数据源并编写Mapper接口和XML映射文件，然后通过`@MapperScan`注解自动扫描Mapper接口。

## 什么是Spring Data REST？

Spring Data REST是Spring提供的一个项目，旨在通过简单配置将Spring Data仓库暴露为RESTful服务。可以通过`@RepositoryRestResource`注解自动生成RESTful API。例如：

```java
@RepositoryRestResource
public interface UserRepository extends JpaRepository<User, Long> {
    // 自动生成的RESTful API
}
```

## 什么是Spring Boot的事务管理？

Spring Boot通过`@EnableTransactionManagement`注解启用事务管理，并通过`@Transactional`注解管理事务边界。例如：

```java
@EnableTransactionManagement
@SpringBootApplication
public class Application {
    // ...
}

@Service
public class MyService {
    @Transactional
    public void transactionalMethod() {
        // 事务性操作
    }
}
```

# Spring Boot的测试

## 如何使用Spring Boot进行单元测试？

Spring Boot提供了`spring-boot-starter-test`，集成了JUnit、Spring Test、AssertJ和Mockito等常用测试框架。可以通过`@SpringBootTest`注解进行集成测试。例如：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class MyServiceTests {
    @Autowired
    private MyService myService;

    @Test
    public void testServiceMethod() {
        assertNotNull(myService);
    }
}
```

## 如何进行Mock测试？

可以通过`@MockBean`注解创建Mock对象，并注入到Spring应用上下文中。例如：

```java
@RunWith(SpringRunner.class)
@SpringBootTest
public class MyControllerTests {
    @MockBean
    private MyService myService;

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testControllerMethod() throws Exception {
        given(myService.someMethod()).willReturn("result");
        mockMvc.perform(get("/someEndpoint"))
               .andExpect(status().isOk())
               .andExpect(content().string("result"));
    }
}
```

## 如何进行数据层的测试？

可以通过`@DataJpaTest`注解进行JPA相关的测试，自动配置嵌入式数据库和Spring Data JPA。例如：

```java
@RunWith(SpringRunner.class)
@DataJpaTest
public class UserRepositoryTests {
    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private UserRepository userRepository;

    @Test
    public void testFindByUsername() {
        User user = new User();
        user.setUsername("testuser");
        entityManager.persist(user);
        User foundUser = userRepository.findByUsername("testuser");
        assertEquals(user.getUsername(), foundUser.getUsername());
    }
}
```

# Spring Boot的部署

## 如何打包Spring Boot应用？

Spring Boot

可以打包成可执行的JAR或WAR文件。通过Maven或Gradle插件，可以将应用打包并包含所有依赖。例如，使用Maven：

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

然后执行`mvn package`命令生成JAR文件。

## 如何在外部服务器上部署Spring Boot应用？

可以将打包生成的WAR文件部署到外部服务器（如Tomcat）。在`pom.xml`中将打包方式改为`war`，并继承`SpringBootServletInitializer`：

```java
@SpringBootApplication
public class Application extends SpringBootServletInitializer {
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(Application.class);
    }
}
```

## Spring Boot如何支持Docker？

可以通过Dockerfile创建Docker镜像并运行Spring Boot应用。示例如下：

```dockerfile
FROM openjdk:11-jre
COPY target/myapp.jar /app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

然后使用Docker命令生成镜像并运行容器：

```sh
docker build -t myapp .
docker run -p 8080:8080 myapp
```



