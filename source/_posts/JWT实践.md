---
title: 基于SpringBoot+SpringSecurity+JWT认证实践
tag:
- java
---

# 认证流程原理

## JWT (JSON Web Token)

JWT是一种用于在各方之间作为JSON对象安全传输信息的紧凑、URL安全的令牌。它由三部分组成：

- **Header**：包含令牌类型（通常为JWT）和签名算法（例如HMAC SHA256）。
- **Payload**：包含声明（claims），即传输的数据。常见的声明包括：用户ID、用户名、过期时间等。
- **Signature**：用于验证令牌的真实性。它是由Header和Payload通过签名算法和密钥生成的。

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
2. **创建UsernamePasswordAuthenticationToken**：`UsernamePasswordAuthenticationToken` 是 Spring Security 中 `Authentication` 接口的一个实现类。它主要用于存储用户的认证信息（用户名和密码），并在认证过程中传递这些信息。



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

