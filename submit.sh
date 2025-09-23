#!/bin/bash
hexo clean
hexo g
hexo d
echo "save theme config"
# 备份当前主题配置
cp -a themes/next/_config.yml source/_config.next.yml
git add .
git commit -m "auto submit"
git push origin hexo