hexo generate
cp -R public/* .deploy/Anshenzheng.github.io
cd .deploy/Anshenzheng.github.io
git add .
git commit -m "update"
git push origin master
shy_annan@126.com
Hell0github