---
title: SpringBoot+JWT整合Swagger
tag:
- java
---

# 什么是 Swagger？

## 历史背景

### Swagger 的起源

- **Swagger 的创建**：Swagger 由 Tony Tam 于 2010 年创建，最初是为了简化 API 文档的生成和维护。
- **开源项目**：Swagger 很快成为一个开源项目，得到了广泛的社区支持和贡献。

### Swagger 的发展

- **Swagger 1.x 和 2.x**：最初的 Swagger 版本（1.x 和 2.x）定义了一种用于描述 RESTful API 的规范，并提供了一套工具，包括 Swagger UI、Swagger Editor 和 Swagger Codegen。
- **Swagger 的普及**：由于其易用性和强大的功能，Swagger 很快成为描述和文档化 API 的事实标准。

### OpenAPI 规范

- **OpenAPI Initiative**：2015 年，Swagger 被 SmartBear Software 收购，并将 Swagger 规范捐赠给 Linux 基金会，成立了 OpenAPI Initiative（OAI）。
- **OpenAPI 3.0**：2017 年，OpenAPI Initiative 发布了 OpenAPI 3.0 规范，这是对 Swagger 2.0 的重大改进，增加了更多功能和灵活性。

## 基本概念

### OpenAPI 规范

- **定义**：OpenAPI 规范（OAS）是一种描述 RESTful API 的标准格式。它允许开发者定义 API 的端点、请求参数、响应格式、安全机制等。
- **格式**：OpenAPI 规范可以使用 JSON 或 YAML 格式编写。

### 主要组件

- **Paths**：定义 API 的端点和操作（如 GET、POST、PUT、DELETE）。
- **Components**：定义可重用的模型、参数、响应等。
- **Security**：定义 API 的安全机制，如 API 密钥、OAuth2、JWT 等。
- **Info**：提供 API 的元数据，如标题、描述、版本等。

### 工具有哪些

- **Swagger UI**：一个交互式的用户界面，用于查看和测试 API。
- **Swagger Editor**：一个在线编辑器，用于编写和测试 OpenAPI 规范文件。
- **Swagger Codegen**：一个工具，用于根据 OpenAPI 规范生成客户端 SDK 和服务器端代码。
- **Swagger Hub**：一个用于协作和管理 API 的平台。

# 为什么使用 Swagger？

- **自动生成文档**：Swagger 可以根据代码自动生成 API 文档，减少手动编写文档的工作量。
- **交互式界面**：Swagger UI 提供了一个用户友好的界面，可以方便地查看和测试 API。
- **提高开发效率**：通过自动生成文档和提供测试界面，Swagger 可以显著提高开发和维护 API 的效率。

# 版本问题

Spring Boot 2.4.8 版本与 Springfox 3.0.0 存在一些兼容性问题。Springfox 3.0.0 更推荐与 Spring Boot 2.6.x 或更高版本一起使用。

**以下解决方案来解决兼容性问题**

方案1：使用 Springfox 3.0.0 并解决兼容性问题

方案2：使用 Spring Boot 2.4.x 兼容的 Swagger 版本（下面采用此方案解决）

方案3：升级 Spring Boot 版本

# 编程步骤

## 添加依赖

在 `pom.xml` 文件中添加 Swagger的依赖项。

```xml
<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.4.8</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
<!-- 省略其他 -->
<dependency>
     <groupId>io.springfox</groupId>
     <artifactId>springfox-swagger2</artifactId>
     <version>2.9.2</version>
</dependency>
<dependency>
     <groupId>io.springfox</groupId>
     <artifactId>springfox-swagger-ui</artifactId>
     <version>2.9.2</version>
</dependency>
```

## 配置 Swagger

