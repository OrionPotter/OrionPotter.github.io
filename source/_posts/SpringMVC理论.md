---
title: SpringMvc理论
tag:
- MVC
---

# SpringMVC介绍

## MVC是什么

MVC（Model-View-Controller，模型-视图-控制器）是一种软件架构模式，主要用于构建用户界面应用程序。它将应用程序分为三个核心部分：模型（Model）、视图（View）和控制器（Controller），从而实现关注点分离，使开发和维护更加简便和高效。

### MVC组件

模型（Model）

模型是应用程序的核心部分，负责处理应用程序的业务逻辑和数据管理。它直接与数据库交互，执行CRUD操作（创建、读取、更新、删除）。模型中的数据通常是纯粹的业务逻辑，没有任何关于用户界面的知识。

视图（View）

视图是用户界面部分，负责数据的展示。视图从模型获取数据并将其呈现给用户。视图是静态的，不包含业务逻辑，它只负责显示数据。视图的主要任务是渲染模型的数据到适当的格式，如HTML、JSON、XML等。

控制器（Controller）

控制器充当模型和视图之间的中介，处理用户输入并更新模型和视图。它接收用户输入，通过调用模型的方法来处理数据，并选择合适的视图来显示处理后的结果。控制器包含应用程序的流控制逻辑，是用户与应用程序交互的主要渠道。

### MVC的工作流程

1. **用户在视图中执行操作**（例如点击按钮或链接）。
2. **控制器捕捉到用户的输入**，调用相应的模型方法来处理业务逻辑。
3. **模型处理业务逻辑**，更新数据或从数据库中获取数据。
4. **控制器接收到模型返回的数据**，选择合适的视图来呈现这些数据。
5. **视图将数据渲染**并显示给用户。

### MVC设计模式优点

- **关注点分离**：每个组件有明确的职责，使代码更易于理解和维护。
- **可测试性**：模型、视图和控制器可以独立测试，提高代码质量。
- **可复用性**：视图和模型可以独立变化，提高组件的重用性。
- **并行开发**：开发人员可以独立开发模型、视图和控制器，减少开发时间。

## 什么是SpringMVC

SpringMVC是Spring Framework的一部分，是一种基于Java的MVC（Model-View-Controller）框架，主要用于构建Web应用程序。它提供了一套强大的工具和功能，使开发者能够轻松创建和管理Web应用程序的各个组件。

### 优点

1. **与Spring生态系统的无缝集成**：SpringMVC与Spring框架的其他模块（如Spring Security、Spring Data等）紧密集成，提供一致的编程模型。
2. **注解驱动**：大量使用注解（如`@Controller`、`@RequestMapping`、`@GetMapping`等）简化配置和开发。
3. **灵活的视图解析**：支持多种视图技术，开发者可以根据需求选择合适的视图引擎。
4. **强大的数据绑定和验证功能**：提供数据绑定、表单处理和验证功能，简化用户输入处理。
5. **易于测试**：SpringMVC的各个组件可以独立测试，提高了代码的可维护性和可测试性。



# 核心组件

## 核心组件

1. **DispatcherServlet**：前端控制器（Front Controller），所有的 HTTP 请求都会先经过它。它负责将请求分发到合适的处理器（Controller）。

2. **Handler Mapping**：将请求映射到相应的处理器（Controller）。它根据请求的 URL、HTTP 方法等信息来确定应该调用哪个处理器。

3. **Handler Adapter**：将请求处理器（Controller）与 `DispatcherServlet` 连接起来。它负责将请求参数转换为控制器方法的参数，并调用相应的方法来处理请求，最终返回一个 `ModelAndView` 对象。

4. **Controller**：处理请求的核心组件。它包含业务逻辑，并返回一个 `ModelAndView` 对象，包含模型数据和视图信息。

5. **ModelAndView**：一个包含模型数据和视图名称的对象。控制器处理完请求后，会返回一个 `ModelAndView` 对象，`DispatcherServlet` 会根据这个对象来渲染视图。

6. **View Resolver**：将逻辑视图名称解析为实际的视图对象（如 JSP、Thymeleaf 模板等）。它根据 `ModelAndView` 中的视图名称来确定具体的视图。

