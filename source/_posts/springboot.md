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

### **运行打包后的应用**

```shell
$ java -jar target/myapplication-0.0.1-SNAPSHOT.jar

$ java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=8000,suspend=n \
       -jar target/myapplication-0.0.1-SNAPSHOT.jar

```