创建一个配置类来配置 Swagger

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.example.mp"))
                .paths(PathSelectors.any())
                .build()
                .apiInfo(apiInfo())
                .securitySchemes(Collections.singletonList(apiKey()))
                .securityContexts(Collections.singletonList(securityContext()));
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("IP-Insight")
                .description("IP-Insight API Description")
                .version("1.0.0")
                .build();
    }
	// 添加AWT认证，后续请求都会携带jwt token
    private SecurityScheme apiKey() {
        return new ApiKey("JWT", "Authorization", "header");
    }

    private SecurityContext securityContext() {
        return SecurityContext.builder()
                .securityReferences(defaultAuth())
                .forPaths(PathSelectors.any())
                .build();
    }

    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Collections.singletonList(new SecurityReference("JWT", authorizationScopes));
    }
}
```

## 标注控制器类

使用 Swagger 注解来标注你的控制器和方法。

```java
@RestController
@Api(value = "test Controller", tags = {"test"})
public class TestController {
    @GetMapping("/test")
    @ApiOperation(value = "test Method", tags = {"方法测试"})
    public String test(){
        return "test";
    }
}
```

## 配置安全访问

代码涉及的jwt的认证，要想访问ui必须放行`"/swagger-ui.html**", "/swagger-resources/**", "/v2/api-docs", "/webjars/**`请求

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {


    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .antMatchers("/auth/login", "/auth/register","/swagger-ui.html**", "/swagger-resources/**", "/v2/api-docs", "/webjars/**").permitAll() // 允许匿名访问登录和注册路径
                .anyRequest().authenticated()
                .and()
                //注册过滤器
                .addFilterBefore(new JwtRequestFilter(jwtUtils, userDetailsService), UsernamePasswordAuthenticationFilter.class);
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(jwtUserDetailsService).passwordEncoder(passwordEncoder());
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
}
```

## 访问 Swagger UI

启动你的 Spring Boot 应用程序，然后在浏览器中访问 Swagger UI。默认情况下，Swagger UI 可以通过以下 URL 访问：

```http
http://localhost:8080/swagger-ui/
```

在 Swagger UI 中，你会看到一个 "Authorize" 按钮。点击这个按钮，会弹出一个输入框，要求你输入 JWT Token。用户界面列出了所有的 API 端点，并且可以在界面上进行token获取。

**输入 JWT Token**

在弹出的输入框中，输入你的 JWT Token，格式如下：

```	plaintext
Bearer <your_jwt_token>
例如：
Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMSIsImV4cCI6MTYxNjI1NDQwMCwiaWF0IjoxNjE2MjU0MDAwfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5
```

点击 "Authorize" 按钮，Swagger UI 将携带这个 JWT Token 进行所有后续的 API 请求。

# 注解

## 基本注解

### @Api

`@Api` 注解用于标注一个控制器类，提供该类的基本信息。

```java
@RestController
@Api(value = "Example Controller", tags = {"Example"})
public class ExampleController {
    // ...
}
```

### @ApiOperation

`@ApiOperation` 注解用于标注一个方法，提供该方法的基本信息。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint")
    public String getExample() {
        return "Hello, Swagger!";
    }
}
```

## 参数注解

### @ApiParam

`@ApiParam` 注解用于标注方法参数，提供该参数的基本信息。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example/{id}")
    @ApiOperation(value = "Get Example by ID", notes = "Provide an ID to look up specific example")
    public String getExampleById(
            @ApiParam(value = "ID of the example to retrieve", required = true) 
            @PathVariable String id) {
        return "Hello, Swagger! ID: " + id;
    }
}
```

### @ApiImplicitParam 

`@ApiImplicitParam` 注解用于描述单个隐式参数。它有多个属性，用于详细描述参数的各个方面。

**属性**

- `name`：参数名称。
- `value`：参数描述。
- `required`：参数是否必需，默认为 `false`。
- `dataType`：参数的数据类型，如 `string`、`int` 等。
- `paramType`：参数类型，常见的值有 `query`（查询参数）、`header`（请求头）、`path`（路径参数）、`form`（表单参数）等。
- `example`：参数的示例值。
- `defaultValue`：参数的默认值。

```java
@RestController
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with implicit param")
    @ApiImplicitParam(name = "param1", value = "Parameter 1", required = true, dataType = "string", paramType = "query", example = "exampleValue")
    public String getExample(@RequestParam String param1) {
        return "Hello, Swagger! Param1: " + param1;
    }
}
```

### @ApiImplicitParams

`@ApiImplicitParams` 注解用于描述多个隐式参数。它包含一个 `value` 属性，该属性是一个 `@ApiImplicitParam` 注解的数组。

**属性**:`value`：一个 `@ApiImplicitParam` 注解的数组。

```java
@RestController
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with multiple implicit params")
    @ApiImplicitParams({
        @ApiImplicitParam(name = "param1", value = "Parameter 1", required = true, dataType = "string", paramType = "query", example = "exampleValue1"),
        @ApiImplicitParam(name = "param2", value = "Parameter 2", required = false, dataType = "string", paramType = "query", example = "exampleValue2")
    })
    public String getExample(@RequestParam String param1, @RequestParam(required = false) String param2) {
        return "Hello, Swagger! Param1: " + param1 + ", Param2: " + param2;
    }
}
```



## 响应注解

### @ApiResponse

`@ApiResponse` 注解用于描述单个响应信息。它有多个属性，用于详细描述响应的各个方面。

**属性**

- `code`：响应的 HTTP 状态码。
- `message`：响应的描述信息。
- `response`：响应的类类型，用于描述响应的具体数据结构。
- `responseContainer`：响应的容器类型，如 `List` 或 `Map`。
- `examples`：响应的示例值。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with a single response")
    @ApiResponse(code = 200, message = "Successfully retrieved example")
    public String getExample() {
        return "Hello, Swagger!";
    }
}
```

### @ApiResponses

`@ApiResponses` 注解用于描述多个响应信息。它包含一个 `value` 属性，该属性是一个 `@ApiResponse` 注解的数组。

