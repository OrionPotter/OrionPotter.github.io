---
title: Github
tag: 
- Github
typora-root-url: ./..
---

# git的通信协议

## ssh协议

```shell
git clone git@github.com:BJPotter/BJPotter.github.io.git
```

## https协议

```shell
git clone https://github.com/BJPotter/BJPotter.github.io.git
```



## gitHub Cli协议

```shell
gh repo clone BJPotter/BJPotter.github.io
```



# gitHub配置SSH Key

## 设置git的用户名和邮箱

```shell
# 在Git客户端执行
git config --global user.name "这里输入你在GitHub的账户名"
git config --global user.email "这里输入你在GitHub的注册邮箱名"
```

## 生成**SSH Key**

```shell
cd ~/.ssh
ssh-keygen -t rsa -C "这里输入你在 GitHub 的注册邮箱"
cat id_rsa.pub
```

## gitHub配置公钥

>在github中点击头像，依次点击Settings > SSH and GPG Keys > New SSH Key
>
>把客户端的公钥复制到里面，并给title起一个名字保存即可

## 测试

```shell
ssh -T git@github.com
# 返回 You've successfully authenticated则成功 
```

# https免密配置

```shell
# 输入一次账号密码后第二次就会记住账号密码。
git config --global credential.helper store
```



# Actions

## 什么是Actions

>github action是一种持续集成和持续交付的（CI/CD）平台，可用于自动执行生成、测试和部署管道。在github创建的仓库中，Actions是可以自定义的一些列的操作，如：提交代码后触发自动化编译打包和部署到远程服务器上，官方所说的定义是：在仓库中自动化、自定义操作执行软件开发工作流程，目前有很多现成的Actions可以直接拿来使用，也可以进行自定义创建到自己工作流程中。

## Actions可以做什么

>Actions通常用来两个方面
>
>1. 自动化ci/cd,触发事件后自动化编译打包部署。
>2. 自动添加标签，当有人提issues的时候可以自动化的添加标签

## Actions组件

>可以把Github Actions 工作流程配置为在存储库发生事件触发。
>
>example: 拉取请求或者推送请求的时候触发工作流程[工作流程理解为jobs]
>
>一个工作流程包含一个作业或者多个作业，这些作业可以按照顺序执行，也可以并发执行，每个作业都会在自己虚拟机中进行，或者在容器中进行，这个运行的进程可以理解为运行了一个runner,每个作业可能会有多个步骤，这个步骤运行自定义的脚本或者运行操作。

<img src="/images/action.png" style="zoom:50%;" />

### **Workflows（工作流）**

>工作流是一个可配置的自动化的程序。创建一个工作流，你需要定义一个 YAML 文件，当你的仓库触发某个事件的时候，工作流就会运行，当然也可以手动触发，或者定义一个时间表。

### **事件（Events）**

>事件是指仓库触发运行工作流的具体的行为，比如创建一个 pull request，新建一个 issue、或者推送一个 commit。你也可以使用时间表触发一个工作流，或者通过请求一个 REST API，再或者手动触发。

### **任务（Jobs）**

>任务是在同一个运行器上执行的一组步骤（steps）。一个步骤（steps）要么是一个shell 脚本（script）要么是一个动作（action）。步骤会顺序执行，并彼此独立。因为每一个步骤都在同一个运行器上被执行，所以你可以从一个步骤（step）传递数据到另一个步骤（step）。

### **动作（Actions）**

>动作是 GitHub Actions 平台的一个自定义的应用，它会执行一个复杂但是需要频繁重复的作业。使用动作可以减少重复代码。比如一个 action 可以实现从 GitHub 拉取你的 git 仓库，为你的构建环境创建合适的工具链等。

### **运行器（Runners）**

>一个运行器是一个可以运行工作流的服务。每一个运行器一次只运行一个单独的任务。GitHub 提供 Ubuntu Linux，Microsoft Windows 和 macOS 运行器，每一个工作流都运行在一个独立新建的虚拟机中。

## **工作流参数**

工作流程是一个可配置的自动化过程，它将运行一个或多个作业。 工作流程由签入到存储库的 YAML 文件定义，并在存储库中的事件触发时运行，也可以手动触发，或按定义的时间表触发。文件位于仓库的根目录下的`.github/workflows`

### 触发工作流程

1. 工作流程存储库发生事件

   ```yml
   # 单个事件触发
   on: push
   # 多个事件触发
   on: [push, fork]
   # 限定master分支发生push事件触发
   on:
     push:
       branches:    
         - master
   ```

2. 预定时间

   ```yml
   # 示例在每天 5:30 和 17:30 UTC 触发工作流程
   on:
     schedule:
       - cron:  '30 5,17 * * *'
   ```

### 使用作业

1. 创建jobs

```yaml
# workflow主体是jobs字段，表示要执行的一项或者多项任务jobs.<job_id>.name job_id：名称自定义 name：任务的说明
jobs:
  #作业id
  my_first_job:
  	#作业名称
    name: My first job
  my_second_job:
    name: My second job
# jobs.<job_id>.needs needs字段指定当前任务的依赖关系，即运行顺序，这个 workflow 的运行顺序依次为：job1、job2、job3
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]    
```

2. 选择运行器

```yaml
# jobs.<job_id>.runs-on runs-on字段指定运行所需要的虚拟机环境。它是必填字段，目前可以使用的虚拟机如下
runs-on: ubuntu-latest
```

<img src="/images/runner.png" style="zoom:50%;" />

>以上是常见的运行器，就是用哪个虚拟机

3. 运行步骤

```xml
# jobs.<job_id>.steps
# steps字段指定每个 Job 的运行步骤，可以包含一个或多个步骤。每个步骤都可以指定以下三个字段。
# 步骤名称。
jobs.<job_id>.steps.name
# 该步骤运行的命令或者 action
jobs.<job_id>.steps.run
# 该步骤所需的环境变量
jobs.<job_id>.steps.env
```

### maven打jar包示例

```xml
# .github/workflows/maven.yml 
name: Java CI with Maven
on:
  push:
    branches: [ "master" ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK 8
      uses: actions/setup-java@v3
      with:
        java-version: '8'
        distribution: 'temurin'
        cache: maven
    - name: Build with Maven
      run: mvn -B clean package
    # Optional: Uploads the JAR file as an artifact
    - name: Upload JAR
      uses: actions/upload-artifact@v2
      with:
        name: DataHub
        path: target/*.jar
```