7. **View**：最终呈现给用户的界面。Spring MVC 支持多种视图技术，如 JSP、Thymeleaf、FreeMarker 等。

8. **Model**：用于在控制器和视图之间传递数据的对象。它通常是一个 `Map` 或 `Model` 接口的实现类。

9. **Interceptor**：用于在请求处理的各个阶段执行额外逻辑的组件。它类似于过滤器，但更强大，可以在请求处理的前后执行操作。

## 工作原理

1.**客户端请求**

客户端发送一个 HTTP 请求到服务器，例如：

```http
GET /hello HTTP/1.1
Host: localhost:8080
```

2.**请求到达** `DispatcherServlet`

所有请求首先到达 Spring 的前端控制器 `DispatcherServlet`。`DispatcherServlet` 是 Spring MVC 的核心组件，负责将请求分发到适当的处理器。

3.**处理器映射（Handler Mapping）**

`DispatcherServlet` 使用处理器映射器（Handler Mapping）查找与请求 URL 对应的处理器（Controller）

```java
@RequestMapping("/hello")
public String hello() {
    return "hello";
}
```

处理器映射器会查找带有 `@RequestMapping` 注解的方法，并确定哪个方法应该处理当前请求。

4.**处理器适配器（Handler Adapter）**

`DispatcherServlet` 使用处理器适配器（Handler Adapter）调用找到的处理器方法。处理器适配器负责将请求参数转换为方法参数，并调用处理器方法。

5.**处理器方法执行**

处理器方法执行业务逻辑，并返回一个模型和视图（ModelAndView）对象。

```java
@RequestMapping("/hello")
public ModelAndView hello() {
    ModelAndView modelAndView = new ModelAndView();
    modelAndView.setViewName("hello");
    modelAndView.addObject("message", "Hello, World!");
    return modelAndView;
}
```

6.**视图解析（View Resolver）**

`DispatcherServlet` 使用视图解析器（View Resolver）解析视图名称，并生成视图对象。

```java
@Bean
public InternalResourceViewResolver viewResolver() {
    InternalResourceViewResolver resolver = new InternalResourceViewResolver();
    resolver.setPrefix("/WEB-INF/views/");
    resolver.setSuffix(".jsp");
    return resolver;
}
```

视图解析器将视图名称 `hello` 解析为 `/WEB-INF/views/hello.jsp`。

7.**视图渲染**

视图对象渲染模型数据，并生成最终的 HTML 响应。

```jsp
<!-- /WEB-INF/views/hello.jsp -->
<html>
<body>
    <h1>${message}</h1>
</body>
</html>
```

8.**响应返回客户端**

`DispatcherServlet` 将生成的响应返回给客户端。

```http
HTTP/1.1 200 OK
Content-Type: text/html;charset=UTF-8

<html>
<body>
    <h1>Hello, World!</h1>
</body>
</html>
```

## 示例代码

下面是一个简单的SpringMVC应用程序示例：

### 配置类（Java Config）

```java
@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public InternalResourceViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }
}
```

### 控制器类

```java
@Controller
public class HelloController {

    @RequestMapping("/hello")
    public ModelAndView hello() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("hello");
        modelAndView.addObject("message", "Hello, World!");
        return modelAndView;
    }
}
```

### 视图（JSP）

```jsp
<!-- /WEB-INF/views/hello.jsp -->
<html>
<body>
    <h1>${message}</h1>
</body>
</html>
```



# 功能

## 转发和重定向

### 转发（Forward）

- **定义**：在服务器内部，服务器将请求转发到另一个资源（如JSP、Servlet）进行处理，浏览器地址栏不发生变化。

- **应用场景**：常用于服务器内部跳转，不需要客户端知道URL变化的情况。

- 实现：使用RequestDispatcher的forward方法。

  ```java
  request.getRequestDispatcher("/targetPage").forward(request, response);
  ```

### 重定向（Redirect）

- **定义**：服务器向客户端发送一个状态码（通常是302），指示客户端去访问另一个URL，浏览器地址栏会更新为新的URL。

