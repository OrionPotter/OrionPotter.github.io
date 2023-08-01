---
title: git-简明指南
tag: git指南
---



1. 创建新仓库

>创建文件夹，打开执行git init,创建新的git仓库

2. 克隆仓库

>1. 克隆本地仓库 git clone /path/repository
>2. 克隆远程仓库 git clone username@host:/path/repository

3. 工作流

>本地仓库由三棵树维护，第一个是工作目录，第二个是git add 以后进入暂存区域index,第三个是 git commit 以后进入head，但是还没到远端仓库

4. 推送远程仓库

>git commit以后会进入本地仓库的head区域，执行git push origin master 会推送到远程仓库
>
>如果没有克隆仓库，但是你想连接远程的某个服务 git remote add origin <Server>,就可以推送上去了

5. 分支

>分支是用来绝缘开发的，当你创建完仓库后，master是默认分支，在其他分支上进行开发，完成后再合并到主分支
>
>创建一个分支： git checkout  -b feature_x
>
>切回主分支： git checkout master
>
>删除分支： git checkout -d feature_x
>
>将本地分支推送到远程仓库： git push origin <branch>

6. 更新与合并

>将远程仓库更新到本地：git pull(git fetch 获取最新的版本到本地 + git merage 将最新的版本与本地的合并)
>
>如果本地和远程产生冲突，需要手动处理冲突的文件名，然后进行git add 冲突文件名
>
>查看分支的区别：git diff <source_branch> <target_branch>

7. 日志

>查看本地仓库的操作记录： git log
>
>查看具体某个人的操作记录： git log --author="xxxx"

8. 替换本地改动

>替换本地改动： git checkout --<filename> 此命令会使head中最新的内容替换掉你的工作目录的文件（已经添加到暂存区的或新创建的文件都不会影响）
>
>放弃本地改动与提交，可以从服务器上获取最新版，并将本地分支指向它，git fetch origin 获取远程最新的仓库，git reset --hard origin/master
