---
title: SpringMvc理论
tag:
- SpringMvc
---

# SpringMVC介绍

## MVC是什么

MVC（Model-View-Controller，模型-视图-控制器）是一种软件架构模式，主要用于构建用户界面应用程序。它将应用程序分为三个核心部分：模型（Model）、视图（View）和控制器（Controller），从而实现关注点分离，使开发和维护更加简便和高效。

### 模型（Model）

模型是应用程序的核心部分，负责处理应用程序的业务逻辑和数据管理。它直接与数据库交互，执行CRUD操作（创建、读取、更新、删除）。模型中的数据通常是纯粹的业务逻辑，没有任何关于用户界面的知识。

### 视图（View）

视图是用户界面部分，负责数据的展示。视图从模型获取数据并将其呈现给用户。视图是静态的，不包含业务逻辑，它只负责显示数据。视图的主要任务是渲染模型的数据到适当的格式，如HTML、JSON、XML等。

### 控制器（Controller）

控制器充当模型和视图之间的中介，处理用户输入并更新模型和视图。它接收用户输入，通过调用模型的方法来处理数据，并选择合适的视图来显示处理后的结果。控制器包含应用程序的流控制逻辑，是用户与应用程序交互的主要渠道。

### MVC的工作流程

1. **用户在视图中执行操作**（例如点击按钮或链接）。
2. **控制器捕捉到用户的输入**，调用相应的模型方法来处理业务逻辑。
3. **模型处理业务逻辑**，更新数据或从数据库中获取数据。
4. **控制器接收到模型返回的数据**，选择合适的视图来呈现这些数据。
5. **视图将数据渲染**并显示给用户。

## MVC设计模式优点

- **关注点分离**：每个组件有明确的职责，使代码更易于理解和维护。
- **可测试性**：模型、视图和控制器可以独立测试，提高代码质量。
- **可复用性**：视图和模型可以独立变化，提高组件的重用性。
- **并行开发**：开发人员可以独立开发模型、视图和控制器，减少开发时间。

## 什么是SpringMVC

SpringMVC是Spring Framework的一部分，是一种基于Java的MVC（Model-View-Controller）框架，主要用于构建Web应用程序。它提供了一套强大的工具和功能，使开发者能够轻松创建和管理Web应用程序的各个组件。

## SpringMVC的优点

1. **与Spring生态系统的无缝集成**：SpringMVC与Spring框架的其他模块（如Spring Security、Spring Data等）紧密集成，提供一致的编程模型。
2. **注解驱动**：大量使用注解（如`@Controller`、`@RequestMapping`、`@GetMapping`等）简化配置和开发。
3. **灵活的视图解析**：支持多种视图技术，开发者可以根据需求选择合适的视图引擎。
4. **强大的数据绑定和验证功能**：提供数据绑定、表单处理和验证功能，简化用户输入处理。
5. **易于测试**：SpringMVC的各个组件可以独立测试，提高了代码的可维护性和可测试性。



# 核心组件

## SpringMVC的核心组件有哪些？

1. **DispatcherServlet**：前端控制器（Front Controller），所有的 HTTP 请求都会先经过它。它负责将请求分发到合适的处理器（Controller）。

2. **Handler Mapping**：将请求映射到相应的处理器（Controller）。它根据请求的 URL、HTTP 方法等信息来确定应该调用哪个处理器。

3. **Handler Adapter**：将请求处理器（Controller）与 `DispatcherServlet` 连接起来。它负责将请求参数转换为控制器方法的参数，并调用相应的方法来处理请求，最终返回一个 `ModelAndView` 对象。

4. **Controller**：处理请求的核心组件。它包含业务逻辑，并返回一个 `ModelAndView` 对象，包含模型数据和视图信息。

5. **ModelAndView**：一个包含模型数据和视图名称的对象。控制器处理完请求后，会返回一个 `ModelAndView` 对象，`DispatcherServlet` 会根据这个对象来渲染视图。

6. **View Resolver**：将逻辑视图名称解析为实际的视图对象（如 JSP、Thymeleaf 模板等）。它根据 `ModelAndView` 中的视图名称来确定具体的视图。