- **应用场景**：常用于需要客户端知道URL变化的情况，如登录后跳转到主页。

- 实现：使用HttpServletResponse的sendRedirect方法。

  ```java
  response.sendRedirect("/targetPage");
  ```

## 前后端调用

1. **前端AJAX请求**：

   ```js
   $.ajax({
       type: "POST",
       url: "/yourController/yourMethod",
       data: JSON.stringify(yourData),
       contentType: "application/json",
       success: function(response) {
           console.log(response);
       }
   });
   ```

2. **后端SpringMVC处理AJAX请求**：

   ```java
   @RestController
   @RequestMapping("/yourController")
   public class YourController {
       @PostMapping("/yourMethod")
       public ResponseEntity<String> handleAjaxRequest(@RequestBody YourDataType yourData) {
           // 处理数据
           return ResponseEntity.ok("Success");
       }
   }
   ```

## 中文乱码

1. **配置SpringMVC**：在配置类或XML中添加字符编码过滤器。

   ```java
   @Configuration
   public class WebConfig implements WebMvcConfigurer {
       @Bean
       public FilterRegistrationBean<CharacterEncodingFilter> characterEncodingFilter() {
           CharacterEncodingFilter filter = new CharacterEncodingFilter();
           filter.setEncoding("UTF-8");
           filter.setForceEncoding(true);
           FilterRegistrationBean<CharacterEncodingFilter> registrationBean = new FilterRegistrationBean<>(filter);
           registrationBean.addUrlPatterns("/*");
           return registrationBean;
       }
   }
   ```

2. **设置请求和响应的编码**：

   ```java
   @GetMapping("/example")
   public ResponseEntity<String> example(HttpServletRequest request, HttpServletResponse response) {
       request.setCharacterEncoding("UTF-8");
       response.setCharacterEncoding("UTF-8");
       return ResponseEntity.ok("中文内容");
   }
   ```

## 文件上传

**`@RequestParam("file") MultipartFile file`**：使用 `@RequestParam` 注解获取上传的文件，`MultipartFile` 是 Spring 提供的文件上传类型，可以包含上传文件的内容。

```java
@Controller
public class FileUploadController {

    // 显示上传文件的表单页面
    @GetMapping("/uploadForm")
    public String uploadForm() {
        return "uploadForm";
    }

    // 处理文件上传
    @PostMapping("/upload")
    public String uploadFile(@RequestParam("file") MultipartFile file,
                             RedirectAttributes redirectAttributes) {

        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "请选择一个文件上传");
            return "redirect:/uploadForm";
        }

        try {
            // 保存文件到服务器本地，这里假设保存到 /tmp 目录下
            String uploadDir = "/tmp/";
            String filePath = uploadDir + file.getOriginalFilename();
            File dest = new File(filePath);
            file.transferTo(dest);

            redirectAttributes.addFlashAttribute("message",
                    "成功上传 '" + file.getOriginalFilename() + "'");

        } catch (IOException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("message",
                    "上传 '" + file.getOriginalFilename() + "' 失败，请重试");
        }

        return "redirect:/uploadForm";
    }
}
```

## 异常处理

1. **使用**`@ExceptionHandler`：

   ```java
   @ControllerAdvice
   public class GlobalExceptionHandler {
       @ExceptionHandler(Exception.class)
       public ResponseEntity<String> handleException(Exception e) {
           return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error: " + e.getMessage());
       }
   }
   ```

2. **自定义异常和处理器**：

   ```java
   @ResponseStatus(HttpStatus.NOT_FOUND)
   public class ResourceNotFoundException extends RuntimeException {
       public ResourceNotFoundException(String message) {
           super(message);
       }
   }
   ```

   ```java
   @ControllerAdvice
   public class GlobalExceptionHandler {
       @ExceptionHandler(ResourceNotFoundException.class)
       public ResponseEntity<String> handleResourceNotFound(ResourceNotFoundException e) {
           return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
       }
   }
   ```

## 拦截器

1. **创建拦截器**：

   ```java
   public class MyInterceptor implements HandlerInterceptor {
       @Override
       public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
           // 前置处理
           return true; // 返回true继续处理，返回false中止处理
       }
   
       @Override
       public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
           // 后置处理
       }
   
       @Override
       public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
           // 完成后处理
       }
   }
   ```

