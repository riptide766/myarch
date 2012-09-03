#!/bin/bash

cachedir=/tmp/customlinux
cachelist="$cachedir/dependlist"
desclist="$cachedir/descfile"

mkdir -p $cachedir

function countdepend(){
	dependlist=`pactree -ul $1 | cut -d" " -f1`
	[  -a $cachelist ] || echo > $cachelist
	for item in $dependlist ; do
		grep -q -e "^$item$" "$cachelist"
		if [[ $? != 0  ]] ; then
			# 打印软件包名，记录到文件
			echo $item | tee -a $cachelist
			# 以两行的形式记录软件包的名字和描述，记录到文件里
			pacman -Qi $item | grep Desc | sed -e "s/\(Description\s*\):\(.*\)/$item\n\t\2/" >> $desclist
		fi
	done
}

for pkg in $@ ; do
	countdepend $pkg
done

