#!/bin/zsh
hexo clean && hexo g && hexo d && git add . && git commit -m "submit env"  && git push origin hexo
