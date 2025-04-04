#!/bin/bash
hexo clean
hexo g
hexo d
git add .
git commit -m "auto submit"
git push origin hexo
