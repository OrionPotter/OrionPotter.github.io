---
title: 基于SpringBoot+SpringSecurity+JWT认证实践
tag:
- java
---

# 认证流程原理

## 跨域认证的问题

互联网服务离不开用户认证。一般流程是下面这样。

> 1、用户向服务器发送用户名和密码。
>
> 2、服务器验证通过后，在当前对话（session）里面保存相关数据，比如用户角色、登录时间等等。
>
> 3、服务器向用户返回一个 session_id，写入用户的 Cookie。
>
> 4、用户随后的每一次请求，都会通过 Cookie，将 session_id 传回服务器。
>
> 5、服务器收到 session_id，找到前期保存的数据，由此得知用户的身份。

这种模式的问题在于，扩展性（scaling）不好。单机当然没有问题，如果是服务器集群，或者是跨域的服务导向架构，就要求 session 数据共享，每台服务器都能够读取 session。

举例来说，A 网站和 B 网站是同一家公司的关联服务。现在要求，用户只要在其中一个网站登录，再访问另一个网站就会自动登录，请问怎么实现？

一种解决方案是 session 数据持久化，写入数据库或别的持久层。各种服务收到请求后，都向持久层请求数据。这种方案的优点是架构清晰，缺点是工程量比较大。另外，持久层万一挂了，就会单点失败。

另一种方案是服务器索性不保存 session 数据了，所有数据都保存在客户端，每次请求都发回服务器。JWT 就是这种方案的一个代表。

## JWT (JSON Web Token)

JWT是一种用于在各方之间作为JSON对象安全传输信息的紧凑、URL安全的令牌。它由三部分组成：

- **Header**：包含令牌类型（通常为JWT）和签名算法（例如HMAC SHA256）。
- **Payload**：包含声明（claims），即传输的数据。常见的声明包括：用户ID、用户名、过期时间等。
- **Signature**：用于验证令牌的真实性。它是由Header和Payload通过签名算法和密钥生成的。

```typescript
Header.Payload.Signature
```

### Header

Header 部分是一个 JSON 对象，描述 JWT 的元数据，通常是下面的样子。

> ```javascript
> {
>   "alg": "HS256",
>   "typ": "JWT"
> }
> ```

上面代码中，`alg`属性表示签名的算法（algorithm），默认是 HMAC SHA256（写成 HS256）；`typ`属性表示这个令牌（token）的类型（type），JWT 令牌统一写为`JWT`。

最后，将上面的 JSON 对象使用 Base64URL 算法（详见后文）转成字符串。

### Payload

Payload 部分也是一个 JSON 对象，用来存放实际需要传递的数据。JWT 规定了7个官方字段，供选用。

> - iss (issuer)：签发人
> - exp (expiration time)：过期时间
> - sub (subject)：主题
> - aud (audience)：受众
> - nbf (Not Before)：生效时间
> - iat (Issued At)：签发时间
> - jti (JWT ID)：编号

除了官方字段，你还可以在这个部分定义私有字段，下面就是一个例子。

> ```javascript
> {
>   "sub": "1234567890",
>   "name": "John Doe",
>   "admin": true
> }
> ```

注意，JWT 默认是不加密的，任何人都可以读到，所以不要把秘密信息放在这个部分。

这个 JSON 对象也要使用 Base64URL 算法转成字符串。

### Signature

Signature 部分是对前两部分的签名，防止数据篡改。

首先，需要指定一个密钥（secret）。这个密钥只有服务器才知道，不能泄露给用户。然后，使用 Header 里面指定的签名算法（默认是 HMAC SHA256），按照下面的公式产生签名。

> ```javascript
> HMACSHA256(
>   base64UrlEncode(header) + "." +
>   base64UrlEncode(payload),
>   secret)
> ```

算出签名以后，把 Header、Payload、Signature 三个部分拼成一个字符串，每个部分之间用"点"（`.`）分隔，就可以返回给用户。

## JWT 的使用方式

客户端收到服务器返回的 JWT，可以储存在 Cookie 里面，也可以储存在 localStorage。

