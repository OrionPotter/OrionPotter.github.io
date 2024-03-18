---
title: git
tag: git使用
date: 2024-01-24
typora-root-url: ./..
---

# git介绍

>Git是一个版本控制系统
>
>Git可以追踪代码的更改
>
>Git可以让多人一起协作编写代码

## 什么是git

git是一个版本控制系统，由Linus Torvalds在2005年创建的，后来一直由Junio Hamano维护，git经常用来跟踪代码变更，跟踪谁变更了代码，协作处理。

## git能做什么

主要用来管理项目，包括拉取远程仓库到本地，推送本地代码到远程仓库，合并分支到主分支。

## git工作流程

>首先初始化一个本地文件夹作为一个工作区域，会默认生成一个.git的隐藏文件，当工作区域的文件发生添加或者删除的时候，git会认为进行了修改，我们add执行后把修改后的状态暂存到暂存区，commit执行后把暂存区的文件，提交到head区，commit可以添加提交原因，也会记录提交时间、提交人等信息，可以通过log命令查看，执行push以后，我们就把本地的改动推送到了远程仓库，当其他人对项目进行了修改，并且提交到了远程，我们可以通过pull获取远程最新的代码到本地工作区。

![](/images/git工作流程.png)







## 为什么使用git

+ 超过70%的开发者都在使用git
+ 开发者可以通过git在世界上任何地方都可以一起办公
+ 开发者可以看到这个项目整个历史
+ 开发者也可以回退到更早之前的历史版本

## 什么是github

首先git不等于github,github的制作工具使用了git，github是一个大的开源公司。github是一个远程的仓库平台，常见的远程仓库平台有github、gitlab、Bitbucket

# git开始

## git安装

