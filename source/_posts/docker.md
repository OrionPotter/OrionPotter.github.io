---
title: docker安装
tag: docker
---

## docker安装

>1. 系统版本：
>
>   要安装 Docker Engine，您需要 CentOS 7、CentOS 8（流）或 CentOS 9（流）的维护版本。
>
>2.  卸载旧版本：
>
>```shell
> sudo yum remove docker \
>                  docker-client \
>                  docker-client-latest \
>                  docker-common \
>                  docker-latest \
>                  docker-latest-logrotate \
>                  docker-logrotate \
>                  docker-engine
>```
>
>3. 设置存储库
>
>```shell
>yum install -y yum-utils
>yum-config-manager \
>    --add-repo \
>    https://download.docker.com/linux/centos/docker-ce.repo
>```
>
>4. 安装最新版doker
>
>```shell
>yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
>```
>
>5. 启动docker
>
>```shell
>systemctl start docker
>```
>
>6. 设置开机自启
>
>```shell
>systemctl enable docker
>```