此后，客户端每次与服务器通信，都要带上这个 JWT。你可以把它放在 Cookie 里面自动发送，但是这样不能跨域，所以更好的做法是放在 HTTP 请求的头信息`Authorization`字段里面。

> ```javascript
> Authorization: Bearer <token>
> ```

另一种做法是，跨域的时候，JWT 就放在 POST 请求的数据体里面。

## 认证流程

1. **用户登录**：用户提交用户名和密码。
2. **认证服务器验证**：服务器验证用户信息，成功后生成JWT令牌。
3. **返回令牌**：服务器将JWT令牌返回给客户端。
4. **客户端存储令牌**：客户端存储令牌（通常在本地存储或Cookie中）。
5. **请求资源**：客户端在每次请求资源时，将JWT令牌放入HTTP请求头中。
6. **服务器验证令牌**：服务器验证JWT令牌的有效性，若有效则返回请求的资源。

# 编程步骤

## 创建SpringBoot项目

使用Spring Initializr创建一个Spring Boot项目，选择以下依赖：

- Spring Web
- Spring Security
- Spring Boot DevTools
- JWT (可以通过Maven或Gradle添加依赖)

## 添加JWT依赖

在`pom.xml`中添加JWT依赖：

```xml
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt</artifactId>
    <version>0.9.1</version>
</dependency>
```

## 创建Security配置类

创建一个配置类来配置Spring Security：

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
        http.csrf().disable() //禁用CSRF保护（对于无状态的REST API来说，CSRF保护通常是多余的）。
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS) //配置会话管理策略为无状态（STATELESS）
                .and()
                .authorizeRequests()
                .antMatchers("/auth/login", "/auth/register").permitAll() // 允许匿名访问登录和注册路径
                .anyRequest().authenticated()
                .and()
            	//注册JWT过滤器，确保在每次请求时验证JWT令牌
                .addFilterBefore(new JwtRequestFilter(jwtUtils, userDetailsService), UsernamePasswordAuthenticationFilter.class);

    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(jwtUserDetailsService).passwordEncoder(passwordEncoder());
    }
	
    // 配置用户认证服务和密码编码器
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

## 创建JWT工具类

创建一个JWT工具类，用于生成和验证JWT令牌：

```java
@Component
@Slf4j
public class JwtUtils {
    @Value("${jwt.secret}")
    private String secret;
    @Value("${jwt.expiration}")
    private Long expiration;


    // 生成JWT令牌
    @CacheResult(cacheKey = "#this.getCacheKey(#username)",expireTime = 1000 * 60 * 60 * 10)
    public String generateToken(String username) {
        String token = Jwts.builder()
                .setSubject(username)
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))
                .signWith(SignatureAlgorithm.HS256, secret)
                .compact();
        return token;
    }

    public String getCacheKey(String username){
        return "token:"+username;
    }

    // 提取声明（claims）
    public Claims extractClaims(String token) {
        try {
            log.info("Extracting claims from Token: {}", token); // 输出接收到的令牌
            return Jwts.parser()
                    .setSigningKey(secret)
                    .parseClaimsJws(token)
                    .getBody();
        } catch (SignatureException e) {
            log.error("Invalid JWT signature: {}", e.getMessage());
            return null;
        } catch (Exception e) {
            log.error("Error extracting claims: {}", e.getMessage());
            return null;
        }
    }

    // 验证JWT令牌
    public boolean validateToken(String token, String username) {
        Claims claims = extractClaims(token);
        if (claims == null) {
            return false;
        }
        String tokenUsername = claims.getSubject();
        boolean isTokenExpired = claims.getExpiration().before(new Date());
        boolean isValid = username.equals(tokenUsername) && !isTokenExpired;
        if (!isValid) {
            log.warn("Token validation failed. Username: {}, Token Username: {}, Is Token Expired: {}", username, tokenUsername, isTokenExpired);
        }
        return isValid;
    }

}
```

## 创建用户认证服务

创建一个用户认证服务，用于加载用户信息：

