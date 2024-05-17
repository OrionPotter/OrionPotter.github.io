---
title: docker
tag: docker
---

# docker安装

## 系统版本要求

要安装 Docker Engine，您需要 CentOS 7、CentOS 8（流）或 CentOS 9（流）的维护版本。

## 安装步骤

### 卸载旧版本

```shell
yum remove docker \
                 docker-client \
                 docker-client-latest \
                 docker-common \
                 docker-latest \
                 docker-latest-logrotate \
                 docker-logrotate \
                 docker-engine
```

### 设置存储库

```shell
yum install -y yum-utils
yum-config-manager \
   --add-repo \
   https://download.docker.com/linux/centos/docker-ce.repo
```

### 安装最新版

```shell
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

### 启动docker

```shell
systemctl start docker
# 设置开机自启
systemctl enable docker
```



# docker日志清理

## 使用 Docker 日志选项进行日志轮转

Docker 提供了内置的日志轮转功能，可以在容器启动时配置。

```shell
docker run -d \
  --log-opt max-size=10m \
  --log-opt max-file=3 \
  your_image
```

上述命令配置 Docker 使其每个日志文件的最大大小为 10MB，并保留最多 3 个日志文件。

## 手动清理 Docker 日志

手动清理 Docker 日志涉及删除 Docker 容器的日志文件。可以通过 `cron` 作业来定期执行此操作。

### 创建清理脚本

首先，创建一个脚本来清理日志。例如，创建一个名为 `docker_log_cleanup.sh` 的脚本：

```shell
#!/bin/bash
# 停止并移除所有未使用的容器、网络、镜像和缓存
# docker system prune -af
# 清理所有容器的日志文件
find /var/lib/docker/containers/ -type f -name "*.log" -exec truncate -s 0 {} \;
# 确保脚本有执行权限：
chmod +x docker_log_cleanup.sh
```

### 设置 `cron` 作业

使用 `cron` 作业定期运行清理脚本。编辑 `crontab` 文件：

```shell
crontab -e
```

添加如下条目，例如每周日凌晨 3 点执行清理任务：

```shell
0 3 * * 0 /path/to/docker_log_cleanup.sh
```

保存并退出 `crontab` 编辑器。

## 使用 Docker 自带的定时清理功能

Docker 提供了 `docker system prune` 命令，可以删除所有未使用的数据（包括停止的容器、未使用的网络、悬挂的镜像和构建缓存）。可以结合 `cron` 来定期运行此命令。

### 创建定期清理脚本

创建一个名为 `docker_system_prune.sh` 的脚本：

```shell
#!/bin/bash
# 运行 Docker system prune 命令
docker system prune -af
# 确保脚本有执行权限
chmod +x docker_system_prune.sh
```

### 设置 `cron` 作业

编辑 `crontab` 文件：

```shell
crontab -e
```

添加如下条目，例如每天凌晨 2 点执行清理任务：

```shell
0 2 * * * /path/to/docker_system_prune.sh
```

保存并退出 `crontab` 编辑器。