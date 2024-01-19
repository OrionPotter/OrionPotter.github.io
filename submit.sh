#/bin/bash
hexo clean
hexo g
hexo d
git config core.safecrlf false
git add .
git commit -m "submit env"
git push origin hexo
