---
title: 软件破解
tag: 
- 破解
---

# Typro破解

>亲测几个版本都有效，主要破解方式为修改注册表，不要给typro检测注册表修改的权限就可以了

1.通过win+r,输入regedit打开注册表

<img src="https://telegraph-image-2ni.pages.dev/file/6ac2175e435ab73248b76.png" style="zoom:50%;" />

2.根据图上的路径，找到Typro

<img src="https://telegraph-image-2ni.pages.dev/file/68fce7738c28d8017a590.png" style="zoom:33%;" />

3.在注册表编辑器中，双击修改IDate的值,将其改为一个未来日期。比如2099-01-01。这样就可以试用Typora到2099-01-01。

<img src="https://telegraph-image-2ni.pages.dev/file/c8c93f58d4cabd60e3eed.png" style="zoom:50%;" />

4.修改管理员的访问权限，typro就不会检测到修改过注册表了

<img src="https://telegraph-image-2ni.pages.dev/file/2c9493624aaf44e0908c4.png" style="zoom:33%;" />

5.执行完第四步后，点击应用和确认，直接就可以打开typro了

# Navicat破解

>无限试用bat脚本

```bat
@echo off

echo Delete HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium\Registration[version and language]
for /f %%i in ('"REG QUERY "HKEY_CURRENT_USER\Software\PremiumSoft\NavicatPremium" /s | findstr /L Registration"') do (
    reg delete %%i /va /f
)
echo.

echo Delete Info folder under HKEY_CURRENT_USER\Software\Classes\CLSID
for /f %%i in ('"REG QUERY "HKEY_CURRENT_USER\Software\Classes\CLSID" /s | findstr /E Info"') do (
    reg delete %%i /va /f
)
echo.

echo Finish

pause
```