7. **View**：最终呈现给用户的界面。Spring MVC 支持多种视图技术，如 JSP、Thymeleaf、FreeMarker 等。

8. **Model**：用于在控制器和视图之间传递数据的对象。它通常是一个 `Map` 或 `Model` 接口的实现类。

9. **Interceptor**：用于在请求处理的各个阶段执行额外逻辑的组件。它类似于过滤器，但更强大，可以在请求处理的前后执行操作。

## SpringMVC的工作原理

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



# 注解

## 注解原理

注解本质是一个继承了Annotation的特殊接口，其具体实现类是Java运行时生成的动态代理类。我们通过反射获取注解时，返回的是Java运行时生成的动态代理对象。通过代理对象调用自定义注解的方法，会最终调用AnnotationInvocationHandler的invoke方法。该方法会从memberValues这个Map中索引出对应的值。而memberValues的来源是Java常量池。

## SpringMVC常用注解

### 控制器相关注解

- `@Controller`：标识一个类为SpringMVC控制器。

  ```java
  @Controller
  public class MyController {
      // ...
  }
  ```

- `@RestController`：标识一个类为RESTful控制器，相当于同时使用了`@Controller`和`@ResponseBody`。

  ```java
  @RestController
  public class MyRestController {
      // ...
  }
  ```

### 请求映射注解

- `@RequestMapping`：映射HTTP请求到处理方法或类上。可以用在类和方法级别。

  ```java
  @Controller
  @RequestMapping("/home")
  public class HomeController {
      @RequestMapping("/welcome")
      public String welcome() {
          return "welcome";
      }
  }
  ```

- `@GetMapping`：专门用于处理HTTP GET请求。

  ```java
  @GetMapping("/items")
  public String getItems() {
      // ...
  }
  ```

- `@PostMapping`：专门用于处理HTTP POST请求。

  ```java
  @PostMapping("/items")
  public String addItem() {
      // ...
  }
  ```

- `@PutMapping`：专门用于处理HTTP PUT请求。

  ```java
  @PutMapping("/items/{id}")
  public String updateItem(@PathVariable("id") Long id) {
      // ...
  }
  ```

- `@DeleteMapping`：专门用于处理HTTP DELETE请求。

  ```java
  @DeleteMapping("/items/{id}")
  public String deleteItem(@PathVariable("id") Long id) {
      // ...
  }
  ```

### 参数绑定注解

- `@PathVariable`：用于绑定URL中的路径变量到方法参数。

  ```java
  @GetMapping("/items/{id}")
  public String getItem(@PathVariable("id") Long id) {
      // ...
  }
  ```

- `@RequestParam`：用于绑定HTTP请求参数到方法参数。

  ```java
  @GetMapping("/search")
  public String search(@RequestParam("q") String query) {
      // ...
  }
  ```

- `@RequestBody`：用于将HTTP请求体中的内容绑定到方法参数。

  ```java
  @PostMapping("/items")
  public String createItem(@RequestBody Item item) {
      // ...
  }
  ```

### 返回值注解

- `@ResponseBody`：用于将方法返回值直接写入HTTP响应体，常用于AJAX请求。

  ```java
  @GetMapping("/data")
  @ResponseBody
  public Data getData() {
      return new Data();
  }
  ```

### 表单处理和验证注解

- `@ModelAttribute`：用于绑定请求参数到命令对象，并将该对象添加到模型中。

  ```java
  @PostMapping("/register")
  public String register(@ModelAttribute User user) {
      // ...
  }
  ```

- `@Valid`：用于启用JSR-303/JSR-380校验。

  ```java
  @PostMapping("/register")
  public String register(@Valid @ModelAttribute User user, BindingResult result) {
      if (result.hasErrors()) {
          return "registerForm";
      }
      // ...
  }
  ```

# SpringMVC常见问题

## 转发和重定向的区别

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

## SpringMVC和AJAX如何互相调用

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

## 中文乱码如何解决

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

## 如何进行异常处理

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

## 如何实现拦截器

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

## SpringMVC前后台传递对象有哪些，区别是什么

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