#/bin/bash
hexo g -d
git config core.safecrlf false
git pull
git add .
git commit -m $1
git push origin hexo
