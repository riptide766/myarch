#! /bin/bash
# Date 20120726 19:29
# 链接bash环境到主目录

echo "链接bash环境文件"
for file in `ls bash.d`;
do
	ln -sfv `pwd`/bash.d/$file ~/\.$file
done


echo "链接脚本到～/bin目录"
mkdir -pv ~/bin
for file in `ls shortkey.d`;
do
	[[ "sh" == ${file#*.} ]] && ln -sfv `pwd`/shortkey.d/$file ~/bin/$file
done
ln -sfv `pwd`/shortkey.d/shortkey.xbindkeysrc ~/.xbindkeysrc


echo "链接firefox的pentadactyl配置到主目录"
for file in `ls pentadactyl.d`;
do
	ln -sfv `pwd`/pentadactyl.d/$file ~/\.${file#*.}
done