2. **注册拦截器**：

   ```java
   @Configuration
   public class WebConfig implements WebMvcConfigurer {
       @Override
       public void addInterceptors(InterceptorRegistry registry) {
           registry.addInterceptor(new MyInterceptor()).addPathPatterns("/**");
       }
   }
   ```

## 数据传递

1. **Model**：

   - **用法**：用于将数据添加到模型中，供视图渲染时使用。

   - 常见方法：

     ```java
     @Controller
     public class MyController {
         @RequestMapping("/example")
         public String example(Model model) {
             model.addAttribute("attributeName", attributeValue);
             return "viewName";
         }
     }
     ```

   - **特点**：主要用于在控制器和视图之间传递数据，适用于返回视图页面的场景。

2. **ModelAndView**：

   - **用法**：既可以传递模型数据，又可以指定视图名称。

   - 常见方法：

     ```java
     @Controller
     public class MyController {
         @RequestMapping("/example")
         public ModelAndView example() {
             ModelAndView mav = new ModelAndView("viewName");
             mav.addObject("attributeName", attributeValue);
             return mav;
         }
     }
     ```

   - **特点**：封装了模型数据和视图信息，适用于需要灵活指定视图和数据的情况。

3. **@ModelAttribute**：

   - **用法**：可以用于方法参数，表示从请求参数中绑定对象；也可以用于方法上，表示在每个请求处理前都会调用，用于预处理数据。

   - 常见方法：

     ```java
     @Controller
     public class MyController {
         @RequestMapping("/example")
         public String example(@ModelAttribute("attributeName") MyModel model) {
             // 使用model对象
             return "viewName";
         }
     
         @ModelAttribute
         public void addAttributes(Model model) {
             model.addAttribute("commonAttribute", commonValue);
         }
     }
     ```

   - **特点**：用于自动绑定请求参数到对象，并可以在每次请求前设置预处理数据。

4. **@RequestBody**和**@ResponseBody**：

   - **用法**：`@RequestBody`用于将请求体中的数据绑定到方法参数上，常用于处理JSON或XML格式的数据；`@ResponseBody`用于将方法返回值作为响应体返回，常用于返回JSON或XML数据。

   - 常见方法：

     ```java
     @Controller
     public class MyController {
         @RequestMapping(value = "/example", method = RequestMethod.POST)
         public @ResponseBody Response example(@RequestBody Request request) {
             // 处理request对象并返回response对象
             return new Response();
         }
     }
     ```

   - **特点**：主要用于RESTful风格的接口中，便于处理和返回JSON或XML数据。

5. **Session和Request作用域对象**：

   - **用法**：可以通过`@SessionAttributes`注解声明某些模型属性存储到会话中，或者直接操作`HttpSession`对象；通过`HttpServletRequest`对象直接操作请求作用域数据。

   - 常见方法：

     ```java
     @Controller
     @SessionAttributes("sessionAttributeName")
     public class MyController {
         @RequestMapping("/example")
         public String example(HttpSession session) {
             session.setAttribute("sessionAttribute", value);
             return "viewName";
         }
     }
     ```

   - **特点**：适用于需要跨请求共享数据的场景，比如用户登录信息。

每种对象传递方式都有其特定的使用场景和特点，Model和ModelAndView适用于返回视图的传统Web应用，@RequestBody和@ResponseBody则更适合RESTful API的开发。

## 跨域问题

### 什么是跨域请求

跨域请求（Cross-Origin Request）指的是浏览器从一个域（域名、协议、端口）向另一个域发送的请求。由于安全原因，浏览器默认不允许从一个域向另一个域发起Ajax请求。这种限制被称为同源策略（Same-Origin Policy）。

### 同源策略的限制

同源策略是浏览器的一种安全机制，用于防止不同源的恶意网站读取本域的敏感数据。两个URL若具有相同的协议、域名和端口号，则被认为是同源的。否则，即使它们只是在端口号上有所不同，也会被认为是跨域的。

