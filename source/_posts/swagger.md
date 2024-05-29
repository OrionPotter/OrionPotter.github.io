---
title: SpringBoot整合Swagger3
tag:
- java
---

# 编程步骤

## 添加依赖

在 `pom.xml` 文件中添加 Swagger 3 的依赖项。

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-boot-starter</artifactId>
    <version>3.0.0</version>
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
@RestController
@RequestMapping("/api")
@Api(value = "Example Controller", tags = {"Example"})
public class ExampleController {

    @GetMapping("/example")
    @ApiOperation(value = "Get Example", notes = "This is an example endpoint")
    public String getExample() {
        return "Hello, Swagger!";
    }
}
```

## 访问 Swagger UI

启动你的 Spring Boot 应用程序，然后在浏览器中访问 Swagger UI。默认情况下，Swagger UI 可以通过以下 URL 访问：

```http
http://localhost:8080/swagger-ui/
```

你应该会看到一个用户界面，列出了所有的 API 端点，并且可以在界面上进行测试。

