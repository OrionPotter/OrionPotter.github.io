---
title: 离线安装GeoServer
tag: 安装
---

## 离线安装GeoServer

>前提：安装好java,配置好JAVA_HOME

1.准备源码包

```shell
https://jaist.dl.sourceforge.net/project/geoserver/GeoServer/2.15.1/geoserver-2.15.1-bin.zip
```

2.解压

```shell
unzip geoserver-2.15.1-bin.zip 
```

3.修改端口

```shell
cd geoserver-2.15.1
vi start.ini 
jetty.port=8181
```

4.启动程序

```shell
cd bin
./startup.sh
```

5.后台启动

```shell
nohup /root/geoserver-2.15.1/bin/startup.sh &
```

## geoserver跨域配置

1.查看对应的版本

>启动程序后，默认用户名/密码登陆进去，F12抓取一下Response Header,Server里面有版本号

```html
Cache-Control: no-cache, no-store
Content-Length: 0
Date: Mon, 23 May 2022 07:56:02 GMT
Expires: Thu, 01 Jan 1970 00:00:00 GMT
Location: http://180.76.187.95:8181/geoserver/web/?0
Pragma: no-cache
Server: Jetty(9.4.12.v20180830)
Set-Cookie: JSESSIONID=node012k3zcl8cf6121wuziii0dzvt75.node0;Path=/geoserver
X-Frame-Options: SAMEORIGIN
```

2.下载jar包

```xml
<!-- https://mvnrepository.com/artifact/org.eclipse.jetty/jetty-server -->
<dependency>
    <groupId>org.eclipse.jetty</groupId>
    <artifactId>jetty-server</artifactId>
    <version>9.4.12.v20180830</version>
</dependency>
```

3.上传jar包

```shell
上传路径 /root/geoserver-2.15.1/webapps/geoserver/WEB-INF/lib
```

4.修改配置

```web.xml
vim /root/geoserver-2.15.1/webapps/geoserver/WEB-INF/web.xml
```

```xml
<filter>
	<filter-name>CORS</filter-name>
	<filter-class>com.thetransactioncompany.cors.CORSFilter</filter-class>
	<init-param>
		<param-name>cors.allowOrigin</param-name>
		<param-value>*</param-value>
	</init-param>
	<init-param>
		<param-name>cors.supportedMethods</param-name>
		<param-value>GET,POST,HEAD,PUT,DELETE</param-value>
	</init-param>
	<init-param>
		<param-name>cors.supportedHeaders</param-name>
		<param-value>Accept,Origin,X-Requested-With,Content-Type,Last-Modified</param-value>
	</init-param>
	<init-param>
		<param-name>cors.exposedHeaders</param-name>
		<param-value>Set-Cookie</param-value>
	</init-param>
	<init-param>
		<param-name>cors.supportsCredentials</param-name>
		<param-value>true</param-value>
	</init-param>
</filter>
<filter-mapping>
	<filter-name>CORS</filter-name>
	<url-pattern>/*</url-pattern>
</filter-mapping>
```

