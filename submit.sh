#!/bin/bash
hexo clean
hexo g
hexo d
echo "save theme config"
cp -a  themes/next/_config.yml source/
git add .
git commit -m "auto submit"
git push origin hexo