>下载安装[https://www.git-scm.com/](https://git-scm.com/)

## git全局配置

```shell
#设置全局用户名
git config --global user.name "test"
#设置全局用户邮箱
git config --global user.email "test@gmail.com"
#设置全局用户密码
git config --global user.password "testpassword"
#设置全局代理
git config --global http.proxy=xxxx
git config --global https.proxy=xxxx
#查看全局配置
git config --global --list
```

**注意：**如果你相对某个仓库单独设置，移除--global命令就可以了

## 初始化git

```shell
#创建一个文件夹
mkdir myproject
#切换到当前文件夹
cd myproject
#初始化git
git init 
Initialized empty Git repository in /Users/user/myproject/.git/
```

现在已经创建并初始化了一个git仓库，会自动生成一个隐藏的.git文件负责对代码进行追踪更改。



# git新增文件

>我们创建git仓库，但是他现在是空的，我们在工作区随便创建一个文件
>
>touch test.txt

```shell
#查看仓库状态
git status
On branch master
No commits yet
Untracked files:
  (use "git add ..." to include in what will be committed)
    test.txt

nothing added to commit but untracked files present (use "git add" to track)
```

>On branch master  说明我们在master分支
>
>No commits yet 我们还没有提交过
>
>Untracked files  test.txt文件没有被提交

# git暂存环境

>Git的核心功能是暂存环境和提交两个概念。
>
>工作中，我们可能添加、编辑、删除文件，但是无论是什么操作，我们结束后都应该把它放到暂存环境，暂存环境的文件准备提交到仓库。
>
>例如：我们创建test.txt，此时我们把它添加到暂存环境

```shell
#把test.txt添加到暂存环境
git add test.txt
#查看下状态
git status
On branch master
No commits yet
Changes to be committed:
  (use "git rm --cached ..." to unstage)
    new file: test.txt
#test.txt已经添加到暂存环境了，等着被提交的状态
```

## 添加一个文件

```shell
git add test.txt
```

## 添加多个文件

```shell
git add [file1] [file2] [file3]
#或者
git add --all
#使用--all参数，将会暂存所有的改变的文件（新增、修改、删除的文件）
```

**注意：**git add --all 等同于 git add -A

# git提交

## 暂存提交

>我们完成工作后将文件添加到暂存区，之后需要提交到本地仓库，git每次提交都会保留一个节点，如果发现bug，可以根据节点id进行回退，当我们提交的时候可以携带提交信息，例如：

```shell
#使用-m 参数可以添加消息
git commit -m "First commit"
```

## 不暂存提交

>当进行小的更改时，使用暂存环境有点浪费时间，我们可以直接提交更改，跳过暂存环境。 

```shell
#使用-a 参数将自动暂存每个已更改的、已跟踪的文件。
git commit -a -m "Updated test.txt"
```

## 提交日志

>我们要查看仓库的历史提交记录，可以查看日志

```shell
#查看历史提交记录
git log 
```

# 分支

## 新建分支

```shell
#新增分支
git branch newBranchName
#查看当前分支
git branch
# 查看当前分支包含远程的
git branch -a 
```

## 切换分支

```shell
# git checkout 分支名称进行切换分支
git checkout master
```

## 紧急分支

```shell
# 创建新分支并切换到新分支
git checkout -b newBranchName
```

## 分支合并

```shell
# 把其他分支合并到主分支
# 切换到主分支
git checkout master
# 合并其他分支到主分支
git merge otherBranchName
# 删除其他分支
git branch -d otherBranchName
```

## 分支冲突

>一般产生的冲突的原因是，其他分支修改了test.txt文件，你的主分支也进行了对test.txt文件的修改，导致其他分支合并到主分支，不知道按照谁的为准导致产生了冲突
>
>解决步骤：
>
>1.git status 查看冲突的文件(或者查看分支的区别：git diff <source_branch> <target_branch>)
>
>2.找到冲突的的文件在主分支中修改成我们想要的
>
>3.git add 冲突文件 提交我们的冲突文件到暂存环境
>
>4.git commit -m "fix conflict" 提交到本地仓库，分支就会自动合并了，冲突就可以解决了
>
>5.删除被合并的分支就可以了 git branch -d otherBranchName

# 克隆仓库

>1. 克隆本地仓库 git clone /path/repository
>2. 克隆远程仓库 git clone username@host:/path/repository

# git拉取

## 添加远程仓库

```shell
# 给本地仓库添加远程仓库
git remote add origin https://github.com/BJPotter/BJPotter.github.io.git
```

## 拉取远程仓库

```shell
# git pull 可以拉取远程仓库的内容
git pull 
# git pull 是两个命令的结合，分别是 git fetch  和 git merge
# git fetch 获取远程仓库最新的内容
# git merge 将获取到最新的内容合并到本地分支
# 更新本地仓库
git pull origin
```

# git推送

```shell
# 提交本地的更改到本地仓库
git commit -a -m "Updated local repo"
# 推送到远程仓库
git push origin
```

# 日志

>查看本地仓库的操作记录： git log
>
>查看具体某个人的操作记录： git log --author="xxxx"

# 版本回退

## git reset

>版本重置，根据git log 提交的id，可以以重置到某个提交节点id，类似于快照的概念。

```shell
# 重置到节点id
git reset --hard 节点id
# 推送到远程
git push
# 如果git push 报错，可能是本地库HEAD指向的版本比远程库的要旧，使用-f参数强制覆盖远程
git push -f 
```

## git revert

>版本还原，在现在的基础上剔除掉之前提交的某个版本，形成一个新的版本

```shell
# 覆盖节点id
git revert -n 节点id
# 这里可能会出现冲突，那么需要手动修改冲突的文件
# 添加到暂存区
git add 文件名
# 提交到本地仓库
git commit -m "版本还原"
# 推送到远程
git push
```

## 远程强制覆盖本地

```shell
# 拉取所有更新，不同步
git fetch --all
# 本地代码同步线上最新版本(会覆盖本地所有与远程仓库上同名的文件)；
git reset --hard origin/master
# 再更新一次（其实也可以不用，第二步命令做过了其实）
git pull
```