### 跨域资源共享（CORS）

跨域资源共享（CORS, Cross-Origin Resource Sharing）是一种机制，它使用额外的HTTP头来告诉浏览器允许Web应用运行在一个源上，可以访问另一个源的资源。CORS允许服务器控制哪些资源允许跨域访问，以及在访问时可以使用哪些HTTP方法。

### @CrossOrigin注解

Spring提供了`@CrossOrigin`注解来简化跨域请求的配置。`@CrossOrigin`注解可以应用在控制器类或方法上，用于启用CORS。

```java
@RestController
@RequestMapping("/api")
//该控制器中的所有请求都允许从http://example.com域进行跨域访问。
@CrossOrigin(origins = "http://example.com")
public class MyController {
	//用于控制器方法上，仅允许对/greeting方法的跨域访问
    @CrossOrigin(
        origins = "http://example.com",
        methods = {RequestMethod.GET, RequestMethod.POST},
        allowedHeaders = {"header1", "header2"},
        allowCredentials = "true",
        maxAge = 3600)
    @RequestMapping("/greeting")
    public String greeting() {
        return "Hello World";
    }
}
```

**origins**：指定允许的域，可以是多个域名的数组。

**methods**：指定允许的HTTP方法，如GET、POST、PUT、DELETE等。

**allowedHeaders**：指定允许的HTTP头。

**allowCredentials**：是否允许发送Cookie。

**maxAge**：指定浏览器在发起预检请求（pre-flight request）后，缓存预检结果的时间（以秒为单位）。

全局CORS配置

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://example.com")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("header1", "header2")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

# 注解

| 类别           | 注解                | 描述                                                         |
| -------------- | ------------------- | ------------------------------------------------------------ |
| 控制器相关     | `@Controller`       | 标识一个类为 SpringMVC 控制器。                              |
|                | `@RestController`   | 标识一个类为 RESTful 控制器，相当于同时使用了 `@Controller` 和 `@ResponseBody`。 |
| 请求映射       | `@RequestMapping`   | 映射 HTTP 请求到处理方法或类上。可以在类或方法级别使用。     |
|                | `@GetMapping`       | 处理 HTTP GET 请求。                                         |
|                | `@PostMapping`      | 处理 HTTP POST 请求。                                        |
|                | `@PutMapping`       | 处理 HTTP PUT 请求。                                         |
|                | `@DeleteMapping`    | 处理 HTTP DELETE 请求。                                      |
| 参数绑定       | `@PathVariable`     | 将 URI 模板变量绑定到方法参数上。                            |
|                | `@RequestParam`     | 将 HTTP 请求参数绑定到方法参数上。                           |
|                | `@RequestBody`      | 将 HTTP 请求体内容绑定到方法参数上。                         |
| 返回值处理     | `@ResponseBody`     | 将方法返回值直接写入 HTTP 响应体，常用于 AJAX 请求。         |
| 表单处理和验证 | `@ModelAttribute`   | 用于绑定请求参数到命令对象，并将该对象添加到模型中。         |
|                | `@Valid`            | 启用 JSR-303/JSR-380 校验，通常与 `@ModelAttribute` 结合使用。 |
| 异常处理       | `@ExceptionHandler` | 标识一个方法用于处理控制器中抛出的异常。                     |
| 拦截器         | `@Interceptor`      | 标识一个类为拦截器，在处理请求前后执行预处理和后处理任务。   |
| 页面跳转       | `@RequestMapping`   | 在控制器方法上使用，用于指定页面跳转或重定向的目标地址。     |
| 参数校验       | `@Validated`        | 类级别注解，用于开启参数校验功能，配合方法参数上的校验注解使用。 |
| 异步请求处理   | `@Async`            | 标识一个方法为异步处理方法，可以在方法返回一个 `Future` 或 `CompletionStage` 对象。 |
| 跨域请求处理   | `@CrossOrigin`      | 标识一个控制器类或方法允许处理跨域请求。                     |
| 数据绑定       | `@InitBinder`       | 用于自定义数据绑定初始化器，对请求参数进行格式化和验证，通常与 `WebDataBinder` 结合使用。 |

