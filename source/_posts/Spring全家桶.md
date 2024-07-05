

# 基础阶段

## Spring Core

### Spring 框架概述

#### Spring 发展历史

#### Spring 的设计理念和目标

#### Spring的核心组件和模块













1.2. **控制反转（IoC）和依赖注入（DI）**

   - IoC 容器的概念和作用
   - IoC 的实现方式（构造器注入、Setter 注入）
   - 注解方式的依赖注入（@Autowired, @Qualifier, @Resource）

1.3. **Bean 管理**
   - Bean 的定义和作用
   - Bean 的生命周期（初始化、销毁）
   - Bean 作用域（Singleton, Prototype, Request, Session）
   - Bean 的自动装配（Autowiring 的类型）

1.4. **Spring 配置**

   - 基于 XML 的配置
   - 基于注解的配置（@Configuration, @ComponentScan）
   - 基于 Java 的配置（@Bean 方法）

1.5. **Spring Context**

   - ApplicationContext 和 BeanFactory 的区别
   - 使用 ClassPathXmlApplicationContext, AnnotationConfigApplicationContext 等上下文

## Spring AOP（面向切面编程）

2.1. **AOP 概念**
   - 切面（Aspect）、连接点（Joinpoint）、切入点（Pointcut）、通知（Advice）、目标（Target）
   - AOP 的应用场景和优势

2.2. **AOP 实现**
   - 基于 XML 的 AOP 配置
   - 基于注解的 AOP 配置（@Aspect, @Before, @After, @Around 等）
   - 使用 Spring AOP 实现日志记录、事务管理、安全检查等

# 中级阶段

## Spring Data

3.1. **Spring JDBC**
   - JdbcTemplate 的使用和配置
   - 事务管理（Transaction Management）
   - 数据库连接池（DataSource）配置

3.2. **Spring ORM**
   - Hibernate 与 Spring 的集成
   - 配置 LocalSessionFactoryBean
   - JPA（Java Persistence API）基础
   - EntityManagerFactory 和 EntityManager 配置

3.3. **Spring Data JPA**
   - Repository 模式
   - CRUD 操作的实现
   - 自定义查询方法
   - JPQL 和 Native Query

## Spring MVC

4.1. **MVC 概念**
   - 模型（Model）、视图（View）、控制器（Controller）模式
   - DispatcherServlet 和前端控制器模式

4.2. **Spring MVC 配置**
   - XML 和 Java 配置
   - 配置 DispatcherServlet、ViewResolver 等

4.3. **控制器**
   - 创建控制器类
   - 请求映射（@RequestMapping）
   - 表单数据处理（@ModelAttribute）
   - 数据验证和错误处理（@Valid, BindingResult）

4.4. **视图**
   - 视图解析器（ViewResolver）
   - 使用 JSP、Thymeleaf、FreeMarker 等模板引擎

4.5. **静态资源管理**
   - 静态资源处理
   - WebJars 配置和使用

## Spring Boot

5.1. **Spring Boot 概述**
   - Spring Boot 的设计理念和优势
   - 使用 Spring Initializr 创建项目

5.2. **自动配置**
   - Spring Boot 的自动配置原理
   - 自定义自动配置（@EnableAutoConfiguration）

5.3. **常用注解**
   - @SpringBootApplication
   - @ComponentScan, @EntityScan

5.4. **外部配置**
   - application.properties 和 application.yml
   - Profile 管理和配置

5.5. **开发工具**
   - Spring Boot DevTools
   - Spring Boot CLI

# 高级阶段

## Spring Security

6.1. **Spring Security 概述**
   - Spring Security 的基本概念和模块
   - 安全认证和授权的基本流程

6.2. **安全配置**
   - 配置 WebSecurityConfigurerAdapter
   - 用户存储（In-Memory, JDBC, LDAP）

6.3. **认证和授权**
   - 自定义登录页面和注销功能
   - 方法级安全（@Secured, @PreAuthorize, @PostAuthorize）

6.4. **OAuth2 和 JWT**
   - 配置和使用 OAuth2
   - 使用 JWT（JSON Web Token）进行安全认证

## Spring Batch

8.1. **Spring Batch 概述**
   - Spring Batch 的基本概念和应用场景

8.2. **批处理任务**
   - 配置和执行批处理任务
   - Job 和 Step 的配置

8.3. **高级批处理**
   - 分片（Partitioning）
   - 并行处理（Parallel Processing）

