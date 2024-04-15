---
title: SFTP实践
tag:
- FTP
---

# SFTP

## SFTP介绍

 sftp是Secure File Transfer Protocol的缩写，安全文件传送协议。可以为传输文件提供一种安全的网络的加密方法。SFTP 为 SSH的其中一部分，是一种传输档案至 Blogger 伺服器的安全方式。其实在SSH软件包中，已经包含了一个叫作SFTP(Secure File Transfer Protocol)的安全文件信息传输子系统，SFTP本身没有单独的守护进程，它必须使用sshd守护进程（端口号默认是22）来完成相应的连接和答复操作，所以从某种意义上来说，SFTP并不像一个服务器程序，而更像是一个客户端程序。SFTP同样是使用加密传输认证信息和传输的数据，所以，使用SFTP是非常安全的。但是，由于这种传输方式使用了加密/解密技术，所以传输效率比普通的FTP要低得多。

## SFTP安装

### 检查openssh版本

>使用系统自带的internal-sftp搭建sftp，因为需要用到chroot，所以openssh 版本不能低于4.8p1

```shell
[root@slave1 ~]# ssh -V
OpenSSH_7.4p1, OpenSSL 1.0.2k-fips  26 Jan 2017
```

### 创建用户组

```shell
[root@slave1 ~]# groupadd sftp
```

### 添加用户到sftp用户组

```shell
[root@slave1 ~]# useradd -g sftp -s /sbin/nologin tom
```

### 修改sftp用户的密码

```shell
[root@slave1 ~]# passwd tom
更改用户 tom 的密码 。
新的 密码：
无效的密码： 密码少于 8 个字符
重新输入新的 密码：
passwd：所有的身份验证令牌已经成功更新。
密码设置为: cat
```

### 创建SFTP目录

```shell
[root@slave1 ~]# mkdir -p /sftp/
# 创建该用户能用的目录
[root@slave1 ~]# mkdir -p /sftp/tom
```

### 修改sshd_config的配置文件

```shell
[root@slave1 ~]# vim /etc/ssh/sshd_config
#Subsystem      sftp    /usr/libexec/openssh/sftp-server 需要注释掉
# 添加以下配置
Subsystem sftp internal-sftp
Match Group sftp
ChrootDirectory /sftp/%u
ForceCommand internal-sftp
AllowTcpForwarding no
X11Forwarding no
```

### 设定Chroot权限

```shell
[root@slave1 ~]# chown root:sftp /sftp
[root@slave1 ~]# chown root:sftp /sftp/tom
[root@slave1 ~]# chmod 755 /sftp
[root@slave1 ~]# chmod 755 /sftp/tom
```

### 设置用户对应的权限

```shell
[root@slave1 ~]# mkdir -p /sftp/tom/files
[root@slave1 ~]# chown tom /sftp/tom/files
[root@slave1 ~]# chmod 755 /sftp/tom/files
```

### 重启sshd

```shell
[root@slave1 ~]# systemctl restart sshd
```

### 连接测试

```shell
[root@slave1 ~]# sftp tom@127.0.0.1
tom@127.0.0.1's password:
Connected to 127.0.0.1.
sftp>
sftp> exit
```