**属性**:`value`：一个 `@ApiResponse` 注解的数组。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with multiple responses")
    @ApiResponses(value = {
        @ApiResponse(code = 200, message = "Successfully retrieved example"),
        @ApiResponse(code = 401, message = "You are not authorized to view the resource"),
        @ApiResponse(code = 403, message = "Accessing the resource you were trying to reach is forbidden"),
        @ApiResponse(code = 404, message = "The resource you were trying to reach is not found")
    })
    public String getExample() {
        return "Hello, Swagger!";
    }
}
```



## 模型注解

### @ApiModel

`@ApiModel` 注解用于描述模型类。它有多个属性，用于详细描述模型类的各个方面。

**属性**

- `value`：模型类的名称。如果未指定，默认使用类名。
- `description`：模型类的描述信息。
- `parent`：模型类的父类。
- `discriminator`：用于多态模型的区分字段。
- `subTypes`：模型类的子类型。
- `reference`：引用的外部模型。

```java
@ApiModel(description = "Details about the user")
public class User {
    // ...
}
```

### @ApiModelProperty

`@ApiModelProperty` 注解用于描述模型类的属性。它有多个属性，用于详细描述属性的各个方面。

**属性**

- `value`：属性的描述信息。
- `name`：属性的名称。如果未指定，默认使用字段名。
- `required`：属性是否必需，默认为 `false`。
- `position`：属性在模型中的位置。
- `hidden`：是否在 Swagger 文档中隐藏该属性，默认为 `false`。
- `example`：属性的示例值。
- `dataType`：属性的数据类型。
- `allowableValues`：属性的允许值。
- `access`：属性的访问级别（如 `public`、`private`）。
- `notes`：属性的备注信息。
- `readOnly`：属性是否为只读，默认为 `false`。

```java
@ApiModel(description = "Details about the user")
public class User {

    @ApiModelProperty(notes = "The unique ID of the user")
    private String id;

    @ApiModelProperty(notes = "The name of the user")
    private String name;

    // Constructor, getters and setters
    public User(String id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters and Setters
}
```

## 其他注解

### @ApiIgnore

`@ApiIgnore` 注解用于忽略某个方法或参数，使其不在 Swagger 文档中显示。

```java
import io.swagger.annotations.ApiIgnore;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/ignore")
    @ApiIgnore
    public String ignoreEndpoint() {
        return "This endpoint is ignored in Swagger documentation";
    }
}

```

# 安全配置

## 配置JWT

- `apiKey()` 方法定义了一个 API 密钥类型的安全方案，名称为 "JWT"，在请求头中传递。
- `securityContext()` 方法应用了安全方案到所有的 API 路径。
- `defaultAuth()` 方法定义了全局的授权范围。

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.example.yourpackage"))
                .paths(PathSelectors.any())
                .build()
                .apiInfo(apiInfo())
                .securitySchemes(Collections.singletonList(apiKey()))
                .securityContexts(Collections.singletonList(securityContext()));
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Your API Title")
                .description("Your API Description")
                .version("1.0.0")
                .build();
    }

    private ApiKey apiKey() {
        return new ApiKey("JWT", "Authorization", "header");
    }

    private SecurityContext securityContext() {
        return SecurityContext.builder()
                .securityReferences(defaultAuth())
                .forPaths(PathSelectors.any())
                .build();
    }

    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("global", "accessEverything");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Collections.singletonList(new SecurityReference("JWT", authorizationScopes));
    }
}
```

## 配置OAuth

- `securityScheme()` 方法定义了一个 OAuth2 类型的安全方案，名称为 "oauth2schema"。
- `authorizationScope()` 方法定义了授权范围。
- `grantType()` 方法定义了授权类型，这里使用的是资源所有者密码凭证授权。
- `securityContext()` 方法应用了安全方案到所有的 API 路径。
- `defaultAuth()` 方法定义了全局的授权范围。
- `security()` 方法配置了 Swagger UI 的安全设置，包括客户端 ID 和客户端密钥。

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.example.yourpackage"))
                .paths(PathSelectors.any())
                .build()
                .apiInfo(apiInfo())
                .securitySchemes(Collections.singletonList(securityScheme()))
                .securityContexts(Collections.singletonList(securityContext()));
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("Your API Title")
                .description("Your API Description")
                .version("1.0.0")
                .build();
    }

    private SecurityScheme securityScheme() {
        return new OAuth("oauth2schema", Arrays.asList(authorizationScope()), Arrays.asList(grantType()));
    }

    private AuthorizationScope authorizationScope() {
        return new AuthorizationScope("read", "for read operations");
    }

    private GrantType grantType() {
        return new ResourceOwnerPasswordCredentialsGrant("http://localhost:8080/oauth/token");
    }

    private SecurityContext securityContext() {
        return SecurityContext.builder()
                .securityReferences(defaultAuth())
                .forPaths(PathSelectors.any())
                .build();
    }

    private List<SecurityReference> defaultAuth() {
        AuthorizationScope authorizationScope = new AuthorizationScope("read", "for read operations");
        AuthorizationScope[] authorizationScopes = new AuthorizationScope[1];
        authorizationScopes[0] = authorizationScope;
        return Collections.singletonList(new SecurityReference("oauth2schema", authorizationScopes));
    }

    @Bean
    public SecurityConfiguration security() {
        return SecurityConfigurationBuilder.builder()
                .clientId("exampleClientId")
                .clientSecret("exampleClientSecret")
                .scopeSeparator(" ")
                .useBasicAuthenticationWithAccessCodeGrant(true)
                .build();
    }
}
```

