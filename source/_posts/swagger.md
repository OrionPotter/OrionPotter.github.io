---
title: SpringBoot整合Swagger
tag:
- java
---



Spring Boot 2.4.8 版本与 Springfox 3.0.0 存在一些兼容性问题。Springfox 3.0.0 更推荐与 Spring Boot 2.6.x 或更高版本一起使用。如果你无法升级 Spring Boot 版本，可以尝试以下解决方案来解决兼容性问题。

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
        return new Docket(DocumentationType.OAS_30)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.example.yourpackage"))
                .paths(PathSelectors.any())
                .build();
    }
}
```

## 标注控制器类

使用 Swagger 注解来标注你的控制器和方法。

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

### @ApiImplicitParam 和 @ApiImplicitParams

`@ApiImplicitParam` 和 `@ApiImplicitParams` 注解用于标注隐式参数，通常用于描述复杂的请求参数。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with implicit params")
    @ApiImplicitParams({
        @ApiImplicitParam(name = "param1", value = "Parameter 1", required = true, dataType = "string", paramType = "query"),
        @ApiImplicitParam(name = "param2", value = "Parameter 2", required = false, dataType = "string", paramType = "query")
    })
    public String getExample(@RequestParam String param1, @RequestParam(required = false) String param2) {
        return "Hello, Swagger! Param1: " + param1 + ", Param2: " + param2;
    }
}
```

## 响应注解

### @ApiResponse 和 @ApiResponses

`@ApiResponse` 和 `@ApiResponses` 注解用于标注方法的响应，提供响应的基本信息。

```java
@RestController
@RequestMapping("/api")
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint with responses")
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

### @ApiModel 和 @ApiModelProperty

`@ApiModel` 和 `@ApiModelProperty` 注解用于标注模型类和属性，提供模型的基本信息。

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
