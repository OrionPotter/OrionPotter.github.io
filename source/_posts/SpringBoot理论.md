---
title: SpringBoot理论
tag:
- SpringBoot理论
---

# 基础

## 什么是SpringBoot

Spring Boot是一个用于创建独立、生产级Spring应用程序的框架。它简化了Spring应用程序的开发，通过提供一系列开箱即用的配置和功能，使开发者能够快速上手并专注于业务逻辑。

## 优点

- **自动配置**：根据项目中的依赖自动配置Spring应用。
- **独立运行**：可以打包成可执行的JAR或WAR文件，直接运行。
- **内嵌服务器**：默认提供内嵌的Tomcat、Jetty和Undertow服务器。
- **简化的Maven配置**：通过提供的“starter”依赖，简化Maven配置。
- **生产级监控和管理**：内置健康检查、监控和管理功能。
- **无代码生成**：没有代码生成，不需要配置文件生成，直接使用Java代码配置。

## 配置类

> Spring Boot倾向于使用Java代码进行配置，建议通过 `@Configuration`类而非 XML 配置。启动类通常作为主要的`@SpringBootConfiguration` 类(相当于`@Configuration`)。

### 导入Configuration 类

 `@Import` 注解可以用来导入额外的配置类。 

 `@ComponentScan` 指定扫描路径，来自动扫描加载所有Spring组件，包括 `@Configuration` 类。

### 导入XML配置文件

`@ImportResource` 注解来加载XML配置文件，将xml配置文件中的bean映射成配置类中bean。

## 自动配置

>Spring Boot的自动装配机制旨在简化配置过程，通过自动检测和配置应用程序所需的组件和服务。

### 自动配置的工作原理

1. **依赖检测**：Spring Boot 会根据你项目中的依赖自动检测所需的配置。例如，如果你添加了 HSQLDB 依赖，Spring Boot 会检测到这一点。
2. **默认配置**：如果你没有手动配置某些 Bean（例如 `DataSource`），Spring Boot 会提供默认配置。例如，在检测到 HSQLDB 依赖且没有手动配置 `DataSource` 的情况下，Spring Boot 会自动配置一个内存数据库。

### 启用自动配置

要启用自动配置功能，你需要在你的配置类上添加 `@EnableAutoConfiguration` 或 `@SpringBootApplication` 注解。

- `@EnableAutoConfiguration`：启用 Spring Boot 的自动配置机制。
- `@SpringBootApplication`：这是一个组合注解，包含了 `@EnableAutoConfiguration`、`@ComponentScan` 和 `@SpringBootConfiguration`，通常用于 Spring Boot 应用的主类。

## 健康检查

Spring Boot Actuator提供了一组用于监控和管理Spring Boot应用的端点，包括健康检查、审计、度量和环境信息等。可以通过`/actuator`访问这些端点，并通过配置文件进行自定义和安全设置。

## Starter

Starter 是一组开箱即用的依赖，简化了项目配置。例如，使用 `spring-boot-starter-data-jpa` 轻松集成 Spring 和 JPA。

## 嵌入式Servlet容器有哪些

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

## 原生镜像

>raalVM 是一个多语言虚拟机，支持多种编程语言和运行时环境。GraalVM 原生镜像（Native Image）是 GraalVM 提供的一项功能，可以将 Java 应用程序编译成独立的本地可执行文件。这种本地可执行文件不依赖于 JVM，可以在没有 Java 运行时环境的情况下运行。**

Spring Boot应用程序可以通过使用 GraalVM 22.3 或以上版本 [转换为原生镜像](https://springdoc.cn/spring-boot/native-image.html#native-image.introducing-graalvm-native-images)。

镜像可以通过 [本地构建工具](https://github.com/graalvm/native-build-tools) Gradle/Maven插件或GraalVM提供的 `native-image` 工具来创建。你也可以使用 [native-image Paketo buildpack](https://github.com/paketo-buildpacks/native-image) 来创建原生镜像。

支持以下版本。

| 名称               | 版本   |
| :----------------- | :----- |
| GraalVM Community  | 22.3   |
| Native Build Tools | 0.9.23 |

# 核心特性

## 懒加载

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

## springBoot的初始化自定义逻辑

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

## 外部配置

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

## 多环境支持

通过在`application.properties`文件中配置不同环境的配置文件，例如：

- `application-dev.properties`：开发环境配置。
- `application-prod.properties`：生产环境配置。
  然后在启动时通过`--spring.profiles.active=dev`或`application.yml`中的`spring.profiles.active=dev`指定激活的配置文件。

## 事件

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



## JSON

Spring Boot提供了与三个JSON库的集成,Jackson是首选和默认的库。

- Gson
- Jackson
- JSON-B

Jackson 是一个用于处理 JSON 数据的流行库，广泛应用于 Java 应用程序中。它可以轻松地将 Java 对象转换为 JSON 格式（序列化），以及将 JSON 数据转换为 Java 对象（反序列化）。在 Spring Boot 中，Jackson 通常用于处理 RESTful API 的请求和响应。

### 基本使用

#### 序列化（将 Java 对象转换为 JSON）

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

#### 反序列化（将 JSON 转换为 Java 对象）

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

###  SpringBoot中使用 Jackson

在 Spring Boot 中，Jackson 通常用于处理 RESTful API 的请求和响应。Spring Boot 默认使用 Jackson 作为 JSON 处理库。

#### 创建Rest控制器

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

#### 发送请求并查看响应

启动应用程序后，访问 `http://localhost:8080/api/user`，你将看到以下 JSON 响应：

```json
{
    "name": "John Doe",
    "age": 30
}
```

### 自定义 Jackson 配置

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

### Jackson注解

```java
@JsonPropertyOrder({ "age", "name" }) // 指定 JSON 属性的顺序
@JsonProperty("full_name") // 自定义 JSON 属性名
@JsonIgnore // 忽略这个属性,使其不被序列化或反序列化
@JsonInclude 注解可以指定只包含非空属性    
@JsonSerialize 、@JsonDeserialize //注解可以自定义序列化和反序列化的逻辑。    
```

什么是Spring Boot DevTools？

Spring Boot DevTools是一个开发工具包，旨在提高开发效率。它提供了自动重启、实时加载属性文件、调试等功能。当类路径上的文件发生变化时，DevTools会自动重新启动应用。

安全

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

## 单元测试

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

# 注解

- **@SpringBootApplication**：用于标注主类，集成了`@Configuration`、`@EnableAutoConfiguration`和`@ComponentScan`。
- **@Configuration**：用于定义配置类，等同于XML配置文件。
- **@EnableAutoConfiguration**：启用自动配置。
- **@ComponentScan**：自动扫描并注册组件。
- **@RestController**：用于创建RESTful Web服务的控制器。
- **@RequestMapping**：用于映射HTTP请求到处理方法。