```java
@Service
public class JwtUserDetailsService implements UserDetailsService {
    @Autowired
    UserService userService;

    // 根据用户名加载用户
    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        LambdaQueryWrapper<User> lambdaQueryWrapper = new LambdaQueryWrapper();
        LambdaQueryWrapper<User> queryWrapper = lambdaQueryWrapper
                .eq(User::getUsername, username);

        User user = userService.getOne(queryWrapper);
        if (user == null) {
            throw new UsernameNotFoundException("User not found");
        }
        return new JwtUserDetails(user); // user是你自定义的UserDetails实现类
    }
}
```

## 创建认证控制器

创建一个控制器来处理用户登录和生成JWT令牌：

```java
@RestController
@RequestMapping("/auth")
@Slf4j
public class LoginController {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private JwtUserDetailsService jwtUserDetailsService;

    // 处理用户登录请求
    @PostMapping("/login")
    public String createToken(@RequestBody User authRequest) throws Exception {
        try {
            // 进行用户认证
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(authRequest.getUsername(), authRequest.getPassword())
            );
        } catch (AuthenticationException e) {
            throw new Exception("Invalid username or password");
        }
        // 生成JWT令牌
        final UserDetails userDetails = jwtUserDetailsService.loadUserByUsername(authRequest.getUsername());
        return jwtUtils.generateToken(userDetails.getUsername());
    }
}
```

## 创建JWT过滤器

创建一个JWT过滤器，用于在每次请求时验证JWT令牌：

```java
public class JwtRequestFilter extends OncePerRequestFilter {

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private JwtUtils jwtUtil;

    public JwtRequestFilter(JwtUtils jwtUtil,UserDetailsService userDetailsService){
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {

        final String authorizationHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;

        // 从请求头中获取JWT令牌
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            jwt = authorizationHeader.substring(7);
            username = jwtUtil.extractClaims(jwt).getSubject();
        }

        // 验证令牌并设置认证信息
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);
            if (jwtUtil.validateToken(jwt, userDetails.getUsername())) {
                UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                usernamePasswordAuthenticationToken
                        .setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
            }
        }
        chain.doFilter(request, response);
    }
}
```

# 执行流程

1. **用户登录请求**：通过客户端（如浏览器或Postman）发送一个包含用户名和密码的POST请求到`/login`接口
2. **创建认证对象Token**：`UsernamePasswordAuthenticationToken` 是 Spring Security 中 `Authentication` 接口的一个实现类。它主要用于存储用户的认证信息（用户名和密码），并在认证过程中传递这些信息。
3. `AuthenticationManager`认证：对创建的`UsernamePasswordAuthenticationToken`对象进行认证，并返回`Authentication`对象。
4. `Authentication`**认证**：如果认证通过，将返回的对象存储到SecurityContext中，如果不通过则抛出认证失败的异常。





# 涉及类介绍

## UsernamePasswordAuthenticationToken

>UsernamePasswordAuthenticationToken是Spring Security中`Authentication` 接口的一个实现类。它主要用于存储用户的认证信息（用户名和密码），并在认证过程中传递这些信息。

**作用：**

1. **存储用户认证信息**：
   - `UsernamePasswordAuthenticationToken` 对象包含了用户的认证信息，例如用户名（principal）和密码（credentials）。
2. **传递认证请求**：
   - 在用户登录时，`UsernamePasswordAuthenticationToken` 对象通常用于创建认证请求对象，并传递给 `AuthenticationManager` 进行认证。
3. **表示认证状态**：
   - `UsernamePasswordAuthenticationToken` 对象还可以表示认证状态，通过 `setAuthenticated` 方法设置为已认证或未认证。

**构造函数：**

```java
public UsernamePasswordAuthenticationToken(Object principal, Object credentials) {
    super((Collection)null); // 调用父类的构造函数，传入 null 表示没有权限信息
    this.principal = principal; // 设置用户主体,就是用户名
    this.credentials = credentials; // 设置用户凭据，就是密码
    this.setAuthenticated(false);// 设置认证状态为未认证
}
```

